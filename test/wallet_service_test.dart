import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tarot_noir/services/solana_wallet_service.dart';

class _MemoryStore implements WalletSecretStore {
  String? phrase;

  @override
  Future<void> deletePhrase() async => phrase = null;

  @override
  Future<String?> readPhrase() async => phrase;

  @override
  Future<void> writePhrase(String value) async => phrase = value;
}

void main() {
  test('base58 round-trips and matches the system program address', () {
    expect(base58Encode(Uint8List(32)), '11111111111111111111111111111111');
    final bytes = List<int>.generate(32, (i) => (i * 7 + 3) % 256);
    expect(base58Decode(base58Encode(bytes)), bytes);
    expect(isValidSolanaAddress('11111111111111111111111111111111'), isTrue);
    expect(isValidSolanaAddress('not-an-address'), isFalse);
  });

  test(
    'SLIP-0010 ed25519 master key matches the published test vector',
    () async {
      // Vector 1 of SLIP-0010 (m/0'): validates our HMAC chain primitives.
      final seed = List<int>.generate(16, (i) => i);
      final hmac = Hmac.sha512();
      final master = (await hmac.calculateMac(
        seed,
        secretKey: SecretKey(utf8.encode('ed25519 seed')),
      )).bytes;
      expect(
        master
            .sublist(0, 32)
            .map((b) => b.toRadixString(16).padLeft(2, '0'))
            .join(),
        '2b4be7f19ee27bbf30c667b642d5f4aa69fd169872f8fc3059c08ebae2eb19e7',
      );
    },
  );

  test('a generated phrase is restored to the same address', () async {
    final phrase = SolanaWalletService.generatePhrase();
    expect(phrase.split(' '), hasLength(12));
    final a = await SolanaWalletService.keysFromPhrase(phrase);
    final b = await SolanaWalletService.keysFromPhrase(phrase);
    expect(a.address, b.address);
    expect(isValidSolanaAddress(a.address), isTrue);
    expect(SolanaWalletService.normalizePhrase(phrase.toUpperCase()), phrase);
    expect(SolanaWalletService.normalizePhrase('abandon abandon'), isNull);
  });

  test('the store keeps the phrase and removal deletes it', () async {
    final store = _MemoryStore();
    final service = SolanaWalletService(store: store);
    expect(await service.hasWallet(), isFalse);
    await service.saveWallet(SolanaWalletService.generatePhrase());
    expect(await service.hasWallet(), isTrue);
    expect(await service.loadKeys(), isNotNull);
    await service.removeWallet();
    expect(await service.hasWallet(), isFalse);
  });

  test('transfer transaction is well formed and correctly signed', () async {
    final keys = await SolanaWalletService.keysFromPhrase(
      SolanaWalletService.generatePhrase(),
    );
    final to = Uint8List.fromList(List.filled(32, 9));
    final tx = await SolanaWalletService.buildTransfer(
      from: keys,
      to: to,
      lamports: 1500000000,
      recentBlockhash: Uint8List.fromList(List.filled(32, 5)),
    );
    expect(tx[0], 1);
    final signature = tx.sublist(1, 65);
    final message = tx.sublist(65);
    expect(message.length, 3 + 1 + 96 + 32 + 1 + 5 + 12);
    final ok = await Ed25519().verify(
      message,
      signature: Signature(
        signature,
        publicKey: SimplePublicKey(keys.publicKey, type: KeyPairType.ed25519),
      ),
    );
    expect(ok, isTrue);
    final lamports = ByteData.sublistView(Uint8List.fromList(message))
        .getUint64(message.length - 8, Endian.little);
    expect(lamports, 1500000000);
  });
}
