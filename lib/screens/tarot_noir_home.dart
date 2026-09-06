import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/journal_entry.dart';
import '../models/tarot_card.dart';
import '../models/tarot_deck.dart';
import '../services/tarot_storage_service.dart';
import 'journal_screen.dart';
import 'premium_screen.dart';
import 'reading_screen.dart';

class TarotNoirHome extends StatefulWidget {
  const TarotNoirHome({super.key});

  @override
  State<TarotNoirHome> createState() => _TarotNoirHomeState();
}

class _TarotNoirHomeState extends State<TarotNoirHome> {
  int _tab = 0;
  String _drawType = 'daily';
  bool _hasDrawnToday = false;
  late TarotCard _card;

  final _journal = <JournalEntry>[];
  final _storage = TarotStorageService();

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    _card =
        tarotDeck[DateTime(
              now.year,
              now.month,
              now.day,
            ).millisecondsSinceEpoch %
            tarotDeck.length];
    _restoreState();
  }

  Future<void> _restoreState() async {
    final snapshot = await _storage.restore(tarotDeck);
    final today = TarotStorageService.dateKey(DateTime.now());
    TarotCard? savedCard;
    for (final card in tarotDeck) {
      if (card.id == snapshot.dailyCardId) {
        savedCard = card;
        break;
      }
    }

    if (!mounted) return;
    setState(() {
      if (snapshot.dailyDate == today && savedCard != null) {
        _card = savedCard;
        _hasDrawnToday = true;
      }
      _journal
        ..clear()
        ..addAll(snapshot.journal);
    });
  }

  Future<void> _persist() => _storage.persist(
    dailyCard: _card,
    date: DateTime.now(),
    journal: _journal,
  );

  void _draw() {
    if (_hasDrawnToday) return;
    setState(() {
      _hasDrawnToday = true;
      _drawType = 'daily';
      _journal.insert(
        0,
        JournalEntry(card: _card, createdAt: DateTime.now(), drawType: 'daily'),
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
        JournalEntry(
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
      ReadingScreen(card: _card, onDraw: _draw, hasDrawnToday: _hasDrawnToday),
      JournalScreen(entries: _journal, onSave: _saveJournalEntry),
      const PremiumScreen(),
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
