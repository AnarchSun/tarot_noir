import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarot_noir/app_config.dart';
import 'package:tarot_noir/l10n/app_localizations.dart';
import 'package:tarot_noir/main.dart';
import 'package:tarot_noir/models/premium_reading.dart';
import 'package:tarot_noir/models/tarot_card.dart';
import 'package:tarot_noir/models/tarot_card_text.dart';
import 'package:tarot_noir/models/tarot_deck.dart';

void main() {
  setUp(() {
    AppConfig.firebaseAuthEnabledForTesting = false;
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  tearDown(() {
    AppConfig.firebaseAuthEnabledForTesting = null;
  });

  test('minor arcana suits are already included in card names', () {
    for (final card in tarotDeck) {
      if (card.isMinorArcana) {
        expect(card.name, contains(' de '), reason: card.name);
      }
    }
  });

  test('daily card advances each day through the full deck', () {
    final firstDay = DateTime.utc(2026, 1, 1);
    final cards = List.generate(
      tarotDeck.length,
      (offset) => dailyCardForDate(firstDay.add(Duration(days: offset))),
    );

    expect(cards.map((card) => card.id).toSet(), hasLength(tarotDeck.length));
    expect(
      dailyCardForDate(firstDay.add(Duration(days: tarotDeck.length))).id,
      cards.first.id,
    );
  });

  testWidgets('daily-card welcome reveals today’s card for guests', (
    tester,
  ) async {
    await tester.pumpWidget(const TarotNoirApp());
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('welcome-landing')), findsOneWidget);
    expect(find.byKey(const Key('welcome-background')), findsOneWidget);
    expect(find.byKey(const Key('welcome-logo')), findsOneWidget);
    expect(find.byKey(const Key('welcome-preview-card')), findsOneWidget);
    expect(find.byKey(const Key('welcome-card-meaning')), findsOneWidget);
    expect(
      tester.getSize(find.byKey(const Key('welcome-preview-card'))).height,
      greaterThan(250),
    );
    expect(
      tester
          .widget<Text>(find.byKey(const Key('welcome-card-meaning')))
          .style
          ?.fontSize,
      12,
    );
    final todayCard = dailyCardForDate(DateTime.now());
    expect(
      (tester.widget<Image>(find.byKey(const Key('welcome-preview-card'))).image
              as AssetImage)
          .assetName,
      todayCard.imagePath,
    );
    expect(find.byKey(const Key('daily-card-back')), findsNothing);
    expect(find.text('Continue with Google'), findsOneWidget);
    expect(find.text('Continue with Facebook'), findsOneWidget);
    expect(find.text('Continue without an account'), findsOneWidget);
    expect(find.byKey(const Key('daily-draw')), findsNothing);

    await tester.tap(find.byKey(const Key('continue-as-guest')));
    await tester.pumpAndSettle();

    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getBool('guest_access_accepted'), isTrue);
    expect(preferences.getString('daily_card_id'), todayCard.id);
    expect(
      preferences.getString('daily_card_date'),
      '${DateTime.now().year.toString().padLeft(4, '0')}-'
      '${DateTime.now().month.toString().padLeft(2, '0')}-'
      '${DateTime.now().day.toString().padLeft(2, '0')}',
    );
    expect(find.byKey(const Key('daily-draw')), findsOneWidget);
    expect(find.text(todayCard.name), findsWidgets);
    expect(
      find.byKey(ValueKey('daily-reveal-${todayCard.id}')),
      findsOneWidget,
    );
    expect(find.text('Daily card already drawn'), findsOneWidget);
    expect(find.byKey(const Key('basic-draw')), findsOneWidget);
    expect(preferences.getString('daily_card_id'), isNotNull);
    expect((preferences.getStringList('journal_entries') ?? []).length, 1);

    await tester.tap(find.byKey(const Key('journal')));
    await tester.pumpAndSettle();
    expect(find.text('Unlock your Journal'), findsOneWidget);
    expect(find.textContaining('Journal sync stays off'), findsOneWidget);
    expect(find.byKey(const Key('account-gate-google')), findsOneWidget);
    await tester.tap(find.byKey(const Key('account-gate-google')));
    await tester.pumpAndSettle();
    expect(
      find.text('Enable Firebase Authentication before signing in.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Premium'));
    await tester.pumpAndSettle();
    expect(find.text('Premium Circle'), findsOneWidget);
  });

  testWidgets('guest choice is remembered when the app is reopened', (
    tester,
  ) async {
    await tester.pumpWidget(const TarotNoirApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('continue-as-guest')));
    await tester.pumpAndSettle();
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getBool('guest_access_accepted'), isTrue);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(const TarotNoirApp());
    await tester.pumpAndSettle();

    expect(find.text('Continue with Google'), findsNothing);
    expect(find.text('Continue without an account'), findsNothing);
    expect(find.byKey(const Key('daily-draw')), findsOneWidget);
    expect(find.text('Daily card already drawn'), findsOneWidget);
  });

  testWidgets('local data erasure requires explicit confirmation', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'preference_orion_memory': true,
      'user_profile': '{"displayName":"Test","firebaseUid":"test-user","completedAt":"2026-01-01T00:00:00.000Z"}',
    });
    await _pumpSignedInApp(tester);
    await tester.tap(find.text('Journal'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.tune));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Erase my local data'),
      300,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.text('Erase my local data'));
    await tester.pumpAndSettle();

    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Erase'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    var preferences = await SharedPreferences.getInstance();
    expect(preferences.getBool('preference_orion_memory'), isTrue);

    await tester.tap(find.text('Erase my local data'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Erase'));
    await tester.pumpAndSettle();
    preferences = await SharedPreferences.getInstance();
    expect(preferences.getKeys(), isEmpty);
  });

  testWidgets('Google sign-in is offered at entry, not in signed-in profile', (
    tester,
  ) async {
    await tester.pumpWidget(const TarotNoirApp());
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('google-sign-in')));
    await tester.pumpAndSettle();
    expect(
      find.text('Enable Firebase Authentication before signing in.'),
      findsOneWidget,
    );
    expect(find.byKey(const Key('facebook-sign-in')), findsOneWidget);

    SharedPreferences.setMockInitialValues(<String, Object>{
      'user_profile': '{"displayName":"Test","firebaseUid":"test-user","completedAt":"2026-01-01T00:00:00.000Z"}',
    });
    await _pumpSignedInApp(tester);
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('journal-cloud-sync')), findsOneWidget);
    expect(find.byKey(const Key('sign-out')), findsOneWidget);
    expect(find.text('Continue with Google'), findsNothing);
    expect(find.text('Continue with Facebook'), findsNothing);

    await tester.scrollUntilVisible(
      find.byKey(const Key('wallet-connect')),
      300,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.pumpAndSettle();
    expect(find.text('Connect a wallet'), findsOneWidget);
    expect(find.text('Download Phantom'), findsOneWidget);
    expect(find.text('Download Solflare'), findsOneWidget);
    await tester.tap(find.byKey(const Key('wallet-connect')));
    await tester.pumpAndSettle();
    expect(
      find.text(
        'Add a Reown project ID and enable WalletConnect before opening the wallet portal.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('falls back to English for an unsupported device locale', (
    tester,
  ) async {
    await tester.pumpWidget(const TarotNoirApp());
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('welcome-landing')), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);
    expect(find.byKey(const Key('welcome-preview-card')), findsOneWidget);
  });

  test('premium readings follow the app language for every card', () {
    for (final card in tarotDeck) {
      final fr = PremiumReadingCatalog.forCard(card, CardOrientation.upright);
      for (final lang in ['en', 'es']) {
        for (final o in CardOrientation.values) {
          if (o.isReversed && !card.supportsReversedOrientation) continue;
          final r = PremiumReadingCatalog.forCard(card, o, lang);
          expect(r.essence, isNot(fr.essence), reason: '${card.id} $lang');
          expect(r.ritual, isNot(contains('{')), reason: '${card.id} $lang');
          expect(
            r.ritual,
            isNot(contains('Rituel')),
            reason: '${card.id} $lang',
          );
        }
      }
    }
  });

  test('card messages follow the app language', () {
    final death = majorArcana.firstWhere((card) => card.number == 'XIII');
    expect(death.localizedMessage('en'), startsWith('What ends'));
    expect(death.localizedMessage('es'), startsWith('Lo que termina'));
    expect(death.localizedMessage('fr'), death.message);
    final minor = minorArcana.first;
    expect(minor.localizedMessage('en'), startsWith('This card speaks of'));
    expect(minor.localizedMessage('fr'), isNot(contains('de le ')));
  });
}

Future<void> _pumpSignedInApp(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const TarotNoirHome(initialUser: _TestFirebaseUser()),
    ),
  );
  await tester.pumpAndSettle();
}

class _TestFirebaseUser implements User {
  const _TestFirebaseUser();

  @override
  String get uid => 'test-user';

  @override
  String? get displayName => 'Test User';

  @override
  String? get email => 'test@example.com';

  @override
  String? get phoneNumber => null;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
