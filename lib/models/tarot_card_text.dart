import 'tarot_card.dart';

// French is the source text stored on TarotCard; only en/es are translated here.
const _majorEn = <String, (String, String)>{
  '0': (
    'THE LEAP',
    'The void is not a fall: it is the space where your next world seeks its form.',
  ),
  'II': (
    'THE SECRET',
    'Do not hand your light to those who only know how to watch the embers.',
  ),
  'XIII': (
    'THE SHEDDING',
    'What ends frees a sacred place. Leave the old skin to the earth.',
  ),
  'XVIII': (
    'THE MIRAGE',
    'Your intuition speaks softly beneath the noise. Walk slowly, but walk with it.',
  ),
  'XV': ('THE CHAIN', 'Look at the chain: it may be looser than you think.'),
  'XVII': (
    'THE HEALING',
    'After the night, your desire to live remains a form of magic.',
  ),
  'VI': ('THE UNION', 'Two paths can meet without losing their mystery.'),
  'XXI': (
    'THE FULFILMENT',
    'What seemed scattered finds its circle again. An ending can become a door.',
  ),
  'I': (
    'THE SPARK',
    'The tools are here. Begin humbly, then let the gesture reveal its way.',
  ),
  'III': (
    'THE CREATION',
    'What is sprouting needs care, beauty and room to breathe.',
  ),
  'IV': ('THE STRUCTURE', 'A fair limit can become a shelter, never a cage.'),
  'V': (
    'THE TRANSMISSION',
    'Seek a landmark that feeds your freedom instead of speaking for you.',
  ),
  'VII': (
    'THE PASSAGE',
    'Gather your strength toward one direction and advance without betraying yourself.',
  ),
  'VIII': (
    'THE BALANCE',
    'See the facts clearly: every choice builds its own weight.',
  ),
  'IX': (
    'THE LAMP',
    'A chosen retreat lights the next step. Keep a light, even a small one.',
  ),
  'X': (
    'THE CYCLE',
    'Movement returns. Welcome what changes and anchor what matters.',
  ),
  'XI': (
    'THE COURAGE',
    'Calm strength transforms more than constraint. Breathe before you act.',
  ),
  'XII': (
    'THE REVERSAL',
    'A voluntary pause can show the angle that momentum could not see.',
  ),
  'XIV': (
    'THE ALCHEMY',
    'Measure, connect, adjust. Your balance is made of small true blends.',
  ),
  'XVI': (
    'THE FAULT LINE',
    'A structure sometimes falls to free the truth that wanted through.',
  ),
  'XIX': (
    'THE CLARITY',
    'Share what makes you feel alive. An honest joy can serve as a compass.',
  ),
  'XX': (
    'THE CALL',
    'An ancient voice calls for a new answer. Choose what belongs to you.',
  ),
};

