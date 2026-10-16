import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarot_noir/app_config.dart';
import 'package:tarot_noir/l10n/app_localizations.dart';
import 'package:tarot_noir/main.dart';
import 'package:tarot_noir/services/solana_wallet_service.dart';
import 'package:tarot_noir/widgets/builtin_wallet_panel.dart';
import 'package:tarot_noir/models/journal_entry.dart';
import 'package:tarot_noir/models/premium_reading.dart';
import 'package:tarot_noir/models/spread.dart';
import 'package:tarot_noir/screens/spreads_screen.dart';
import 'package:tarot_noir/models/tarot_card.dart';
import 'package:tarot_noir/models/tarot_card_text.dart';
import 'package:tarot_noir/models/tarot_deck.dart';

Future<void> _enterAsGuest(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('continue-as-guest')));
  await tester.pumpAndSettle();
  expect(find.byKey(const Key('guest-ad-banner')), findsOneWidget);
  await tester.ensureVisible(find.byKey(const Key('guest-popup-continue')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const Key('guest-popup-continue')));
  await tester.pumpAndSettle();
}

Future<void> _openProfileSubTab(WidgetTester tester, String label) async {
  await tester.tap(
    find.descendant(of: find.byType(TabBar), matching: find.text(label)),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('profile has tabs with about info, collection and wallet', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'user_profile': '{"displayName":"Test","firebaseUid":"test-user","completedAt":"2026-01-01T00:00:00.000Z","bio":"Tarologue nocturne","city":"Montréal","origin":"Québec"}',
    });
    await _pumpSignedInApp(tester);
    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Profile'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Tarologue nocturne'), findsOneWidget);
    expect(find.text('Montréal'), findsOneWidget);
    expect(find.text('Québec'), findsOneWidget);
    await _openProfileSubTab(tester, 'Collection');
    expect(find.byKey(const Key('profile-collection')), findsOneWidget);
    await _openProfileSubTab(tester, 'Wallet');
    expect(find.byKey(const Key('wallet-connect')), findsOneWidget);
  });

  testWidgets('journal groups by date with spread sub-groups and zoom', (
    tester,
  ) async {
    final when = DateTime(2026, 1, 2, 10);
    final entries = [
      JournalEntry(
        card: tarotDeck[3],
        orientation: CardOrientation.upright,
        createdAt: when,
        drawType: 'daily',
      ),
      for (var i = 0; i < 5; i++)
        JournalEntry(
          card: tarotDeck[10 + i],
          orientation: CardOrientation.upright,
          createdAt: when.add(const Duration(minutes: 5)),
          drawType: spreadDrawType(spreadCross5, i),
        ),
    ];
    SharedPreferences.setMockInitialValues(<String, Object>{
      'journal_entries': [for (final e in entries) jsonEncode(e.toJson())],
      'user_profile': '{"displayName":"Test","firebaseUid":"test-user","completedAt":"2026-01-01T00:00:00.000Z"}',
    });
    await _pumpSignedInApp(tester);
    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Profile'),
      ),
    );
    await tester.pumpAndSettle();
    await _openProfileSubTab(tester, 'Journal');
    await tester.scrollUntilVisible(
      find.byKey(const Key('journal-day-2026-01-02')),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.byKey(const Key('journal-day-2026-01-02')), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('5-card cross'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('5-card cross'), findsOneWidget);
    final zoom = find.byKey(Key('journal-zoom-${entries[1].syncId}'));
    await tester.scrollUntilVisible(
      zoom,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(zoom);
    await tester.pumpAndSettle();
    await tester.tap(zoom);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('fullscreen-card')), findsOneWidget);
  });

  testWidgets('every spread shows its card layout above the analyses', (
    tester,
  ) async {
    for (final spread in spreadCatalog) {
      final cards = [
        for (var i = 0; i < spread.cardCount; i++)
          DrawnSpreadCard(tarotDeck[i], CardOrientation.upright),
      ];
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: SpreadResultScreen(spread: spread, cards: cards),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('spread-layout')), findsOneWidget);
      expect(tester.takeException(), isNull, reason: spread.id);
    }
  });

  testWidgets('AI interpretation of a spread unlocks after the ad', (
    tester,
  ) async {
    final spread = spreadCatalog.first;
    var ads = 0;
    final cards = [
      for (var i = 0; i < spread.cardCount; i++)
        DrawnSpreadCard(tarotDeck[i], CardOrientation.upright),
    ];
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SpreadResultScreen(
          spread: spread,
          cards: cards,
          onRequestAd: () async {
            ads++;
            return true;
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    final list = find.byKey(const Key('spread-result'));
    await tester.scrollUntilVisible(
      find.byKey(const Key('spread-ai-unlock')),
      300,
      scrollable: find.descendant(of: list, matching: find.byType(Scrollable)),
    );
    expect(find.byKey(const Key('spread-ai-reading')), findsNothing);
    await tester.tap(find.byKey(const Key('spread-ai-unlock')));
    await tester.pumpAndSettle();
    expect(ads, 1);
    expect(find.byKey(const Key('spread-ai-reading')), findsOneWidget);
    expect(find.byKey(const Key('spread-ai-unlock')), findsNothing);
    await tester.scrollUntilVisible(
      find.byKey(const Key('spread-ai-question')),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.enterText(
      find.byKey(const Key('spread-ai-question')),
      'Que dois-je savoir sur mon travail ?',
    );
    await tester.ensureVisible(find.byKey(const Key('spread-ai-ask')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('spread-ai-ask')));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const Key('spread-ai-answer')),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.byKey(const Key('spread-ai-answer')), findsOneWidget);
    expect(find.textContaining('your work'), findsWidgets);
  });

  testWidgetsJournalNotes();
  setUp(() {
    BuiltinWalletPanel.serviceOverride = SolanaWalletService(
      store: _MemoryWalletStore(),
    );
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

    await _enterAsGuest(tester);

    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getBool('guest_access_accepted'), isTrue);
    expect(preferences.getString('daily_card_id'), isNull);
    expect(find.text('Your personal card of the day'), findsOneWidget);
    expect(find.byKey(const Key('daily-card-back')), findsOneWidget);
    expect(find.text('Daily card already drawn'), findsNothing);

    await tester.tap(find.byKey(const Key('daily-draw')));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.text('Continue'));
    await tester.pump(const Duration(seconds: 2));
    final drawnId = preferences.getString('daily_card_id');
    expect(drawnId, isNotNull);
    expect(drawnId, isNot(todayCard.id));
    expect(find.text('Daily card already drawn'), findsOneWidget);
    expect((preferences.getStringList('journal_entries') ?? []).length, 1);

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Profile'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Unlock your Profile'), findsOneWidget);
    expect(find.textContaining('Journal sync stays off'), findsOneWidget);
    expect(find.byKey(const Key('account-gate-google')), findsOneWidget);
    await tester.ensureVisible(find.byKey(const Key('account-gate-google')));
    await tester.pumpAndSettle();
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
    await _enterAsGuest(tester);
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getBool('guest_access_accepted'), isTrue);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(const TarotNoirApp());
    await tester.pumpAndSettle();

    expect(find.text('Continue with Google'), findsNothing);
    expect(find.text('Continue without an account'), findsNothing);
    expect(find.byKey(const Key('daily-draw')), findsOneWidget);
    expect(find.text('Daily card already drawn'), findsNothing);
  });

  testWidgets('local data erasure requires explicit confirmation', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'preference_orion_memory': true,
      'user_profile': '{"displayName":"Test","firebaseUid":"test-user","completedAt":"2026-01-01T00:00:00.000Z"}',
    });
    await _pumpSignedInApp(tester);
    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Profile'),
      ),
    );
    await tester.pumpAndSettle();
    await _openProfileSubTab(tester, 'Journal');
    await tester.scrollUntilVisible(
      find.byIcon(Icons.tune),
      300,
      scrollable: find.byType(Scrollable).first,
    );
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
    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Profile'),
      ),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const Key('journal-cloud-sync')),
      300,
      scrollable: find.descendant(
        of: find.byKey(const Key('profile-home')),
        matching: find.byType(Scrollable),
      ),
    );
    expect(find.byKey(const Key('journal-cloud-sync')), findsOneWidget);
    expect(find.byKey(const Key('sign-out')), findsOneWidget);
    expect(find.text('Continue with Google'), findsNothing);
    expect(find.text('Continue with Facebook'), findsNothing);

    await _openProfileSubTab(tester, 'Wallet');
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

  test('spread journal draw types round-trip and are validated', () {
    final type = spreadDrawType(spreadCross5, 3);
    expect(isValidDrawType(type), isTrue);
    expect(parseSpreadDrawType(type)?.position, 3);
    expect(isValidDrawType('spread:cross5:5'), isFalse);
    expect(isValidDrawType('spread:unknown:0'), isFalse);
    expect(isValidDrawType('free'), isTrue);
    for (final spread in spreadCatalog) {
      for (final lang in ['fr', 'en', 'es']) {
        expect(
          spreadText(spread, lang).positions.length,
          spread.cardCount,
          reason: '${spread.id} $lang',
        );
      }
    }
    expect(spreadCatalog.where((spread) => spread.isFree), [spreadCross5]);
  });

  testWidgets('free 5-card spread is drawn after the ad and saved to journal', (
    tester,
  ) async {
    await tester.pumpWidget(const TarotNoirApp());
    await tester.pumpAndSettle();
    await _enterAsGuest(tester);
    await tester.tap(find.byKey(const Key('spreads')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('spreads-screen')), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline), findsWidgets);

    await tester.tap(find.byKey(const Key('spread-cross5')));
    await tester.pumpAndSettle();
    expect(find.text('Continue'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('spread-result')), findsOneWidget);
    expect(find.byKey(const Key('spread-layout')), findsOneWidget);
    expect(find.text('Situation'), findsWidgets);
    await tester.scrollUntilVisible(
      find.text('1. SITUATION'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('1. SITUATION'), findsOneWidget);

    final preferences = await SharedPreferences.getInstance();
    final saved = preferences.getStringList('journal_entries') ?? <String>[];
    expect(saved.where((e) => e.contains('spread:cross5:')).length, 5);
  });

  testWidgets('account gate compares guest, free account and Orion+', (
    tester,
  ) async {
    await tester.pumpWidget(const TarotNoirApp());
    await tester.pumpAndSettle();
    await _enterAsGuest(tester);
    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Profile'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('access-comparison')), findsOneWidget);
    expect(find.text('Guest'), findsOneWidget);
    expect(find.text('Free account'), findsOneWidget);
    expect(find.text('Orion+'), findsWidgets);
    expect(find.text('Extended spreads'), findsOneWidget);
  });

  testWidgets('locked spreads send free users to Premium', (tester) async {
    await tester.pumpWidget(const TarotNoirApp());
    await tester.pumpAndSettle();
    await _enterAsGuest(tester);
    await tester.tap(find.byKey(const Key('spreads')));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const Key('spread-celtic')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(find.byKey(const Key('spread-celtic')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('spread-celtic')));
    await tester.pumpAndSettle();
    expect(find.text('Premium Circle'), findsOneWidget);
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

void testWidgetsJournalNotes() {
  testWidgets('journal notes are collapsed by default and saved per entry', (
    tester,
  ) async {
    final entry = JournalEntry(
      card: tarotDeck.first,
      orientation: CardOrientation.upright,
      createdAt: DateTime(2026, 1, 2, 10),
      drawType: 'daily',
    );
    SharedPreferences.setMockInitialValues(<String, Object>{
      'journal_entries': [jsonEncode(entry.toJson())],
      'user_profile': '{"displayName":"Test","firebaseUid":"test-user","completedAt":"2026-01-01T00:00:00.000Z"}',
    });
    await _pumpSignedInApp(tester);
    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Profile'),
      ),
    );
    await tester.pumpAndSettle();
    await _openProfileSubTab(tester, 'Journal');
    final toggle = find.byKey(Key('journal-notes-toggle-${entry.syncId}'));
    await tester.scrollUntilVisible(
      toggle,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.byKey(Key('journal-notes-${entry.syncId}')), findsNothing);
    await tester.ensureVisible(toggle);
    await tester.pumpAndSettle();
    await tester.tap(toggle);
    await tester.pumpAndSettle();
    expect(find.byKey(Key('journal-notes-${entry.syncId}')), findsOneWidget);
    await tester.ensureVisible(find.byType(TextField).last);
    await tester.enterText(find.byType(TextField).last, 'Ma note');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save note'));
    await tester.pumpAndSettle();
    final preferences = await SharedPreferences.getInstance();
    expect(
      (preferences.getStringList('journal_entries') ?? []).single,
      contains('Ma note'),
    );
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

class _MemoryWalletStore implements WalletSecretStore {
  String? phrase;
  @override
  Future<void> deletePhrase() async => phrase = null;
  @override
  Future<String?> readPhrase() async => phrase;
  @override
  Future<void> writePhrase(String value) async => phrase = value;
}
