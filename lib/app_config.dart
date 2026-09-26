/// Centralizes non-secret deployment settings.
abstract final class AppConfig {
  static const localStateKey = 'tarot_noir.state.v1';
  static const localStateVersion = 1;

  static const appName = 'Tarot Noir';
  static const tarotImageDirectory = 'assets/images/tarot_temp';
  static const solanaCluster = String.fromEnvironment(
    'SOLANA_CLUSTER',
    defaultValue: 'devnet',
  );

  /// Active l'aperçu Orion+ en développement uniquement.
  /// En production, l'accès doit être validé côté serveur après achat ou NFT.
  static const premiumEnabled = bool.fromEnvironment(
    'PREMIUM_ENABLED',
    defaultValue: false,
  );

  /// Disabled during visual deck verification. Enable for production builds.
  static const dailyDrawLockEnabled = bool.fromEnvironment(
    'DAILY_DRAW_LOCK_ENABLED',
    defaultValue: false,
  );

  /// Local preview only. No advertising SDK or network request is used.
  static const adPlaceholderEnabled = bool.fromEnvironment(
    'AD_PLACEHOLDER_ENABLED',
    defaultValue: true,
  );

  /// Authentication stays closed until a Firebase project is configured.
  static const firebaseAuthEnabled = bool.fromEnvironment(
    'FIREBASE_AUTH_ENABLED',
    defaultValue: false,
  );

  /// Facebook also requires a Meta application and native Android/iOS setup.
  static const facebookAuthEnabled = bool.fromEnvironment(
    'FACEBOOK_AUTH_ENABLED',
    defaultValue: false,
  );

  static const firebaseProjectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
  );
  static const firebaseApiKey = String.fromEnvironment('FIREBASE_API_KEY');
  static const firebaseAppId = String.fromEnvironment('FIREBASE_APP_ID');
  static const firebaseMessagingSenderId = String.fromEnvironment(
    'FIREBASE_MESSAGING_SENDER_ID',
  );

  static const metaAppId = String.fromEnvironment('META_APP_ID');

  static bool get isFirebaseAuthConfigured =>
      firebaseAuthEnabled &&
      firebaseProjectId.isNotEmpty &&
      firebaseApiKey.isNotEmpty &&
      firebaseAppId.isNotEmpty &&
      firebaseMessagingSenderId.isNotEmpty;

  static bool get isFacebookAuthConfigured =>
      isFirebaseAuthConfigured && facebookAuthEnabled && metaAppId.isNotEmpty;

  /// WalletConnect uses a public Reown project identifier, never a seed phrase.
  static const walletConnectEnabled = bool.fromEnvironment(
    'WALLETCONNECT_ENABLED',
    defaultValue: false,
  );

  static const reownProjectId = String.fromEnvironment('REOWN_PROJECT_ID');
  static const walletMetadataUrl = String.fromEnvironment(
    'WALLETCONNECT_METADATA_URL',
    defaultValue: 'https://github.com/AnarchSun/tarot_noir',
  );
  static const walletIconUrl = String.fromEnvironment('WALLETCONNECT_ICON_URL');
  static const walletRedirectScheme = 'tarotnoir';
  static const phantomDownloadUrl = 'https://phantom.com/download';
  static const solflareDownloadUrl = 'https://www.solflare.com/download/';

  static bool get isWalletConnectConfigured =>
      walletConnectEnabled && reownProjectId.isNotEmpty;

  static const solanaClusterUrl = String.fromEnvironment(
    'SOLANA_CLUSTER_URL',
    defaultValue: 'https://api.devnet.solana.com',
  );
}
