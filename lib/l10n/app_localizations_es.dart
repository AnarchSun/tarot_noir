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
  String get journalSubtitle =>
      'Tus notas y cartas se guardan en este dispositivo.';

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
      'Estos ajustes se guardan en este dispositivo. Orion y las notificaciones aún no están conectados.';

  @override
  String get orionMemory => 'Memoria de Orion';

  @override
  String get orionMemoryDetail =>
      'Guardar tu elección para una futura memoria de Orion. Aún no se envían conversaciones a una IA.';

  @override
  String get personalizedGuidance => 'Guía personalizada';

  @override
  String get personalizedGuidanceDetail =>
      'Guardar tu elección para una futura personalización con las notas que compartas explícitamente.';

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
      'El diario y las preferencias permanecen en este dispositivo sin cifrado de la aplicación. No se envían datos a Orion ni se accede a búsquedas web o redes sociales. Las futuras conexiones requerirán consentimiento aparte. El borrado elimina notas y ajustes, pero conserva la carta del día y el límite gratuito.';

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
  String get freeDailyReading => '1 carta al día · texto breve';

  @override
  String get premiumDailyReading => 'Tiradas libres · lectura profunda';

  @override
  String get localNotes => 'Notas locales';

  @override
  String get linkedJournal => 'Vínculos con Orion (previstos)';

  @override
  String get dailyLimitReached => 'Carta del día revelada · vuelve mañana';

  @override
  String get interpretation => 'Interpretación';

  @override
  String get shortInterpretation => 'Texto breve';

  @override
  String get deepInterpretation => 'Texto profundo (vista previa)';

  @override
  String get dailyCardOnly => 'Solo la carta del día';

  @override
  String get extendedReadingsPlanned =>
      'Cruz celta, relaciones, estaciones (previstas)';

  @override
  String get standardGuidance => 'Guía estándar';

  @override
  String get consentGuidance => 'Con consentimiento (prevista)';

  @override
  String get notIncluded => 'No incluido';

  @override
  String get optionalMemory => 'Opcional, con consentimiento (prevista)';

  @override
  String get included => 'Incluido';

  @override
  String get planned => 'Previsto';

  @override
  String get storageLoadError =>
      'No se pudo leer la copia local. Tus datos no se han reemplazado. Inténtalo de nuevo.';

  @override
  String get storageSaveError =>
      'No se pudo guardar el cambio; repite la acción.';

  @override
  String get retry => 'Reintentar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get eraseConfirmation =>
      '¿Eliminar todas las notas y restablecer las preferencias? Se conservarán la carta del día y su límite.';

  @override
  String get dataErased => 'Notas eliminadas y preferencias restablecidas.';

  @override
  String get toneMystic => 'Místico y directo';

  @override
  String get toneGentle => 'Suave y contemplativo';

  @override
  String get tonePractical => 'Simbólico y práctico';
}
