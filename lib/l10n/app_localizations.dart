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

  /// No description provided for @adFree.
  ///
  /// In fr, this message translates to:
  /// **'Sans publicité'**
  String get adFree;

  /// No description provided for @adFreeDetail.
  ///
  /// In fr, this message translates to:
  /// **'Les publicités financent la version gratuite, jamais les membres Premium.'**
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

  /// No description provided for @adPlaceholder.
  ///
  /// In fr, this message translates to:
  /// **'Espace partenaire — réseau publicitaire à connecter.'**
  String get adPlaceholder;
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
