import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In fr, this message translates to:
  /// **'Tarot Noir'**
  String get appTitle;

  /// No description provided for @dailyReading.
  ///
  /// In fr, this message translates to:
  /// **'Le tirage du jour'**
  String get dailyReading;

  /// No description provided for @drawAnother.
  ///
  /// In fr, this message translates to:
  /// **'Tirer une autre carte'**
  String get drawAnother;

  /// No description provided for @reading.
  ///
  /// In fr, this message translates to:
  /// **'Tirage'**
  String get reading;

  /// No description provided for @journal.
  ///
  /// In fr, this message translates to:
  /// **'Journal'**
  String get journal;

  /// No description provided for @premium.
  ///
  /// In fr, this message translates to:
  /// **'Premium'**
  String get premium;

  /// No description provided for @journalTitle.
  ///
  /// In fr, this message translates to:
  /// **'Journal des arcanes'**
  String get journalTitle;

  /// No description provided for @journalSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Tes notes et cartes sont conservées sur cet appareil.'**
  String get journalSubtitle;

  /// No description provided for @journalEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Ton journal attend le premier signe.'**
  String get journalEmpty;

  /// No description provided for @premiumTitle.
  ///
  /// In fr, this message translates to:
  /// **'Cercle Premium'**
  String get premiumTitle;

  /// No description provided for @premiumIntro.
  ///
  /// In fr, this message translates to:
  /// **'Un accès premium sera accordé après vérification d’un NFT de la collection Tarot Noir.'**
  String get premiumIntro;

  /// No description provided for @extendedReadings.
  ///
  /// In fr, this message translates to:
  /// **'Tirages étendus'**
  String get extendedReadings;

  /// No description provided for @extendedReadingsDetail.
  ///
  /// In fr, this message translates to:
  /// **'Croix celtique, relations et saisons.'**
  String get extendedReadingsDetail;

  /// No description provided for @nftAvatars.
  ///
  /// In fr, this message translates to:
  /// **'Avatars NFT'**
  String get nftAvatars;

  /// No description provided for @nftAvatarsDetail.
  ///
  /// In fr, this message translates to:
  /// **'Arcane Éclipse, Lune Noire et futures séries.'**
  String get nftAvatarsDetail;

  /// No description provided for @adFree.
  ///
  /// In fr, this message translates to:
  /// **'Sans annonces'**
  String get adFree;

  /// No description provided for @adFreeDetail.
  ///
  /// In fr, this message translates to:
  /// **'Tarot Noir ne diffuse aucune annonce, pour tous les cercles.'**
  String get adFreeDetail;

  /// No description provided for @walletSoon.
  ///
  /// In fr, this message translates to:
  /// **'Connexion wallet — bientôt'**
  String get walletSoon;

  /// No description provided for @networkConfigured.
  ///
  /// In fr, this message translates to:
  /// **'Réseau configuré : {network}. Le mint est désactivé tant que les paramètres Candy Machine ne sont pas fournis.'**
  String networkConfigured(Object network);

  /// No description provided for @preferences.
  ///
  /// In fr, this message translates to:
  /// **'Préférences'**
  String get preferences;

  /// No description provided for @preferencesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Votre rituel, vos règles'**
  String get preferencesTitle;

  /// No description provided for @preferencesIntro.
  ///
  /// In fr, this message translates to:
  /// **'Ces réglages sont enregistrés sur cet appareil. Orion et les notifications ne sont pas encore connectés.'**
  String get preferencesIntro;

  /// No description provided for @orionMemory.
  ///
  /// In fr, this message translates to:
  /// **'Mémoire Orion'**
  String get orionMemory;

  /// No description provided for @orionMemoryDetail.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer ton choix pour une future mémoire Orion. Aucun échange avec une IA pour le moment.'**
  String get orionMemoryDetail;

  /// No description provided for @personalizedGuidance.
  ///
  /// In fr, this message translates to:
  /// **'Guidance personnalisée'**
  String get personalizedGuidance;

  /// No description provided for @personalizedGuidanceDetail.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer ton choix pour une future personnalisation à partir des notes que tu partageras explicitement.'**
  String get personalizedGuidanceDetail;

  /// No description provided for @dailyReminder.
  ///
  /// In fr, this message translates to:
  /// **'Rappel rituel'**
  String get dailyReminder;

  /// No description provided for @dailyReminderDetail.
  ///
  /// In fr, this message translates to:
  /// **'Préparer un rappel quotidien ; les notifications ne sont pas encore activées.'**
  String get dailyReminderDetail;

  /// No description provided for @orionTone.
  ///
  /// In fr, this message translates to:
  /// **'Voix d’Orion'**
  String get orionTone;

  /// No description provided for @dataAndInterests.
  ///
  /// In fr, this message translates to:
  /// **'Données et intérêts'**
  String get dataAndInterests;

  /// No description provided for @dataPolicy.
  ///
  /// In fr, this message translates to:
  /// **'Le journal et les préférences restent sur cet appareil, sans chiffrement applicatif. Aucun envoi vers Orion, aucune lecture de tes recherches web ou réseaux sociaux. Toute connexion future demandera un consentement distinct. L’effacement supprime les notes et réglages, mais conserve la carte du jour pour respecter la limite gratuite.'**
  String get dataPolicy;

  /// No description provided for @eraseLocalData.
  ///
  /// In fr, this message translates to:
  /// **'Effacer mes données locales'**
  String get eraseLocalData;

  /// No description provided for @noDataToErase.
  ///
  /// In fr, this message translates to:
  /// **'Aucune donnée persistante à effacer dans cette démo.'**
  String get noDataToErase;

  /// No description provided for @comparePlans.
  ///
  /// In fr, this message translates to:
  /// **'Comparer Gratuit et Orion+'**
  String get comparePlans;

  /// No description provided for @comparisonIntro.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez le cercle qui vous convient. Aucun achat ni accès wallet n’est actif dans cette démo.'**
  String get comparisonIntro;

  /// No description provided for @comparisonFeature.
  ///
  /// In fr, this message translates to:
  /// **'Rituel'**
  String get comparisonFeature;

  /// No description provided for @freePlan.
  ///
  /// In fr, this message translates to:
  /// **'Gratuit'**
  String get freePlan;

  /// No description provided for @orionPlus.
  ///
  /// In fr, this message translates to:
  /// **'Orion+'**
  String get orionPlus;

  /// No description provided for @dailyCard.
  ///
  /// In fr, this message translates to:
  /// **'Carte du jour'**
  String get dailyCard;

  /// No description provided for @journalAccess.
  ///
  /// In fr, this message translates to:
  /// **'Journal rituel'**
  String get journalAccess;

  /// No description provided for @freeDailyReading.
  ///
  /// In fr, this message translates to:
  /// **'1 carte par jour · texte court'**
  String get freeDailyReading;

  /// No description provided for @premiumDailyReading.
  ///
  /// In fr, this message translates to:
  /// **'Tirages libres · lecture approfondie'**
  String get premiumDailyReading;

  /// No description provided for @localNotes.
  ///
  /// In fr, this message translates to:
  /// **'Notes locales'**
  String get localNotes;

  /// No description provided for @linkedJournal.
  ///
  /// In fr, this message translates to:
  /// **'Liens avec Orion (prévus)'**
  String get linkedJournal;

  /// No description provided for @dailyLimitReached.
  ///
  /// In fr, this message translates to:
  /// **'Carte du jour révélée · reviens demain'**
  String get dailyLimitReached;

  /// No description provided for @interpretation.
  ///
  /// In fr, this message translates to:
  /// **'Interprétation'**
  String get interpretation;

  /// No description provided for @shortInterpretation.
  ///
  /// In fr, this message translates to:
  /// **'Texte abrégé'**
  String get shortInterpretation;

  /// No description provided for @deepInterpretation.
  ///
  /// In fr, this message translates to:
  /// **'Texte approfondi (aperçu)'**
  String get deepInterpretation;

  /// No description provided for @dailyCardOnly.
  ///
  /// In fr, this message translates to:
  /// **'Carte du jour uniquement'**
  String get dailyCardOnly;

  /// No description provided for @extendedReadingsPlanned.
  ///
  /// In fr, this message translates to:
  /// **'Croix celtique, relations, saisons (prévus)'**
  String get extendedReadingsPlanned;

  /// No description provided for @standardGuidance.
  ///
  /// In fr, this message translates to:
  /// **'Guidance standard'**
  String get standardGuidance;

  /// No description provided for @consentGuidance.
  ///
  /// In fr, this message translates to:
  /// **'Sur consentement (prévue)'**
  String get consentGuidance;

  /// No description provided for @notIncluded.
  ///
  /// In fr, this message translates to:
  /// **'Non inclus'**
  String get notIncluded;

  /// No description provided for @optionalMemory.
  ///
  /// In fr, this message translates to:
  /// **'Optionnelle, sur consentement (prévue)'**
  String get optionalMemory;

  /// No description provided for @included.
  ///
  /// In fr, this message translates to:
  /// **'Inclus'**
  String get included;

  /// No description provided for @planned.
  ///
  /// In fr, this message translates to:
  /// **'Prévu'**
  String get planned;

  /// No description provided for @storageLoadError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de lire la sauvegarde locale. Tes données n’ont pas été remplacées. Réessaie.'**
  String get storageLoadError;

  /// No description provided for @storageSaveError.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarde impossible. La modification n’a pas été enregistrée ; réessaie ton action.'**
  String get storageSaveError;

  /// No description provided for @retry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get retry;

  /// No description provided for @cancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// No description provided for @eraseConfirmation.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer toutes les notes et réinitialiser les préférences ? La carte du jour et sa limite seront conservées.'**
  String get eraseConfirmation;

  /// No description provided for @dataErased.
  ///
  /// In fr, this message translates to:
  /// **'Notes effacées et préférences réinitialisées.'**
  String get dataErased;

  /// No description provided for @toneMystic.
  ///
  /// In fr, this message translates to:
  /// **'Mystique et direct'**
  String get toneMystic;

  /// No description provided for @toneGentle.
  ///
  /// In fr, this message translates to:
  /// **'Doux et contemplatif'**
  String get toneGentle;

  /// No description provided for @tonePractical.
  ///
  /// In fr, this message translates to:
  /// **'Symbolique et concret'**
  String get tonePractical;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
