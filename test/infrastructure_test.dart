import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tarot_noir/models/journal_entry.dart';
import 'package:tarot_noir/models/premium_reading.dart';
import 'package:tarot_noir/models/tarot_card.dart';
import 'package:tarot_noir/models/tarot_deck.dart';
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
      expect(path, startsWith('assets/images/tarot_cards/'));
      expect(
        path,
        matches(
          RegExp(
            r'^assets/images/tarot_cards/(major|minor)/[A-Za-z0-9_]+\.png$',
          ),
        ),
      );
      expect(File(path).existsSync(), isTrue, reason: path);
    }
  });
}
