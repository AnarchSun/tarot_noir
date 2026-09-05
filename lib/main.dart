// lib/main.dart

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
    this.imagePath,
  );

  final String number;
  final String name;
  final String symbol;
  final String keyword;
  final String message;
  final String imagePath;
}

const _arcana = <TarotCard>[
  TarotCard(
    '0',
    'Le Fou',
    '✦',
    'LE SAUT',
    'Le vide n’est pas une chute : c’est l’espace où ton prochain monde cherche sa forme.',
    'assets/images/tarot_temp/As_d_Épées.png',
  ),
  TarotCard(
    'II',
    'La Grande Prêtresse',
    '☾',
    'LE SECRET',
    'Ne livre pas ta lumière à ceux qui ne savent regarder que les braises.',
    'assets/images/tarot_temp/L_Hermite.png',
  ),
  TarotCard(
    'XIII',
    'La Mort',
    '☠',
    'LA MUE',
    'Ce qui se termine libère une place sacrée. Laisse l’ancienne peau à la terre.',
    'assets/images/tarot_temp/La_Mort.png',
  ),
  TarotCard(
    'XVIII',
    'La Lune',
    '☾',
    'LE MIRAGE',
    'Ton intuition parle bas sous le bruit. Marche lentement, mais marche avec elle.',
    'assets/images/tarot_temp/La_Lune.png',
  ),
  TarotCard(
    'XV',
    'Le Diable',
    '♜',
    'LA CHAÎNE',
    'Regarde la chaîne : elle est peut-être plus lâche que tu ne le crois.',
    'assets/images/tarot_temp/Le_Diable.png',
  ),
  TarotCard(
    'XVII',
    'L’Étoile',
    '✧',
    'LA GUÉRISON',
    'Après la nuit, ton désir de vivre demeure une forme de magie.',
    'assets/images/tarot_temp/Le_Soleil.png',
  ),
  TarotCard(
    'VI',
    'Les Amants',
    '♡',
    'L’UNION',
    'Deux chemins peuvent se rencontrer sans perdre leur mystère.',
    'assets/images/tarot_temp/Les_Amants.png',
  ),
  TarotCard(
    'XXI',
    'Le Monde',
    '◎',
    'L’ACCOMPLISSEMENT',
    'Ce qui semblait dispersé retrouve son cercle. Une fin peut devenir une porte.',
    'assets/images/tarot_temp/Le_Monde.png',
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

  final _journal = <_JournalEntry>[];

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();

    _card =
        _arcana[DateTime(now.year, now.month, now.day).millisecondsSinceEpoch %
            _arcana.length];
  }

  // Tirage aléatoire d'une nouvelle carte.
  void _draw() {
    setState(() {
      _card = _arcana[Random().nextInt(_arcana.length)];
      _journal.insert(0, _JournalEntry(card: _card, createdAt: DateTime.now()));
    });
  }

  void _saveJournalEntry(String note, int mood) {
    final trimmedNote = note.trim();
    if (trimmedNote.isEmpty) return;

    setState(() {
      _journal.insert(
        0,
        _JournalEntry(
          card: _card,
          note: trimmedNote,
          mood: mood,
          createdAt: DateTime.now(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final pages = [
      _ReadingPage(
        card: _card,
        onDraw: _draw,
        onOpenPremium: () => setState(() => _tab = 2),
      ),
      _JournalPage(entries: _journal, onSave: _saveJournalEntry),
      const _PremiumPage(),
    ];

    return Scaffold(
      body: SafeArea(child: pages[_tab]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (index) {
          setState(() => _tab = index);
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.auto_awesome_outlined),
            selectedIcon: const Icon(Icons.auto_awesome),
            label: l10n.reading,
          ),
          NavigationDestination(
            icon: const Icon(Icons.menu_book_outlined),
            selectedIcon: const Icon(Icons.menu_book),
            label: l10n.journal,
          ),
          NavigationDestination(
            icon: const Icon(Icons.workspace_premium_outlined),
            selectedIcon: const Icon(Icons.workspace_premium),
            label: l10n.premium,
          ),
        ],
      ),
    );
  }
}

class _ReadingPage extends StatelessWidget {
  const _ReadingPage({
    required this.card,
    required this.onDraw,
    required this.onOpenPremium,
  });

  final TarotCard card;
  final VoidCallback onDraw;
  final VoidCallback onOpenPremium;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
      children: [
        Text(
          l10n.appTitle.toUpperCase(),
          style: const TextStyle(
            letterSpacing: 4,
            color: Color(0xFFD4AF59),
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          l10n.dailyReading,
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
        ),

        const SizedBox(height: 24),

        // IMAGE DE LA CARTE
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

        const SizedBox(height: 20),

        if (AppConfig.premiumEnabled)
          _OrionPremiumInsight(card: card)
        else
          _PremiumTeaser(onOpen: onOpenPremium),

        const SizedBox(height: 28),

        // ============================================================
        // BOUTON : TIRER UNE AUTRE CARTE
        // ============================================================
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: onDraw,
            icon: const Icon(Icons.casino_outlined),
            label: Text(l10n.drawAnother),
          ),
        ),

        if (AppConfig.adsEnabled) ...[
          const SizedBox(height: 20),
          const _AdPlaceholder(),
        ],
      ],
    );
  }
}

