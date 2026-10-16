import 'dart:convert';
import 'dart:typed_data';

import 'package:bip39_mnemonic/bip39_mnemonic.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../app_config.dart';

const _alphabet = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';

String base58Encode(List<int> bytes) {
  var zeros = 0;
  while (zeros < bytes.length && bytes[zeros] == 0) {
    zeros++;
  }
  var value = BigInt.zero;
  for (final b in bytes) {
    value = (value << 8) | BigInt.from(b);
  }
  final out = StringBuffer();
  final base = BigInt.from(58);
  while (value > BigInt.zero) {
    out.write(_alphabet[(value % base).toInt()]);
    value ~/= base;
  }
  return '1' * zeros + out.toString().split('').reversed.join();
}

Uint8List? base58Decode(String input) {
  var value = BigInt.zero;
  final base = BigInt.from(58);
  for (final c in input.split('')) {
    final index = _alphabet.indexOf(c);
    if (index < 0) return null;
    value = value * base + BigInt.from(index);
  }
  var zeros = 0;
  while (zeros < input.length && input[zeros] == '1') {
    zeros++;
  }
  final bytes = <int>[];
  while (value > BigInt.zero) {
    bytes.add((value & BigInt.from(0xff)).toInt());
    value >>= 8;
  }
  return Uint8List.fromList([...List.filled(zeros, 0), ...bytes.reversed]);
}

bool isValidSolanaAddress(String address) =>
    base58Decode(address.trim())?.length == 32;

class WalletKeys {
  const WalletKeys(this.keyPair, this.publicKey);

  final SimpleKeyPair keyPair;
  final Uint8List publicKey;

  String get address => base58Encode(publicKey);
}

/// SLIP-0010 ed25519 derivation along Solana's m/44'/501'/0'/0' path.
Future<WalletKeys> deriveSolanaKeys(List<int> seed) async {
  final hmac = Hmac.sha512();
  Future<List<int>> mac(List<int> key, List<int> data) async =>
      (await hmac.calculateMac(data, secretKey: SecretKey(key))).bytes;
  var node = await mac(utf8.encode('ed25519 seed'), seed);
  for (final index in const [44, 501, 0, 0]) {
    final hardened = index | 0x80000000;
    node = await mac(node.sublist(32), [
      0,
      ...node.sublist(0, 32),
      (hardened >> 24) & 0xff,
      (hardened >> 16) & 0xff,
      (hardened >> 8) & 0xff,
      hardened & 0xff,
    ]);
  }
  final keyPair = await Ed25519().newKeyPairFromSeed(node.sublist(0, 32));
  final publicKey = (await keyPair.extractPublicKey()).bytes;
  return WalletKeys(keyPair, Uint8List.fromList(publicKey));
}

abstract class WalletSecretStore {
  Future<String?> readPhrase();
  Future<void> writePhrase(String phrase);
  Future<void> deletePhrase();
}

class SecureWalletSecretStore implements WalletSecretStore {
  const SecureWalletSecretStore();

  static const _key = 'orion_wallet_recovery_phrase';
  static const _storage = FlutterSecureStorage();

  @override
  Future<String?> readPhrase() => _storage.read(key: _key);

  @override
  Future<void> writePhrase(String phrase) =>
      _storage.write(key: _key, value: phrase);

  @override
  Future<void> deletePhrase() => _storage.delete(key: _key);
}

class WalletException implements Exception {
  const WalletException(this.message);

  final String message;

  @override
  String toString() => message;
}

class SolanaWalletService {
  SolanaWalletService({
    this.store = const SecureWalletSecretStore(),
    http.Client? client,
    String? rpcUrl,
  }) : _client = client ?? http.Client(),
       _rpcUrl = rpcUrl ?? AppConfig.solanaClusterUrl;

  final WalletSecretStore store;
  final http.Client _client;
  final String _rpcUrl;

  static String generatePhrase() => Mnemonic.generate(
    Language.english,
    length: MnemonicLength.words12,
  ).sentence;

  static String? normalizePhrase(String input) {
    final words = input
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();
    try {
      return Mnemonic.fromWords(words: words).sentence;
    } catch (_) {
      return null;
    }
  }

  static Future<WalletKeys> keysFromPhrase(String phrase) =>
      deriveSolanaKeys(Mnemonic.fromSentence(phrase, Language.english).seed);

  Future<bool> hasWallet() async => await store.readPhrase() != null;

  Future<String?> readPhrase() => store.readPhrase();

  Future<void> saveWallet(String phrase) => store.writePhrase(phrase);

  Future<void> removeWallet() => store.deletePhrase();

  Future<WalletKeys?> loadKeys() async {
    final phrase = await store.readPhrase();
    return phrase == null ? null : keysFromPhrase(phrase);
  }

  Future<dynamic> _rpc(String method, List<Object?> params) async {
    final response = await _client
        .post(
          Uri.parse(_rpcUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'jsonrpc': '2.0',
            'id': 1,
            'method': method,
            'params': params,
          }),
        )
        .timeout(const Duration(seconds: 20));
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final error = body['error'];
    if (error != null) {
      throw WalletException((error as Map)['message']?.toString() ?? 'RPC');
    }
    return body['result'];
  }

  Future<int> balanceLamports(String address) async {
    final result = await _rpc('getBalance', [address]) as Map;
    return result['value'] as int;
  }

  /// Counts NFT-like token accounts (amount 1, 0 decimals).
  Future<int> nftCount(String address) async {
    final result = await _rpc('getTokenAccountsByOwner', [
      address,
      {'programId': 'TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA'},
      {'encoding': 'jsonParsed'},
    ]) as Map;
    var count = 0;
    for (final account in result['value'] as List) {
      final info = account['account']['data']['parsed']['info'] as Map;
      final amount = info['tokenAmount'] as Map;
      if (amount['decimals'] == 0 && amount['amount'] == '1') count++;
    }
    return count;
  }

  /// Builds a signed legacy SystemProgram transfer, base64-encoded.
  static Future<Uint8List> buildTransfer({
    required WalletKeys from,
    required Uint8List to,
    required int lamports,
    required Uint8List recentBlockhash,
  }) async {
    final data = ByteData(12)
      ..setUint32(0, 2, Endian.little)
      ..setUint64(4, lamports, Endian.little);
    final message = Uint8List.fromList([
      1, 0, 1, // signatures, readonly signed, readonly unsigned
      3, ...from.publicKey, ...to, ...Uint8List(32), // system program
      ...recentBlockhash,
      1, // instructions
      2, 2, 0, 1, 12, ...data.buffer.asUint8List(),
    ]);
    final signature = await Ed25519().sign(message, keyPair: from.keyPair);
    return Uint8List.fromList([1, ...signature.bytes, ...message]);
  }

  Future<String> sendSol({
    required WalletKeys from,
    required String toAddress,
    required double sol,
  }) async {
    final to = base58Decode(toAddress.trim());
    if (to == null || to.length != 32) {
      throw const WalletException('invalid-address');
    }
    final lamports = (sol * 1000000000).round();
    if (lamports <= 0) throw const WalletException('invalid-amount');
    final blockhash =
        (await _rpc('getLatestBlockhash', [
              {'commitment': 'finalized'},
            ]) as Map)['value']['blockhash']
            as String;
    final tx = await buildTransfer(
      from: from,
      to: to,
      lamports: lamports,
      recentBlockhash: base58Decode(blockhash)!,
    );
    final signature = await _rpc('sendTransaction', [
      base64Encode(tx),
      {'encoding': 'base64'},
    ]) as String;
    return signature;
  }
}
