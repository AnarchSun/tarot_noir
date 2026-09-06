import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tarot_noir/app_config.dart';
import 'package:tarot_noir/controllers/tarot_controller.dart';
import 'package:tarot_noir/data/tarot_deck.dart';
import 'package:tarot_noir/models/user_preferences.dart';
import 'package:tarot_noir/repositories/local_repository.dart';
import 'package:tarot_noir/services/reading_policy.dart';

import 'support/memory_preferences.dart';

void main() {
  late MemoryPreferences storage;
  late DateTime now;
  TarotController controller({bool premium = false}) => TarotController(
    repository: PreferencesLocalRepository(storage: storage),
    policy: ReadingPolicy(premium: premium),
    clock: () => now,
  );

  setUp(() {
    storage = MemoryPreferences();
    now = DateTime(2026, 9, 5, 14);
  });

  test('catalog has 78 unique cards and eight valid image paths', () {
    expect(tarotDeck.length, 78);
    expect(tarotCardsById.length, 78);
    for (final suit in ['Bâtons', 'Coupes', 'Épées', 'Deniers']) {
      expect(tarotDeck.where((c) => c.id.endsWith('-$suit')).length, 14);
    }
    final images = tarotDeck.where((c) => c.imagePath.isNotEmpty).toList();
    expect(images.length, 8);
    expect(images.map((c) => c.imagePath).toSet().length, 8);
    for (final card in images) {
      expect(File(card.imagePath).existsSync(), isTrue);
    }
  });

  test(
    'notes, preferences and card survive a new controller and repository',
    () async {
      final first = controller();
      expect(await first.initialize(), isTrue);
      final id = first.state.card.id;
      expect(await first.saveNote('  Ma note mystique  ', 4), isTrue);
      expect(
        await first.updatePreferences(
          const UserPreferences(
            orionMemory: true,
            personalizedGuidance: true,
            dailyReminder: true,
            tone: OrionTone.gentle,
          ),
        ),
        isTrue,
      );
      first.dispose();
      final second = controller();
      await second.initialize();
      expect(second.state.card.id, id);
      expect(second.state.journal.single.note, 'Ma note mystique');
      expect(second.state.journal.single.mood, 4);
      expect(second.state.preferences.orionMemory, isTrue);
      expect(second.state.preferences.personalizedGuidance, isTrue);
      expect(second.state.preferences.dailyReminder, isTrue);
      expect(second.state.preferences.tone, OrionTone.gentle);
      expect(await second.draw(), isFalse);
      second.dispose();
    },
  );

  test(
    'free daily card renews on next day and ignores clock rollback',
    () async {
      final c = controller();
      await c.initialize();
      final initial = c.state.card.id;
      expect(await c.draw(), isFalse);
      now = DateTime(2026, 9, 6);
      await c.refreshDay();
      expect(c.state.day, now);
      expect(c.state.card.id, tarotDeck[dailyCardIndex(now, 78)].id);
      final next = c.state.card.id;
      now = DateTime(2026, 9, 5);
      await c.refreshDay();
      expect(c.state.card.id, next);
      expect(c.state.day, DateTime(2026, 9, 6));
      expect(initial, isNotEmpty);
      c.dispose();
    },
  );

  test(
    'Premium redraw persists history without storing an entitlement',
    () async {
      final c = controller(premium: true);
      await c.initialize();
      expect(await c.draw(), isTrue);
      expect(c.state.journal.length, 1);
      final restored = controller(premium: true);
      await restored.initialize();
      expect(restored.state.card.id, c.state.card.id);
      expect(restored.state.journal.length, 1);
      expect(
        storage.values[AppConfig.localStateKey],
        isNot(contains('premium')),
      );
      c.dispose();
      restored.dispose();
    },
  );

  test(
    'erasing persists defaults and preserves the daily lock and other keys',
    () async {
      storage.values['unrelated'] = 'keep';
      final c = controller();
      await c.initialize();
      final id = c.state.card.id;
      await c.saveNote('Private note', 3);
      await c.updatePreferences(const UserPreferences(orionMemory: true));
      expect(await c.erasePersonalData(), isTrue);
      final restored = controller();
      await restored.initialize();
      expect(restored.state.journal, isEmpty);
      expect(restored.state.preferences.orionMemory, isFalse);
      expect(restored.state.card.id, id);
      expect(await restored.draw(), isFalse);
      expect(storage.values['unrelated'], 'keep');
      expect(
        storage.values[AppConfig.localStateKey],
        isNot(contains('Private note')),
      );
      c.dispose();
      restored.dispose();
    },
  );

  test('failed writes preserve committed state and permit retry', () async {
    final c = controller();
    await c.initialize();
    final raw = storage.values[AppConfig.localStateKey];
    storage.failWrite = true;
    expect(await c.saveNote('Keep my draft', 2), isFalse);
    expect(c.storageError, isTrue);
    expect(c.state.journal, isEmpty);
    expect(storage.values[AppConfig.localStateKey], raw);
    storage.failWrite = false;
    expect(await c.saveNote('Keep my draft', 2), isTrue);
    expect(c.storageError, isFalse);
    expect(c.state.journal.single.note, 'Keep my draft');
    c.dispose();
  });

  test(
    'corrupt and future-version storage is retained without overwrite',
    () async {
      for (final raw in [
        'broken json',
        jsonEncode({'version': 999}),
      ]) {
        storage.values[AppConfig.localStateKey] = raw;
        final c = controller();
        expect(await c.initialize(), isFalse);
        expect(c.ready, isFalse);
        expect(c.storageError, isTrue);
        expect(storage.values[AppConfig.localStateKey], raw);
        expect(await c.saveNote('Must not overwrite', 3), isFalse);
        c.dispose();
      }
    },
  );

  test('unavailable reads can be retried', () async {
    storage.failRead = true;
    final c = controller();
    expect(await c.initialize(), isFalse);
    storage.failRead = false;
    expect(await c.initialize(), isTrue);
    c.dispose();
  });

  test(
    'concurrent save cannot duplicate a note or overwrite pending data',
    () async {
      final c = controller();
      await c.initialize();
      storage.writeGate = Completer<void>();
      final first = c.saveNote('Once', 3);
      expect(c.busy, isTrue);
      expect(await c.saveNote('Twice', 3), isFalse);
      storage.writeGate!.complete();
      expect(await first, isTrue);
      expect(c.state.journal.single.note, 'Once');
      c.dispose();
    },
  );
}
