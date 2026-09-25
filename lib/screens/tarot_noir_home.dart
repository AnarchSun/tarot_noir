import 'dart:math';

import 'package:flutter/material.dart';

import '../app_config.dart';
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
  bool _hasRevealedCard = false;
  bool _isRestoring = true;
  late TarotCard _card;
  CardOrientation _orientation = CardOrientation.upright;

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
    _orientation = _orientationFor(_card);
    _restoreState();
  }

  CardOrientation _orientationFor(TarotCard card) {
    if (!card.supportsReversedOrientation) return CardOrientation.upright;
    return Random().nextBool()
        ? CardOrientation.reversed
        : CardOrientation.upright;
  }

  Future<void> _restoreState() async {
    final snapshot = await _storage.restore(tarotDeck);
    TarotCard? savedCard;
    for (final card in tarotDeck) {
      if (card.id == snapshot.dailyCardId) {
        savedCard = card;
        break;
      }
    }

    if (!mounted) return;
    setState(() {
      if (TarotStorageService.isDailyDrawLocked(
            snapshot.dailyDate,
            DateTime.now(),
          ) &&
          savedCard != null &&
          AppConfig.dailyDrawLockEnabled) {
        _card = savedCard;
        _orientation = snapshot.dailyOrientation;
        _hasDrawnToday = true;
        _hasRevealedCard = true;
      }
      _isRestoring = false;
      _journal
        ..clear()
        ..addAll(snapshot.journal);
    });
  }

  Future<bool> _persist() async {
    try {
      await _storage.persist(
        dailyCard: _card,
        date: DateTime.now(),
        orientation: _orientation,
        journal: _journal,
      );
      return true;
    } catch (_) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.storageError)));
      }
      return false;
    }
  }

  Future<void> _draw() async {
    if (AppConfig.dailyDrawLockEnabled && _hasDrawnToday) return;
    final nextCard = AppConfig.dailyDrawLockEnabled
        ? _card
        : tarotDeck[Random().nextInt(tarotDeck.length)];
    final nextOrientation = _orientationFor(nextCard);
    final nextDrawType = AppConfig.dailyDrawLockEnabled ? 'daily' : 'free';
    final entry = JournalEntry(
      card: nextCard,
      orientation: nextOrientation,
      createdAt: DateTime.now(),
      drawType: nextDrawType,
    );
    setState(() {
      _card = nextCard;
      _orientation = nextOrientation;
      _hasDrawnToday = AppConfig.dailyDrawLockEnabled;
      _hasRevealedCard = true;
      _drawType = nextDrawType;
      _journal.insert(0, entry);
    });
    if (!await _persist() && mounted) {
      setState(() {
        _hasDrawnToday = false;
        _hasRevealedCard = false;
        _journal.remove(entry);
      });
    }
  }

  Future<void> _saveJournalEntry(String note, int mood) async {
    final trimmedNote = note.trim();
    if (trimmedNote.isEmpty) return;
    final index = _journal.indexWhere(
      (entry) => entry.card.id == _card.id && entry.drawType == _drawType,
    );
    setState(() {
      if (index >= 0) {
        _journal[index] = _journal[index].copyWith(
          note: trimmedNote,
          mood: mood,
        );
      } else {
        _journal.insert(
          0,
          JournalEntry(
            card: _card,
            orientation: _orientation,
            note: trimmedNote,
            mood: mood,
            createdAt: DateTime.now(),
            drawType: _drawType,
          ),
        );
      }
    });
    await _persist();
  }

  Future<void> _deleteJournalEntry(JournalEntry entry) async {
    final index = _journal.indexOf(entry);
    if (index < 0) return;
    setState(() => _journal.removeAt(index));
    if (!await _persist() && mounted) {
      setState(() => _journal.insert(index, entry));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pages = [
      ReadingScreen(
        card: _card,
        orientation: _orientation,
        onDraw: _draw,
        hasDrawn: _hasRevealedCard,
        isDailyDrawLocked: AppConfig.dailyDrawLockEnabled && _hasDrawnToday,
        isRestoring: _isRestoring,
      ),
      JournalScreen(
        entries: _journal,
        onSave: _saveJournalEntry,
        onDelete: _deleteJournalEntry,
      ),
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
