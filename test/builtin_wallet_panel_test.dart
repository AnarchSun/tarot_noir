import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:tarot_noir/l10n/app_localizations.dart';
import 'package:tarot_noir/services/solana_wallet_service.dart';
import 'package:tarot_noir/widgets/builtin_wallet_panel.dart';

class _MemoryStore implements WalletSecretStore {
  String? phrase;
  @override
  Future<void> deletePhrase() async => phrase = null;
  @override
  Future<String?> readPhrase() async => phrase;
  @override
  Future<void> writePhrase(String value) async => phrase = value;
}

SolanaWalletService _service(_MemoryStore store) => SolanaWalletService(
  store: store,
  client: MockClient((http.Request request) async {
    final method = (jsonDecode(request.body) as Map)['method'];
    final result = method == 'getBalance'
        ? {'value': 2500000000}
        : {'value': <Object>[]};
    return http.Response(
      jsonEncode({'jsonrpc': '2.0', 'id': 1, 'result': result}),
      200,
    );
  }),
);

Future<void> _pump(
  WidgetTester tester,
  _MemoryStore store, {
  bool premium = true,
}) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 2.5;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          child: BuiltinWalletPanel(
            isPremiumUnlocked: premium,
            onOpenPremium: () {},
            service: _service(store),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('non-premium users see the locked state', (tester) async {
    await _pump(tester, _MemoryStore(), premium: false);
    expect(find.byKey(const Key('wallet-discover-premium')), findsOneWidget);
    expect(find.byKey(const Key('wallet-create')), findsNothing);
  });

  testWidgets('creating a wallet requires confirming the phrase', (
    tester,
  ) async {
    final store = _MemoryStore();
    await _pump(tester, store);
    await tester.tap(find.byKey(const Key('wallet-create')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('wallet-phrase')), findsOneWidget);
    expect(
      tester
          .widget<FilledButton>(find.byKey(const Key('wallet-activate')))
          .onPressed,
      isNull,
    );
    expect(store.phrase, isNull);
    await tester.tap(find.byKey(const Key('wallet-saved-check')));
    await tester.pump();
    await tester.tap(find.byKey(const Key('wallet-activate')));
    await tester.pumpAndSettle();
    expect(store.phrase, isNotNull);
    expect(find.byKey(const Key('wallet-address')), findsOneWidget);
    expect(find.textContaining('2.5000 SOL'), findsOneWidget);
  });

  testWidgets('import rejects bad phrases and accepts a valid one', (
    tester,
  ) async {
    final store = _MemoryStore();
    await _pump(tester, store);
    await tester.tap(find.byKey(const Key('wallet-import')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('wallet-import-field')),
      'nope',
    );
    await tester.tap(find.byKey(const Key('wallet-import-submit')));
    await tester.pump();
    expect(find.text('Invalid recovery phrase.'), findsOneWidget);
    await tester.enterText(
      find.byKey(const Key('wallet-import-field')),
      SolanaWalletService.generatePhrase(),
    );
    await tester.tap(find.byKey(const Key('wallet-import-submit')));
    await tester.pumpAndSettle();
    expect(store.phrase, isNotNull);
    expect(find.byKey(const Key('wallet-address')), findsOneWidget);
  });

  testWidgets('send validates the address and amount', (tester) async {
    final store = _MemoryStore()..phrase = SolanaWalletService.generatePhrase();
    await _pump(tester, store);
    await tester.tap(find.byKey(const Key('wallet-send')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('wallet-send-to')), 'abc');
    await tester.enterText(find.byKey(const Key('wallet-send-amount')), '0');
    await tester.tap(find.byKey(const Key('wallet-send-submit')));
    await tester.pump();
    expect(find.text('Invalid Solana address.'), findsOneWidget);
    expect(find.text('Invalid amount.'), findsOneWidget);
  });
}
