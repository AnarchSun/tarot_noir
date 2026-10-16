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
  String get dailyReading => 'Card of the day';

  @override
  String get dailyDrawPrompt =>
      'Your card of the day is waiting. Draw once today to reveal its message.';

  @override
  String accountGateTitle(Object destination) {
    return 'Unlock your $destination';
  }

  @override
  String get accountGateBody =>
      'Create an account or sign in to get your profile and your journal, where every drawn card is kept with its notes. Journal sync stays off until you enable it.';

  @override
  String get orionPlusTeaser =>
      'Orion+ is separate from a free account, with deeper readings and additional guidance.';

  @override
  String get discoverOrionPlus => 'Explore Orion+';

  @override
  String authenticationStartupFailed(Object error) {
    return 'Sign-in could not initialize: $error. You can continue as a guest.';
  }

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
  String storageOperationFailed(Object error) {
    return 'Could not finish the local data operation: $error';
  }

  @override
  String get deleteJournalEntry => 'Delete this entry';

  @override
  String get dailyDrawLocked => 'Daily card already drawn';

  @override
  String get drawDaily => 'Draw my daily card';

  @override
  String get basicDraw => 'Draw a basic card';

  @override
  String get continueWithoutAccount => 'Continue without an account';

  @override
  String get reading => 'Reading';

  @override
  String get journal => 'Journal';

  @override
  String get premium => 'Premium';

  @override
  String get journalTitle => 'Arcana journal';

  @override
  String get journalSubtitle =>
      'Every drawn card is kept here, with its date and your notes.';

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
      'This deletes the daily draw, journal, profile, notes, and all local preferences. It does not delete data already synced to Firebase.';

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
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get authenticationConfigured => 'Firebase sign-in is ready';

  @override
  String get authenticationNotConfigured => 'Connection awaiting configuration';

  @override
  String get authenticationPrivacy =>
      'Sign-in is handled by Firebase. Tarot Noir never receives your provider passwords.';

  @override
  String get journalSyncTitle => 'Sync journal with Firebase';

  @override
  String get journalSyncDescription =>
      'With your permission, this device’s journal is merged with this account’s private Firestore journal. Turning this off stops future sync but does not delete cloud copies. Entries created while another account is signed in are not uploaded to this account.';

  @override
  String get journalSyncEnabled => 'Journal synchronization enabled.';

  @override
  String get journalSyncDisabled =>
      'Journal synchronization disabled. Existing cloud copies remain available.';

  @override
  String journalSyncFailed(Object error) {
    return 'The journal remains saved locally, but synchronization failed: $error';
  }

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
  String walletError(String error) {
    return 'Wallet: $error';
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
      'Choose the identity shown in Tarot Noir after connecting your account or wallet.';

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
      'Enable Firebase Authentication before signing in.';

  @override
  String signedInAs(Object email) {
    return 'Signed in: $email';
  }

  @override
  String get signOut => 'Sign out';

  @override
  String get home => 'Home';

  @override
  String get spreads => 'Spreads';

  @override
  String get spreadsIntro =>
      'Choose a spread. Free spreads show a short ad; extended spreads are reserved for Orion+.';

  @override
  String get spreadFreeBadge => 'Free · short ad';

  @override
  String get spreadPremiumBadge => 'Orion+';

  @override
  String spreadCardCount(int count) {
    return '$count cards';
  }

  @override
  String get spreadSavedToJournal =>
      'This spread’s cards were added to your journal.';

  @override
  String get spreadLocked => 'This spread is reserved for Orion+.';

  @override
  String get compareGuest => 'Guest';

  @override
  String get compareAccount => 'Free account';

  @override
  String get compareRowDaily => 'Tarot Noir card of the day';

  @override
  String get compareRowCross => '5-card cross (with ad)';

  @override
  String get compareRowJournal => 'Journal and notes (in Profile)';

  @override
  String get compareRowProfile => 'Profile and preferences';

  @override
  String get compareRowExtended => 'Extended spreads';

  @override
  String get compareRowDeepReading => 'Orion’s readings and questions per card';

  @override
  String get compareRowNoAds => 'No ads';

  @override
  String get compareRowNft => 'NFT avatars';

  @override
  String get notesToggle => 'Notes';

  @override
  String get saveNote => 'Save note';

  @override
  String get orionAssessmentTitle => 'Orion’s assessment';

  @override
  String get orionAskSoon =>
      'Coming soon: ask Orion a question and it will answer based on this card.';

  @override
  String get orionLockedHint => 'Orion’s assessment and questions with Orion+';

  @override
  String get personalDailyReading => 'Your personal card of the day';

  @override
  String get tarotNoirDaily => 'Tarot Noir card of the day';

  @override
  String get tarotNoirDailyDesc =>
      'The same card for everyone, all day long. It changes at midnight.';

  @override
  String get tarotNoirDailyBadge => 'Free · for everyone';

  @override
  String get sharedDailyNote =>
      'This card is the same for everyone today. For yours, draw your personal card of the day from Home.';

  @override
  String get compareRowPersonal => 'Your personal card of the day';

  @override
  String get guestPopupTitle => 'Before you enter as a guest';

  @override
  String get guestPopupBody =>
      'As a guest you keep the Tarot Noir card of the day, your personal card of the day and the 5-card cross (with an ad). A free account also keeps your journal, notes and profile. Orion+ adds Orion’s readings and extended spreads.';

  @override
  String get guestContinueAction => 'Continue as a guest';

  @override
  String get guestAdLabel => 'Ad';

  @override
  String get guestAdBody => 'Advertising space reserved for guests';

  @override
  String get profileTabHome => 'Profile';

  @override
  String get profileTabJournal => 'Journal';

  @override
  String get profileTabCollection => 'Collection';

  @override
  String get profileTabWallet => 'Wallet';

  @override
  String get bioLabel => 'Bio / description';

  @override
  String get cityLabel => 'City';

  @override
  String get originLabel => 'Origin';

  @override
  String get aboutTitle => 'About';

  @override
  String get aboutEmpty =>
      'Add a bio, your city or your origin to introduce your profile.';

  @override
  String memberSince(String date) {
    return 'In the circle since $date';
  }

  @override
  String get collectionTitle => 'Collection';

  @override
  String get collectionEmpty =>
      'Your Tarot Noir NFTs will appear here. The Solana avatar collection is not open yet.';

  @override
  String get collectionPremiumHint =>
      'A built-in wallet will come with Orion+ to receive and keep your NFTs.';

  @override
  String get walletTabIntro =>
      'Connect your existing Solana wallet. The built-in wallet included with Orion+ (address, balance, NFTs, send and receive) is in preparation.';

  @override
  String get walletBuiltinTitle => 'Orion+ wallet';

  @override
  String get walletLockedHint =>
      'A built-in Solana wallet (address, balance, NFTs, send and receive) is included with Orion+.';

  @override
  String get walletDiscoverPremium => 'Discover Orion+';

  @override
  String get walletCreateIntro =>
      'Keys are created and kept on this device. Only you hold the recovery phrase: without it, nobody can recover your wallet.';

  @override
  String get walletCreate => 'Create my wallet';

  @override
  String get walletImport => 'Import a wallet';

  @override
  String get walletRecoveryTitle => 'Your recovery phrase';

  @override
  String get walletRecoveryWarning =>
      'Write these 12 words down in order and keep them offline. Never share them: they give access to all your funds.';

  @override
  String get walletSavedConfirm => 'I have saved my recovery phrase';

  @override
  String get walletActivate => 'Activate wallet';

  @override
  String get walletImportTitle => 'Import with a phrase';

  @override
  String get walletImportHint =>
      'Enter your 12 or 24 words separated by spaces';

  @override
  String get walletInvalidPhrase => 'Invalid recovery phrase.';

  @override
  String get walletImportAction => 'Import';

  @override
  String get walletAddress => 'Address';

  @override
  String get walletCopy => 'Copy';

  @override
  String get walletCopied => 'Address copied.';

  @override
  String get walletBalance => 'Balance';

  @override
  String get walletRefresh => 'Refresh';

  @override
  String get walletSend => 'Send';

  @override
  String get walletReceive => 'Receive';

  @override
  String get walletReceiveHint => 'Share this address to receive SOL or NFTs.';

  @override
  String get walletRecipient => 'Recipient address';

  @override
  String get walletAmount => 'Amount (SOL)';

  @override
  String get walletInvalidAddress => 'Invalid Solana address.';

  @override
  String get walletInvalidAmount => 'Invalid amount.';

  @override
  String get walletSendAction => 'Send';

  @override
  String walletSent(String signature) {
    return 'Transaction sent: $signature';
  }

  @override
  String get walletShowPhrase => 'Show recovery phrase';

  @override
  String get walletRemove => 'Remove this wallet from the device';

  @override
  String get walletRemoveConfirm =>
      'Without your recovery phrase your funds will be lost. Remove the wallet?';

  @override
  String get walletRemoveAction => 'Remove';

  @override
  String get walletCancel => 'Cancel';

  @override
  String get walletClose => 'Close';

  @override
  String walletNetworkNote(String cluster) {
    return 'Network: $cluster (test network, no real value).';
  }

  @override
  String walletNftCount(int count) {
    return 'NFTs: $count';
  }

  @override
  String get walletExternalTitle => 'Or connect an external wallet';

  @override
  String get spreadAiTitle => 'ORION · AI INTERPRETATION';

  @override
  String get spreadAiLockedBody =>
      'Get an in-depth reading of each card according to its position in the spread. Free after a short ad, or included with Orion+.';

  @override
  String get spreadAiWatchAd => 'See AI interpretation (watch ad)';

  @override
  String get spreadAskTitle => 'ASK ORION A QUESTION';

  @override
  String get spreadAskHint =>
      'E.g. what should I understand about my relationship?';

  @override
  String get spreadAskAction => 'Ask Orion';

  @override
  String get orionAskLockedBody =>
      'Ask Orion a question and get an answer tailored to your card. Free after a short ad, or included with Orion+.';

  @override
  String get orionSavedToJournal => 'Saved to your journal.';

  @override
  String get orionJournalTitle => 'Questions to Orion';
}
