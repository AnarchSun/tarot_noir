import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(const TarotNoirApp());

class TarotNoirApp extends StatelessWidget {
  const TarotNoirApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tarot Noir',
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF090711),
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFE6C66A),
            secondary: Color(0xFF9B75D8),
            surface: Color(0xFF171226),
          ),
          textTheme: const TextTheme(
            headlineLarge: TextStyle(fontWeight: FontWeight.w700),
            titleLarge: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        home: const RootScreen(),
      );
}

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _index = 0;
  final _pages = const [ReadingPage(), OrionPage(), CollectionPage()];

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(child: _pages[_index]),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (value) => setState(() => _index = value),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.auto_awesome_outlined), selectedIcon: Icon(Icons.auto_awesome), label: 'Tirage'),
            NavigationDestination(icon: Icon(Icons.nights_stay_outlined), selectedIcon: Icon(Icons.nights_stay), label: 'Orion'),
            NavigationDestination(icon: Icon(Icons.token_outlined), selectedIcon: Icon(Icons.token), label: 'Collection'),
          ],
        ),
      );
}

class ReadingPage extends StatefulWidget {
  const ReadingPage({super.key});

  @override
  State<ReadingPage> createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  TarotCard? _card;
  bool _reversed = false;

  void _draw() {
    final random = Random();
    setState(() {
      _card = tarotDeck[random.nextInt(tarotDeck.length)];
      _reversed = random.nextBool();
    });
  }

  @override
  Widget build(BuildContext context) {
    final card = _card;
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
      children: [
        const Text('TAROT NOIR', style: TextStyle(letterSpacing: 4, color: Color(0xFFE6C66A), fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        const Text('Le signe de votre nuit', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text('Un tirage quotidien pour éclairer vos intentions — à recevoir comme une invitation à la réflexion.', style: TextStyle(color: Colors.white.withValues(alpha: .7))),
        const SizedBox(height: 28),
        _TarotCardView(card: card, reversed: _reversed),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: _draw,
          icon: const Icon(Icons.casino_outlined),
          label: Text(card == null ? 'Révéler mon tirage gratuit' : 'Tirer une nouvelle carte'),
          style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 17)),
        ),
        const SizedBox(height: 18),
        if (card != null) _Interpretation(card: card, reversed: _reversed),
        const SizedBox(height: 18),
        OutlinedButton.icon(
          onPressed: () => _showPremium(context),
          icon: const Icon(Icons.workspace_premium_outlined),
          label: const Text('Explorer les tirages premium'),
        ),
      ],
    );
  }
}

class _TarotCardView extends StatelessWidget {
  const _TarotCardView({required this.card, required this.reversed});
  final TarotCard? card;
  final bool reversed;

  @override
  Widget build(BuildContext context) => Container(
        height: 300,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF302154), Color(0xFF120D23)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFFE6C66A).withValues(alpha: .65)),
          boxShadow: const [BoxShadow(color: Color(0x66000000), blurRadius: 30, offset: Offset(0, 18))],
        ),
        child: Center(
          child: card == null
              ? const Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.visibility_off_outlined, size: 54, color: Color(0xFFE6C66A)), SizedBox(height: 14), Text('La carte attend votre intention')])
              : Transform.rotate(
                  angle: reversed ? pi : 0,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text(card.symbol, style: const TextStyle(fontSize: 82)),
                    const SizedBox(height: 12),
                    Text(card.name.toUpperCase(), style: const TextStyle(letterSpacing: 2.5, color: Color(0xFFE6C66A), fontWeight: FontWeight.bold)),
                    Text(reversed ? 'RENVERSEE' : 'DROITE', style: const TextStyle(fontSize: 11, letterSpacing: 2)),
                  ]),
                ),
        ),
      );
}

