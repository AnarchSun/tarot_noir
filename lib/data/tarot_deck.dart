import '../app_config.dart';
import '../models/tarot_card.dart';

const _arcana = <TarotCard>[
  TarotCard(
    number: '0',
    id: '0',
    nameFr: 'Le Fou',
    symbol: '✦',
    keyword: 'LE SAUT',
    message: 'Le vide n’est pas une chute : c’est l’espace où ton prochain monde cherche sa forme.',
    imagePath: '',
  ),
  TarotCard(
    number: 'II',
    id: 'II',
    nameFr: 'La Grande Prêtresse',
    symbol: '☾',
    keyword: 'LE SECRET',
    message: 'Ne livre pas ta lumière à ceux qui ne savent regarder que les braises.',
    imagePath: '',
  ),
  TarotCard(
    number: 'XIII',
    id: 'XIII',
    nameFr: 'La Mort',
    symbol: '☠',
    keyword: 'LA MUE',
    message: 'Ce qui se termine libère une place sacrée. Laisse l’ancienne peau à la terre.',
    imagePath: '${AppConfig.tarotImageDirectory}/La_Mort.png',
  ),
  TarotCard(
    number: 'XVIII',
    id: 'XVIII',
    nameFr: 'La Lune',
    symbol: '☾',
    keyword: 'LE MIRAGE',
    message: 'Ton intuition parle bas sous le bruit. Marche lentement, mais marche avec elle.',
    imagePath: '${AppConfig.tarotImageDirectory}/La_Lune.png',
  ),
  TarotCard(
    number: 'XV',
    id: 'XV',
    nameFr: 'Le Diable',
    symbol: '♜',
    keyword: 'LA CHAÎNE',
    message:
        'Regarde la chaîne : elle est peut-être plus lâche que tu ne le crois.',
    imagePath: '${AppConfig.tarotImageDirectory}/Le_Diable.png',
  ),
  TarotCard(
    number: 'XVII',
    id: 'XVII',
    nameFr: 'L’Étoile',
    symbol: '✧',
    keyword: 'LA GUÉRISON',
    message: 'Après la nuit, ton désir de vivre demeure une forme de magie.',
    imagePath: '',
  ),
  TarotCard(
    number: 'VI',
    id: 'VI',
    nameFr: 'Les Amants',
    symbol: '♡',
    keyword: 'L’UNION',
    message: 'Deux chemins peuvent se rencontrer sans perdre leur mystère.',
    imagePath: '${AppConfig.tarotImageDirectory}/Les_Amants.png',
  ),
  TarotCard(
    number: 'XXI',
    id: 'XXI',
    nameFr: 'Le Monde',
    symbol: '◎',
    keyword: 'L’ACCOMPLISSEMENT',
    message: 'Ce qui semblait dispersé retrouve son cercle. Une fin peut devenir une porte.',
    imagePath: '${AppConfig.tarotImageDirectory}/Le_Monde.png',
  ),
  TarotCard(
    number: 'I',
    id: 'I',
    nameFr: 'Le Bateleur',
    symbol: '✣',
    keyword: 'L’ÉLAN',
    message: 'Les outils sont là. Commence humblement, puis laisse le geste te révéler sa voie.',
    imagePath: '',
  ),
  TarotCard(
    number: 'III',
    id: 'III',
    nameFr: 'L’Impératrice',
    symbol: '♕',
    keyword: 'LA CRÉATION',
    message:
        'Ce qui germe demande du soin, de la beauté et un espace où respirer.',
    imagePath: '',
  ),
  TarotCard(
    number: 'IV',
    id: 'IV',
    nameFr: 'L’Empereur',
    symbol: '♔',
    keyword: 'LA STRUCTURE',
    message: 'Une limite juste peut devenir une protection, jamais une cage.',
    imagePath: '',
  ),
  TarotCard(
    number: 'V',
    id: 'V',
    nameFr: 'Le Pape',
    symbol: '✠',
    keyword: 'LA TRANSMISSION',
    message: 'Cherche un repère qui nourrit ta liberté au lieu de parler à ta place.',
    imagePath: '',
  ),
  TarotCard(
    number: 'VII',
    id: 'VII',
    nameFr: 'Le Chariot',
    symbol: '✦',
    keyword: 'LE PASSAGE',
    message: 'Rassemble tes forces vers une seule direction et avance sans te trahir.',
    imagePath: '',
  ),
  TarotCard(
    number: 'VIII',
    id: 'VIII',
    nameFr: 'La Justice',
    symbol: '⚖',
    keyword: 'L’ÉQUILIBRE',
    message: 'Regarde les faits avec clarté : chaque choix construit son propre poids.',
    imagePath: '',
  ),
  TarotCard(
    number: 'IX',
    id: 'IX',
    nameFr: 'L’Hermite',
    symbol: '☿',
    keyword: 'LA LAMPE',
    message: 'Le retrait choisi éclaire la prochaine marche. Garde une lumière, même petite.',
    imagePath: '${AppConfig.tarotImageDirectory}/L_Hermite.png',
  ),
  TarotCard(
    number: 'X',
    id: 'X',
    nameFr: 'La Roue de Fortune',
    symbol: '◉',
    keyword: 'LE CYCLE',
    message:
        'Le mouvement revient. Accueille ce qui change et ancre ce qui compte.',
    imagePath: '',
  ),
  TarotCard(
    number: 'XI',
    id: 'XI',
    nameFr: 'La Force',
    symbol: '♌',
    keyword: 'LE COURAGE',
    message: 'La force calme transforme davantage que la contrainte. Respire avant d’agir.',
    imagePath: '',
  ),
  TarotCard(
    number: 'XII',
    id: 'XII',
    nameFr: 'Le Pendu',
    symbol: '⌇',
    keyword: 'LE RENVERSEMENT',
    message:
        'Une pause volontaire peut montrer l’angle que l’élan ne voyait pas.',
    imagePath: '',
  ),
  TarotCard(
    number: 'XIV',
    id: 'XIV',
    nameFr: 'Tempérance',
    symbol: '⚗',
    keyword: 'L’ALCHIMIE',
    message: 'Dose, relie, ajuste. Ton équilibre se fabrique par de petits mélanges vrais.',
    imagePath: '',
  ),
  TarotCard(
    number: 'XVI',
    id: 'XVI',
    nameFr: 'La Maison Dieu',
    symbol: 'ϟ',
    keyword: 'LA FAILLE',
    message: 'Une structure tombe parfois pour libérer la vérité qui voulait passer.',
    imagePath: '',
  ),
  TarotCard(
    number: 'XIX',
    id: 'XIX',
    nameFr: 'Le Soleil',
    symbol: '☀',
    keyword: 'LA CLARTÉ',
    message: 'Partage ce qui te rend vivant. Une joie honnête peut servir de boussole.',
    imagePath: '${AppConfig.tarotImageDirectory}/Le_Soleil.png',
  ),
  TarotCard(
    number: 'XX',
    id: 'XX',
    nameFr: 'Le Jugement',
    symbol: '⌁',
    keyword: 'L’APPEL',
    message: 'Une voix ancienne appelle une réponse neuve. Choisis ce qui t’appartient.',
    imagePath: '',
  ),
];

