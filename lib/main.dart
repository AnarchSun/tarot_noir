// lib/main.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_config.dart';
import 'l10n/app_localizations.dart';
import 'models/tarot_card.dart';

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

const _arcana = <TarotCard>[
  TarotCard(
    '0',
    'Le Fou',
    '✦',
    'LE SAUT',
    'Le vide n’est pas une chute : c’est l’espace où ton prochain monde cherche sa forme.',
    '',
  ),
  TarotCard(
    'II',
    'La Grande Prêtresse',
    '☾',
    'LE SECRET',
    'Ne livre pas ta lumière à ceux qui ne savent regarder que les braises.',
    '',
  ),
  TarotCard(
    'XIII',
    'La Mort',
    '☠',
    'LA MUE',
    'Ce qui se termine libère une place sacrée. Laisse l’ancienne peau à la terre.',
    'assets/images/tarot_cards/arcane_majeur/La_Mort.png',
  ),
  TarotCard(
    'XVIII',
    'La Lune',
    '☾',
    'LE MIRAGE',
    'Ton intuition parle bas sous le bruit. Marche lentement, mais marche avec elle.',
    'assets/images/tarot_cards/arcane_majeur/La_lune.png',
  ),
  TarotCard(
    'XV',
    'Le Diable',
    '♜',
    'LA CHAÎNE',
    'Regarde la chaîne : elle est peut-être plus lâche que tu ne le crois.',
    'assets/images/tarot_cards/arcane_majeur/Le_Diable.jpeg',
  ),
  TarotCard(
    'XVII',
    'L’Étoile',
    '✧',
    'LA GUÉRISON',
    'Après la nuit, ton désir de vivre demeure une forme de magie.',
    'assets/images/tarot_cards/arcane_majeur/Le_Soleil.png',
  ),
  TarotCard(
    'VI',
    'Les Amants',
    '♡',
    'L’UNION',
    'Deux chemins peuvent se rencontrer sans perdre leur mystère.',
    'assets/images/tarot_cards/arcane_majeur/Les_Amants.png',
  ),
  TarotCard(
    'XXI',
    'Le Monde',
    '◎',
    'L’ACCOMPLISSEMENT',
    'Ce qui semblait dispersé retrouve son cercle. Une fin peut devenir une porte.',
    'assets/images/tarot_cards/arcane_majeur/Le_Monde.png',
  ),
  TarotCard(
    'I',
    'Le Bateleur',
    '✣',
    'L’ÉLAN',
    'Les outils sont là. Commence humblement, puis laisse le geste te révéler sa voie.',
    '',
  ),
  TarotCard(
    'III',
    'L’Impératrice',
    '♕',
    'LA CRÉATION',
    'Ce qui germe demande du soin, de la beauté et un espace où respirer.',
    '',
  ),
  TarotCard(
    'IV',
    'L’Empereur',
    '♔',
    'LA STRUCTURE',
    'Une limite juste peut devenir une protection, jamais une cage.',
    '',
  ),
  TarotCard(
    'V',
    'Le Pape',
    '✠',
    'LA TRANSMISSION',
    'Cherche un repère qui nourrit ta liberté au lieu de parler à ta place.',
    '',
  ),
  TarotCard(
    'VII',
    'Le Chariot',
    '✦',
    'LE PASSAGE',
    'Rassemble tes forces vers une seule direction et avance sans te trahir.',
    '',
  ),
  TarotCard(
    'VIII',
    'La Justice',
    '⚖',
    'L’ÉQUILIBRE',
    'Regarde les faits avec clarté : chaque choix construit son propre poids.',
    '',
  ),
  TarotCard(
    'IX',
    'L’Hermite',
    '☿',
    'LA LAMPE',
    'Le retrait choisi éclaire la prochaine marche. Garde une lumière, même petite.',
    'assets/images/tarot_cards/arcane_majeur/L_Hermite.png',
  ),
  TarotCard(
    'X',
    'La Roue de Fortune',
    '◉',
    'LE CYCLE',
    'Le mouvement revient. Accueille ce qui change et ancre ce qui compte.',
    '',
  ),
  TarotCard(
    'XI',
    'La Force',
    '♌',
    'LE COURAGE',
    'La force calme transforme davantage que la contrainte. Respire avant d’agir.',
    '',
  ),
  TarotCard(
    'XII',
    'Le Pendu',
    '⌇',
    'LE RENVERSEMENT',
    'Une pause volontaire peut montrer l’angle que l’élan ne voyait pas.',
    '',
  ),
  TarotCard(
    'XIV',
    'Tempérance',
    '⚗',
    'L’ALCHIMIE',
    'Dose, relie, ajuste. Ton équilibre se fabrique par de petits mélanges vrais.',
    '',
  ),
  TarotCard(
    'XVI',
    'La Maison Dieu',
    'ϟ',
    'LA FAILLE',
    'Une structure tombe parfois pour libérer la vérité qui voulait passer.',
    '',
  ),
  TarotCard(
    'XIX',
    'Le Soleil',
    '☀',
    'LA CLARTÉ',
    'Partage ce qui te rend vivant. Une joie honnête peut servir de boussole.',
    '',
  ),
  TarotCard(
    'XX',
    'Le Jugement',
    '⌁',
    'L’APPEL',
    'Une voix ancienne appelle une réponse neuve. Choisis ce qui t’appartient.',
    '',
  ),
];