class _Interpretation extends StatelessWidget {
  const _Interpretation({required this.card, required this.reversed});
  final TarotCard card;
  final bool reversed;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: const Color(0xFF171226), borderRadius: BorderRadius.circular(20)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${card.name} ${reversed ? '— message à accueillir' : '— message du jour'}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Text(reversed ? card.reversedMeaning : card.meaning, style: TextStyle(height: 1.5, color: Colors.white.withValues(alpha: .84))),
          const SizedBox(height: 14),
          const Text('Interprétation symbolique — ne remplace pas un avis médical, juridique ou financier.', style: TextStyle(fontSize: 11, color: Color(0xFFB9AFCB))),
        ]),
      );
}

class OrionPage extends StatefulWidget {
  const OrionPage({super.key});
  @override
  State<OrionPage> createState() => _OrionPageState();
}

class _OrionPageState extends State<OrionPage> {
  final _controller = TextEditingController();
  final List<_Message> _messages = [const _Message('Orion', 'Je suis Orion. Déposez votre question sous la lune : je vous proposerai une lecture symbolique, avec douceur et discernement.', false)];

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_Message('Vous', text, true));
      _messages.add(const _Message('Orion', 'Votre question porte une tension entre ce qui est connu et ce qui souhaite naître. Prenez un instant : quel choix respecte le mieux vos valeurs et votre sécurité ? La carte tirée peut servir de miroir, pas de verdict.', false));
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) => Column(children: [
        const Padding(padding: EdgeInsets.fromLTRB(24, 28, 24, 14), child: Row(children: [CircleAvatar(backgroundColor: Color(0xFF9B75D8), child: Icon(Icons.nights_stay)), SizedBox(width: 12), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('ORION', style: TextStyle(letterSpacing: 3, fontWeight: FontWeight.bold)), Text('Guide symbolique · bêta', style: TextStyle(fontSize: 12, color: Color(0xFFB9AFCB)))])])),
        Expanded(child: ListView.builder(padding: const EdgeInsets.symmetric(horizontal: 16), itemCount: _messages.length, itemBuilder: (_, i) { final m = _messages[i]; return Align(alignment: m.mine ? Alignment.centerRight : Alignment.centerLeft, child: Container(margin: const EdgeInsets.symmetric(vertical: 6), padding: const EdgeInsets.all(14), constraints: const BoxConstraints(maxWidth: 310), decoration: BoxDecoration(color: m.mine ? const Color(0xFF6A4BA0) : const Color(0xFF171226), borderRadius: BorderRadius.circular(16)), child: Text(m.text)); })),
        SafeArea(top: false, child: Padding(padding: const EdgeInsets.all(16), child: Row(children: [Expanded(child: TextField(controller: _controller, onSubmitted: (_) => _send(), decoration: const InputDecoration(hintText: 'Posez votre question…', filled: true))), const SizedBox(width: 8), IconButton.filled(onPressed: _send, icon: const Icon(Icons.arrow_upward))])))
      ]);
}

class CollectionPage extends StatelessWidget {
  const CollectionPage({super.key});
  @override
  Widget build(BuildContext context) => ListView(padding: const EdgeInsets.fromLTRB(24, 28, 24, 20), children: [
        const Text('COLLECTION', style: TextStyle(letterSpacing: 4, color: Color(0xFFE6C66A), fontWeight: FontWeight.w700)),
        const SizedBox(height: 12), const Text('Reliques numériques', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700)), const SizedBox(height: 10),
        Text('Vos cartes et reliques restent consultables ici. La connexion Solana doit être activée via un backend sécurisé avant toute transaction.', style: TextStyle(color: Colors.white.withValues(alpha: .72))),
        const SizedBox(height: 26),
        _collectionTile(Icons.auto_awesome, 'Sceau de la Lune', 'Récompense de bienvenue', 'À révéler'),
        _collectionTile(Icons.account_balance_wallet_outlined, 'Portefeuille Solana', 'Non connecté', 'Connecter bientôt'),
        _collectionTile(Icons.shield_outlined, 'Vos actifs, votre contrôle', 'Aucune phrase de récupération demandée', 'En savoir plus'),
      ]);
  Widget _collectionTile(IconData icon, String title, String subtitle, String action) => Card(child: ListTile(leading: Icon(icon, color: const Color(0xFFE6C66A)), title: Text(title), subtitle: Text(subtitle), trailing: Text(action, style: const TextStyle(color: Color(0xFFE6C66A)))));
}

