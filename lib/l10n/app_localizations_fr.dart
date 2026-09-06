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
  String get reading => 'Tirage';

  @override
  String get journal => 'Journal';

  @override
  String get premium => 'Premium';

  @override
  String get journalTitle => 'Journal des arcanes';

  @override
  String get journalSubtitle =>
      'Tes notes et cartes sont conservées sur cet appareil.';

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
  String get adFree => 'Sans annonces';

  @override
  String get adFreeDetail =>
      'Tarot Noir ne diffuse aucune annonce, pour tous les cercles.';

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
      'Ces réglages sont enregistrés sur cet appareil. Orion et les notifications ne sont pas encore connectés.';

  @override
  String get orionMemory => 'Mémoire Orion';

  @override
  String get orionMemoryDetail =>
      'Enregistrer ton choix pour une future mémoire Orion. Aucun échange avec une IA pour le moment.';

  @override
  String get personalizedGuidance => 'Guidance personnalisée';

  @override
  String get personalizedGuidanceDetail =>
      'Enregistrer ton choix pour une future personnalisation à partir des notes que tu partageras explicitement.';

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
      'Le journal et les préférences restent sur cet appareil, sans chiffrement applicatif. Aucun envoi vers Orion, aucune lecture de tes recherches web ou réseaux sociaux. Toute connexion future demandera un consentement distinct. L’effacement supprime les notes et réglages, mais conserve la carte du jour pour respecter la limite gratuite.';

  @override
  String get eraseLocalData => 'Effacer mes données locales';

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
  String get freeDailyReading => '1 carte par jour · texte court';

  @override
  String get premiumDailyReading => 'Tirages libres · lecture approfondie';

  @override
  String get localNotes => 'Notes locales';

  @override
  String get linkedJournal => 'Liens avec Orion (prévus)';

  @override
  String get dailyLimitReached => 'Carte du jour révélée · reviens demain';

  @override
  String get interpretation => 'Interprétation';

  @override
  String get shortInterpretation => 'Texte abrégé';

  @override
  String get deepInterpretation => 'Texte approfondi (aperçu)';

  @override
  String get dailyCardOnly => 'Carte du jour uniquement';

  @override
  String get extendedReadingsPlanned =>
      'Croix celtique, relations, saisons (prévus)';

  @override
  String get standardGuidance => 'Guidance standard';

  @override
  String get consentGuidance => 'Sur consentement (prévue)';

  @override
  String get notIncluded => 'Non inclus';

  @override
  String get optionalMemory => 'Optionnelle, sur consentement (prévue)';

  @override
  String get included => 'Inclus';

  @override
  String get planned => 'Prévu';

  @override
  String get storageLoadError =>
      'Impossible de lire la sauvegarde locale. Tes données n’ont pas été remplacées. Réessaie.';

  @override
  String get storageSaveError =>
      'Sauvegarde impossible. La modification n’a pas été enregistrée ; réessaie ton action.';

  @override
  String get retry => 'Réessayer';

  @override
  String get cancel => 'Annuler';

  @override
  String get eraseConfirmation =>
      'Supprimer toutes les notes et réinitialiser les préférences ? La carte du jour et sa limite seront conservées.';

  @override
  String get dataErased => 'Notes effacées et préférences réinitialisées.';

  @override
  String get toneMystic => 'Mystique et direct';

  @override
  String get toneGentle => 'Doux et contemplatif';

  @override
  String get tonePractical => 'Symbolique et concret';
}
