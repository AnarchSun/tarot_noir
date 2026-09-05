// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Tarot Noir';

  @override
  String get dailyReading => 'Daily reading';

  @override
  String get drawAnother => 'Draw another card';

  @override
  String get reading => 'Reading';

  @override
  String get journal => 'Journal';

  @override
  String get premium => 'Premium';

  @override
  String get journalTitle => 'Arcana journal';

  @override
  String get journalSubtitle => 'Cards drawn during this session.';

  @override
  String get journalEmpty => 'Your journal awaits its first sign.';

  @override
  String get premiumTitle => 'Premium Circle';

  @override
  String get premiumIntro =>
      'Premium access will be granted after verifying an NFT from the Tarot Noir collection.';

  @override
  String get extendedReadings => 'Extended readings';

  @override
  String get extendedReadingsDetail =>
      'Celtic cross, relationships and seasons.';

  @override
  String get nftAvatars => 'NFT avatars';

  @override
  String get nftAvatarsDetail =>
      'Eclipse Arcana, Black Moon and future series.';

  @override
  String get adFree => 'Ad-free';

  @override
  String get adFreeDetail =>
      'Ads fund the free experience, never Premium members.';

  @override
  String get walletSoon => 'Wallet connection — coming soon';

  @override
  String networkConfigured(Object network) {
    return 'Configured network: $network. Minting remains disabled until Candy Machine settings are provided.';
  }

  @override
  String get adPlaceholder => 'Partner space — advertising network to connect.';

  @override
  String get preferences => 'Preferences';

  @override
  String get preferencesTitle => 'Your ritual, your rules';

  @override
  String get preferencesIntro =>
      'These settings remain local in this demo. Nothing is transmitted without your clear choice.';

  @override
  String get orionMemory => 'Orion memory';

  @override
  String get orionMemoryDetail =>
      'Allow Orion to connect your conversations during this session.';

  @override
  String get personalizedGuidance => 'Personalized guidance';

  @override
  String get personalizedGuidanceDetail =>
      'Use only notes and themes you choose to share.';

  @override
  String get dailyReminder => 'Ritual reminder';

  @override
  String get dailyReminderDetail =>
      'Prepare a daily reminder; notifications are not enabled yet.';

  @override
  String get orionTone => 'Orion’s voice';

  @override
  String get dataAndInterests => 'Data and interests';

  @override
  String get dataPolicy =>
      'Tarot Noir does not read your web searches, clicks, or social networks. Any future connection must be enabled separately, described clearly, and revocable.';

  @override
  String get eraseLocalData => 'Erase my local data';

  @override
  String get noDataToErase =>
      'There is no persistent data to erase in this demo.';

  @override
  String get comparePlans => 'Compare Free and Orion+';

  @override
  String get comparisonIntro =>
      'Choose the circle that suits you. No purchase or wallet access is active in this demo.';

  @override
  String get comparisonFeature => 'Ritual';

  @override
  String get freePlan => 'Free';

  @override
  String get orionPlus => 'Orion+';

  @override
  String get dailyCard => 'Daily card';

  @override
  String get journalAccess => 'Ritual journal';

  @override
  String get adsPolicy => 'Advertising';

  @override
  String get freeDailyReading => '1 short reading';

  @override
  String get premiumDailyReading => 'In-depth reading + history';

  @override
  String get localNotes => 'Local notes';

  @override
  String get linkedJournal => 'Links with cards and Orion';

  @override
  String get adsMayAppear => 'May appear if enabled';

  @override
  String get noAds => 'No ads';
}
