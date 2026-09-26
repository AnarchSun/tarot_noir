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
  String get drawPrompt =>
      'The veil awaits your gesture. Draw a card to reveal today’s sign.';

  @override
  String get restoringRitual => 'Restoring the ritual…';

  @override
  String get storageError => 'Local save failed. The ritual was not locked.';

  @override
  String get deleteJournalEntry => 'Delete this entry';

  @override
  String get dailyDrawLocked => 'Daily card already drawn';

  @override
  String get drawDaily => 'Draw my daily card';

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
  String get adPlaceholderTitle => 'Advertising space — preview';

  @override
  String get adPlaceholderBody =>
      'A short ad may appear here before the free reading. No real ad or personal data is used.';

  @override
  String get continueLabel => 'Continue';

  @override
  String get adFree => 'No ads';

  @override
  String get adFreeDetail =>
      'The free plan may show a short ad before the reading. Orion+ remains ad-free.';

  @override
  String get walletSoon => 'Wallet connection — coming soon';

  @override
  String networkConfigured(Object network) {
    return 'Configured network: $network. Minting remains disabled until Candy Machine settings are provided.';
  }

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
  String get eraseLocalDataConfirmation =>
      'This deletes the daily draw, journal, profile, notes, and all local preferences.';

  @override
  String get cancel => 'Cancel';

  @override
  String get erase => 'Erase';

  @override
  String get localDataErased => 'Local data erased.';

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
  String get freeDailyReading => '1 short reading';

  @override
  String get premiumDailyReading => 'In-depth reading + history';

  @override
  String get localNotes => 'Local notes';

  @override
  String get linkedJournal => 'Links with cards and Orion';

  @override
  String get journalNoteHint =>
      'Write what the card stirs or illuminates in you…';

  @override
  String moodLabel(Object mood) {
    return 'MOOD OF THE DAY · $mood/5';
  }

  @override
  String get sealNote => 'Save note';

  @override
  String get dailyDrawType => 'Daily card';

  @override
  String get freeDrawType => 'Free draw';

  @override
  String drawDate(Object date) {
    return 'Drawn on $date';
  }

  @override
  String endpointLabel(Object url) {
    return 'Devnet endpoint: $url';
  }

  @override
  String get journalDetails => 'Reading details';

  @override
  String get keywordLabel => 'Keyword';

  @override
  String get interpretationLabel => 'Interpretation';

  @override
  String get drawTypeLabel => 'Reading type';

  @override
  String get noteLabel => 'Personal note';

  @override
  String moodValue(Object mood) {
    return 'Mood: $mood/5';
  }

  @override
  String get profile => 'Profile';

  @override
  String get profileTitle => 'Your circle';

  @override
  String get profileIntro =>
      'Sign in to prepare secure synchronization of your journal and Orion preferences.';

  @override
  String get continueWithFacebook => 'Continue with Facebook';

  @override
  String get continueWithEmail => 'Continue with email';

  @override
  String get authenticationConfigured => 'Facebook connection configured';

  @override
  String get authenticationNotConfigured => 'Connection awaiting configuration';

  @override
  String get authenticationPrivacy =>
      'Tarot Noir never receives your Facebook password. You can revoke access from your account.';

  @override
  String get facebookConfigurationRequired =>
      'Firebase and the Meta application must be configured before Facebook sign-in can open.';

  @override
  String get walletSectionTitle => 'Solana wallet';

  @override
  String get walletConnect => 'Connect a wallet';

  @override
  String get walletDisconnect => 'Disconnect wallet';

  @override
  String get walletInitializing => 'Opening the WalletConnect portal…';

  @override
  String get walletPrivacy =>
      'Connection shares only your public Solana address. Tarot Noir never asks for a seed phrase or private key.';

  @override
  String get walletConfigurationRequired =>
      'Add a Reown project ID and enable WalletConnect before opening the wallet portal.';

  @override
  String walletConnectedAs(Object address) {
    return 'Wallet connected: $address';
  }

  @override
  String walletError(Object message) {
    return 'Wallet connection failed: $message';
  }

  @override
  String get walletOpenProfile => 'Connect my wallet';

  @override
  String get walletAvailableInProfile =>
      'Wallet connection is available from the Profile tab.';

  @override
  String get walletDownloadHint =>
      'No Solana wallet yet? Download one from its official website.';

  @override
  String get downloadPhantom => 'Download Phantom';

  @override
  String get downloadSolflare => 'Download Solflare';

  @override
  String get walletDownloadError => 'Unable to open the wallet download page.';

  @override
  String get completeProfileTitle => 'Complete your profile';

  @override
  String get completeProfileIntro =>
      'Choose the identity shown in Tarot Noir after connecting this wallet.';

  @override
  String get displayNameLabel => 'Name or alias';

  @override
  String get displayNameRequired => 'Enter a name or alias.';

  @override
  String get emailOptional => 'Email (optional)';

  @override
  String get emailInvalid => 'Enter a valid email address.';

  @override
  String publicWalletLabel(Object address) {
    return 'Public wallet: $address';
  }

  @override
  String get saveProfile => 'Save profile';

  @override
  String get profileSaved => 'Profile saved locally.';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get firebaseConfigurationRequired =>
      'Add the public Firebase identifiers and enable authentication before signing in.';

  @override
  String get emailSignIn => 'Email sign-in';

  @override
  String get createAccount => 'Create account';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordTooShort => 'Use at least 6 characters.';

  @override
  String get signIn => 'Sign in';

  @override
  String get needAccount => 'Create a new account';

  @override
  String get alreadyHaveAccount => 'I already have an account';

  @override
  String signedInAs(Object email) {
    return 'Signed in: $email';
  }

  @override
  String get signOut => 'Sign out';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get passwordResetEmailSent =>
      'If this account exists, a password reset email has been sent.';

  @override
  String get verificationEmailSent => 'A verification email has been sent.';
}
