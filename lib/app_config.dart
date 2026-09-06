/// Centralizes non-secret deployment settings.
abstract final class AppConfig {
  static const localStateKey = 'tarot_noir.state.v1';
  static const localStateVersion = 1;

  static const appName = 'Tarot Noir';
  static const tarotImageDirectory = 'assets/images/tarot_cards';
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

  static const solanaClusterUrl = String.fromEnvironment(
    'SOLANA_CLUSTER_URL',
    defaultValue: 'https://api.devnet.solana.com',
  );
}
