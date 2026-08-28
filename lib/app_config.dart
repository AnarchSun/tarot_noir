/// Centralizes non-secret deployment settings.
abstract final class AppConfig {
  static const appName = 'Tarot Noir';
  static const solanaCluster = String.fromEnvironment(
    'SOLANA_CLUSTER',
    defaultValue: 'devnet',
  );
  static const adsEnabled = bool.fromEnvironment(
    'ADS_ENABLED',
    defaultValue: false,
  );
}
