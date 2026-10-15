class SpreadDefinition {
  const SpreadDefinition(this.id, this.cardCount, {required this.isFree});

  final String id;
  final int cardCount;

  /// Free spreads are available to everyone after a short ad.
  final bool isFree;
}

class SpreadText {
  const SpreadText(this.title, this.description, this.positions);

  final String title;
  final String description;
  final List<String> positions;
}

const spreadCross5 = SpreadDefinition('cross5', 5, isFree: true);
const spreadThree = SpreadDefinition('three', 3, isFree: false);
const spreadSeasons = SpreadDefinition('seasons', 4, isFree: false);
const spreadRelationship = SpreadDefinition('relationship', 6, isFree: false);
const spreadCeltic = SpreadDefinition('celtic', 10, isFree: false);

const spreadCatalog = <SpreadDefinition>[
  spreadCross5,
  spreadThree,
  spreadSeasons,
  spreadRelationship,
  spreadCeltic,
];

const _spreadTexts = <String, Map<String, SpreadText>>{
  'fr': {
    'cross5': SpreadText(
      'Croix à 5 cartes',
      'Le tirage de base : une situation vue du passé, de l’avenir, de ce qui t’élève et de ce qui te retient.',
      ['Situation', 'Passé', 'Avenir', 'Ce qui t’élève', 'Ce qui te retient'],
    ),
    'three': SpreadText(
      'Passé · Présent · Avenir',
      'Un regard simple sur le chemin parcouru, l’instant et la direction.',
      ['Passé', 'Présent', 'Avenir'],
    ),
    'seasons': SpreadText(
      'Les Saisons',
      'Quatre temps pour lire un cycle : ce qui s’éveille, s’épanouit, mûrit et se retire.',
      ['Printemps', 'Été', 'Automne', 'Hiver'],
    ),
    'relationship': SpreadText(
      'Relations',
      'Un lien lu des deux côtés : toi, l’autre, ce qui vous relie ou vous sépare.',
      [
        'Toi',
        'L’autre',
        'Ce qui vous relie',
        'Ce qui vous sépare',
        'Ce que tu offres',
        'Conseil',
      ],
    ),
    'celtic': SpreadText(
      'Croix celtique',
      'Le grand tirage à 10 cartes pour explorer une question en profondeur.',
      [
        'Situation',
        'Obstacle',
        'Fondation',
        'Passé récent',
        'Couronne',
        'Avenir proche',
        'Toi',
        'Environnement',
        'Espoirs et peurs',
        'Issue',
      ],
    ),
  },
  'en': {
    'cross5': SpreadText(
      '5-card cross',
      'The basic spread: a situation seen from the past, the future, what lifts you and what holds you back.',
      ['Situation', 'Past', 'Future', 'What lifts you', 'What holds you back'],
    ),
    'three': SpreadText(
      'Past · Present · Future',
      'A simple look at the road travelled, the moment and the direction.',
      ['Past', 'Present', 'Future'],
    ),
    'seasons': SpreadText(
      'The Seasons',
      'Four moments to read a cycle: what awakens, flourishes, ripens and withdraws.',
      ['Spring', 'Summer', 'Autumn', 'Winter'],
    ),
    'relationship': SpreadText(
      'Relationships',
      'A bond read from both sides: you, the other, what joins and what divides you.',
      [
        'You',
        'The other',
        'What joins you',
        'What divides you',
        'What you offer',
        'Advice',
      ],
    ),
    'celtic': SpreadText(
      'Celtic cross',
      'The great 10-card spread to explore a question in depth.',
      [
        'Situation',
        'Obstacle',
        'Foundation',
        'Recent past',
        'Crown',
        'Near future',
        'You',
        'Surroundings',
        'Hopes and fears',
        'Outcome',
      ],
    ),
  },
  'es': {
    'cross5': SpreadText(
      'Cruz de 5 cartas',
      'La tirada básica: una situación vista desde el pasado, el futuro, lo que te eleva y lo que te retiene.',
      ['Situación', 'Pasado', 'Futuro', 'Lo que te eleva', 'Lo que te retiene'],
    ),
    'three': SpreadText(
      'Pasado · Presente · Futuro',
      'Una mirada simple al camino recorrido, al instante y a la dirección.',
      ['Pasado', 'Presente', 'Futuro'],
    ),
    'seasons': SpreadText(
      'Las Estaciones',
      'Cuatro tiempos para leer un ciclo: lo que despierta, florece, madura y se retira.',
      ['Primavera', 'Verano', 'Otoño', 'Invierno'],
    ),
    'relationship': SpreadText(
      'Relaciones',
      'Un vínculo leído desde ambos lados: tú, el otro, lo que los une y lo que los separa.',
      [
        'Tú',
        'El otro',
        'Lo que los une',
        'Lo que los separa',
        'Lo que ofreces',
        'Consejo',
      ],
    ),
    'celtic': SpreadText(
      'Cruz celta',
      'La gran tirada de 10 cartas para explorar una pregunta en profundidad.',
      [
        'Situación',
        'Obstáculo',
        'Fundamento',
        'Pasado reciente',
        'Corona',
        'Futuro cercano',
        'Tú',
        'Entorno',
        'Esperanzas y miedos',
        'Desenlace',
      ],
    ),
  },
};

SpreadText spreadText(SpreadDefinition spread, String languageCode) =>
    (_spreadTexts[languageCode] ?? _spreadTexts['en']!)[spread.id]!;

const _spreadPrefix = 'spread:';

/// Journal entries of a spread store the spread and the card's position.
String spreadDrawType(SpreadDefinition spread, int position) =>
    '$_spreadPrefix${spread.id}:$position';

({SpreadDefinition spread, int position})? parseSpreadDrawType(
  String drawType,
) {
  if (!drawType.startsWith(_spreadPrefix)) return null;
  final parts = drawType.substring(_spreadPrefix.length).split(':');
  if (parts.length != 2) return null;
  final position = int.tryParse(parts[1]);
  if (position == null) return null;
  for (final spread in spreadCatalog) {
    if (spread.id == parts[0] && position >= 0 && position < spread.cardCount) {
      return (spread: spread, position: position);
    }
  }
  return null;
}

bool isValidDrawType(String drawType) =>
    drawType == 'daily' ||
    drawType == 'free' ||
    parseSpreadDrawType(drawType) != null;

String drawTypeLabel(
  String drawType,
  String languageCode, {
  required String daily,
  required String free,
}) {
  if (drawType == 'daily') return daily;
  final parsed = parseSpreadDrawType(drawType);
  if (parsed == null) return free;
  final text = spreadText(parsed.spread, languageCode);
  return '${text.title} · ${text.positions[parsed.position]}';
}
