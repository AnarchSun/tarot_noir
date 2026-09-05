// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Tarot Noir';

  @override
  String get dailyReading => 'Tirada del día';

  @override
  String get drawAnother => 'Sacar otra carta';

  @override
  String get reading => 'Tirada';

  @override
  String get journal => 'Diario';

  @override
  String get premium => 'Premium';

  @override
  String get journalTitle => 'Diario de arcanos';

  @override
  String get journalSubtitle => 'Cartas sacadas durante esta sesión.';

  @override
  String get journalEmpty => 'Tu diario espera la primera señal.';

  @override
  String get premiumTitle => 'Círculo Premium';

  @override
  String get premiumIntro =>
      'El acceso premium se concederá tras verificar un NFT de la colección Tarot Noir.';

  @override
  String get extendedReadings => 'Tiradas ampliadas';

  @override
  String get extendedReadingsDetail => 'Cruz celta, relaciones y estaciones.';

  @override
  String get nftAvatars => 'Avatares NFT';

  @override
  String get nftAvatarsDetail => 'Arcano Eclipse, Luna Negra y futuras series.';

  @override
  String get adFree => 'Sin anuncios';

  @override
  String get adFreeDetail =>
      'Tarot Noir no muestra anuncios, para todos los círculos.';

  @override
  String get walletSoon => 'Conexión de wallet — próximamente';

  @override
  String networkConfigured(Object network) {
    return 'Red configurada: $network. La acuñación sigue desactivada hasta proporcionar los ajustes de Candy Machine.';
  }

  @override
  String get preferences => 'Preferencias';

  @override
  String get preferencesTitle => 'Tu ritual, tus reglas';

  @override
  String get preferencesIntro =>
      'Estos ajustes permanecen locales en esta demo. Nada se transmite sin tu elección clara.';

  @override
  String get orionMemory => 'Memoria de Orion';

  @override
  String get orionMemoryDetail =>
      'Permite a Orion vincular tus conversaciones durante esta sesión.';

  @override
  String get personalizedGuidance => 'Guía personalizada';

  @override
  String get personalizedGuidanceDetail =>
      'Usa solo las notas y temas que decidas compartir.';

  @override
  String get dailyReminder => 'Recordatorio ritual';

  @override
  String get dailyReminderDetail =>
      'Prepara un recordatorio diario; las notificaciones aún no están activadas.';

  @override
  String get orionTone => 'Voz de Orion';

  @override
  String get dataAndInterests => 'Datos e intereses';

  @override
  String get dataPolicy =>
      'Tarot Noir no lee tus búsquedas web, clics ni redes sociales. Cualquier conexión futura deberá activarse por separado, describirse claramente y poder revocarse.';

  @override
  String get eraseLocalData => 'Borrar mis datos locales';

  @override
  String get noDataToErase =>
      'No hay datos persistentes que borrar en esta demo.';

  @override
  String get comparePlans => 'Comparar Gratis y Orion+';

  @override
  String get comparisonIntro =>
      'Elige el círculo que te conviene. Ninguna compra ni acceso a wallet está activo en esta demo.';

  @override
  String get comparisonFeature => 'Ritual';

  @override
  String get freePlan => 'Gratis';

  @override
  String get orionPlus => 'Orion+';

  @override
  String get dailyCard => 'Carta del día';

  @override
  String get journalAccess => 'Diario ritual';

  @override
  String get freeDailyReading => '1 lectura corta';

  @override
  String get premiumDailyReading => 'Lectura profunda + historial';

  @override
  String get localNotes => 'Notas locales';

  @override
  String get linkedJournal => 'Vínculos con las cartas y Orion';
}
