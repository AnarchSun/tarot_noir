---
target: guest-first Tarot Noir daily-card entry
total_score: 22
max_score: 40
na_heuristics: 
p0_count: 0
p1_count: 3
timestamp: 2026-10-06T23-25-20Z
slug: lib-screens-reading-screen-dart
---
Method: dual-agent (A: f4e02b4e-75c2-4e2d-b29b-54b20952dcec · B: ed249011-8cac-46b8-a252-9fe12f259995)

## Design Health Score

| # | Heuristique | Score | Problème principal |
|---|---|---:|---|
| 1 | Visibilité de l’état système | 2/4 | La restauration a un spinner, mais aucune progression mesurée; le visuel de référence montre « Tirage prêt » et une barre pleine pendant le chargement. |
| 2 | Correspondance avec le monde réel | 3/4 | Carte et interprétation sont lisibles; le lien entre aperçu, tirage quotidien et tirage libre est ambigu. |
| 3 | Contrôle et liberté | 2/4 | L’invité peut continuer, mais Journal et Profil disparaissent au lieu d’ouvrir une explication avec retour. |
| 4 | Cohérence et standards | 2/4 | L’accueil initial mélange révélation, choix de compte et écran de lecture; la maquette et le flux ont des étapes différentes. |
| 5 | Prévention des erreurs | 2/4 | Le tirage libre est répétable et l’annonce publicitaire intervient au premier tirage libre, pas sur un tirage quotidien unique. |
| 6 | Reconnaissance plutôt que mémorisation | 3/4 | Google et invité sont nommés, mais les avantages de compte/Premium ne sont pas visibles au bon moment. |
| 7 | Flexibilité et efficacité | 2/4 | L’accès invité existe; après ce choix, aucun chemin vers une création de compte depuis les sections verrouillées n’est disponible. |
| 8 | Esthétique et minimalisme | 2/4 | La référence est spectaculaire mais rouge/noir/or et chargée; elle ne reprend pas le bleu poudre/turquoise et l’ivoire, ni la retenue symbolique demandée. |
| 9 | Aide à la récupération | 2/4 | L’annulation d’authentification ne bloque pas, mais le parcours invité n’explique pas comment accéder plus tard au compte et aux fonctions verrouillées. |
| 10 | Aide et documentation | 2/4 | Les bénéfices de compte et d’Orion+ ne sont pas exposés au point où ils deviennent pertinents. |
| **Total** | | **22/40 — Acceptable** | **La structure existe, mais le contrat entre chargement, tirage et accès doit être clarifié.** |

## Verdict de spécificité

**Évaluation design :** le tarot quotidien déterministe et l’interprétation courte appartiennent bien à Tarot Noir. La séquence d’accueil actuelle est toutefois un écran de lecture avec une animation limitée à l’apparition par fondu/échelle de la carte; elle n’est pas un véritable interlude animé de marque. Le visuel fourni ressemble à une affiche fixe, pas à une séquence animée: le logo, la carte, le texte et la barre sont tous déjà présents. La barre pleine et « Tirage prêt » contredisent l’état de chargement.

**Scan déterministe :** `detect.mjs --json lib/screens/reading_screen.dart` a retourné `[]` (zéro constat). Le détecteur est générique et ce fichier Flutter/Dart n’offre pas de preuve visuelle navigateur; ce résultat ne valide ni le rendu natif ni l’animation. Aucune superposition navigateur n’est disponible. La revue du code a trouvé les écarts de flux ci-dessous, que ce scan ne mesure pas.

## Impression générale

La direction émotionnelle gothique attire l’œil, mais l’affiche présente un résultat déjà tiré, alors que le parcours décrit demande ensuite de tirer la carte du jour. La meilleure opportunité est de séparer nettement le court spectacle de démarrage, le choix de compte, puis l’accueil de lecture et le tirage volontaire.

## Points forts

- La carte du jour est déterministe et la courte interprétation crée une bonne accroche produit.
- Continuer sans compte donne un accès immédiat à la lecture et Premium.
- Le logo et une vraie carte du jeu peuvent rendre le chargement distinctif plutôt qu’un écran générique.

## Problèmes prioritaires