class _TarotCardView extends StatelessWidget {
  const _TarotCardView({required this.card});

  final TarotCard card;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 430,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF251935), Color(0xFF0E0A16)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFD4AF59), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          card.imagePath,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    card.symbol,
                    style: const TextStyle(
                      fontSize: 90,
                      color: Color(0xFFD4AF59),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    card.name.toUpperCase(),
                    style: const TextStyle(
                      letterSpacing: 2,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _JournalPage extends StatefulWidget {
  const _JournalPage({required this.entries, required this.onSave});

  final List<_JournalEntry> entries;
  final void Function(String note, int mood) onSave;

  @override
  State<_JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<_JournalPage> {
  final _controller = TextEditingController();
  int _mood = 3;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    widget.onSave(_controller.text, _mood);
    if (_controller.text.trim().isNotEmpty) {
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.journalTitle,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              IconButton(
                tooltip: l10n.preferences,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const _PreferencesPage()),
                ),
                icon: const Icon(Icons.tune),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(l10n.journalSubtitle),
          const SizedBox(height: 20),
          TextField(
            controller: _controller,
            minLines: 3,
            maxLines: 6,
            decoration: const InputDecoration(
              filled: true,
              hintText: 'Écris ce que la carte remue ou éclaire en toi…',
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'INTENSITÉ DU JOUR · $_mood/5',
            style: const TextStyle(fontSize: 12, letterSpacing: 1.2),
          ),
          Slider(
            value: _mood.toDouble(),
            min: 1,
            max: 5,
            divisions: 4,
            label: '$_mood / 5',
            onChanged: (value) => setState(() => _mood = value.round()),
          ),
          FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.bookmark_add_outlined),
            label: const Text('Sceller cette note'),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: widget.entries.isEmpty
                ? Center(child: Text(l10n.journalEmpty))
                : ListView.separated(
                    itemCount: widget.entries.length,
                    separatorBuilder: (_, _) => const Divider(),
                    itemBuilder: (_, i) {
                      final entry = widget.entries[i];
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.asset(
                            entry.card.imagePath,
                            width: 42,
                            height: 58,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Text(
                              entry.card.symbol,
                              style: const TextStyle(
                                fontSize: 28,
                                color: Color(0xFFD4AF59),
                              ),
                            ),
                          ),
                        ),
                        title: Text(entry.card.name),
                        subtitle: Text(
                          entry.note?.isNotEmpty == true
                              ? '${entry.note} · ${entry.mood ?? 3}/5'
                              : '${entry.card.keyword} · ${entry.mood ?? 3}/5',
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _PreferencesPage extends StatefulWidget {
  const _PreferencesPage();

  @override
  State<_PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<_PreferencesPage> {
  bool _orionMemory = false;
  bool _personalizedGuidance = false;
  bool _dailyReminder = false;
  String _tone = 'Mystique et direct';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.preferences)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            l10n.preferencesTitle,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Text(l10n.preferencesIntro),
          const SizedBox(height: 18),
          SwitchListTile(
            value: _orionMemory,
            onChanged: (value) => setState(() => _orionMemory = value),
            title: Text(l10n.orionMemory),
            subtitle: Text(l10n.orionMemoryDetail),
          ),
          SwitchListTile(
            value: _personalizedGuidance,
            onChanged: (value) => setState(() => _personalizedGuidance = value),
            title: Text(l10n.personalizedGuidance),
            subtitle: Text(l10n.personalizedGuidanceDetail),
          ),
          SwitchListTile(
            value: _dailyReminder,
            onChanged: (value) => setState(() => _dailyReminder = value),
            title: Text(l10n.dailyReminder),
            subtitle: Text(l10n.dailyReminderDetail),
          ),
          const Divider(height: 34),
          Text(
            l10n.orionTone,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _tone,
            decoration: const InputDecoration(filled: true),
            items: const [
              DropdownMenuItem(
                value: 'Mystique et direct',
                child: Text('Mystique et direct'),
              ),
              DropdownMenuItem(
                value: 'Doux et contemplatif',
                child: Text('Doux et contemplatif'),
              ),
              DropdownMenuItem(
                value: 'Symbolique et concret',
                child: Text('Symbolique et concret'),
              ),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _tone = value);
            },
          ),
          const Divider(height: 34),
          Text(
            l10n.dataAndInterests,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(l10n.dataPolicy),
            ),
          ),
          TextButton.icon(
            onPressed: () =>
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(l10n.noDataToErase))),
            icon: const Icon(Icons.delete_outline),
            label: Text(l10n.eraseLocalData),
          ),
        ],
      ),
    );
  }
}

