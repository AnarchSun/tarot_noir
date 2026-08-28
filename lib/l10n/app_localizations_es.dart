// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Tarot Noir';

  @override
  String get dailyReading => 'Tirada del día';

  @override
  String get drawAnother => 'Sacar otra carta';

  @override
  String get reading => 'Tirada';

  @override
  String get journal => 'Diario';

  @override
  String get premium => 'Premium';

  @override
  String get journalTitle => 'Diario de arcanos';

  @override
  String get journalSubtitle => 'Cartas sacadas durante esta sesión.';

  @override
  String get journalEmpty => 'Tu diario espera la primera señal.';

  @override
  String get premiumTitle => 'Círculo Premium';

  @override
  String get premiumIntro =>
      'El acceso premium se concederá tras verificar un NFT de la colección Tarot Noir.';

  @override
  String get extendedReadings => 'Tiradas ampliadas';

  @override
  String get extendedReadingsDetail => 'Cruz celta, relaciones y estaciones.';

  @override
  String get nftAvatars => 'Avatares NFT';

  @override
  String get nftAvatarsDetail => 'Arcano Eclipse, Luna Negra y futuras series.';

  @override
  String get adFree => 'Sin publicidad';

  @override
  String get adFreeDetail =>
      'Los anuncios financian la experiencia gratuita, nunca a los miembros Premium.';

  @override
  String get walletSoon => 'Conexión de wallet — próximamente';

  @override
  String networkConfigured(Object network) {
    return 'Red configurada: $network. La acuñación sigue desactivada hasta proporcionar los ajustes de Candy Machine.';
  }

  @override
  String get adPlaceholder =>
      'Espacio de socios — red publicitaria por conectar.';
}
