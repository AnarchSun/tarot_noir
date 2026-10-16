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
  String get dailyReading => 'Carte du jour';

  @override
  String get dailyDrawPrompt =>
      'Ta carte du jour t’attend. Tire-la une fois aujourd’hui pour découvrir son message.';

  @override
  String accountGateTitle(Object destination) {
    return 'Accède à $destination';
  }

  @override
  String get accountGateBody =>
      'Crée un compte ou connecte-toi pour retrouver ton profil et ton journal, où chaque carte tirée est conservée avec ses notes. La synchronisation du journal reste désactivée tant que tu ne l’actives pas.';

  @override
  String get orionPlusTeaser =>
      'Orion+ est distinct d’un compte gratuit et propose des interprétations plus approfondies et des conseils supplémentaires.';

  @override
  String get discoverOrionPlus => 'Découvrir Orion+';

  @override
  String authenticationStartupFailed(Object error) {
    return 'La connexion n’a pas pu s’initialiser : $error. Tu peux continuer comme invité.';
  }

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
  String storageOperationFailed(Object error) {
    return 'Impossible de terminer l’opération sur les données locales : $error';
  }

  @override
  String get deleteJournalEntry => 'Supprimer cette entrée';

  @override
  String get dailyDrawLocked => 'Carte du jour déjà tirée';

  @override
  String get drawDaily => 'Tirer ma carte du jour';

  @override
  String get basicDraw => 'Tirer une carte simple';

  @override
  String get continueWithoutAccount => 'Continuer sans compte';

  @override
  String get reading => 'Tirage';

  @override
  String get journal => 'Journal';

  @override
  String get premium => 'Premium';

  @override
  String get journalTitle => 'Journal des arcanes';

  @override
  String get journalSubtitle =>
      'Chaque carte tirée est conservée ici, avec sa date et tes notes.';

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
      'Cette action supprime le tirage quotidien, le journal, le profil, les notes et toutes les préférences locales. Elle ne supprime pas les données déjà synchronisées avec Firebase.';

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
  String get continueWithGoogle => 'Continuer avec Google';

  @override
  String get authenticationConfigured => 'Connexion Firebase prête';

  @override
  String get authenticationNotConfigured =>
      'Connexion en attente de configuration';

  @override
  String get authenticationPrivacy =>
      'La connexion est gérée par Firebase. Tarot Noir ne reçoit jamais les mots de passe de vos fournisseurs.';

  @override
  String get journalSyncTitle => 'Synchroniser le journal avec Firebase';

  @override
  String get journalSyncDescription =>
      'Avec votre autorisation, le journal de cet appareil est fusionné avec le journal Firestore privé de ce compte. Désactiver la synchronisation arrête les prochains transferts, sans supprimer les copies dans le cloud. Les entrées créées avec un autre compte connecté ne sont pas transférées vers ce compte.';

  @override
  String get journalSyncEnabled => 'Synchronisation du journal activée.';

  @override
  String get journalSyncDisabled =>
      'Synchronisation du journal désactivée. Les copies dans le cloud sont conservées.';

  @override
  String journalSyncFailed(Object error) {
    return 'Le journal reste enregistré localement, mais la synchronisation a échoué : $error';
  }

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
      'Choisissez l’identité affichée dans Tarot Noir après la connexion de votre compte ou wallet.';

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
      'Activez Firebase Authentication avant de vous connecter.';

  @override
  String signedInAs(Object email) {
    return 'Connecté : $email';
  }

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get home => 'Accueil';

  @override
  String get spreads => 'Tirages';

  @override
  String get spreadsIntro =>
      'Choisis un tirage. Les tirages gratuits affichent une courte annonce ; les tirages étendus sont réservés à Orion+.';

  @override
  String get spreadFreeBadge => 'Gratuit · courte annonce';

  @override
  String get spreadPremiumBadge => 'Orion+';

  @override
  String spreadCardCount(int count) {
    return '$count cartes';
  }

  @override
  String get spreadSavedToJournal =>
      'Les cartes de ce tirage ont été ajoutées à ton journal.';

  @override
  String get spreadLocked => 'Ce tirage est réservé à Orion+.';

  @override
  String get compareGuest => 'Invité';

  @override
  String get compareAccount => 'Compte gratuit';

  @override
  String get compareRowDaily => 'Carte du jour Tarot Noir';

  @override
  String get compareRowCross => 'Croix à 5 cartes (avec annonce)';

  @override
  String get compareRowJournal => 'Journal et notes (dans Profil)';

  @override
  String get compareRowProfile => 'Profil et préférences';

  @override
  String get compareRowExtended => 'Tirages étendus';

  @override
  String get compareRowDeepReading => 'Lectures d’Orion et questions par carte';

  @override
  String get compareRowNoAds => 'Sans annonces';

  @override
  String get compareRowNft => 'Avatars NFT';

  @override
  String get notesToggle => 'Notes';

  @override
  String get saveNote => 'Enregistrer la note';

  @override
  String get orionAssessmentTitle => 'Évaluation d’Orion';

  @override
  String get orionAskSoon =>
      'Bientôt : pose ta question à Orion, qui répondra selon cette carte.';

  @override
  String get orionLockedHint => 'Évaluation et questions d’Orion avec Orion+';

  @override
  String get personalDailyReading => 'Ta carte du jour personnelle';

  @override
  String get tarotNoirDaily => 'Carte du jour Tarot Noir';

  @override
  String get tarotNoirDailyDesc =>
      'La même carte pour tout le monde, toute la journée. Elle change à minuit.';

  @override
  String get tarotNoirDailyBadge => 'Gratuite · pour tous';

  @override
  String get sharedDailyNote =>
      'Cette carte est la même pour tous aujourd’hui. Pour la tienne, tire ta carte du jour personnelle depuis l’accueil.';

  @override
  String get compareRowPersonal => 'Ta carte du jour personnelle';

  @override
  String get guestPopupTitle => 'Avant d’entrer en invité';

  @override
  String get guestPopupBody =>
      'En invité, tu gardes la carte du jour Tarot Noir, ta carte du jour personnelle et la croix à 5 cartes (avec annonce). Un compte gratuit conserve en plus ton journal, tes notes et ton profil. Orion+ ajoute les lectures d’Orion et les tirages étendus.';

  @override
  String get guestContinueAction => 'Continuer en invité';

  @override
  String get guestAdLabel => 'Annonce';

  @override
  String get guestAdBody => 'Espace publicitaire réservé aux invités';

  @override
  String get profileTabHome => 'Profil';

  @override
  String get profileTabJournal => 'Journal';

  @override
  String get profileTabCollection => 'Collection';

  @override
  String get profileTabWallet => 'Portefeuille';

  @override
  String get bioLabel => 'Bio / description';

  @override
  String get cityLabel => 'Ville';

  @override
  String get originLabel => 'Origine';

  @override
  String get aboutTitle => 'À propos';

  @override
  String get aboutEmpty =>
      'Ajoute une bio, ta ville ou ton origine pour présenter ton profil.';

  @override
  String memberSince(String date) {
    return 'Dans le cercle depuis $date';
  }

  @override
  String get collectionTitle => 'Collection';

  @override
  String get collectionEmpty =>
      'Tes NFTs Tarot Noir apparaîtront ici. La collection d’avatars sur Solana n’est pas encore ouverte.';

  @override
  String get collectionPremiumHint =>
      'Un portefeuille intégré accompagnera Orion+ pour recevoir et garder tes NFTs.';

  @override
  String get walletTabIntro =>
      'Connecte ton portefeuille Solana existant. Le portefeuille intégré inclus avec Orion+ (adresse, solde, NFTs, envoi et réception) est en préparation.';
}
