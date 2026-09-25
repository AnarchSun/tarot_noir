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

  testWidgets('falls back to English for an unsupported device locale', (
    tester,
  ) async {
    await tester.pumpWidget(const TarotNoirApp());
    expect(find.text('Daily reading'), findsOneWidget);
    expect(find.text('TAROT NOIR'), findsOneWidget);
  });
}
