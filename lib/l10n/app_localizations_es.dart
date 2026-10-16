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
  String get dailyReading => 'Carta del día';

  @override
  String get dailyDrawPrompt =>
      'Tu carta del día te espera. Sácala una vez hoy para descubrir su mensaje.';

  @override
  String accountGateTitle(Object destination) {
    return 'Accede a $destination';
  }

  @override
  String get accountGateBody =>
      'Crea una cuenta o inicia sesión para acceder a tu perfil y a tu diario, donde cada carta sacada se conserva con sus notas. La sincronización del diario seguirá desactivada hasta que la habilites.';

  @override
  String get orionPlusTeaser =>
      'Orion+ es independiente de una cuenta gratuita e incluye lecturas más profundas y orientación adicional.';

  @override
  String get discoverOrionPlus => 'Descubrir Orion+';

  @override
  String authenticationStartupFailed(Object error) {
    return 'No se pudo iniciar la autenticación: $error. Puedes continuar como invitado.';
  }

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
  String storageOperationFailed(Object error) {
    return 'No se pudo completar la operación de datos locales: $error';
  }

  @override
  String get deleteJournalEntry => 'Eliminar esta entrada';

  @override
  String get dailyDrawLocked => 'Carta del día ya sacada';

  @override
  String get drawDaily => 'Sacar mi carta del día';

  @override
  String get basicDraw => 'Sacar una carta sencilla';

  @override
  String get continueWithoutAccount => 'Continuar sin cuenta';

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
      'Cada carta sacada se conserva aquí, con su fecha y tus notas.';

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
      'Esta acción elimina la tirada diaria, el diario, el perfil, las notas y todas las preferencias locales. No elimina los datos ya sincronizados con Firebase.';

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
  String get continueWithGoogle => 'Continuar con Google';

  @override
  String get authenticationConfigured => 'Acceso de Firebase listo';

  @override
  String get authenticationNotConfigured =>
      'Conexión pendiente de configuración';

  @override
  String get authenticationPrivacy =>
      'Firebase gestiona el inicio de sesión. Tarot Noir nunca recibe las contraseñas de tus proveedores.';

  @override
  String get journalSyncTitle => 'Sincronizar el diario con Firebase';

  @override
  String get journalSyncDescription =>
      'Con tu permiso, el diario de este dispositivo se combina con el diario privado de Firestore de esta cuenta. Desactivarlo detiene futuras sincronizaciones, pero no elimina las copias en la nube. Las entradas creadas con otra cuenta conectada no se transfieren a esta cuenta.';

  @override
  String get journalSyncEnabled => 'Sincronización del diario activada.';

  @override
  String get journalSyncDisabled =>
      'Sincronización del diario desactivada. Las copias en la nube se conservan.';

  @override
  String journalSyncFailed(Object error) {
    return 'El diario sigue guardado localmente, pero falló la sincronización: $error';
  }

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
  String walletError(String error) {
    return 'Billetera: $error';
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
      'Activa Firebase Authentication antes de iniciar sesión.';

  @override
  String signedInAs(Object email) {
    return 'Conectado: $email';
  }

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get home => 'Inicio';

  @override
  String get spreads => 'Tiradas';

  @override
  String get spreadsIntro =>
      'Elige una tirada. Las tiradas gratuitas muestran un anuncio breve; las tiradas ampliadas son exclusivas de Orion+.';

  @override
  String get spreadFreeBadge => 'Gratis · anuncio breve';

  @override
  String get spreadPremiumBadge => 'Orion+';

  @override
  String spreadCardCount(int count) {
    return '$count cartas';
  }

  @override
  String get spreadSavedToJournal =>
      'Las cartas de esta tirada se añadieron a tu diario.';

  @override
  String get spreadLocked => 'Esta tirada es exclusiva de Orion+.';

  @override
  String get compareGuest => 'Invitado';

  @override
  String get compareAccount => 'Cuenta gratuita';

  @override
  String get compareRowDaily => 'Carta del día Tarot Noir';

  @override
  String get compareRowCross => 'Cruz de 5 cartas (con anuncio)';

  @override
  String get compareRowJournal => 'Diario y notas (en Perfil)';

  @override
  String get compareRowProfile => 'Perfil y preferencias';

  @override
  String get compareRowExtended => 'Tiradas ampliadas';

  @override
  String get compareRowDeepReading => 'Lecturas de Orion y preguntas por carta';

  @override
  String get compareRowNoAds => 'Sin anuncios';

  @override
  String get compareRowNft => 'Avatares NFT';

  @override
  String get notesToggle => 'Notas';

  @override
  String get saveNote => 'Guardar nota';

  @override
  String get orionAssessmentTitle => 'Evaluación de Orion';

  @override
  String get orionAskSoon =>
      'Próximamente: haz tu pregunta a Orion y responderá según esta carta.';

  @override
  String get orionLockedHint => 'Evaluación y preguntas a Orion con Orion+';

  @override
  String get personalDailyReading => 'Tu carta del día personal';

  @override
  String get tarotNoirDaily => 'Carta del día Tarot Noir';

  @override
  String get tarotNoirDailyDesc =>
      'La misma carta para todos, durante todo el día. Cambia a medianoche.';

  @override
  String get tarotNoirDailyBadge => 'Gratis · para todos';

  @override
  String get sharedDailyNote =>
      'Esta carta es la misma para todos hoy. Para la tuya, saca tu carta del día personal desde Inicio.';

  @override
  String get compareRowPersonal => 'Tu carta del día personal';

  @override
  String get guestPopupTitle => 'Antes de entrar como invitado';

  @override
  String get guestPopupBody =>
      'Como invitado conservas la carta del día Tarot Noir, tu carta del día personal y la cruz de 5 cartas (con anuncio). Una cuenta gratuita conserva además tu diario, tus notas y tu perfil. Orion+ añade las lecturas de Orion y las tiradas ampliadas.';

  @override
  String get guestContinueAction => 'Continuar como invitado';

  @override
  String get guestAdLabel => 'Anuncio';

  @override
  String get guestAdBody => 'Espacio publicitario reservado a invitados';

  @override
  String get profileTabHome => 'Perfil';

  @override
  String get profileTabJournal => 'Diario';

  @override
  String get profileTabCollection => 'Colección';

  @override
  String get profileTabWallet => 'Billetera';

  @override
  String get bioLabel => 'Bio / descripción';

  @override
  String get cityLabel => 'Ciudad';

  @override
  String get originLabel => 'Origen';

  @override
  String get aboutTitle => 'Acerca de';

  @override
  String get aboutEmpty =>
      'Añade una bio, tu ciudad o tu origen para presentar tu perfil.';

  @override
  String memberSince(String date) {
    return 'En el círculo desde $date';
  }

  @override
  String get collectionTitle => 'Colección';

  @override
  String get collectionEmpty =>
      'Tus NFTs de Tarot Noir aparecerán aquí. La colección de avatares en Solana aún no está abierta.';

  @override
  String get collectionPremiumHint =>
      'Una billetera integrada acompañará a Orion+ para recibir y guardar tus NFTs.';

  @override
  String get walletTabIntro =>
      'Conecta tu billetera Solana existente. La billetera integrada incluida con Orion+ (dirección, saldo, NFTs, envío y recepción) está en preparación.';

  @override
  String get walletBuiltinTitle => 'Billetera Orion+';

  @override
  String get walletLockedHint =>
      'Una billetera Solana integrada (dirección, saldo, NFTs, envío y recepción) se incluye con Orion+.';

  @override
  String get walletDiscoverPremium => 'Descubrir Orion+';

  @override
  String get walletCreateIntro =>
      'Las claves se crean y se guardan en este dispositivo. Solo tú tienes la frase de recuperación: sin ella nadie puede recuperar tu billetera.';

  @override
  String get walletCreate => 'Crear mi billetera';

  @override
  String get walletImport => 'Importar una billetera';

  @override
  String get walletRecoveryTitle => 'Tu frase de recuperación';

  @override
  String get walletRecoveryWarning =>
      'Anota estas 12 palabras en orden y guárdalas sin conexión. No las compartas nunca: dan acceso a todos tus fondos.';

  @override
  String get walletSavedConfirm => 'He guardado mi frase de recuperación';

  @override
  String get walletActivate => 'Activar billetera';

  @override
  String get walletImportTitle => 'Importar con una frase';

  @override
  String get walletImportHint =>
      'Escribe tus 12 o 24 palabras separadas por espacios';

  @override
  String get walletInvalidPhrase => 'Frase de recuperación no válida.';

  @override
  String get walletImportAction => 'Importar';

  @override
  String get walletAddress => 'Dirección';

  @override
  String get walletCopy => 'Copiar';

  @override
  String get walletCopied => 'Dirección copiada.';

  @override
  String get walletBalance => 'Saldo';

  @override
  String get walletRefresh => 'Actualizar';

  @override
  String get walletSend => 'Enviar';

  @override
  String get walletReceive => 'Recibir';

  @override
  String get walletReceiveHint =>
      'Comparte esta dirección para recibir SOL o NFTs.';

  @override
  String get walletRecipient => 'Dirección del destinatario';

  @override
  String get walletAmount => 'Importe (SOL)';

  @override
  String get walletInvalidAddress => 'Dirección Solana no válida.';

  @override
  String get walletInvalidAmount => 'Importe no válido.';

  @override
  String get walletSendAction => 'Enviar';

  @override
  String walletSent(String signature) {
    return 'Transacción enviada: $signature';
  }

  @override
  String get walletShowPhrase => 'Mostrar la frase de recuperación';

  @override
  String get walletRemove => 'Quitar esta billetera del dispositivo';

  @override
  String get walletRemoveConfirm =>
      'Sin tu frase de recuperación perderás tus fondos. ¿Quitar la billetera?';

  @override
  String get walletRemoveAction => 'Quitar';

  @override
  String get walletCancel => 'Cancelar';

  @override
  String get walletClose => 'Cerrar';

  @override
  String walletNetworkNote(String cluster) {
    return 'Red: $cluster (red de prueba, sin valor real).';
  }

  @override
  String walletNftCount(int count) {
    return 'NFTs: $count';
  }

  @override
  String get walletExternalTitle => 'O conecta una billetera externa';

  @override
  String get spreadAiTitle => 'ORION · INTERPRETACIÓN IA';

  @override
  String get spreadAiLockedBody =>
      'Obtén una lectura profunda de cada carta según su posición en la tirada. Gratis tras un breve anuncio, o incluida con Orion+.';

  @override
  String get spreadAiWatchAd => 'Ver interpretación IA (anuncio)';
}
