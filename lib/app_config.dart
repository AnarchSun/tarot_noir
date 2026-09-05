/// Centralizes non-secret deployment settings.
abstract final class AppConfig {
  static const appName = 'Tarot Noir';
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
