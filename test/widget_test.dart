import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarot_noir/app_config.dart';
import 'package:tarot_noir/l10n/app_localizations.dart';
import 'package:tarot_noir/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('random-card welcome leads to a daily reading for guests', (
    tester,
  ) async {
    await tester.pumpWidget(const TarotNoirApp());
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('welcome-landing')), findsOneWidget);
    expect(find.byKey(const Key('welcome-background')), findsOneWidget);
    expect(find.byKey(const Key('welcome-logo')), findsOneWidget);
    expect(find.byKey(const Key('welcome-preview-card')), findsOneWidget);
    expect(find.byKey(const Key('welcome-card-meaning')), findsOneWidget);
    expect(find.byKey(const Key('daily-card-back')), findsNothing);
    expect(find.text('Continue with Google'), findsOneWidget);
    expect(find.text('Continue with Facebook'), findsNothing);
    expect(find.text('Continue without an account'), findsOneWidget);
    expect(find.byKey(const Key('daily-draw')), findsNothing);

    await tester.tap(find.byKey(const Key('continue-as-guest')));
    await tester.pumpAndSettle();

    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getBool('guest_access_accepted'), isTrue);
    expect(preferences.getString('daily_card_id'), isNull);
    expect(find.byKey(const Key('daily-draw')), findsOneWidget);
    expect(find.byKey(const Key('daily-card-back')), findsOneWidget);
    _expectVisibleInReadingViewport(
      tester,
      find.byKey(const Key('daily-draw')),
    );

    await tester.tap(find.byKey(const Key('daily-draw')));
    if (AppConfig.adPlaceholderEnabled && !AppConfig.premiumEnabled) {
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Advertising space — preview'), findsOneWidget);
      await tester.tap(find.text('Continue'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pump();
    } else {
      await tester.pump(const Duration(milliseconds: 700));
    }

    expect(find.byKey(const Key('daily-draw')), findsOneWidget);
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

void _expectVisibleInReadingViewport(WidgetTester tester, Finder finder) {
  final buttonBounds = tester.getRect(finder);
  final readingBounds = tester.getRect(find.byType(ListView).first);
  expect(buttonBounds.overlaps(readingBounds), isTrue);
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
