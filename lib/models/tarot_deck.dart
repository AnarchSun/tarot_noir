import 'tarot_card.dart';

const majorArcana = <TarotCard>[
  TarotCard(
    '0',
    'Le Mat',
    '✦',
    'LE SAUT',
    'Le vide n’est pas une chute : c’est l’espace où ton prochain monde cherche sa forme.',
    'assets/images/tarot_cards/major/Le_Fou.png',
  ),
  TarotCard(
    'II',
    'La Papesse',
    '☾',
    'LE SECRET',
    'Ne livre pas ta lumière à ceux qui ne savent regarder que les braises.',
    'assets/images/tarot_cards/major/La_Papesse.png',
  ),
  TarotCard(
    'XIII',
    'La Mort',
    '☠',
    'LA MUE',
    'Ce qui se termine libère une place sacrée. Laisse l’ancienne peau à la terre.',
    'assets/images/tarot_cards/major/La_Mort.png',
  ),
  TarotCard(
    'XVIII',
    'La Lune',
    '☾',
    'LE MIRAGE',
    'Ton intuition parle bas sous le bruit. Marche lentement, mais marche avec elle.',
    'assets/images/tarot_cards/major/La_Lune.png',
  ),
  TarotCard(
    'XV',
    'Le Diable',
    '♜',
    'LA CHAÎNE',
    'Regarde la chaîne : elle est peut-être plus lâche que tu ne le crois.',
    'assets/images/tarot_cards/major/Le_Diable.png',
  ),
  TarotCard(
    'XVII',
    'L’Étoile',
    '✧',
    'LA GUÉRISON',
    'Après la nuit, ton désir de vivre demeure une forme de magie.',
    'assets/images/tarot_cards/major/L_Etoile.png',
  ),
  TarotCard(
    'VI',
    'Les Amants',
    '♡',
    'L’UNION',
    'Deux chemins peuvent se rencontrer sans perdre leur mystère.',
    'assets/images/tarot_cards/major/Les_Amants.png',
  ),
  TarotCard(
    'XXI',
    'Le Monde',
    '◎',
    'L’ACCOMPLISSEMENT',
    'Ce qui semblait dispersé retrouve son cercle. Une fin peut devenir une porte.',
    'assets/images/tarot_cards/major/Le_Monde.png',
  ),
  TarotCard(
    'I',
    'Le Bateleur',
    '✣',
    'L’ÉLAN',
    'Les outils sont là. Commence humblement, puis laisse le geste te révéler sa voie.',
    'assets/images/tarot_cards/major/Le_Bateleur.png',
  ),
  TarotCard(
    'III',
    'L’Impératrice',
    '♕',
    'LA CRÉATION',
    'Ce qui germe demande du soin, de la beauté et un espace où respirer.',
    'assets/images/tarot_cards/major/L_Imperatrice.png',
  ),
  TarotCard(
    'IV',
    'L’Empereur',
    '♔',
    'LA STRUCTURE',
    'Une limite juste peut devenir une protection, jamais une cage.',
    'assets/images/tarot_cards/major/L_Empereur.png',
  ),
  TarotCard(
    'V',
    'Le Pape',
    '✠',
    'LA TRANSMISSION',
    'Cherche un repère qui nourrit ta liberté au lieu de parler à ta place.',
    'assets/images/tarot_cards/major/Le_Pape.png',
  ),
  TarotCard(
    'VII',
    'Le Chariot',
    '✦',
    'LE PASSAGE',
    'Rassemble tes forces vers une seule direction et avance sans te trahir.',
    'assets/images/tarot_cards/major/Le_Chariot.png',
  ),
  TarotCard(
    'VIII',
    'La Justice',
    '⚖',
    'L’ÉQUILIBRE',
    'Regarde les faits avec clarté : chaque choix construit son propre poids.',
    'assets/images/tarot_cards/major/La_Justice.png',
  ),
  TarotCard(
    'IX',
    'L’Hermite',
    '☿',
    'LA LAMPE',
    'Le retrait choisi éclaire la prochaine marche. Garde une lumière, même petite.',
    'assets/images/tarot_cards/major/L_Hermite.png',
  ),
  TarotCard(
    'X',
    'La Roue de Fortune',
    '◉',
    'LE CYCLE',
    'Le mouvement revient. Accueille ce qui change et ancre ce qui compte.',
    'assets/images/tarot_cards/major/La_Roue_De_Fortune.png',
  ),
  TarotCard(
    'XI',
    'La Force',
    '♌',
    'LE COURAGE',
    'La force calme transforme davantage que la contrainte. Respire avant d’agir.',
    'assets/images/tarot_cards/major/La_Force.png',
  ),
  TarotCard(
    'XII',
    'Le Pendu',
    '⌇',
    'LE RENVERSEMENT',
    'Une pause volontaire peut montrer l’angle que l’élan ne voyait pas.',
    'assets/images/tarot_cards/major/Le_Pendu.png',
  ),
  TarotCard(
    'XIV',
    'Tempérance',
    '⚗',
    'L’ALCHIMIE',
    'Dose, relie, ajuste. Ton équilibre se fabrique par de petits mélanges vrais.',
    'assets/images/tarot_cards/major/Temperance.png',
  ),
  TarotCard(
    'XVI',
    'La Tour',
    'ϟ',
    'LA FAILLE',
    'Une structure tombe parfois pour libérer la vérité qui voulait passer.',
    'assets/images/tarot_cards/major/La_Tour.png',
  ),
  TarotCard(
    'XIX',
    'Le Soleil',
    '☀',
    'LA CLARTÉ',
    'Partage ce qui te rend vivant. Une joie honnête peut servir de boussole.',
    'assets/images/tarot_cards/major/Le_Soleil.png',
  ),
  TarotCard(
    'XX',
    'Le Jugement',
    '⌁',
    'L’APPEL',
    'Une voix ancienne appelle une réponse neuve. Choisis ce qui t’appartient.',
    'assets/images/tarot_cards/major/Le_Jugement.png',
  ),
];