void _showPremium(BuildContext context) => showModalBottomSheet(context: context, showDragHandle: true, builder: (_) => Padding(padding: const EdgeInsets.fromLTRB(24, 8, 24, 32), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Rituels premium', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)), const SizedBox(height: 16), const ListTile(leading: Icon(Icons.dark_mode), title: Text('Pack Éclipse'), subtitle: Text('Tirage à 3 cartes · intention, obstacle, passage')), const ListTile(leading: Icon(Icons.family_restroom), title: Text('Bénédiction ancestrale'), subtitle: Text('Lecture guidée et journal rituel')), FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Configurer les achats intégrés'))]));

class _Message { const _Message(this.author, this.text, this.mine); final String author; final String text; final bool mine; }
class TarotCard { const TarotCard(this.name, this.symbol, this.meaning, this.reversedMeaning); final String name, symbol, meaning, reversedMeaning; }

const majorArcana = [
  TarotCard('Le Mat', '☾', 'Un commencement audacieux se présente. Avancez avec curiosité, en gardant un point d’ancrage concret.', 'L’élan existe, mais l’impulsion demande à être ralentie. Vérifiez votre direction avant de partir.'),
  TarotCard('La Papesse', '☽', 'L’intuition mûrit dans le silence. Observez les détails et laissez la réponse se déployer.', 'Un savoir est retenu ou ignoré. Créez un espace calme avant de décider.'),
  TarotCard('L’Impératrice', '♕', 'Votre créativité nourrit ce qui veut grandir. Donnez forme à une idée avec tendresse.', 'Le soin des autres a peut-être pris toute la place. Réservez une part de votre énergie.'),
  TarotCard('L’Empereur', '♔', 'Structurez votre désir : une limite claire peut devenir un acte de protection.', 'La rigidité fatigue. Demandez-vous où une règle peut devenir un soutien plutôt qu’une prison.'),
  TarotCard('L’Amoureux', '♡', 'Un choix aligné naît du dialogue entre désir, conscience et engagement.', 'Clarifiez ce qui est vraiment choisi, plutôt que ce qui est attendu de vous.'),
  TarotCard('Le Chariot', '✦', 'Votre détermination ouvre le passage. Dirigez votre énergie vers une intention précise.', 'Deux élans se contredisent. Réunissez-les avant d’accélérer.'),
  TarotCard('La Force', '♌', 'La force calme transforme plus durablement que la contrainte. Faites preuve de patience.', 'Ne confondez pas endurance et épuisement : votre limite mérite d’être entendue.'),
  TarotCard('L’Hermite', '☿', 'Un retrait choisi éclaire votre prochaine étape. Écoutez la sagesse déjà acquise.', 'L’isolement se prolonge peut-être. Partagez votre question avec une personne sûre.'),
  TarotCard('Le Bateleur', '✣', 'Une idée et les moyens de commencer sont déjà à portée. Expérimentez sans exiger la perfection.', 'La dispersion ou l’illusion de maîtrise peut retarder le premier pas. Simplifiez votre approche.'),
  TarotCard('La Justice', '⚖', 'Regardez les faits avec lucidité. L’équilibre se construit par des gestes cohérents.', 'Une décision mérite encore des informations ou un regard extérieur.'),
  TarotCard('La Lune', '☾', 'Tout n’est pas encore visible. Accueillez l’émotion sans la prendre immédiatement pour une certitude.', 'Le brouillard se lève peu à peu. Notez vos rêves, puis vérifiez vos intuitions dans le réel.'),
  TarotCard('Le Soleil', '☀', 'La clarté et le lien reviennent. Partagez ce qui vous donne de l’élan.', 'La joie peut coexister avec l’ombre. Ne vous forcez pas à paraître rayonnant.'),
  TarotCard('Le Monde', '◌', 'Une étape se complète. Honorez le chemin parcouru et préparez l’espace de la suite.', 'Une boucle attend peut-être un dernier geste de clôture.'),
  TarotCard('Le Pape', '✠', 'Une transmission ou un repère éthique peut vous aider. Cherchez un conseil qui respecte votre liberté.', 'Interrogez les traditions qui vous encadrent : lesquelles vous servent encore ?'),
  TarotCard('La Roue de Fortune', '◉', 'Un cycle bouge. Accueillez le changement et repérez la possibilité qui l’accompagne.', 'Face à l’imprévu, revenez à ce qui dépend réellement de vous.'),
  TarotCard('Le Pendu', '⌇', 'Une pause volontaire change la perspective. Ce délai peut éclairer votre priorité.', 'Le sacrifice n’a pas à être permanent. Réévaluez ce que vous donnez et pourquoi.'),
  TarotCard('L’Arcane sans nom', '☠', 'Une transformation ouvre de l’espace. Laissez partir ce qui a terminé son cycle.', 'Un attachement rend la transition difficile. Accompagnez la fin avec douceur.'),
  TarotCard('Tempérance', '⚗', 'Dosez, reliez, ajustez. Un rythme plus doux peut créer une harmonie durable.', 'L’équilibre se cherche encore : évitez les extrêmes pour le moment.'),
  TarotCard('Le Diable', '♄', 'Regardez sans honte ce qui vous attache. La conscience ouvre un choix.', 'Une habitude ou une relation appelle une limite claire et du soutien si nécessaire.'),
  TarotCard('La Maison Dieu', 'ϟ', 'Une vérité bouscule une structure. Restez proche de vos soutiens et du concret.', 'Anticiper chaque secousse ne protège pas toujours. Préparez plutôt des appuis fiables.'),
  TarotCard('L’Étoile', '✧', 'L’espoir redevient pratique : soignez votre vision par un petit geste régulier.', 'Votre foi a besoin de repos. Permettez-vous de recevoir de l’aide.'),
  TarotCard('Le Jugement', '⌁', 'Un appel intérieur vous invite à faire la paix avec une part de votre histoire.', 'Une voix ancienne parle peut-être trop fort. Choisissez consciemment ce qui vous appartient.'),
];

