// English and Spanish Orion+ texts; French lives in PremiumReadingCatalog.
// Card names stay in French everywhere, so they are interpolated unchanged.
const premiumMajor = <String, Map<String, String>>{
  'en': {
    '0': 'A threshold opens without a complete map of the territory. Trust living movement over worn-out certainties.',
    'I': 'The beginning is already in your hands. Your tools, however imperfect, are enough to take the first step.',
    'II': 'Something is ripening in silence. Listening, study and patience reveal more than haste.',
    'III': 'Thought seeks a fertile form. Create and nurture what wants to grow without demanding a perfect result.',
    'IV': 'Stability comes from an embraced structure. Choose the limits that protect your work and your territory.',
    'V': 'A transmission becomes possible. Receive the teaching, then test it so it supports your own voice.',
    'VI': 'Desire meets choice. Seek a deep agreement between your values, your bonds and your direction.',
    'VII': 'Opposing forces can move together if you clearly hold the reins and the direction.',
    'VIII': 'The facts call for an honest measure. Observe the consequences and decide without disguising what you know.',
    'IX': 'Withdrawal lights up what noise was covering. Move slowly and let experience become wisdom.',
    'X': 'The cycle turns and redistributes positions. Welcome what you cannot control and seize the foothold still within reach.',
    'XI': 'Your power grows by staying conscious and calm. Tame instinct without crushing it.',
    'XII': 'Suspension changes the view. Stop forcing the outcome and watch the truth from another angle.',
    'XIII': 'A form has finished its work. Transformation asks for a clean cut to free life.',
    'XIV': 'Alchemy works by dosage. Join opposites and let a flexible solution emerge patiently.',
    'XV': 'Desire shows its power and its attachments. Look at what captivates you to recover your choice.',
    'XVI': 'A construction that was too narrow cracks. The fall reveals a truth and prepares a more honest foundation.',
    'XVII': 'Vulnerability becomes a spring again. Offer your gestures to what heals and restores your trust.',
    'XVIII': 'The unseen colours the path. Welcome presentiments, then verify them before trusting them with the direction.',
    'XIX': 'Clarity feeds connection and creation. Share the warmth and accept being seen without needless armour.',
    'XX': 'A call crosses your story. Answer from the person you are becoming rather than from the past fault.',
    'XXI': 'The fragments find their place in an accomplished whole. Honour the ending and prepare the next circle.',
  },
  'es': {
    '0': 'Se abre un umbral sin un mapa completo del territorio. Confía en el movimiento vivo más que en certezas gastadas.',
    'I': 'El comienzo ya está en tus manos. Tus herramientas, aun imperfectas, bastan para dar el primer paso.',
    'II': 'Algo madura en el silencio. Escuchar, estudiar y tener paciencia revela más que la prisa.',
    'III': 'El pensamiento busca una forma fértil. Crea y nutre lo que quiere crecer sin exigir un resultado perfecto.',
    'IV': 'La estabilidad nace de una estructura asumida. Elige los límites que protegen tu obra y tu territorio.',
    'V': 'Una transmisión se vuelve posible. Recibe la enseñanza y ponla a prueba para que sostenga tu propia voz.',
    'VI': 'El deseo encuentra la elección. Busca un acuerdo profundo entre tus valores, tus vínculos y tu rumbo.',
    'VII': 'Fuerzas opuestas pueden avanzar juntas si sostienes con claridad las riendas y la dirección.',
    'VIII': 'Los hechos piden una medida honesta. Observa las consecuencias y decide sin disfrazar lo que sabes.',
    'IX': 'El retiro ilumina lo que el ruido cubría. Avanza despacio y deja que la experiencia se vuelva sabiduría.',
    'X': 'El ciclo gira y redistribuye las posiciones. Acoge lo incontrolable y aprovecha el asidero que aún está a tu alcance.',
    'XI': 'Tu poder gana al mantenerse consciente y sereno. Doma el instinto sin aplastarlo.',
    'XII': 'La suspensión cambia la mirada. Deja de forzar el desenlace y observa la verdad desde otro ángulo.',
    'XIII': 'Una forma ha terminado su obra. La transformación pide un corte limpio para liberar la vida.',
    'XIV': 'La alquimia actúa por dosis. Une los opuestos y deja que una solución flexible surja con paciencia.',
    'XV': 'El deseo muestra su poder y sus ataduras. Mira lo que te cautiva para recuperar tu elección.',
    'XVI': 'Una construcción demasiado estrecha se resquebraja. La caída revela una verdad y prepara una base más honesta.',
    'XVII': 'La vulnerabilidad vuelve a ser fuente. Ofrece tus gestos a lo que sana y restaura tu confianza.',
    'XVIII': 'Lo invisible tiñe el camino. Acoge los presentimientos y verifícalos antes de confiarles el rumbo.',
    'XIX': 'La claridad nutre el vínculo y la creación. Comparte el calor y acepta que te vean sin armadura inútil.',
    'XX': 'Un llamado cruza tu historia. Responde desde quien estás llegando a ser, no desde la falta pasada.',
    'XXI': 'Los fragmentos encuentran su lugar en un todo cumplido. Honra el final y prepara el siguiente círculo.',
  },
};

