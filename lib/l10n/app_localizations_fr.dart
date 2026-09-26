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
      'Cette action supprime le tirage quotidien, le journal, les notes et toutes les préférences locales.';

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
}