const _suits = ['Bâtons', 'Coupes', 'Épées', 'Deniers'];
const _ranks = ['As', 'Deux', 'Trois', 'Quatre', 'Cinq', 'Six', 'Sept', 'Huit', 'Neuf', 'Dix', 'Valet', 'Cavalier', 'Reine', 'Roi'];

final minorArcana = [
  for (final suit in _suits)
    for (var i = 0; i < _ranks.length; i++)
      TarotCard(
        '${_ranks[i]} de $suit',
        _suitSymbol(suit),
        _minorMeaning(suit, i),
        'L’énergie des $suit semble bloquée ou demande à être regardée sous un autre angle. Revenez à ce que vous pouvez ajuster avec soin.',
      ),
];

final tarotDeck = [...majorArcana, ...minorArcana];

String _suitSymbol(String suit) => switch (suit) { 'Bâtons' => '♣', 'Coupes' => '♡', 'Épées' => '♠', _ => '◇' };

String _minorMeaning(String suit, int rank) {
  const themes = {
    'Bâtons': 'l’élan, l’action et la créativité',
    'Coupes': 'les émotions, le lien et l’intuition',
    'Épées': 'la pensée, la parole et le discernement',
    'Deniers': 'les ressources, le corps et le quotidien',
  };
  final intensity = rank < 4 ? 'un commencement' : rank < 10 ? 'une évolution' : 'une maturité';
  return 'Cette carte parle de $intensity dans ${themes[suit]}. Cherchez le prochain geste simple qui vous rapproche de votre intention.';
}