- **[P1] Carte révélée avant le tirage promis.** Si l’écran animé révèle la vraie carte et son sens avant l’accueil, le bouton « Tirer ma carte du jour » devient redondant et l’annonce ne précède plus l’action attendue. **Correction :** choisir un seul contrat. Recommandation: pendant le chargement, montrer le dos/la silhouette de la carte et une phrase d’ambiance; après « Continuer comme invité », le bouton de tirage lance l’emplacement publicitaire, puis révèle la carte quotidienne déterministe une seule fois par date. Si la révélation animée est le tirage, supprimer le second bouton de tirage quotidien et réserver l’annonce à un autre tirage clairement nommé. **Commande :** `/impeccable shape`.
- **[P1] Les portes Journal/Profil ne proposent pas de suite.** Les destinations sont absentes des onglets invités; l’invité ne peut ni comprendre pourquoi ni créer son compte au moment où il en voit l’intérêt. **Correction :** garder Journal/Profil repérables; au toucher, ouvrir une feuille explicative avec bénéfices concrets du compte (sauvegarde/synchronisation du journal avec consentement), action Google/Facebook et retour sans compte. Présenter Orion+ à part, comme offre facultative, jamais comme condition pour créer un compte. **Commande :** `/impeccable onboard`.
- **[P1] Le chargement prétend être terminé.** Une barre remplie et « Tirage prêt » ne sont pas crédibles durant l’attente et habituent l’utilisateur à ignorer l’indicateur. **Correction :** progression indéterminée si la restauration n’est pas mesurable; sinon progression basée sur de vraies étapes, puis transition explicite « Prêt ». Garder l’attente courte et autoriser de poursuivre si possible. **Commande :** `/impeccable harden`.
- **[P2] L’image fixe ne vend pas le mouvement.** L’unique apparition scale/fade de la carte ne crée pas une animation de tirage. **Correction :** chorégraphier une seule séquence courte: logo qui se révèle, dos de carte qui monte, retournement avec pause, nom et phrase qui apparaissent, puis contrôles d’accès après la fin. Ajouter un bouton pour passer l’animation et respecter la réduction des animations. **Commande :** `/impeccable animate`.
- **[P2] Le visuel s’écarte de l’identité Tarot Noir établie.** La maquette est presque entièrement rouge/noire/or et accumule des ornements célestes, contrairement au bleu poudre/turquoise, à l’ivoire vieilli et à la symbolique Marseille prioritaire. **Correction :** garder le noir profond et quelques accents rouges, ramener le turquoise/ivoire dans la hiérarchie, limiter les ornements et laisser la carte authentique porter le spectacle. **Commande :** `/impeccable colorize`.

## Signaux par persona

- **Jordan, première visite :** comprend la carte et les boutons, mais ne voit pas pourquoi le Journal/Profil est absent après son choix invité; aucun point d’entrée n’explique le compte.
- **Casey, mobile distrait :** le grand visuel vertical est accrocheur, mais peut repousser les actions sous la zone visible; les choix d’accès doivent apparaître dès que le chargement réel termine, avec une animation courte et interruptible.
- **Riley, test des limites :** plusieurs tirages libres aléatoires peuvent suivre le premier; l’application doit distinguer visuellement et durablement le tirage quotidien unique des tirages additionnels/publicitaires.

## Observations secondaires

- Le bouton Google de connexion peut aussi créer un compte via Firebase; le libellé devrait éviter de laisser croire qu’il faut choisir entre deux parcours distincts.
- Ne jamais retarder artificiellement l’accès avec une barre de progression décorative pour augmenter les vues publicitaires.
- Le bénéfice Orion+ doit être distinct de l’accès compte gratuit, et l’accès guest rester complet pour les fonctions non personnelles.

## Questions de conception

- L’animation d’accueil doit-elle révéler la vraie carte quotidienne, ou seulement la suggérer avant le tirage volontaire? Les deux comportements ne peuvent pas coexister sans rendre le bouton et l’annonce confus.
- Quand un invité touche Journal ou Profil, veut-on d’abord une explication avec connexion/inscription, puis un retour simple à l’application? Recommandé: oui, sans redirection bloquante ni offre Orion+ mêlée à l’inscription.
