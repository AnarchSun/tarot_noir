import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tarot_noir/app_config.dart';
import 'package:tarot_noir/main.dart';
import 'package:tarot_noir/controllers/tarot_controller.dart';
import 'package:tarot_noir/repositories/local_repository.dart';
import 'package:tarot_noir/services/reading_policy.dart';

import 'support/memory_preferences.dart';

void main() {
  late MemoryPreferences storage;
  TarotController makeController() =>
      TarotController(repository: PreferencesLocalRepository(storage: storage));
  setUp(() {
    storage = MemoryPreferences();
  });

  test('daily card is stable throughout the same calendar day', () {
    expect(
      dailyCardIndex(DateTime(2026, 9, 5, 23, 59), 78),
      dailyCardIndex(DateTime(2026, 9, 5), 78),
    );
  });

  testWidgets('free redraw stays blocked after restarting the app', (
    tester,
  ) async {
    for (var i = 0; i < 2; i++) {
      final c = makeController();
      await tester.pumpWidget(TarotNoirApp(controller: c));
      await tester.pumpAndSettle();
      expect(find.text('Daily reading'), findsOneWidget);
      await tester.drag(find.byType(ListView), const Offset(0, -600));
      await tester.pumpAndSettle();
      final button = tester.widget<FilledButton>(
        find.byWidgetPredicate((widget) => widget is FilledButton),
      );
      expect(button.onPressed == null, !AppConfig.premiumEnabled);
      expect(
        find.text('Daily card revealed · come back tomorrow'),
        AppConfig.premiumEnabled ? findsNothing : findsOneWidget,
      );
      await tester.pumpWidget(const SizedBox.shrink());
      c.dispose();
    }
  });

  testWidgets('comparison includes all ten feature rows', (tester) async {
    final c = makeController();
    await tester.pumpWidget(TarotNoirApp(controller: c));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Premium'));
    await tester.pumpAndSettle();
    expect(tester.widget<Table>(find.byType(Table)).children.length, 11);
    expect(find.text('1 card per day · short text'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    c.dispose();
  });

  testWidgets('journal UI retains draft on failure then saves across restart', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(450, 950));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final c = makeController();
    await tester.pumpWidget(TarotNoirApp(controller: c));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Journal'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'My saved note');
    storage.failWrite = true;
    await tester.tap(find.text('Sceller cette note'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      'My saved note',
    );
    storage.failWrite = false;
    await tester.tap(find.text('Sceller cette note'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      isEmpty,
    );
    await tester.pumpWidget(const SizedBox.shrink());
    c.dispose();
    final restored = makeController();
    await tester.pumpWidget(TarotNoirApp(controller: restored));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Journal'));
    await tester.pumpAndSettle();
    expect(find.text('My saved note · 3/5'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    restored.dispose();
  });

  testWidgets('preferences persist and erase requires confirmation', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(450, 1100));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final c = makeController();
    await tester.pumpWidget(TarotNoirApp(controller: c));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Journal'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.tune));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(SwitchListTile).first);
    await tester.pumpAndSettle();
    expect(c.state.preferences.orionMemory, isTrue);
    final restored = makeController();
    await restored.initialize();
    expect(restored.state.preferences.orionMemory, isTrue);
    restored.dispose();
    await tester.scrollUntilVisible(find.byIcon(Icons.delete_outline), 300);
    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(c.state.preferences.orionMemory, isTrue);
    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();
    await tester.tap(
      find
          .descendant(
            of: find.byType(AlertDialog),
            matching: find.byType(TextButton),
          )
          .last,
    );
    await tester.pumpAndSettle();
    expect(c.state.preferences.orionMemory, isFalse);
    await tester.pumpWidget(const SizedBox.shrink());
    c.dispose();
  });
}