const _minorRanks = [
  'As',
  'Deux',
  'Trois',
  'Quatre',
  'Cinq',
  'Six',
  'Sept',
  'Huit',
  'Neuf',
  'Dix',
  'Valet',
  'Cavalier',
  'Reine',
  'Roi',
];

const _minorSuits = [
  _MinorSuit('Bâtons', '♣', 'l’élan, l’action et la création'),
  _MinorSuit('Coupes', '♡', 'l’émotion, le lien et l’intuition'),
  _MinorSuit('Épées', '♠', 'la pensée, la parole et le discernement'),
  _MinorSuit('Deniers', '◇', 'le corps, les ressources et le quotidien'),
];

final _minorArcana = <TarotCard>[
  for (final suit in _minorSuits)
    for (var index = 0; index < _minorRanks.length; index++)
      TarotCard(
        '${index + 1}-${suit.name}',
        '${_minorRanks[index]} de ${suit.name}',
        suit.symbol,
        suit.name.toUpperCase(),
        'Cette carte parle de ${suit.theme}. Cherche le prochain geste simple qui respecte ton intention.',
        suit.name == 'Épées' && index == 0
            ? 'assets/images/tarot_cards/arcane_mineur/As_Dépées.png'
            : '',
      ),
];

final _deck = <TarotCard>[..._arcana, ..._minorArcana];

class _MinorSuit {
  const _MinorSuit(this.name, this.symbol, this.theme);

  final String name;
  final String symbol;
  final String theme;
}

class TarotNoirHome extends StatefulWidget {
  const TarotNoirHome({super.key});

  @override
  State<TarotNoirHome> createState() => _TarotNoirHomeState();
}

class _TarotNoirHomeState extends State<TarotNoirHome> {
  static const _dailyCardKey = 'daily_card_id';
  static const _dailyDateKey = 'daily_card_date';
  static const _journalKey = 'journal_entries';

  int _tab = 0;
  String _drawType = 'daily';
  bool _hasDrawnToday = false;

  late TarotCard _card;

  final _journal = <_JournalEntry>[];

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();