const premiumRanks = <String, Map<String, String>>{
  'en': {
    'As': 'A pure seed appears and asks for a first conscious yes.',
    'Deux': 'Two forces seek agreement within their tension.',
    'Trois':
        'Energy circulates and calls for cooperation, expression and growth.',
    'Quatre': 'A stable form is built, with the risk of becoming too closed.',
    'Cinq': 'Conflict reveals a useful fault line and forces a review of the balance.',
    'Six': 'A passage toward harmony becomes possible through exchange.',
    'Sept':
        'The trial asks for discernment and faithfulness to your intention.',
    'Huit': 'Movement intensifies; discipline turns momentum into mastery.',
    'Neuf': 'The cycle nears maturity and tests your endurance.',
    'Dix': 'A culmination brings result and weight; integrate before starting again.',
    'Valet':
        'A new message invites you to learn and experiment without a mask.',
    'Cavalier':
        'The quest speeds up; direct your energy before it chooses for you.',
    'Reine': 'Mastery becomes inward, receptive and able to nourish.',
    'Roi': 'Mastery becomes decision, responsibility and concrete influence.',
  },
  'es': {
    'As': 'Aparece una semilla pura y pide un primer sí consciente.',
    'Deux': 'Dos fuerzas buscan un acuerdo dentro de su tensión.',
    'Trois': 'La energía circula y llama a la cooperación, la expresión y el crecimiento.',
    'Quatre': 'Se construye una forma estable, con el riesgo de volverse demasiado cerrada.',
    'Cinq':
        'El conflicto revela una grieta útil y obliga a revisar el equilibrio.',
    'Six':
        'Un paso hacia la armonía se vuelve posible mediante el intercambio.',
    'Sept': 'La prueba exige discernimiento y fidelidad a tu intención.',
    'Huit': 'El movimiento se intensifica; la disciplina convierte el impulso en dominio.',
    'Neuf': 'El ciclo se acerca a su madurez y pone a prueba tu resistencia.',
    'Dix': 'Una culminación trae resultado y peso; integra antes de volver a empezar.',
    'Valet': 'Un mensaje nuevo invita a aprender y experimentar sin máscara.',
    'Cavalier':
        'La búsqueda se acelera; dirige tu energía antes de que elija por ti.',
    'Reine': 'El dominio se vuelve interior, receptivo y capaz de nutrir.',
    'Roi':
        'El dominio se vuelve decisión, responsabilidad e influencia concreta.',
  },
};

const premiumSuits = <String, Map<String, String>>{
  'en': {
    'Bâtons': 'The fire of Wands concerns your desire, creativity and capacity to act.',
    'Coupes': 'The water of Cups runs through emotions, intuition and the truth of bonds.',
    'Épées': 'The air of Swords lights up thought, speech, tension and lucid choices.',
    'Deniers': 'The earth of Coins speaks of the body, work, resources and what lasts.',
  },
  'es': {
    'Bâtons': 'El fuego de los Bastos concierne a tu deseo, tu creatividad y tu capacidad de actuar.',
    'Coupes': 'El agua de las Copas atraviesa las emociones, la intuición y la verdad de los vínculos.',
    'Épées': 'El aire de las Espadas ilumina el pensamiento, la palabra, las tensiones y las decisiones lúcidas.',
    'Deniers': 'La tierra de los Oros habla del cuerpo, el trabajo, los recursos y lo que perdura.',
  },
};

const premiumFrame = <String, Map<String, String>>{
  'en': {
    'title': 'ORION+ · DEEP READING',
    'reversed': 'Reversed, {name} signals a held-back, excessive or self-turned energy; it asks for patient readjustment.',
    'upright': 'In its light, {name} asks you to fully inhabit this energy without rushing it.',
    'shadowReversed': 'Knot to undo: notice where fear, control or exhaustion block {keyword}. The resistance shows what needs care.',
    'shadowUpright': 'Shadow to watch: mistaking {keyword} for an obligation, or moving on without listening to your limits.',
    'ritual': 'Ritual: write down a specific situation tied to {keyword}. Choose a gesture you can do today, then note in your journal what it changes.',
  },
  'es': {
    'title': 'ORION+ · LECTURA PROFUNDA',
    'reversed': 'Invertida, {name} señala una energía contenida, excesiva o vuelta contra ti; pide un reajuste paciente.',
    'upright': 'En su luz, {name} te pide habitar plenamente esta energía sin precipitarla.',
    'shadowReversed': 'Nudo por deshacer: observa dónde el miedo, el control o el agotamiento bloquean {keyword}. La resistencia indica lo que necesita cuidado.',
    'shadowUpright': 'Sombra que vigilar: confundir {keyword} con una obligación, o avanzar sin escuchar tus límites.',
    'ritual': 'Ritual: escribe una situación concreta ligada a {keyword}. Elige un gesto realizable hoy y anota en tu diario lo que transforma.',
  },
};
