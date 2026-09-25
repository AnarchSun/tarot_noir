import 'tarot_card.dart';

class PremiumReading {
  const PremiumReading({
    required this.essence,
    required this.shadow,
    required this.ritual,
  });
  final String essence;
  final String shadow;
  final String ritual;
}

abstract final class PremiumReadingCatalog {
  static const _major = <String, String>{
    'Le Mat': 'Un seuil s’ouvre sans carte complète du territoire. Fais confiance au mouvement vivant plutôt qu’aux certitudes usées.',
    'Le Bateleur': 'Le commencement est déjà entre tes mains. Tes outils, même imparfaits, suffisent pour poser le premier acte.',
    'La Papesse': 'Quelque chose mûrit dans le silence. L’écoute, l’étude et la patience révèlent davantage que la précipitation.',
    'L’Impératrice': 'La pensée cherche une forme fertile. Crée et nourris ce qui veut grandir sans exiger un résultat parfait.',
    'L’Empereur': 'La stabilité vient d’une structure assumée. Choisis les limites qui protègent ton œuvre et ton territoire.',
    'Le Pape': 'Une transmission devient possible. Reçois l’enseignement, puis éprouve-le afin qu’il soutienne ta propre voix.',
    'Les Amants': 'Le désir rencontre le choix. Cherche un accord profond entre tes valeurs, tes liens et ta direction.',
    'Le Chariot': 'Des forces contraires peuvent avancer ensemble si tu tiens clairement les rênes et la direction.',
    'La Justice': 'Les faits réclament une mesure honnête. Observe les conséquences et décide sans maquiller ce que tu sais.',
    'L’Hermite': 'Le retrait éclaire ce que le bruit recouvrait. Avance lentement et laisse l’expérience devenir sagesse.',
    'La Roue de Fortune': 'Le cycle tourne et redistribue les positions. Accueille l’incontrôlable et saisis la prise encore accessible.',
    'La Force': 'Ta puissance gagne à rester consciente et calme. Apprivoise l’instinct sans l’écraser.',
    'Le Pendu': 'La suspension change le regard. Cesse de forcer l’issue et observe la vérité depuis un autre angle.',
    'La Mort': 'Une forme a terminé son œuvre. La transformation demande une coupure nette pour libérer la vie.',
    'Tempérance': 'L’alchimie agit par dosage. Relie les contraires et laisse une solution souple émerger patiemment.',
    'Le Diable': 'Le désir montre sa puissance et ses attaches. Regarde ce qui te captive pour retrouver ton choix.',
    'La Tour': 'Une construction trop étroite se fissure. La chute révèle une vérité et prépare une base plus honnête.',
    'L’Étoile': 'La vulnérabilité redevient une source. Offre tes gestes à ce qui soigne et restaure ta confiance.',
    'La Lune': 'L’invisible colore le chemin. Accueille les pressentiments, puis vérifie-les avant de leur confier la direction.',
    'Le Soleil': 'La clarté nourrit le lien et la création. Partage la chaleur et accepte d’être vu sans armure inutile.',
    'Le Jugement': 'Un appel traverse ton histoire. Réponds depuis la personne que tu deviens plutôt que depuis la faute passée.',
    'Le Monde': 'Les fragments trouvent leur place dans un ensemble accompli. Honore la fin et prépare le cercle suivant.',
  };

  static const _ranks = <String, String>{
    'As': 'Une graine pure apparaît et demande un premier oui conscient.',
    'Deux': 'Deux forces cherchent un accord dans leur tension.',
    'Trois':
        'L’énergie circule et appelle coopération, expression et croissance.',
    'Quatre':
        'Une forme stable se construit, avec le risque de devenir trop fermée.',
    'Cinq':
        'Le conflit révèle une faille utile et oblige à réviser l’équilibre.',
    'Six': 'Un passage vers l’harmonie devient possible par l’échange.',
    'Sept': 'L’épreuve demande discernement et fidélité à ton intention.',
    'Huit': 'Le mouvement s’intensifie; la discipline transforme l’élan en maîtrise.',
    'Neuf': 'Le cycle approche de sa maturité et éprouve ton endurance.',
    'Dix': 'Une culmination apporte résultat et poids; intègre avant de recommencer.',
    'Valet': 'Un message neuf invite à apprendre et expérimenter sans masque.',
    'Cavalier':
        'La quête s’accélère; dirige ton énergie avant qu’elle ne choisisse.',
    'Reine': 'La maîtrise devient intérieure, réceptive et capable de nourrir.',
    'Roi':
        'La maîtrise devient décision, responsabilité et influence concrète.',
  };

  static const _suits = <String, String>{
    'Bâtons': 'Le feu des Bâtons concerne ton désir, ta créativité et ta capacité d’agir.',
    'Coupes': 'L’eau des Coupes traverse les émotions, l’intuition et la vérité des liens.',
    'Épées': 'L’air des Épées éclaire la pensée, la parole, les tensions et les choix lucides.',
    'Deniers': 'La terre des Deniers parle du corps, du travail, des ressources et de ce qui dure.',
  };

  static PremiumReading forCard(TarotCard card, CardOrientation orientation) {
    final essence = card.supportsReversedOrientation
        ? _minor(card)
        : (_major[card.name] ?? card.message);
    final direction = orientation.isReversed
        ? 'Renversée, ${card.name} signale une énergie retenue, excessive ou tournée contre toi; elle réclame un réajustement patient.'
        : 'Dans sa lumière, ${card.name} te demande d’habiter pleinement cette énergie sans la brusquer.';
    return PremiumReading(
      essence: '$essence $direction',
      shadow: orientation.isReversed
          ? 'Nœud à défaire : observe où la peur, le contrôle ou l’épuisement bloquent ${card.keyword.toLowerCase()}. La résistance indique ce qui demande du soin.'
          : 'Ombre à surveiller : confondre ${card.keyword.toLowerCase()} avec une obligation, ou avancer sans écouter tes limites.',
      ritual:
          'Rituel : écris une situation précise liée à ${card.keyword.toLowerCase()}. Choisis un geste réalisable aujourd’hui, puis note dans ton journal ce qu’il transforme.',
    );
  }

  static String _minor(TarotCard card) {
    final parts = card.name.split(' de ');
    return '${_ranks[parts.first] ?? card.message} ${_suits[parts.length > 1 ? parts.last : ''] ?? ''}';
  }
}