const minorRanks = [
  'As',
  'Deux',
  'Trois',
  'Quatre',
  'Cinq',
  'Six',
  'Sept',
  'Huit',
  'Neuf',
  'Dix',
  'Valet',
  'Cavalier',
  'Reine',
  'Roi',
];

const minorSuits = [
  (name: 'Bâtons', symbol: '♣', theme: 'l’élan, l’action et la création'),
  (name: 'Coupes', symbol: '♡', theme: 'l’émotion, le lien et l’intuition'),
  (
    name: 'Épées',
    symbol: '♠',
    theme: 'la pensée, la parole et le discernement',
  ),
  (
    name: 'Deniers',
    symbol: '◇',
    theme: 'le corps, les ressources et le quotidien',
  ),
];

const _minorFileRanks = [
  'As',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '10',
  'Valet',
  'Cavalier',
  'Reine',
  'Roi',
];

String _minorImagePath(String suit, int rankIndex) {
  final suitFile = switch (suit) {
    'Bâtons' => 'De_Batons',
    'Coupes' => 'De_Coupes',
    'Épées' => 'D_Epees',
    'Deniers' => 'De_Deniers',
    _ => throw ArgumentError.value(suit, 'suit'),
  };
  return 'assets/images/tarot_cards/minor/'
      '${_minorFileRanks[rankIndex]}_$suitFile.png';
}

final minorArcana = <TarotCard>[
  for (final suit in minorSuits)
    for (var index = 0; index < minorRanks.length; index++)
      TarotCard(
        '${index + 1}-${suit.name}',
        '${minorRanks[index]} de ${suit.name}',
        suit.symbol,
        suit.name.toUpperCase(),
        'Cette carte parle de ${suit.theme}. Cherche le prochain geste simple qui respecte ton intention.',
        _minorImagePath(suit.name, index),
      ),
];

final tarotDeck = <TarotCard>[...majorArcana, ...minorArcana];
