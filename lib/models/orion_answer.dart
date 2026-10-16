import 'tarot_card.dart';
import 'tarot_card_text.dart';

enum OrionTopic { love, work, money, health, decision, general }

class OrionQuestionCard {
  const OrionQuestionCard({
    required this.card,
    required this.orientation,
    required this.position,
  });

  final TarotCard card;
  final CardOrientation orientation;
  final String position;
}

/// Local, deterministic answers. Replace with a server-side AI later.
class OrionAnswerCatalog {
  static const _keywords = <OrionTopic, List<String>>{
    OrionTopic.love: [
      'amour',
      'love',
      'amor',
      'couple',
      'relation',
      'ex',
      'cœur',
      'coeur',
      'heart',
      'corazón',
      'corazon',
      'pareja',
      'mariage',
      'boyfriend',
      'girlfriend',
      'novio',
      'novia',
    ],
    OrionTopic.work: [
      'travail',
      'boulot',
      'emploi',
      'carrière',
      'carriere',
      'job',
      'work',
      'career',
      'trabajo',
      'carrera',
      'projet',
      'project',
      'proyecto',
      'patron',
      'boss',
      'jefe',
    ],
    OrionTopic.money: [
      'argent',
      'money',
      'dinero',
      'finance',
      'dette',
      'debt',
      'deuda',
      'salaire',
      'salary',
      'salario',
      'investissement',
      'invest',
    ],
    OrionTopic.health: [
      'santé',
      'sante',
      'health',
      'salud',
      'corps',
      'body',
      'cuerpo',
      'fatigue',
      'stress',
      'sommeil',
      'sleep',
      'sueño',
    ],
    OrionTopic.decision: [
      'choisir',
      'choix',
      'choose',
      'choice',
      'decision',
      'décision',
      'elegir',
      'dois-je',
      'should',
      'debo',
      'quitter',
      'leave',
      'dejar',
    ],
  };

  static OrionTopic topicOf(String question) {
    final words = RegExp(
      r"[\p{L}'’]+",
      unicode: true,
    ).allMatches(question.toLowerCase()).map((m) => m.group(0)!).toSet();
    for (final entry in _keywords.entries) {
      if (entry.value.any(words.contains)) return entry.key;
    }
    return OrionTopic.general;
  }

  static const _intro = <String, Map<OrionTopic, String>>{
    'fr': {
      OrionTopic.love: 'Sur le terrain du cœur et des liens, voici ce que disent tes cartes.',
      OrionTopic.work: 'Pour ta vie professionnelle et tes projets, voici ce que montrent tes cartes.',
      OrionTopic.money: 'Pour ce qui touche à l’argent et aux ressources, voici ce que révèlent tes cartes.',
      OrionTopic.health: 'Pour ton énergie et ton équilibre, voici ce que murmurent tes cartes. Ce n’est pas un avis médical.',
      OrionTopic.decision: 'Face à ce choix, voici l’éclairage de tes cartes.',
      OrionTopic.general: 'Voici la réponse de tes cartes à ta question.',
    },
    'en': {
      OrionTopic.love:
          'On matters of the heart and bonds, here is what your cards say.',
      OrionTopic.work:
          'For your work and projects, here is what your cards show.',
      OrionTopic.money:
          'For money and resources, here is what your cards reveal.',
      OrionTopic.health: 'For your energy and balance, here is what your cards whisper. This is not medical advice.',
      OrionTopic.decision:
          'Facing this choice, here is what your cards illuminate.',
      OrionTopic.general: 'Here is your cards’ answer to your question.',
    },
    'es': {
      OrionTopic.love:
          'En asuntos del corazón y los vínculos, esto dicen tus cartas.',
      OrionTopic.work:
          'Para tu trabajo y tus proyectos, esto muestran tus cartas.',
      OrionTopic.money:
          'Sobre el dinero y los recursos, esto revelan tus cartas.',
      OrionTopic.health: 'Sobre tu energía y equilibrio, esto susurran tus cartas. No es consejo médico.',
      OrionTopic.decision: 'Ante esta decisión, esto iluminan tus cartas.',
      OrionTopic.general: 'Esta es la respuesta de tus cartas a tu pregunta.',
    },
  };

