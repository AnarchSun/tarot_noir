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

  /// No description provided for @drawPrompt.
  ///
  /// In fr, this message translates to:
  /// **'Le voile attend ton geste. Tire une carte pour révéler le signe du jour.'**
  String get drawPrompt;

  /// No description provided for @restoringRitual.
  ///
  /// In fr, this message translates to:
  /// **'Restauration du rituel…'**
  String get restoringRitual;

  /// No description provided for @storageError.
  ///
  /// In fr, this message translates to:
  /// **'La sauvegarde locale a échoué. Le rituel n’a pas été verrouillé.'**
  String get storageError;

  /// No description provided for @deleteJournalEntry.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer cette entrée'**
  String get deleteJournalEntry;

  /// No description provided for @dailyDrawLocked.
  ///
  /// In fr, this message translates to:
  /// **'Carte du jour déjà tirée'**
  String get dailyDrawLocked;

  /// No description provided for @drawDaily.
  ///
  /// In fr, this message translates to:
  /// **'Tirer ma carte du jour'**
  String get drawDaily;

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
  /// **'Les cartes tirées pendant cette session.'**
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

  /// No description provided for @adPlaceholderTitle.
  ///
  /// In fr, this message translates to:
  /// **'Espace publicitaire — aperçu'**
  String get adPlaceholderTitle;

  /// No description provided for @adPlaceholderBody.
  ///
  /// In fr, this message translates to:
  /// **'Une courte annonce pourra apparaître ici avant le tirage gratuit. Aucune publicité réelle ni donnée personnelle n’est utilisée.'**
  String get adPlaceholderBody;

  /// No description provided for @continueLabel.
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get continueLabel;

  /// No description provided for @adFree.
  ///
  /// In fr, this message translates to:
  /// **'Sans annonces'**
  String get adFree;

  /// No description provided for @adFreeDetail.
  ///
  /// In fr, this message translates to:
  /// **'Le mode gratuit pourra présenter une courte annonce avant le tirage. Orion+ reste sans annonces.'**
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
  /// **'Ces réglages restent locaux dans cette démo. Rien n’est transmis sans votre choix clair.'**
  String get preferencesIntro;

  /// No description provided for @orionMemory.
  ///
  /// In fr, this message translates to:
  /// **'Mémoire Orion'**
  String get orionMemory;

  /// No description provided for @orionMemoryDetail.
  ///
  /// In fr, this message translates to:
  /// **'Autoriser Orion à relier vos conversations durant cette session.'**
  String get orionMemoryDetail;

  /// No description provided for @personalizedGuidance.
  ///
  /// In fr, this message translates to:
  /// **'Guidance personnalisée'**
  String get personalizedGuidance;

  /// No description provided for @personalizedGuidanceDetail.
  ///
  /// In fr, this message translates to:
  /// **'Utiliser seulement les notes et thèmes que vous décidez de partager.'**
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
  /// **'Tarot Noir ne lit pas vos recherches web, vos clics ni vos réseaux sociaux. Toute connexion future devra être activée séparément, décrite clairement et révocable.'**
  String get dataPolicy;

  /// No description provided for @eraseLocalData.
  ///
  /// In fr, this message translates to:
  /// **'Effacer mes données locales'**
  String get eraseLocalData;

  /// No description provided for @eraseLocalDataConfirmation.
  ///
  /// In fr, this message translates to:
  /// **'Cette action supprime le tirage quotidien, le journal, le profil, les notes et toutes les préférences locales.'**
  String get eraseLocalDataConfirmation;

  /// No description provided for @cancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// No description provided for @erase.
  ///
  /// In fr, this message translates to:
  /// **'Effacer'**
  String get erase;

  /// No description provided for @localDataErased.
  ///
  /// In fr, this message translates to:
  /// **'Données locales effacées.'**
  String get localDataErased;

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
  /// **'1 lecture courte'**
  String get freeDailyReading;

  /// No description provided for @premiumDailyReading.
  ///
  /// In fr, this message translates to:
  /// **'Lecture approfondie + historique'**
  String get premiumDailyReading;

  /// No description provided for @localNotes.
  ///
  /// In fr, this message translates to:
  /// **'Notes locales'**
  String get localNotes;

  /// No description provided for @linkedJournal.
  ///
  /// In fr, this message translates to:
  /// **'Liens avec les cartes et Orion'**
  String get linkedJournal;

  /// No description provided for @journalNoteHint.
  ///
  /// In fr, this message translates to:
  /// **'Écris ce que la carte remue ou éclaire en toi…'**
  String get journalNoteHint;

  /// No description provided for @moodLabel.
  ///
  /// In fr, this message translates to:
  /// **'HUMEUR DU JOUR · {mood}/5'**
  String moodLabel(Object mood);

  /// No description provided for @sealNote.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer la note'**
  String get sealNote;

  /// No description provided for @dailyDrawType.
  ///
  /// In fr, this message translates to:
  /// **'Carte du jour'**
  String get dailyDrawType;

  /// No description provided for @freeDrawType.
  ///
  /// In fr, this message translates to:
  /// **'Tirage libre'**
  String get freeDrawType;

  /// No description provided for @drawDate.
  ///
  /// In fr, this message translates to:
  /// **'Tirée le {date}'**
  String drawDate(Object date);

  /// No description provided for @endpointLabel.
  ///
  /// In fr, this message translates to:
  /// **'Endpoint devnet : {url}'**
  String endpointLabel(Object url);

  /// No description provided for @journalDetails.
  ///
  /// In fr, this message translates to:
  /// **'Détails du tirage'**
  String get journalDetails;

  /// No description provided for @keywordLabel.
  ///
  /// In fr, this message translates to:
  /// **'Mot-clé'**
  String get keywordLabel;

  /// No description provided for @interpretationLabel.
  ///
  /// In fr, this message translates to:
  /// **'Interprétation'**
  String get interpretationLabel;

  /// No description provided for @drawTypeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Type de tirage'**
  String get drawTypeLabel;

  /// No description provided for @noteLabel.
  ///
  /// In fr, this message translates to:
  /// **'Note personnelle'**
  String get noteLabel;

  /// No description provided for @moodValue.
  ///
  /// In fr, this message translates to:
  /// **'Humeur : {mood}/5'**
  String moodValue(Object mood);

  /// No description provided for @profile.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get profile;

  /// No description provided for @profileTitle.
  ///
  /// In fr, this message translates to:
  /// **'Votre cercle'**
  String get profileTitle;

  /// No description provided for @profileIntro.
  ///
  /// In fr, this message translates to:
  /// **'Connectez-vous pour préparer la synchronisation sécurisée du journal et des préférences Orion.'**
  String get profileIntro;

  /// No description provided for @continueWithFacebook.
  ///
  /// In fr, this message translates to:
  /// **'Continuer avec Facebook'**
  String get continueWithFacebook;

  /// No description provided for @continueWithEmail.
  ///
  /// In fr, this message translates to:
  /// **'Continuer avec un courriel'**
  String get continueWithEmail;

  /// No description provided for @authenticationConfigured.
  ///
  /// In fr, this message translates to:
  /// **'Connexion Facebook configurée'**
  String get authenticationConfigured;

  /// No description provided for @authenticationNotConfigured.
  ///
  /// In fr, this message translates to:
  /// **'Connexion en attente de configuration'**
  String get authenticationNotConfigured;

  /// No description provided for @authenticationPrivacy.
  ///
  /// In fr, this message translates to:
  /// **'Tarot Noir ne reçoit jamais votre mot de passe Facebook. Vous pouvez révoquer l’accès depuis votre compte.'**
  String get authenticationPrivacy;

  /// No description provided for @facebookConfigurationRequired.
  ///
  /// In fr, this message translates to:
  /// **'Firebase et l’application Meta doivent être configurés avant d’ouvrir la connexion Facebook.'**
  String get facebookConfigurationRequired;

  /// No description provided for @walletSectionTitle.
  ///
  /// In fr, this message translates to:
  /// **'Wallet Solana'**
  String get walletSectionTitle;

  /// No description provided for @walletConnect.
  ///
  /// In fr, this message translates to:
  /// **'Connecter un wallet'**
  String get walletConnect;

  /// No description provided for @walletDisconnect.
  ///
  /// In fr, this message translates to:
  /// **'Déconnecter le wallet'**
  String get walletDisconnect;

  /// No description provided for @walletInitializing.
  ///
  /// In fr, this message translates to:
  /// **'Ouverture du portail WalletConnect…'**
  String get walletInitializing;

  /// No description provided for @walletPrivacy.
  ///
  /// In fr, this message translates to:
  /// **'La connexion partage seulement votre adresse Solana publique. Tarot Noir ne demande jamais de seed phrase ni de clé privée.'**
  String get walletPrivacy;

  /// No description provided for @walletConfigurationRequired.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez un identifiant de projet Reown et activez WalletConnect avant d’ouvrir le portail wallet.'**
  String get walletConfigurationRequired;

  /// No description provided for @walletConnectedAs.
  ///
  /// In fr, this message translates to:
  /// **'Wallet connecté : {address}'**
  String walletConnectedAs(Object address);

  /// No description provided for @walletError.
  ///
  /// In fr, this message translates to:
  /// **'Échec de la connexion wallet : {message}'**
  String walletError(Object message);

  /// No description provided for @walletOpenProfile.
  ///
  /// In fr, this message translates to:
  /// **'Connecter mon wallet'**
  String get walletOpenProfile;

  /// No description provided for @walletAvailableInProfile.
  ///
  /// In fr, this message translates to:
  /// **'La connexion wallet est accessible dans l’onglet Profil.'**
  String get walletAvailableInProfile;

  /// No description provided for @walletDownloadHint.
  ///
  /// In fr, this message translates to:
  /// **'Pas encore de wallet Solana? Téléchargez-en un depuis son site officiel.'**
  String get walletDownloadHint;

  /// No description provided for @downloadPhantom.
  ///
  /// In fr, this message translates to:
  /// **'Télécharger Phantom'**
  String get downloadPhantom;

  /// No description provided for @downloadSolflare.
  ///
  /// In fr, this message translates to:
  /// **'Télécharger Solflare'**
  String get downloadSolflare;

  /// No description provided for @walletDownloadError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible d’ouvrir la page de téléchargement du wallet.'**
  String get walletDownloadError;

  /// No description provided for @completeProfileTitle.
  ///
  /// In fr, this message translates to:
  /// **'Compléter votre profil'**
  String get completeProfileTitle;

  /// No description provided for @completeProfileIntro.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez l’identité affichée dans Tarot Noir après la connexion de ce wallet.'**
  String get completeProfileIntro;

  /// No description provided for @displayNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom ou alias'**
  String get displayNameLabel;

  /// No description provided for @displayNameRequired.
  ///
  /// In fr, this message translates to:
  /// **'Entrez un nom ou un alias.'**
  String get displayNameRequired;

  /// No description provided for @emailOptional.
  ///
  /// In fr, this message translates to:
  /// **'Courriel (facultatif)'**
  String get emailOptional;

  /// No description provided for @emailInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Entrez une adresse courriel valide.'**
  String get emailInvalid;

  /// No description provided for @publicWalletLabel.
  ///
  /// In fr, this message translates to:
  /// **'Wallet public : {address}'**
  String publicWalletLabel(Object address);

  /// No description provided for @saveProfile.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer le profil'**
  String get saveProfile;

  /// No description provided for @profileSaved.
  ///
  /// In fr, this message translates to:
  /// **'Profil enregistré localement.'**
  String get profileSaved;

  /// No description provided for @editProfile.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le profil'**
  String get editProfile;

  /// No description provided for @firebaseConfigurationRequired.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez les identifiants publics Firebase et activez l’authentification avant de vous connecter.'**
  String get firebaseConfigurationRequired;

  /// No description provided for @emailSignIn.
  ///
  /// In fr, this message translates to:
  /// **'Connexion par courriel'**
  String get emailSignIn;

  /// No description provided for @createAccount.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get createAccount;

  /// No description provided for @emailLabel.
  ///
  /// In fr, this message translates to:
  /// **'Courriel'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get passwordLabel;

  /// No description provided for @passwordTooShort.
  ///
  /// In fr, this message translates to:
  /// **'Utilisez au moins 6 caractères.'**
  String get passwordTooShort;

  /// No description provided for @signIn.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get signIn;

  /// No description provided for @needAccount.
  ///
  /// In fr, this message translates to:
  /// **'Créer un nouveau compte'**
  String get needAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In fr, this message translates to:
  /// **'J’ai déjà un compte'**
  String get alreadyHaveAccount;

  /// No description provided for @signedInAs.
  ///
  /// In fr, this message translates to:
  /// **'Connecté : {email}'**
  String signedInAs(Object email);

  /// No description provided for @signOut.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get signOut;

  /// No description provided for @forgotPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié?'**
  String get forgotPassword;

  /// No description provided for @passwordResetEmailSent.
  ///
  /// In fr, this message translates to:
  /// **'Si ce compte existe, un courriel de réinitialisation a été envoyé.'**
  String get passwordResetEmailSent;

  /// No description provided for @verificationEmailSent.
  ///
  /// In fr, this message translates to:
  /// **'Un courriel de vérification a été envoyé.'**
  String get verificationEmailSent;
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
