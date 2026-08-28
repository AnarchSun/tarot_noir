import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_config.dart';
import 'l10n/app_localizations.dart';

void main() => runApp(const TarotNoirApp());

class TarotNoirApp extends StatelessWidget {
  const TarotNoirApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFF09070E),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFD4AF59),
        secondary: Color(0xFF926BB6),
        surface: Color(0xFF171220),
      ),
    ),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    localeResolutionCallback: (deviceLocale, supportedLocales) =>
        supportedLocales.firstWhere(
          (locale) => locale.languageCode == deviceLocale?.languageCode,
          orElse: () => const Locale('en'),
        ),
    home: const TarotNoirHome(),
  );
}

class TarotCard {
  const TarotCard(
    this.number,
    this.name,
    this.symbol,
    this.keyword,
    this.message,
  );
  final String number, name, symbol, keyword, message;
}

const _arcana = <TarotCard>[
  TarotCard(
    '0',
    'Le Fou',
    '✦',
    'LE SAUT',
    'Le vide n’est pas une chute : c’est l’espace où ton prochain monde cherche sa forme.',
  ),
  TarotCard(
    'II',
    'La Grande Prêtresse',
    '☾',
    'LE SECRET',
    'Ne livre pas ta lumière à ceux qui ne savent regarder que les braises.',
  ),
  TarotCard(
    'XIII',
    'La Mort',
    '☠',
    'LA MUE',
    'Ce qui se termine libère une place sacrée. Laisse l’ancienne peau à la terre.',
  ),
  TarotCard(
    'XVIII',
    'La Lune',
    '☾',
    'LE MIRAGE',
    'Ton intuition parle bas sous le bruit. Marche lentement, mais marche avec elle.',
  ),
  TarotCard(
    'XV',
    'Le Diable',
    '♜',
    'LA CHAÎNE',
    'Regarde la chaîne : elle est peut-être plus lâche que tu ne le crois.',
  ),
  TarotCard(
    'XVII',
    'L’Étoile',
    '✧',
    'LA GUÉRISON',
    'Après la nuit, ton désir de vivre demeure une forme de magie.',
  ),
];

class TarotNoirHome extends StatefulWidget {
  const TarotNoirHome({super.key});
  @override
  State<TarotNoirHome> createState() => _TarotNoirHomeState();
}

class _TarotNoirHomeState extends State<TarotNoirHome> {
  int _tab = 0;
  late TarotCard _card;
  final _journal = <TarotCard>[];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _card =
        _arcana[DateTime(now.year, now.month, now.day).millisecondsSinceEpoch %
            _arcana.length];
  }

  void _draw() => setState(() {
    _card = _arcana[Random().nextInt(_arcana.length)];
    _journal.insert(0, _card);
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pages = [
      _ReadingPage(card: _card, onDraw: _draw),
      _JournalPage(cards: _journal),
      const _PremiumPage(),
    ];
    return Scaffold(
      body: SafeArea(child: pages[_tab]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (index) => setState(() => _tab = index),
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome),
            label: l10n.reading,
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: l10n.journal,
          ),
          NavigationDestination(
            icon: Icon(Icons.workspace_premium_outlined),
            selectedIcon: Icon(Icons.workspace_premium),
            label: l10n.premium,
          ),
        ],
      ),
    );
  }
}

class _ReadingPage extends StatelessWidget {
  const _ReadingPage({required this.card, required this.onDraw});
  final TarotCard card;
  final VoidCallback onDraw;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
    children: [
      Text(
        AppLocalizations.of(context)!.appTitle.toUpperCase(),
        style: const TextStyle(
          letterSpacing: 4,
          color: Color(0xFFD4AF59),
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        AppLocalizations.of(context)!.dailyReading,
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 24),
      _TarotCardView(card: card),
      const SizedBox(height: 24),
      Text(
        card.keyword,
        style: const TextStyle(
          letterSpacing: 2,
          color: Color(0xFFD4AF59),
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 10),
      Text(
        card.message,
        style: const TextStyle(
          fontSize: 18,
          height: 1.5,
          color: Color(0xFFE7DFEA),
        ),
      ),
      const SizedBox(height: 28),
      FilledButton.icon(
        onPressed: onDraw,
        icon: const Icon(Icons.casino_outlined),
        label: Text(AppLocalizations.of(context)!.drawAnother),
      ),
      if (AppConfig.adsEnabled) ...[
        const SizedBox(height: 20),
        const _AdPlaceholder(),
      ],
    ],
  );
}

class _TarotCardView extends StatelessWidget {
  const _TarotCardView({required this.card});
  final TarotCard card;

