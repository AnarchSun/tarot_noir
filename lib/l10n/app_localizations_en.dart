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
}