const _minorRanks = [
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

const _minorSuits = [
  _MinorSuit('Bâtons', '♣', 'l’élan, l’action et la création'),
  _MinorSuit('Coupes', '♡', 'l’émotion, le lien et l’intuition'),
  _MinorSuit('Épées', '♠', 'la pensée, la parole et le discernement'),
  _MinorSuit('Deniers', '◇', 'le corps, les ressources et le quotidien'),
];

final _minorArcana = <TarotCard>[
  for (final suit in _minorSuits)
    for (var index = 0; index < _minorRanks.length; index++)
      TarotCard(
        number: '${index + 1}-${suit.name}',
        id: '${index + 1}-${suit.name}',
        nameFr: '${_minorRanks[index]} de ${suit.name}',
        symbol: suit.symbol,
        keyword: suit.name.toUpperCase(),
        message:
            'Cette carte parle de ${suit.theme}. Cherche le prochain geste simple qui respecte ton intention.',
        imagePath: suit.name == 'Épées' && index == 0
            ? '${AppConfig.tarotImageDirectory}/As_Dépées.png'
            : '',
      ),
];

final tarotDeck = List<TarotCard>.unmodifiable([..._arcana, ..._minorArcana]);

final tarotCardsById = Map<String, TarotCard>.unmodifiable({
  for (final card in tarotDeck) card.id: card,
});

class _MinorSuit {
  const _MinorSuit(this.name, this.symbol, this.theme);

  final String name;
  final String symbol;
  final String theme;
}