  @override
  Widget build(BuildContext context) => Container(
    height: 310,
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF251935), Color(0xFF0E0A16)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(28),
      border: Border.all(color: const Color(0xFFD4AF59), width: 1.5),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          card.number,
          style: const TextStyle(color: Color(0xFFD4AF59), fontSize: 18),
        ),
        Expanded(
          child: Center(
            child: Text(
              card.symbol,
              style: const TextStyle(fontSize: 122, color: Color(0xFFD4AF59)),
            ),
          ),
        ),
        Text(
          card.name.toUpperCase(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            letterSpacing: 2,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}

class _JournalPage extends StatelessWidget {
  const _JournalPage({required this.cards});
  final List<TarotCard> cards;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.journalTitle,
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(AppLocalizations.of(context)!.journalSubtitle),
        const SizedBox(height: 20),
        Expanded(
          child: cards.isEmpty
              ? Center(child: Text(AppLocalizations.of(context)!.journalEmpty))
              : ListView.separated(
                  itemCount: cards.length,
                  separatorBuilder: (_, _) => const Divider(),
                  itemBuilder: (_, i) => ListTile(
                    leading: Text(
                      cards[i].symbol,
                      style: const TextStyle(
                        fontSize: 28,
                        color: Color(0xFFD4AF59),
                      ),
                    ),
                    title: Text(cards[i].name),
                    subtitle: Text(cards[i].keyword),
                  ),
                ),
        ),
      ],
    ),
  );
}

class _PremiumPage extends StatelessWidget {
  const _PremiumPage();
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(24),
    children: [
      Text(
        AppLocalizations.of(context)!.premiumTitle,
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 12),
      Text(AppLocalizations.of(context)!.premiumIntro),
      const SizedBox(height: 24),
      _FeatureTile(
        Icons.auto_awesome,
        AppLocalizations.of(context)!.extendedReadings,
        AppLocalizations.of(context)!.extendedReadingsDetail,
      ),
      _FeatureTile(
        Icons.palette_outlined,
        AppLocalizations.of(context)!.nftAvatars,
        AppLocalizations.of(context)!.nftAvatarsDetail,
      ),
      _FeatureTile(
        Icons.block_outlined,
        AppLocalizations.of(context)!.adFree,
        AppLocalizations.of(context)!.adFreeDetail,
      ),
      const SizedBox(height: 24),
      OutlinedButton(
        onPressed: null,
        child: Text(AppLocalizations.of(context)!.walletSoon),
      ),
      const SizedBox(height: 12),
      Text(
        AppLocalizations.of(context)!
            .networkConfigured(AppConfig.solanaCluster),
        style: const TextStyle(fontSize: 12, color: Color(0xFFB9AFBE)),
      ),
    ],
  );
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile(this.icon, this.title, this.detail);
  final IconData icon;
  final String title, detail;
  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: Icon(icon, color: const Color(0xFFD4AF59)),
      title: Text(title),
      subtitle: Text(detail),
    ),
  );
}

class _AdPlaceholder extends StatelessWidget {
  const _AdPlaceholder();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      border: Border.all(color: const Color(0xFF3F3449)),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      children: [
        const Icon(Icons.campaign_outlined, size: 18),
        const SizedBox(width: 10),
        Expanded(child: Text(AppLocalizations.of(context)!.adPlaceholder)),
      ],
    ),
  );
}
