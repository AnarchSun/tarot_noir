// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Tarot Noir';

  @override
  String get dailyReading => 'Le tirage du jour';

  @override
  String get drawAnother => 'Tirer une autre carte';

  @override
  String get reading => 'Tirage';

  @override
  String get journal => 'Journal';

  @override
  String get premium => 'Premium';

  @override
  String get journalTitle => 'Journal des arcanes';

  @override
  String get journalSubtitle => 'Les cartes tirées pendant cette session.';

  @override
  String get journalEmpty => 'Ton journal attend le premier signe.';

  @override
  String get premiumTitle => 'Cercle Premium';

  @override
  String get premiumIntro =>
      'Un accès premium sera accordé après vérification d’un NFT de la collection Tarot Noir.';

  @override
  String get extendedReadings => 'Tirages étendus';

  @override
  String get extendedReadingsDetail => 'Croix celtique, relations et saisons.';

  @override
  String get nftAvatars => 'Avatars NFT';

  @override
  String get nftAvatarsDetail =>
      'Arcane Éclipse, Lune Noire et futures séries.';

  @override
  String get adFree => 'Sans publicité';

  @override
  String get adFreeDetail =>
      'Les publicités financent la version gratuite, jamais les membres Premium.';

  @override
  String get walletSoon => 'Connexion wallet — bientôt';

  @override
  String networkConfigured(Object network) {
    return 'Réseau configuré : $network. Le mint est désactivé tant que les paramètres Candy Machine ne sont pas fournis.';
  }

  @override
  String get adPlaceholder =>
      'Espace partenaire — réseau publicitaire à connecter.';
}