class _PremiumPage extends StatelessWidget {
  const _PremiumPage();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          l10n.premiumTitle,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Text(l10n.premiumIntro),
        const SizedBox(height: 24),

        _FeatureTile(
          Icons.auto_awesome,
          l10n.extendedReadings,
          l10n.extendedReadingsDetail,
        ),

        _FeatureTile(
          Icons.palette_outlined,
          l10n.nftAvatars,
          l10n.nftAvatarsDetail,
        ),

        _FeatureTile(Icons.block_outlined, l10n.adFree, l10n.adFreeDetail),

        const SizedBox(height: 24),

        OutlinedButton(onPressed: null, child: Text(l10n.walletSoon)),

        const SizedBox(height: 12),

        Text(
          l10n.networkConfigured(AppConfig.solanaCluster),
          style: const TextStyle(fontSize: 12, color: Color(0xFFB9AFBE)),
        ),
        const SizedBox(height: 8),
        Text(
          'Endpoint devnet : ${AppConfig.solanaClusterUrl}',
          style: const TextStyle(fontSize: 12, color: Color(0xFFB9AFBE)),
        ),
      ],
    );
  }
}

class _OrionPremiumInsight extends StatelessWidget {
  const _OrionPremiumInsight({required this.card});

  final TarotCard card;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: const Color(0xFF211839),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFFD4AF59).withValues(alpha: .55)),
    ),
    child: Text(
      'ORION+ · Avec ${card.name}, choisis un geste minuscule mais réel. Note-le dans ton Journal, puis reviens observer ce qu’il a déplacé.',
      style: const TextStyle(height: 1.45),
    ),
  );
}

class _PremiumTeaser extends StatelessWidget {
  const _PremiumTeaser({required this.onOpen});

  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: const Color(0xFF171220),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'RITUEL ORION+',
          style: TextStyle(
            letterSpacing: 1.5,
            color: Color(0xFFD4AF59),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Lecture approfondie, liens avec le Journal et historique des signes.',
        ),
        TextButton.icon(
          onPressed: onOpen,
          icon: const Icon(Icons.workspace_premium_outlined),
          label: const Text('Explorer Premium'),
        ),
      ],
    ),
  );
}

class _JournalEntry {
  const _JournalEntry({
    required this.card,
    required this.createdAt,
    this.note,
    this.mood,
  });

  final TarotCard card;
  final DateTime createdAt;
  final String? note;
  final int? mood;
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile(this.icon, this.title, this.detail);

  final IconData icon;
  final String title;
  final String detail;

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
