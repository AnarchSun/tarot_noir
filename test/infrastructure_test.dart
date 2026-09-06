import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tarot_noir/models/tarot_deck.dart';

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

  test('all declared illustrations are available and normalized', () {
    final illustrated = tarotDeck.where((card) => card.hasIllustration);
    final paths = illustrated.map((card) => card.imagePath).toList();

    expect(paths.toSet(), hasLength(paths.length));
    for (final path in paths) {
      expect(path, startsWith('assets/images/tarot_cards/'));
      expect(
        path,
        matches(RegExp(r'^assets/images/tarot_cards/[A-Za-z0-9_]+\.png$')),
      );
      expect(File(path).existsSync(), isTrue, reason: path);
    }
  });
}
