// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Tarot Noir';

  @override
  String get dailyReading => 'Le tirage du jour';

  @override
  String get drawAnother => 'Tirer une autre carte';

  @override
  String get drawPrompt =>
      'Le voile attend ton geste. Tire une carte pour révéler le signe du jour.';

  @override
  String get restoringRitual => 'Restauration du rituel…';

  @override
  String get storageError =>
      'La sauvegarde locale a échoué. Le rituel n’a pas été verrouillé.';

  @override
  String get deleteJournalEntry => 'Supprimer cette entrée';

  @override
  String get dailyDrawLocked => 'Carte du jour déjà tirée';

  @override
  String get drawDaily => 'Tirer ma carte du jour';

  @override
  String get reading => 'Tirage';

  @override
  String get journal => 'Journal';

  @override
  String get premium => 'Premium';

  @override
  String get journalTitle => 'Journal des arcanes';

  @override
  String get journalSubtitle => 'Les cartes tirées pendant cette session.';

  @override
  String get journalEmpty => 'Ton journal attend le premier signe.';

  @override
  String get premiumTitle => 'Cercle Premium';

  @override
  String get premiumIntro =>
      'Un accès premium sera accordé après vérification d’un NFT de la collection Tarot Noir.';

  @override
  String get extendedReadings => 'Tirages étendus';

  @override
  String get extendedReadingsDetail => 'Croix celtique, relations et saisons.';

  @override
  String get nftAvatars => 'Avatars NFT';

  @override
  String get nftAvatarsDetail =>
      'Arcane Éclipse, Lune Noire et futures séries.';

  @override
  String get adPlaceholderTitle => 'Espace publicitaire — aperçu';

  @override
  String get adPlaceholderBody =>
      'Une courte annonce pourra apparaître ici avant le tirage gratuit. Aucune publicité réelle ni donnée personnelle n’est utilisée.';

  @override
  String get continueLabel => 'Continuer';

  @override
  String get adFree => 'Sans annonces';

  @override
  String get adFreeDetail =>
      'Le mode gratuit pourra présenter une courte annonce avant le tirage. Orion+ reste sans annonces.';

  @override
  String get walletSoon => 'Connexion wallet — bientôt';

  @override
  String networkConfigured(Object network) {
    return 'Réseau configuré : $network. Le mint est désactivé tant que les paramètres Candy Machine ne sont pas fournis.';
  }

  @override
  String get preferences => 'Préférences';

  @override
  String get preferencesTitle => 'Votre rituel, vos règles';

  @override
  String get preferencesIntro =>
      'Ces réglages restent locaux dans cette démo. Rien n’est transmis sans votre choix clair.';

  @override
  String get orionMemory => 'Mémoire Orion';

  @override
  String get orionMemoryDetail =>
      'Autoriser Orion à relier vos conversations durant cette session.';

  @override
  String get personalizedGuidance => 'Guidance personnalisée';

  @override
  String get personalizedGuidanceDetail =>
      'Utiliser seulement les notes et thèmes que vous décidez de partager.';

  @override
  String get dailyReminder => 'Rappel rituel';

  @override
  String get dailyReminderDetail =>
      'Préparer un rappel quotidien ; les notifications ne sont pas encore activées.';

  @override
  String get orionTone => 'Voix d’Orion';

  @override
  String get dataAndInterests => 'Données et intérêts';

  @override
  String get dataPolicy =>
      'Tarot Noir ne lit pas vos recherches web, vos clics ni vos réseaux sociaux. Toute connexion future devra être activée séparément, décrite clairement et révocable.';

  @override
  String get eraseLocalData => 'Effacer mes données locales';

  @override
  String get eraseLocalDataConfirmation =>
      'Cette action supprime le tirage quotidien, le journal, le profil, les notes et toutes les préférences locales.';

  @override
  String get cancel => 'Annuler';

  @override
  String get erase => 'Effacer';

  @override
  String get localDataErased => 'Données locales effacées.';

  @override
  String get noDataToErase =>
      'Aucune donnée persistante à effacer dans cette démo.';

  @override
  String get comparePlans => 'Comparer Gratuit et Orion+';

  @override
  String get comparisonIntro =>
      'Choisissez le cercle qui vous convient. Aucun achat ni accès wallet n’est actif dans cette démo.';

  @override
  String get comparisonFeature => 'Rituel';

  @override
  String get freePlan => 'Gratuit';

  @override
  String get orionPlus => 'Orion+';

  @override
  String get dailyCard => 'Carte du jour';

  @override
  String get journalAccess => 'Journal rituel';

  @override
  String get freeDailyReading => '1 lecture courte';

  @override
  String get premiumDailyReading => 'Lecture approfondie + historique';

  @override
  String get localNotes => 'Notes locales';

  @override
  String get linkedJournal => 'Liens avec les cartes et Orion';

  @override
  String get journalNoteHint =>
      'Écris ce que la carte remue ou éclaire en toi…';

  @override
  String moodLabel(Object mood) {
    return 'HUMEUR DU JOUR · $mood/5';
  }

  @override
  String get sealNote => 'Enregistrer la note';

  @override
  String get dailyDrawType => 'Carte du jour';

  @override
  String get freeDrawType => 'Tirage libre';

  @override
  String drawDate(Object date) {
    return 'Tirée le $date';
  }

  @override
  String endpointLabel(Object url) {
    return 'Endpoint devnet : $url';
  }

  @override
  String get journalDetails => 'Détails du tirage';

  @override
  String get keywordLabel => 'Mot-clé';

  @override
  String get interpretationLabel => 'Interprétation';

  @override
  String get drawTypeLabel => 'Type de tirage';

  @override
  String get noteLabel => 'Note personnelle';

  @override
  String moodValue(Object mood) {
    return 'Humeur : $mood/5';
  }

  @override
  String get profile => 'Profil';

  @override
  String get profileTitle => 'Votre cercle';

  @override
  String get profileIntro =>
      'Connectez-vous pour préparer la synchronisation sécurisée du journal et des préférences Orion.';

  @override
  String get continueWithFacebook => 'Continuer avec Facebook';

  @override
  String get continueWithEmail => 'Continuer avec un courriel';

  @override
  String get authenticationConfigured => 'Connexion Facebook configurée';

  @override
  String get authenticationNotConfigured =>
      'Connexion en attente de configuration';

  @override
  String get authenticationPrivacy =>
      'Tarot Noir ne reçoit jamais votre mot de passe Facebook. Vous pouvez révoquer l’accès depuis votre compte.';

  @override
  String get facebookConfigurationRequired =>
      'Firebase et l’application Meta doivent être configurés avant d’ouvrir la connexion Facebook.';

  @override
  String get walletSectionTitle => 'Wallet Solana';

  @override
  String get walletConnect => 'Connecter un wallet';

  @override
  String get walletDisconnect => 'Déconnecter le wallet';

  @override
  String get walletInitializing => 'Ouverture du portail WalletConnect…';

  @override
  String get walletPrivacy =>
      'La connexion partage seulement votre adresse Solana publique. Tarot Noir ne demande jamais de seed phrase ni de clé privée.';

  @override
  String get walletConfigurationRequired =>
      'Ajoutez un identifiant de projet Reown et activez WalletConnect avant d’ouvrir le portail wallet.';

  @override
  String walletConnectedAs(Object address) {
    return 'Wallet connecté : $address';
  }

  @override
  String walletError(Object message) {
    return 'Échec de la connexion wallet : $message';
  }

  @override
  String get walletOpenProfile => 'Connecter mon wallet';

  @override
  String get walletAvailableInProfile =>
      'La connexion wallet est accessible dans l’onglet Profil.';

  @override
  String get walletDownloadHint =>
      'Pas encore de wallet Solana? Téléchargez-en un depuis son site officiel.';

  @override
  String get downloadPhantom => 'Télécharger Phantom';

  @override
  String get downloadSolflare => 'Télécharger Solflare';

  @override
  String get walletDownloadError =>
      'Impossible d’ouvrir la page de téléchargement du wallet.';

  @override
  String get completeProfileTitle => 'Compléter votre profil';

  @override
  String get completeProfileIntro =>
      'Choisissez l’identité affichée dans Tarot Noir après la connexion de ce wallet.';

  @override
  String get displayNameLabel => 'Nom ou alias';

  @override
  String get displayNameRequired => 'Entrez un nom ou un alias.';

  @override
  String get emailOptional => 'Courriel (facultatif)';

  @override
  String get emailInvalid => 'Entrez une adresse courriel valide.';

  @override
  String publicWalletLabel(Object address) {
    return 'Wallet public : $address';
  }

  @override
  String get saveProfile => 'Enregistrer le profil';

  @override
  String get profileSaved => 'Profil enregistré localement.';

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String get firebaseConfigurationRequired =>
      'Ajoutez les identifiants publics Firebase et activez l’authentification avant de vous connecter.';

  @override
  String get emailSignIn => 'Connexion par courriel';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get emailLabel => 'Courriel';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get passwordTooShort => 'Utilisez au moins 6 caractères.';

  @override
  String get signIn => 'Se connecter';

  @override
  String get needAccount => 'Créer un nouveau compte';

  @override
  String get alreadyHaveAccount => 'J’ai déjà un compte';

  @override
  String signedInAs(Object email) {
    return 'Connecté : $email';
  }

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get forgotPassword => 'Mot de passe oublié?';

  @override
  String get passwordResetEmailSent =>
      'Si ce compte existe, un courriel de réinitialisation a été envoyé.';

  @override
  String get verificationEmailSent =>
      'Un courriel de vérification a été envoyé.';

  @override
  String get emailNotVerified => 'Votre courriel n’est pas encore vérifié.';

  @override
  String get resendVerification => 'Renvoyer le courriel';

  @override
  String get refreshVerification => 'J’ai vérifié';

  @override
  String get emailVerified => 'Courriel vérifié.';

  @override
  String get emailStillUnverified => 'Le courriel n’est pas encore vérifié.';
}
