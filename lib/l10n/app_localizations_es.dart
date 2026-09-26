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
  String get drawPrompt =>
      'El velo espera tu gesto. Saca una carta para revelar la señal del día.';

  @override
  String get restoringRitual => 'Restaurando el ritual…';

  @override
  String get storageError =>
      'Falló el guardado local. El ritual no fue bloqueado.';

  @override
  String get deleteJournalEntry => 'Eliminar esta entrada';

  @override
  String get dailyDrawLocked => 'Carta del día ya sacada';

  @override
  String get drawDaily => 'Sacar mi carta del día';

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
  String get adPlaceholderTitle => 'Espacio publicitario — vista previa';

  @override
  String get adPlaceholderBody =>
      'Aquí podrá aparecer un anuncio corto antes de la tirada gratuita. No se usa publicidad real ni datos personales.';

  @override
  String get continueLabel => 'Continuar';

  @override
  String get adFree => 'Sin anuncios';

  @override
  String get adFreeDetail =>
      'El plan gratuito podrá mostrar un anuncio corto antes de la tirada. Orion+ permanece sin anuncios.';

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
  String get eraseLocalDataConfirmation =>
      'Esta acción elimina la tirada diaria, el diario, el perfil, las notas y todas las preferencias locales.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get erase => 'Eliminar';

  @override
  String get localDataErased => 'Datos locales eliminados.';

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

  @override
  String get journalNoteHint =>
      'Escribe lo que la carta remueve o ilumina en ti…';

  @override
  String moodLabel(Object mood) {
    return 'ÁNIMO DEL DÍA · $mood/5';
  }

  @override
  String get sealNote => 'Guardar la nota';

  @override
  String get dailyDrawType => 'Carta del día';

  @override
  String get freeDrawType => 'Tirada libre';

  @override
  String drawDate(Object date) {
    return 'Sacada el $date';
  }

  @override
  String endpointLabel(Object url) {
    return 'Endpoint devnet: $url';
  }

  @override
  String get journalDetails => 'Detalles de la tirada';

  @override
  String get keywordLabel => 'Palabra clave';

  @override
  String get interpretationLabel => 'Interpretación';

  @override
  String get drawTypeLabel => 'Tipo de tirada';

  @override
  String get noteLabel => 'Nota personal';

  @override
  String moodValue(Object mood) {
    return 'Ánimo: $mood/5';
  }

  @override
  String get profile => 'Perfil';

  @override
  String get profileTitle => 'Tu círculo';

  @override
  String get profileIntro =>
      'Inicia sesión para preparar la sincronización segura del diario y las preferencias de Orion.';

  @override
  String get continueWithFacebook => 'Continuar con Facebook';

  @override
  String get continueWithEmail => 'Continuar con correo electrónico';

  @override
  String get authenticationConfigured => 'Conexión de Facebook configurada';

  @override
  String get authenticationNotConfigured =>
      'Conexión pendiente de configuración';

  @override
  String get authenticationPrivacy =>
      'Tarot Noir nunca recibe tu contraseña de Facebook. Puedes revocar el acceso desde tu cuenta.';

  @override
  String get facebookConfigurationRequired =>
      'Firebase y la aplicación Meta deben configurarse antes de abrir el inicio de sesión con Facebook.';

  @override
  String get walletSectionTitle => 'Wallet de Solana';

  @override
  String get walletConnect => 'Conectar un wallet';

  @override
  String get walletDisconnect => 'Desconectar el wallet';

  @override
  String get walletInitializing => 'Abriendo el portal WalletConnect…';

  @override
  String get walletPrivacy =>
      'La conexión solo comparte tu dirección pública de Solana. Tarot Noir nunca solicita una frase semilla ni una clave privada.';

  @override
  String get walletConfigurationRequired =>
      'Añade un ID de proyecto Reown y activa WalletConnect antes de abrir el portal del wallet.';

  @override
  String walletConnectedAs(Object address) {
    return 'Wallet conectado: $address';
  }

  @override
  String walletError(Object message) {
    return 'Error de conexión del wallet: $message';
  }

  @override
  String get walletOpenProfile => 'Conectar mi wallet';

  @override
  String get walletAvailableInProfile =>
      'La conexión del wallet está disponible en la pestaña Perfil.';

  @override
  String get walletDownloadHint =>
      '¿Aún no tienes un wallet de Solana? Descárgalo desde su sitio oficial.';

  @override
  String get downloadPhantom => 'Descargar Phantom';

  @override
  String get downloadSolflare => 'Descargar Solflare';

  @override
  String get walletDownloadError =>
      'No se pudo abrir la página de descarga del wallet.';

  @override
  String get completeProfileTitle => 'Completa tu perfil';

  @override
  String get completeProfileIntro =>
      'Elige la identidad mostrada en Tarot Noir después de conectar tu cuenta o wallet.';

  @override
  String get displayNameLabel => 'Nombre o alias';

  @override
  String get displayNameRequired => 'Introduce un nombre o alias.';

  @override
  String get emailOptional => 'Correo electrónico (opcional)';

  @override
  String get emailInvalid => 'Introduce un correo electrónico válido.';

  @override
  String publicWalletLabel(Object address) {
    return 'Wallet público: $address';
  }

  @override
  String get saveProfile => 'Guardar perfil';

  @override
  String get profileSaved => 'Perfil guardado localmente.';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get firebaseConfigurationRequired =>
      'Añade los identificadores públicos de Firebase y activa la autenticación antes de iniciar sesión.';

  @override
  String get emailSignIn => 'Acceso por correo';

  @override
  String get createAccount => 'Crear una cuenta';

  @override
  String get emailLabel => 'Correo electrónico';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get passwordTooShort => 'Usa al menos 6 caracteres.';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get needAccount => 'Crear una cuenta nueva';

  @override
  String get alreadyHaveAccount => 'Ya tengo una cuenta';

  @override
  String signedInAs(Object email) {
    return 'Conectado: $email';
  }

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get passwordResetEmailSent =>
      'Si esta cuenta existe, se envió un correo para restablecer la contraseña.';

  @override
  String get verificationEmailSent => 'Se envió un correo de verificación.';

  @override
  String get emailNotVerified => 'Tu correo aún no está verificado.';

  @override
  String get resendVerification => 'Reenviar correo';

  @override
  String get refreshVerification => 'Ya lo verifiqué';

  @override
  String get emailVerified => 'Correo verificado.';

  @override
  String get emailStillUnverified => 'El correo aún no está verificado.';
}