const _majorEs = <String, (String, String)>{
  '0': (
    'EL SALTO',
    'El vacío no es una caída: es el espacio donde tu próximo mundo busca su forma.',
  ),
  'II': (
    'EL SECRETO',
    'No entregues tu luz a quienes solo saben mirar las brasas.',
  ),
  'XIII': (
    'LA MUDA',
    'Lo que termina libera un lugar sagrado. Deja la piel vieja a la tierra.',
  ),
  'XVIII': (
    'EL ESPEJISMO',
    'Tu intuición habla bajo entre el ruido. Camina despacio, pero camina con ella.',
  ),
  'XV': ('LA CADENA', 'Mira la cadena: quizá esté más floja de lo que crees.'),
  'XVII': (
    'LA SANACIÓN',
    'Tras la noche, tus ganas de vivir siguen siendo una forma de magia.',
  ),
  'VI': ('LA UNIÓN', 'Dos caminos pueden encontrarse sin perder su misterio.'),
  'XXI': (
    'EL LOGRO',
    'Lo que parecía disperso recupera su círculo. Un final puede volverse una puerta.',
  ),
  'I': (
    'EL IMPULSO',
    'Las herramientas están ahí. Empieza con humildad y deja que el gesto te revele su camino.',
  ),
  'III': (
    'LA CREACIÓN',
    'Lo que germina pide cuidado, belleza y un espacio donde respirar.',
  ),
  'IV': (
    'LA ESTRUCTURA',
    'Un límite justo puede volverse protección, nunca una jaula.',
  ),
  'V': (
    'LA TRANSMISIÓN',
    'Busca una referencia que nutra tu libertad en lugar de hablar por ti.',
  ),
  'VII': (
    'EL PASAJE',
    'Reúne tus fuerzas hacia una sola dirección y avanza sin traicionarte.',
  ),
  'VIII': (
    'EL EQUILIBRIO',
    'Mira los hechos con claridad: cada decisión construye su propio peso.',
  ),
  'IX': (
    'LA LÁMPARA',
    'El retiro elegido ilumina el siguiente paso. Conserva una luz, aunque sea pequeña.',
  ),
  'X': (
    'EL CICLO',
    'El movimiento vuelve. Acoge lo que cambia y ancla lo que importa.',
  ),
  'XI': (
    'EL CORAJE',
    'La fuerza serena transforma más que la coacción. Respira antes de actuar.',
  ),
  'XII': (
    'LA INVERSIÓN',
    'Una pausa voluntaria puede mostrar el ángulo que el impulso no veía.',
  ),
  'XIV': (
    'LA ALQUIMIA',
    'Dosifica, une, ajusta. Tu equilibrio se fabrica con pequeñas mezclas verdaderas.',
  ),
  'XVI': (
    'LA GRIETA',
    'A veces una estructura cae para liberar la verdad que quería pasar.',
  ),
  'XIX': (
    'LA CLARIDAD',
    'Comparte lo que te hace sentir vivo. Una alegría honesta puede servir de brújula.',
  ),
  'XX': (
    'EL LLAMADO',
    'Una voz antigua pide una respuesta nueva. Elige lo que te pertenece.',
  ),
};

const _themesFr = {
  'Bâtons': 'de l’élan, de l’action et de la création',
  'Coupes': 'de l’émotion, du lien et de l’intuition',
  'Épées': 'de la pensée, de la parole et du discernement',
  'Deniers': 'du corps, des ressources et du quotidien',
};

const _themesEn = {
  'Bâtons': 'drive, action and creation',
  'Coupes': 'emotion, connection and intuition',
  'Épées': 'thought, speech and discernment',
  'Deniers': 'the body, resources and daily life',
};

const _themesEs = {
  'Bâtons': 'el impulso, la acción y la creación',
  'Coupes': 'la emoción, el vínculo y la intuición',
  'Épées': 'el pensamiento, la palabra y el discernimiento',
  'Deniers': 'el cuerpo, los recursos y lo cotidiano',
};

extension TarotCardText on TarotCard {
  String localizedKeyword(String languageCode) {
    if (isMinorArcana) return keyword;
    final table = switch (languageCode) {
      'en' => _majorEn,
      'es' => _majorEs,
      _ => null,
    };
    return table?[number]?.$1 ?? keyword;
  }

  String localizedMessage(String languageCode) {
    if (!isMinorArcana) {
      final table = switch (languageCode) {
        'en' => _majorEn,
        'es' => _majorEs,
        _ => null,
      };
      return table?[number]?.$2 ?? message;
    }
    final suit = number.split('-').last;
    return switch (languageCode) {
      'en' =>
        'This card speaks of ${_themesEn[suit]}. Look for the next simple gesture that honours your intention.',
      'es' =>
        'Esta carta habla de ${_themesEs[suit]}. Busca el próximo gesto simple que respete tu intención.',
      _ =>
        'Cette carte parle ${_themesFr[suit]}. Cherche le prochain geste simple qui respecte ton intention.',
    };
  }
}
