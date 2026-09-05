# Tarot Noir

MVP Flutter d’une application de tarot, conversation symbolique et collection numérique. L’expérience est volontairement **non prédictive** : elle propose des pistes de réflexion et ne remplace jamais une aide médicale, juridique, financière ou psychologique.

## Lancer le prototype

1. Installez le SDK Flutter (Dart 3.3+).
2. Depuis ce dossier, lancez `flutter pub get`, puis `flutter run`.

## Ce qui est fonctionnel dans ce MVP

- Tirage aléatoire parmi les arcanes majeurs disponibles et lecture droite/renversée.
- Écran de chat Orion avec comportement local de démonstration (aucune donnée ni clé API).
- Parcours de tirages premium prêt à être relié à StoreKit / Google Play Billing.
- Écran Collection qui prépare l’intégration d’actifs Solana sans connecter de portefeuille ni signer de transaction.

## Architecture de production recommandée

`Flutter → API backend → fournisseur IA → base de connaissances validée`

- **Orion** doit être une couche de persona et de récupération documentaire (RAG), avec citations internes et tests de sécurité ; ce n’est pas un modèle autonome à embarquer dans l’app.
- Garder les clés et la logique de paiement hors de Flutter, sur le backend.
- Valider les reçus d’achats intégrés côté serveur et appliquer quotas/abonnements côté serveur.
- Pour Solana : connexion via un SDK portefeuille, signature explicite, vérification serveur de l’owner/mint, métadonnées sur stockage pérenne. Ne jamais demander ou stocker une seed phrase.
- Prévoir les règles des stores avant de lier les NFT à des avantages payants. Les tarifs, la disponibilité et les flux d’achat doivent être validés avant soumission.

## Étapes suivantes

1. Choisir le fournisseur IA (Vertex AI, Azure AI Foundry ou OpenAI via backend) et l’hébergement.
2. Constituer un corpus sous licences adaptées et établir les règles éditoriales d’Orion.
3. Ajouter authentification, stockage chiffré des données utilisateur, analytics consentis et suppression de compte.
4. Intégrer les achats natifs, puis Solana après revue conformité/sécurité.
