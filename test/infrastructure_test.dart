import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarot_noir/models/journal_entry.dart';
import 'package:tarot_noir/models/premium_reading.dart';
import 'package:tarot_noir/models/tarot_card.dart';
import 'package:tarot_noir/models/tarot_deck.dart';
import 'package:tarot_noir/models/user_profile.dart';
import 'package:tarot_noir/services/tarot_storage_service.dart';

void main() {
  test('catalogue contains the complete Marseille deck', () {
    expect(tarotDeck, hasLength(78));
    expect(tarotDeck.map((card) => card.id).toSet(), hasLength(78));
    expect(tarotDeck.map((card) => card.name).toSet(), hasLength(78));

    expect(majorArcana, hasLength(22));
    expect(minorArcana, hasLength(56));
    expect(
      majorArcana.map((card) => card.number),
      containsAll(<String>[
        '0',
        'I',
        'II',
        'III',
        'IV',
        'V',
        'VI',
        'VII',
        'VIII',
        'IX',
        'X',
        'XI',
        'XII',
        'XIII',
        'XIV',
        'XV',
        'XVI',
        'XVII',
        'XVIII',
        'XIX',
        'XX',
        'XXI',
      ]),
    );
    expect(
      majorArcana.map((card) => card.name),
      containsAll(<String>[
        'Le Mat',
        'Le Bateleur',
        'La Papesse',
        'L’Impératrice',
        'L’Empereur',
        'Le Pape',
        'Les Amants',
        'Le Chariot',
        'La Justice',
        'L’Hermite',
        'La Roue de Fortune',
        'La Force',
        'Le Pendu',
        'La Mort',
        'Tempérance',
        'Le Diable',
        'La Tour',
        'L’Étoile',
        'La Lune',
        'Le Soleil',
        'Le Jugement',
        'Le Monde',
      ]),
    );

    for (final suit in ['Bâtons', 'Coupes', 'Épées', 'Deniers']) {
      expect(
        minorArcana.where((card) => card.name.endsWith(' de $suit')),
        hasLength(14),
      );
    }
  });

  test('every card has a substantial and unique premium reading', () {
    final readings = <String>{};
    for (final card in tarotDeck) {
      final reading = PremiumReadingCatalog.forCard(
        card,
        CardOrientation.upright,
      );
      expect(reading.essence.length, greaterThan(150), reason: card.name);
      expect(reading.shadow.length, greaterThan(80), reason: card.name);
      expect(reading.ritual.length, greaterThan(100), reason: card.name);
      readings.add(reading.essence);
    }
    expect(readings, hasLength(78));
  });

  test('only minor arcana support reversed orientation', () {
    expect(
      majorArcana.every((card) => !card.supportsReversedOrientation),
      isTrue,
    );
    expect(
      minorArcana.every((card) => card.supportsReversedOrientation),
      isTrue,
    );
  });

  test('legacy v1 state migrates without losing journal data', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'tarot_noir.state.v1': jsonEncode(<String, Object>{
        'version': 1,
        'day': '2026-09-25T00:00:00.000',
        'cardId': 'IX',
        'preferences': <String, Object>{
          'orionMemory': true,
          'personalizedGuidance': true,
          'dailyReminder': false,
          'tone': 'practical',
        },
        'journal': <Object>[
          <String, Object>{
            'cardId': 'XIII',
            'createdAt': '2026-09-24T12:00:00.000',
            'note': 'Transformation',
            'mood': 4,
          },
        ],
      }),
    });
    final storage = TarotStorageService();
    final snapshot = await storage.restore(tarotDeck);
    final preferences = await storage.restorePreferences();

    expect(
      snapshot.dailyCardId,
      tarotDeck.firstWhere((c) => c.number == 'IX').id,
    );
    expect(snapshot.journal.single.card.number, 'XIII');
    expect(snapshot.journal.single.note, 'Transformation');
    expect(preferences[TarotStorageService.orionMemoryKey], isTrue);
    expect(preferences[TarotStorageService.toneKey], 'Symbolique et concret');
    final raw = await SharedPreferences.getInstance();
    expect(raw.containsKey('tarot_noir.state.v1'), isFalse);
  });

  test('preferences persist and local data can be erased', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      TarotStorageService.journalKey: <String>['entry'],
      TarotStorageService.dailyCardKey: '0-Le Mat',
    });
    final storage = TarotStorageService();

    await storage.saveBoolPreference(TarotStorageService.orionMemoryKey, true);
    await storage.saveTone('Symbolique et concret');

    final restored = await TarotStorageService().restorePreferences();
    expect(restored[TarotStorageService.orionMemoryKey], isTrue);
    expect(restored[TarotStorageService.toneKey], 'Symbolique et concret');

    await storage.clearAll();
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getKeys(), isEmpty);
  });

  test(
    'completed wallet profile persists and is erased with local data',
    () async {
      final storage = TarotStorageService();
      final profile = UserProfile(
        displayName: 'Nyx',
        email: 'nyx@example.com',
        walletAddress: 'DevnetPublicAddress',
        completedAt: DateTime.utc(2026, 9, 26),
      );

      await storage.saveUserProfile(profile);
      final restored = await storage.restoreUserProfile();
      expect(restored, isNotNull);
      expect(restored!.displayName, 'Nyx');
      expect(restored.walletAddress, 'DevnetPublicAddress');

      await storage.clearAll();
      expect(await storage.restoreUserProfile(), isNull);
    },
  );

  test('storage schema version is explicit', () {
    expect(TarotStorageService.storageSchemaVersion, 2);
    expect(TarotStorageService.storageSchemaVersionKey, isNotEmpty);
  });

  test('daily draw lock resists a clock rollback', () {
    expect(
      TarotStorageService.isDailyDrawLocked(
        '2026-09-25',
        DateTime(2026, 9, 24),
      ),
      isTrue,
    );
    expect(
      TarotStorageService.isDailyDrawLocked(
        '2026-09-25',
        DateTime(2026, 9, 26),
      ),
      isFalse,
    );
  });

  test('journal orientation survives serialization', () {
    final entry = JournalEntry(
      card: minorArcana.first,
      orientation: CardOrientation.reversed,
      createdAt: DateTime.utc(2026, 9, 25),
    );

    final restored = JournalEntry.fromJson(
      jsonEncode(entry.toJson()),
      tarotDeck,
    );

    expect(restored, isNotNull);
    expect(restored!.orientation, CardOrientation.reversed);
  });

  test('legacy journal entries default to upright orientation', () {
    final entry = JournalEntry(
      card: minorArcana.first,
      createdAt: DateTime.utc(2026, 9, 25),
    ).toJson()..remove('orientation');

    final restored = JournalEntry.fromJson(jsonEncode(entry), tarotDeck);

    expect(restored, isNotNull);
    expect(restored!.orientation, CardOrientation.upright);
  });

  test('all declared illustrations are available and normalized', () {
    final illustrated = tarotDeck.where((card) => card.hasIllustration);
    final paths = illustrated.map((card) => card.imagePath).toList();

    expect(illustrated, hasLength(78));
    expect(paths.toSet(), hasLength(paths.length));
    for (final path in paths) {
      expect(path, startsWith('assets/images/tarot_temp/'));
      expect(
        path,
        matches(RegExp(r'^assets/images/tarot_temp/[A-Za-z0-9_]+\.png$')),
      );
      expect(File(path).existsSync(), isTrue, reason: path);
    }
  });
}
