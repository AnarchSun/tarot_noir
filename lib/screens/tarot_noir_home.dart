import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../app_config.dart';
import '../l10n/app_localizations.dart';
import '../models/journal_entry.dart';
import '../models/tarot_card.dart';
import '../models/tarot_deck.dart';
import '../services/firebase_auth_service.dart';
import '../services/firestore_sync_service.dart';
import '../services/tarot_storage_service.dart';
import 'journal_screen.dart';
import 'premium_screen.dart';
import 'profile_screen.dart';
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
  bool _hasShownAdPlaceholder = false;
  User? _firebaseUser;
  String? _journalSyncUserUid;
  late TarotCard _card;
  CardOrientation _orientation = CardOrientation.upright;

  final _journal = <JournalEntry>[];
  final _storage = TarotStorageService();
  final _auth = const FirebaseAuthService();
  Future<void> _journalSyncQueue = Future<void>.value();
  late final Future<void> _restoreTask;

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
    _firebaseUser = _auth.currentUser;
    _restoreTask = _restoreState();
  }

  CardOrientation _orientationFor(TarotCard card) {
    if (!card.supportsReversedOrientation) return CardOrientation.upright;
    return Random().nextBool()
        ? CardOrientation.reversed
        : CardOrientation.upright;
  }

  Future<void> _restoreState() async {
    final snapshot = await _storage.restore(tarotDeck);
    final syncUserUid = await _storage.journalSyncUserUid();
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
      _journalSyncUserUid = syncUserUid;
      _journal
        ..clear()
        ..addAll(snapshot.journal);
    });
    final user = _firebaseUser;
    if (user != null && syncUserUid == user.uid) {
      try {
        await _synchronizeJournal(user);
      } catch (error) {
        _showJournalSyncError(error);
      }
    }
  }

  Future<bool> _persist() async {
    try {
      await _storage.persist(
        dailyCard: _card,
        date: DateTime.now(),
        orientation: _orientation,
        journal: _journal,
      );
      final user = _firebaseUser;
      if (user != null && _journalSyncUserUid == user.uid) {
        try {
          await _synchronizeJournal(user);
        } catch (error) {
          _showJournalSyncError(error);
        }
      }
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

  Future<void> _synchronizeJournal(User user) {
    final sync = _journalSyncQueue.then<void>(
      (_) => _performJournalSynchronization(user),
    );
    _journalSyncQueue = sync.then<void>((_) {}, onError: (Object _) {});
    return sync;
  }

  Future<void> _performJournalSynchronization(User user) async {
    if (_firebaseUser?.uid != user.uid) {
      throw StateError('Sign in again before synchronizing the journal.');
    }
    final deletedIds = await _storage.pendingDeletedJournalEntryIds(user.uid);
    final synchronizedJournal = await FirestoreSyncService().synchronizeJournal(
      user: user,
      localJournal: List<JournalEntry>.of(_journal),
      deletedEntryIds: deletedIds,
    );
    if (_firebaseUser?.uid != user.uid) {
      throw StateError('The signed-in account changed during synchronization.');
    }
    final pendingDeletes = await _storage.pendingDeletedJournalEntryIds(
      user.uid,
    );
    final pendingDeleteIds = pendingDeletes.toSet();
    final reconciledJournal = <String, JournalEntry>{
      for (final entry in synchronizedJournal)
        if (!pendingDeleteIds.contains(entry.syncId)) entry.syncId: entry,
      for (final entry in _journal)
        if (entry.canSyncTo(user.uid) &&
            !pendingDeleteIds.contains(entry.syncId))
          entry.syncId: entry,
    }.values.toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    await _storage.saveJournal(reconciledJournal);
    await _storage.clearDeletedJournalEntries(user.uid, deletedIds);
    if (!mounted) return;
    setState(() {
      _journal
        ..clear()
        ..addAll(reconciledJournal);
    });
  }

  Future<void> _enableJournalSync(User user) async {
    await _restoreTask;
    if (!mounted || _firebaseUser?.uid != user.uid) {
      throw StateError('Sign in again before enabling journal sync.');
    }
    await _synchronizeJournal(user);
    await _storage.setJournalSyncUser(user.uid);
    if (mounted) setState(() => _journalSyncUserUid = user.uid);
  }

  Future<void> _disableJournalSync(User user) async {
    if (_journalSyncUserUid != user.uid) return;
    await _storage.setJournalSyncUser(null);
    if (mounted) setState(() => _journalSyncUserUid = null);
  }

  void _onFirebaseUserChanged(User? user) {
    if (!mounted) return;
    setState(() => _firebaseUser = user);
    if (user != null && !_isRestoring && _journalSyncUserUid == user.uid) {
      unawaited(_synchronizeJournal(user).catchError(_showJournalSyncError));
    }
  }

  void _showJournalSyncError(Object error) {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.journalSyncFailed(error.toString()))),
    );
  }

  Future<void> _draw() async {
    if (AppConfig.dailyDrawLockEnabled && _hasDrawnToday) return;
    if (AppConfig.adPlaceholderEnabled &&
        !AppConfig.premiumEnabled &&
        !_hasShownAdPlaceholder) {
      _hasShownAdPlaceholder = true;
      final l10n = AppLocalizations.of(context)!;
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.hourglass_bottom),
          title: Text(l10n.adPlaceholderTitle),
          content: Text(l10n.adPlaceholderBody),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.continueLabel),
            ),
          ],
        ),
      );
      if (!mounted) return;
    }
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
      syncOwnerUid: _firebaseUser?.uid,
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
            syncOwnerUid: _firebaseUser?.uid,
          ),
        );
      }
    });
    await _persist();
  }

  void _onDataCleared() {
    setState(() {
      _journal.clear();
      _hasDrawnToday = false;
      _hasRevealedCard = false;
      _journalSyncUserUid = null;
    });
  }

  Future<void> _deleteJournalEntry(JournalEntry entry) async {
    final index = _journal.indexOf(entry);
    if (index < 0) return;
    final syncUser = _firebaseUser;
    final isSyncEnabled =
        syncUser != null && _journalSyncUserUid == syncUser.uid;
    if (isSyncEnabled) {
      try {
        await _storage.queueDeletedJournalEntry(syncUser.uid, entry.syncId);
      } catch (error) {
        _showJournalSyncError(error);
        return;
      }
    }
    setState(() => _journal.removeAt(index));
    if (!await _persist()) {
      if (isSyncEnabled) {
        try {
          await _storage.clearDeletedJournalEntries(syncUser.uid, [
            entry.syncId,
          ]);
        } catch (error) {
          _showJournalSyncError(error);
        }
      }
      if (mounted) {
        setState(() => _journal.insert(index, entry));
      }
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
        onClearData: _onDataCleared,
      ),
      const PremiumScreen(),
      ProfileScreen(
        onFirebaseUserChanged: _onFirebaseUserChanged,
        onEnableJournalSync: _enableJournalSync,
        onDisableJournalSync: _disableJournalSync,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: _tab, children: pages),
      ),
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
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: l10n.profile,
          ),
        ],
      ),
    );
  }
}