    _card =
        _deck[DateTime(now.year, now.month, now.day).millisecondsSinceEpoch %
            _deck.length];
    _restoreState();
  }

  String _dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  Future<void> _restoreState() async {
    final preferences = await SharedPreferences.getInstance();
    final today = _dateKey(DateTime.now());
    final savedDate = preferences.getString(_dailyDateKey);
    final savedCardId = preferences.getString(_dailyCardKey);
    final savedCard = _cardForId(savedCardId);
    final savedJournal = preferences.getStringList(_journalKey) ?? [];

    if (!mounted) return;
    setState(() {
      if (savedDate == today && savedCard != null) {
        _card = savedCard;
        _hasDrawnToday = true;
      }
      _journal
        ..clear()
        ..addAll(
          savedJournal.map(_JournalEntry.fromJson).whereType<_JournalEntry>(),
        );
    });
  }

  TarotCard? _cardForId(String? id) {
    if (id == null) return null;
    for (final card in _deck) {
      if (card.id == id) return card;
    }
    return null;
  }

  Future<void> _persist() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_dailyCardKey, _card.id);
    await preferences.setString(_dailyDateKey, _dateKey(DateTime.now()));
    await preferences.setStringList(
      _journalKey,
      _journal.map((entry) => jsonEncode(entry.toJson())).toList(),
    );
  }

  void _draw() {
    if (_hasDrawnToday) return;
    setState(() {
      _hasDrawnToday = true;
      _drawType = 'daily';
      _journal.insert(
        0,
        _JournalEntry(
          card: _card,
          createdAt: DateTime.now(),
          drawType: 'daily',
        ),
      );
    });
    _persist();
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
          drawType: _drawType,
        ),
      );
    });
    _persist();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final pages = [
      _ReadingPage(card: _card, onDraw: _draw, hasDrawnToday: _hasDrawnToday),
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
    required this.hasDrawnToday,
  });

  final TarotCard card;
  final VoidCallback onDraw;
  final bool hasDrawnToday;

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

        if (AppConfig.premiumEnabled) _OrionPremiumInsight(card: card),

        const SizedBox(height: 28),

        // ============================================================
        // BOUTON : TIRER UNE AUTRE CARTE
        // ============================================================
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: hasDrawnToday ? null : onDraw,
            icon: const Icon(Icons.casino_outlined),
            label: Text(l10n.drawDaily),
          ),
        ),
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
            decoration: InputDecoration(
              filled: true,
              hintText: l10n.journalNoteHint,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.moodLabel(_mood),
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
            label: Text(l10n.sealNote),
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
                          [
                            entry.card.keyword,
                            l10n.drawDate(
                              DateFormat.yMd(l10n.localeName)
                                  .format(entry.createdAt),
                            ),
                            entry.drawType == 'daily'
                                ? l10n.dailyDrawType
                                : l10n.freeDrawType,
                            if (entry.note?.isNotEmpty == true) entry.note!,
                            '${entry.mood ?? 3}/5',
                          ].join(' · '),
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
        Text(l10n.comparisonIntro),
        const SizedBox(height: 10),
        Text(l10n.premiumIntro),
        const SizedBox(height: 24),
        _PlanComparisonTable(l10n: l10n),

        const SizedBox(height: 24),

        Text(l10n.extendedReadingsDetail, style: const TextStyle(height: 1.45)),
        const SizedBox(height: 10),
        Text(l10n.nftAvatarsDetail, style: const TextStyle(height: 1.45)),
        const SizedBox(height: 10),
        Text(l10n.adFreeDetail, style: const TextStyle(height: 1.45)),
        const SizedBox(height: 24),

        OutlinedButton(onPressed: null, child: Text(l10n.walletSoon)),

        const SizedBox(height: 12),

        Text(
          l10n.networkConfigured(AppConfig.solanaCluster),
          style: const TextStyle(fontSize: 12, color: Color(0xFFB9AFBE)),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.endpointLabel(AppConfig.solanaClusterUrl),
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

class _JournalEntry {
  const _JournalEntry({
    required this.card,
    required this.createdAt,
    this.drawType = 'daily',
    this.note,
    this.mood,
  });

  final TarotCard card;
  final DateTime createdAt;
  final String drawType;
  final String? note;
  final int? mood;

  Map<String, dynamic> toJson() => {
    'cardId': card.id,
    'createdAt': createdAt.toIso8601String(),
    'drawType': drawType,
    if (note != null) 'note': note,
    if (mood != null) 'mood': mood,
  };

  static _JournalEntry? fromJson(String value) {
    try {
      final json = jsonDecode(value) as Map<String, dynamic>;
      final card = _deck.firstWhere((card) => card.id == json['cardId']);
      return _JournalEntry(
        card: card,
        createdAt: DateTime.parse(json['createdAt'] as String),
        drawType: json['drawType'] as String? ?? 'daily',
        note: json['note'] as String?,
        mood: json['mood'] as int?,
      );
    } on FormatException {
      return null;
    } on StateError {
      return null;
    } on TypeError {
      return null;
    }
  }
}

class _PlanComparisonTable extends StatelessWidget {
  const _PlanComparisonTable({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) => Table(
    border: TableBorder.all(
      color: const Color(0xFF3F3449),
      borderRadius: BorderRadius.circular(12),
    ),
    columnWidths: const {
      0: FlexColumnWidth(1.25),
      1: FlexColumnWidth(),
      2: FlexColumnWidth(),
    },
    children: [
      _row(l10n.comparisonFeature, l10n.freePlan, l10n.orionPlus, header: true),
      _row(l10n.dailyCard, l10n.freeDailyReading, l10n.premiumDailyReading),
      _row(l10n.journalAccess, l10n.localNotes, l10n.linkedJournal),
    ],
  );

  TableRow _row(
    String feature,
    String free,
    String premium, {
    bool header = false,
  }) => TableRow(
    decoration: header ? const BoxDecoration(color: Color(0xFF211839)) : null,
    children: [
      _cell(feature, header),
      _cell(free, header),
      _cell(premium, header),
    ],
  );

  Widget _cell(String text, bool header) => Padding(
    padding: const EdgeInsets.all(12),
    child: Text(
      text,
      style: TextStyle(
        fontWeight: header ? FontWeight.w700 : FontWeight.w400,
        fontSize: 12,
      ),
    ),
  );
}
