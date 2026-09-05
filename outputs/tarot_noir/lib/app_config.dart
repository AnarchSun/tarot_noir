/// Configuration publique de Tarot Noir.
///
/// Exemple de lancement local :
/// flutter run --dart-define=PREMIUM_ENABLED=true --dart-define=ADS_ENABLED=false
///
/// Aucun secret ne doit être placé ici. Les clés API, clés privées et seed
/// phrases restent exclusivement côté backend.
abstract final class AppConfig {
  static const premiumEnabled = bool.fromEnvironment(
    'PREMIUM_ENABLED',
    defaultValue: false,
  );

  static const adsEnabled = bool.fromEnvironment(
    'ADS_ENABLED',
    defaultValue: false,
  );

  static const solanaClusterUrl = String.fromEnvironment(
    'SOLANA_CLUSTER_URL',
    defaultValue: 'https://api.devnet.solana.com',
  );
}