  static const _focus = <String, Map<OrionTopic, String>>{
    'fr': {
      OrionTopic.love: 'dans tes relations',
      OrionTopic.work: 'dans ton travail',
      OrionTopic.money: 'dans tes finances',
      OrionTopic.health: 'dans ton énergie',
      OrionTopic.decision: 'dans ce choix',
      OrionTopic.general: 'dans ta situation',
    },
    'en': {
      OrionTopic.love: 'in your relationships',
      OrionTopic.work: 'in your work',
      OrionTopic.money: 'in your finances',
      OrionTopic.health: 'in your energy',
      OrionTopic.decision: 'in this choice',
      OrionTopic.general: 'in your situation',
    },
    'es': {
      OrionTopic.love: 'en tus relaciones',
      OrionTopic.work: 'en tu trabajo',
      OrionTopic.money: 'en tus finanzas',
      OrionTopic.health: 'en tu energía',
      OrionTopic.decision: 'en esta decisión',
      OrionTopic.general: 'en tu situación',
    },
  };

  static const _upright = {
    'fr': '{pos} — {name} : ce thème de « {kw} » est porteur {focus}. Appuie-toi dessus.',
    'en': '{pos} — {name}: the theme of “{kw}” is supportive {focus}. Lean on it.',
    'es': '{pos} — {name}: el tema de «{kw}» es favorable {focus}. Apóyate en él.',
  };
  static const _reversed = {
    'fr': '{pos} — {name} (renversée) : « {kw} » est bloqué ou excessif {focus}. Ralentis et ajuste.',
    'en': '{pos} — {name} (reversed): “{kw}” is blocked or excessive {focus}. Slow down and adjust.',
    'es': '{pos} — {name} (invertida): «{kw}» está bloqueado o en exceso {focus}. Frena y ajusta.',
  };
  static const _advice = {
    'fr': 'Conseil : commence par ce que dit {first}, puis note dans ton journal un geste concret à poser cette semaine.',
    'en': 'Advice: start with what {first} says, then note in your journal one concrete step for this week.',
    'es': 'Consejo: empieza por lo que dice {first} y anota en tu diario un paso concreto para esta semana.',
  };
  static const _balance = {
    'fr': 'Ton tirage penche vers le soutien : {up} carte(s) à l’endroit contre {down} renversée(s).',
    'en': 'Your spread leans supportive: {up} upright card(s) against {down} reversed.',
    'es': 'Tu tirada se inclina al apoyo: {up} carta(s) derecha(s) frente a {down} invertida(s).',
  };
  static const _balanceDown = {
    'fr': 'Ton tirage invite à la prudence : {down} carte(s) renversée(s) contre {up} à l’endroit.',
    'en': 'Your spread invites caution: {down} reversed card(s) against {up} upright.',
    'es': 'Tu tirada invita a la cautela: {down} carta(s) invertida(s) frente a {up} derecha(s).',
  };

  static String answer(
    String question,
    List<OrionQuestionCard> cards,
    String lang,
  ) {
    final l = _intro.containsKey(lang) ? lang : 'en';
    final topic = topicOf(question);
    final lines = <String>[_intro[l]![topic]!];
    var up = 0;
    var down = 0;
    for (final c in cards) {
      final reversed = c.orientation.isReversed;
      reversed ? down++ : up++;
      lines.add(
        (reversed ? _reversed : _upright)[l]!
            .replaceAll('{pos}', c.position)
            .replaceAll('{name}', c.card.name)
            .replaceAll('{kw}', c.card.localizedKeyword(l).toLowerCase())
            .replaceAll('{focus}', _focus[l]![topic]!),
      );
    }
    final tone = up >= down ? _balance : _balanceDown;
    lines.add(tone[l]!.replaceAll('{up}', '$up').replaceAll('{down}', '$down'));
    if (cards.isNotEmpty) {
      lines.add(_advice[l]!.replaceAll('{first}', cards.first.card.name));
    }
    return lines.join('\n\n');
  }
}
