# Tarot Noir

Prototype Flutter mobile sombre et mystique autour du Tarot de Marseille.
Les fonctionnalités décrites ci-dessous correspondent au code actuel.

## Infrastructure

```text
lib/
  main.dart                 Initialisation Flutter
  app.dart                  Thème, langues et composition
  app_config.dart           Chemins, réseau devnet, aperçu Premium, clé de stockage
  models/                   Carte unique, note, préférences, état local versionné
  data/tarot_deck.dart       Catalogue de 78 cartes et index par identifiant stable
  services/reading_policy.dart  Règles Gratuit/Premium et sélection quotidienne
  repositories/             Interface de stockage et adaptateur shared_preferences
  controllers/              Actions, validation, sauvegarde et état observable
  pages/                    Écrans existants reliés au contrôleur
```

Le contrôleur reçoit son dépôt, son horloge et sa politique d’accès par injection.
Les pages n’écrivent pas directement dans le stockage. Le dépôt peut être remplacé
par une base locale sans réécrire les écrans.

## Fonctionnement actuel

- Gratuit : une carte révélée par jour, texte court, journal local.
- Carte déterministe selon la date locale, mémorisée par identifiant : même carte
  après réouverture. Actualisation à minuit ou à la reprise de l’application.
- Recul de date : aucune nouvelle carte tant que la date ne dépasse pas le dernier
  jour enregistré. Une avance manuelle de l’horloge ou une suppression du stockage
  restent hors des garanties du prototype ; une limite inviolable exige un serveur.
- Journal, humeur, préférences et carte courante enregistrés dans un document JSON
  versionné. Les identifiants des cartes ne doivent plus changer sans migration.
- Écritures exclusives ; aucune validation visuelle d’une sauvegarde échouée.
  Le brouillon reste dans le champ si l’enregistrement échoue.
- Une sauvegarde illisible ou d’une version inconnue bloque le chargement avec
  un message et un bouton de réessai, sans écraser les données.
- Effacement confirmé depuis les préférences : notes supprimées et réglages remis
  à zéro ; seuls la date et l’identifiant de la carte restent pour le verrou du jour.
- Tableau Gratuit/Premium de dix rubriques conservé ; fonctions futures signalées.
- Interface français, anglais, espagnol ; langue de l’appareil, anglais par défaut.
  Les textes du catalogue de cartes restent pour l’instant en français.
- Huit images de test reliées à leurs cartes dans `assets/images/tarot_temp`.
  Les autres cartes utilisent un symbole de remplacement.

## Configuration

Tout reste dans `lib/app_config.dart`. Aucun secret ne doit entrer dans ce fichier
ni dans Git. Les paramètres disponibles :

```sh
flutter run
flutter run --dart-define=PREMIUM_ENABLED=true
flutter run --dart-define=SOLANA_CLUSTER=devnet --dart-define=SOLANA_CLUSTER_URL=https://api.devnet.solana.com
```

`PREMIUM_ENABLED` est exclusivement un aperçu de développement, pas une preuve
d’achat. Il autorise les tirages supplémentaires et l’aperçu de texte Orion+.
Aucun droit Premium n’est enregistré dans les préférences locales.

## Stockage et confidentialité

`shared_preferences` 2.5.5 utilise le stockage local de la plateforme. Il convient
au prototype et aux réglages ; il n’offre ni chiffrement applicatif, ni sauvegarde
cloud, ni garantie de durabilité adaptée à des données critiques. Un journal destiné
à la production devra passer à un stockage adapté et à une stratégie de sauvegarde.
Les règles de sauvegarde système de l’appareil peuvent aussi s’appliquer.

Documentation : https://pub.dev/packages/shared_preferences

Orion, notifications, wallet, NFT, paiement et backend ne sont pas connectés.
Les consentements mémorisés sont des préférences pour des fonctions futures ;
toute activation d’une intégration demandera un consentement informé distinct.
Aucun navigateur, réseau social ou historique web n’est lu. Aucune annonce active.

## Vérification

```sh
flutter pub get
flutter gen-l10n
dart format lib test
flutter analyze --no-pub
flutter test --no-pub
flutter test --no-pub --dart-define=PREMIUM_ENABLED=true
```

Les tests traversent le contrôleur et le vrai encodeur/décodeur du dépôt avec une
frontière de stockage simulée. Ils couvrent la réouverture, le verrou quotidien,
le catalogue, l’effacement, la corruption, les erreurs et les écritures concurrentes.
Une vérification sur appareil Android/iOS reste nécessaire avant distribution.
