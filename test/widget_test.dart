import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarot_noir/app_config.dart';
import 'package:tarot_noir/main.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('draw button reveals another card and journals it', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'daily_card_date': '2099-12-31',
      'daily_card_id': '0-Le Mat',
    });

    await tester.pumpWidget(const TarotNoirApp());
    await tester.pumpAndSettle();

    expect(find.text('Draw my daily card'), findsOneWidget);
    expect(find.byType(Image), findsNothing);

    await tester.tap(find.text('Draw my daily card'));
    await tester.pumpAndSettle();
    if (AppConfig.adPlaceholderEnabled && !AppConfig.premiumEnabled) {
      expect(find.text('Advertising space — preview'), findsOneWidget);
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
    }

    expect(
      find.text(
        AppConfig.dailyDrawLockEnabled
            ? 'Daily card already drawn'
            : 'Draw another card',
      ),
      findsOneWidget,
    );
    expect(find.byType(Image), findsOneWidget);

    await tester.tap(find.text('Journal'));
    await tester.pumpAndSettle();

    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('local data erasure requires explicit confirmation', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'preference_orion_memory': true,
    });
    await tester.pumpWidget(const TarotNoirApp());
    await tester.pumpAndSettle();
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

  testWidgets('profile exposes Facebook without pretending it is configured', (
    tester,
  ) async {
    await tester.pumpWidget(const TarotNoirApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('journal-cloud-sync')), findsNothing);
    expect(find.text('Continue with Facebook'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);
    expect(find.text('Continue with phone'), findsNothing);
    expect(find.text('Continue with email'), findsNothing);
    expect(find.byKey(const Key('apple-sign-in')), findsNothing);

    const configurationRequired =
        'Enable Firebase Authentication before signing in.';
    await tester.tap(find.byKey(const Key('google-sign-in')));
    await tester.pumpAndSettle();
    expect(find.text(configurationRequired), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('facebook-sign-in')));
    await tester.pumpAndSettle();
    expect(
      find.text(
        'Firebase and the Meta application must be configured before Facebook sign-in can open.',
      ),
      findsOneWidget,
    );
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Connection awaiting configuration'),
      300,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Connection awaiting configuration'), findsOneWidget);

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

  testWidgets('Apple sign-in is shown only on iOS', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    try {
      await tester.pumpWidget(const TarotNoirApp());
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('apple-sign-in')), findsOneWidget);
      await tester.tap(find.byKey(const Key('apple-sign-in')));
      await tester.pumpAndSettle();
      expect(
        find.text('Enable Firebase Authentication before signing in.'),
        findsOneWidget,
      );
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });

  testWidgets('falls back to English for an unsupported device locale', (
    tester,
  ) async {
    await tester.pumpWidget(const TarotNoirApp());
    expect(find.text('Daily reading'), findsOneWidget);
    expect(find.text('TAROT NOIR'), findsOneWidget);
  });
}
