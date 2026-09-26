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

  static const solanaClusterUrl = String.fromEnvironment(
    'SOLANA_CLUSTER_URL',
    defaultValue: 'https://api.devnet.solana.com',
  );
}
