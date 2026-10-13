# Tarot Noir

Prototype Flutter mobile sombre et mystique autour du Tarot de Marseille.
Les fonctionnalités décrites ci-dessous correspondent au code actuel.

## Infrastructure

```text
lib/
  main.dart                 Thème, langues et point d’entrée
  app_config.dart           Réseau devnet et aperçu Premium
  models/                   Cartes, deck et entrées du journal
  services/                 Persistance locale SharedPreferences
  screens/                  Tirage, journal, préférences, Premium et profil
  widgets/                  Cartes et composants Premium réutilisables
```

Le shell principal conserve la navigation entre les écrans et délègue la persistance
au service local. Le catalogue contient les 78 cartes, tandis que les illustrations
peuvent être ajoutées progressivement sans créer de faux assets.

## Fonctionnement actuel

- Gratuit : une carte révélée par jour, texte court, journal local.
- L’accueil présente la carte du jour et propose Google, Facebook ou l’accès
  invité. La carte est révélée et sauvegardée à l’entrée, puis une nouvelle carte
  apparaît automatiquement à la première ouverture d’un autre jour.
- La carte dépend de la date locale et parcourt les 78 cartes dans l’ordre;
  l’identifiant sauvegardé maintient le même tirage après réouverture.
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
- Les illustrations des 78 cartes sont dans `assets/images/tarot_temp`; le fond
  et le logo de l’accueil sont dans `assets/images/backgrounds` et `branding`.

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

### Profil et authentification

L’écran d’accueil propose Google, Facebook (si configuré) ou l’accès invité ;
aucune connexion par courriel/mot de passe n’y est proposée. Pour Android, les options
FlutterFire et `android/app/google-services.json` sont générés pour le projet
`tarot-noir`; les options sont publiques et ne contiennent aucun secret serveur.
Activez le fournisseur **Google** dans Firebase Authentication. Ajoutez les
empreintes SHA du certificat
Android dans les paramètres de l’application Firebase, puis récupérez le
`google-services.json` à jour afin qu’il contienne les clients OAuth Android et
Web. Le fichier de ce dépôt a été actualisé après l’enregistrement des
empreintes debug SHA-1 et SHA-256.

L’authentification Firebase est contrôlée par `FIREBASE_AUTH_ENABLED`. Les
identifiants locaux Google et Meta se passent avec
`--dart-define-from-file=config/auth.local.json`, fichier ignoré par Git. Les
mots de passe et jetons privés ne sont jamais enregistrés dans Git.

### Synchronisation Firestore du journal

La synchronisation du journal est désactivée par défaut. Une fois connecté,
activez **Synchroniser le journal avec Firebase** dans Profil pour fusionner le
journal local avec `users/{uid}/journal` dans le compte Firebase courant. Les
entrées synchronisées restent associées à leur UID et ne sont pas transférées à
un autre compte connecté sur le même appareil. Désactiver l’option arrête les
transferts futurs, sans effacer les copies distantes; effacer les données locales
ne supprime pas non plus les données Firestore.

Avant le premier déploiement, activez l’API Cloud Firestore et créez la base
Firestore **Standard** dans `northamerica-northeast1` (Montréal) pour le projet
`tarot-noir`. Puis publiez les règles propriétaires et l’indexation déclarée :

```sh
firebase deploy --only firestore:rules,firestore:indexes --project tarot-noir
```

Les règles de `firestore.rules` limitent les lectures et écritures au propriétaire
du compte et valident les champs des profils et entrées du journal. Aucun journal
n’est envoyé avant le consentement dans Profil.

Pour Facebook, activez le fournisseur dans Firebase Authentication, créez
l’application Android et iOS correspondante dans Meta, puis renseignez
`META_APP_ID`, `META_CLIENT_TOKEN` et `FACEBOOK_AUTH_ENABLED`. Android génère ses ressources Meta depuis ces paramètres. Sur iOS, copiez
`ios/Flutter/Meta.local.xcconfig.example` vers `ios/Flutter/Meta.local.xcconfig`
et renseignez-y le même `META_APP_ID` et `META_CLIENT_TOKEN`. Ce fichier est ignoré
par Git ; les valeurs sont substituées dans `Info.plist` au build. Le bouton
Facebook reste visible, mais la connexion est bloquée si un paramètre manque.

```sh
flutter run --dart-define-from-file=config/auth.local.json
```

Pour activer les flux email, Google et téléphone sur Android :

```sh
flutter run --dart-define=FIREBASE_AUTH_ENABLED=true
```

Le Client Token Meta est un identifiant d’application public attendu par le SDK;
les App Secrets Meta, jetons OAuth utilisateur et clés de service restent hors du
dépôt, dans les consoles ou sur le serveur. Après une connexion Google ou
Facebook, le profil local est proposé avec le nom et le courriel Firebase
préremplis. Un profil existant peut aussi conserver son adresse wallet.

### Connexion wallet

WalletConnect utilise Reown AppKit sur Solana devnet. Créez un projet public dans
la console Reown, puis ajoutez `REOWN_PROJECT_ID` dans votre copie locale de
`config/auth.example.json` et activez `WALLETCONNECT_ENABLED`. L’application
reçoit seulement l’adresse publique ; elle ne lit ni seed phrase ni clé privée.
La connexion prouve qu’un wallet a accepté une session. Les liens de téléchargement
ouvrent uniquement les pages officielles Phantom et Solflare. Après connexion, le
formulaire demande un alias et un courriel facultatif, enregistrés localement avec
l’adresse publique. Un véritable login et l’accès Premium demanderont ensuite un
défi signé, vérifié par le backend.

Le schéma de retour mobile est `tarotnoir://wallet`. Toute modification de ce
schéma doit rester identique dans `AppConfig`, Android, iOS et la console Reown.

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
