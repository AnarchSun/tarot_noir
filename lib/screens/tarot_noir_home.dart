import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../app_config.dart';
import '../l10n/app_localizations.dart';
import '../models/journal_entry.dart';
import '../models/tarot_card.dart';
import '../models/tarot_deck.dart';
import '../services/firebase_auth_service.dart';
import '../services/firestore_sync_service.dart';
import '../services/tarot_storage_service.dart';
import '../widgets/account_access_sheet.dart';
import 'journal_screen.dart';
import 'premium_screen.dart';
import 'profile_screen.dart';
import 'reading_screen.dart';

class TarotNoirHome extends StatefulWidget {
  const TarotNoirHome({this.initialUser, super.key});

  final User? initialUser;

  @override
  State<TarotNoirHome> createState() => _TarotNoirHomeState();
}

class _TarotNoirHomeState extends State<TarotNoirHome> {
  int _tab = 0;
  String _drawType = 'daily';
  bool _hasChosenAccess = false;
  bool _isRestoring = true;
  bool _isDailyDrawing = false;
  bool _isSigningIn = false;
  bool _isFacebookSigningIn = false;
  bool _hasShownFreeAdPlaceholder = false;
  User? _firebaseUser;
  String? _journalSyncUserUid;
  Object? _authInitializationError;
  late TarotCard _dailyCard;
  late TarotCard _startupPreviewCard;
  bool _hasDrawnToday = false;
  TarotCard? _freeCard;
  late TarotCard _card;
  CardOrientation _dailyOrientation = CardOrientation.upright;
  CardOrientation _freeOrientation = CardOrientation.upright;
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
    _dailyCard = _cardForDate(now);
    _startupPreviewCard = tarotDeck[Random().nextInt(tarotDeck.length)];
    _card = _dailyCard;
    _firebaseUser =
        widget.initialUser ??
        (FirebaseAuthService.isInitialized ? _auth.currentUser : null);
    _hasChosenAccess = _firebaseUser != null;
    _restoreTask = _initializeAndRestore();
  }

  TarotCard _cardForDate(DateTime date) {
    final day = DateTime.utc(date.year, date.month, date.day);
    return tarotDeck[day.millisecondsSinceEpoch % tarotDeck.length];
  }

  CardOrientation _orientationFor(TarotCard card) {
    if (!card.supportsReversedOrientation) return CardOrientation.upright;
    return Random().nextBool()
        ? CardOrientation.reversed
        : CardOrientation.upright;
  }

  Future<void> _initializeAndRestore() async {
    try {
      await FirebaseAuthService.initialize();
      _firebaseUser = widget.initialUser ?? _auth.currentUser;
    } catch (error) {
      _authInitializationError = error;
    }
    await _restoreState();
    final error = _authInitializationError;
    if (error != null && mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.authenticationStartupFailed(error.toString())),
        ),
      );
    }
  }

  Future<void> _restoreState() async {
    try {
      final snapshot = await _storage.restore(tarotDeck);
      final syncUserUid = await _storage.journalSyncUserUid();
      final hasAcceptedGuestAccess = await _storage.hasAcceptedGuestAccess();
      final now = DateTime.now();
      TarotCard? savedCard;
      for (final card in tarotDeck) {
        if (card.id == snapshot.dailyCardId) {
          savedCard = card;
          break;
        }
      }
      final hasDrawnToday =
          TarotStorageService.isDailyDrawLocked(snapshot.dailyDate, now) &&
          savedCard != null;
      final dailyCard = hasDrawnToday ? savedCard : _cardForDate(now);
      JournalEntry? latestFreeEntry;
      for (final entry in snapshot.journal) {
        if (entry.drawType == 'free' &&
            (latestFreeEntry == null ||
                entry.createdAt.isAfter(latestFreeEntry.createdAt))) {
          latestFreeEntry = entry;
        }
      }
      final restoredJournal = List<JournalEntry>.of(snapshot.journal);

      if (!mounted) return;
      setState(() {
        _dailyCard = dailyCard;
        _hasDrawnToday = hasDrawnToday;
        _dailyOrientation = hasDrawnToday
            ? snapshot.dailyOrientation
            : CardOrientation.upright;
        _freeCard = latestFreeEntry?.card;
        _freeOrientation =
            latestFreeEntry?.orientation ?? CardOrientation.upright;
        _card = latestFreeEntry?.card ?? dailyCard;
        _orientation = latestFreeEntry?.orientation ?? _dailyOrientation;
        _drawType = latestFreeEntry?.drawType ?? 'daily';
        _hasChosenAccess = _firebaseUser != null || hasAcceptedGuestAccess;
        _isRestoring = false;
        _journalSyncUserUid = syncUserUid;
        _journal
          ..clear()
          ..addAll(restoredJournal);
      });

      final user = _firebaseUser;
      if (user != null && syncUserUid == user.uid) {
        try {
          await _synchronizeJournal(user);
        } catch (error) {
          _showJournalSyncError(error);
        }
      }
    } catch (error) {
      if (!mounted) return;
      setState(() => _isRestoring = false);
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.storageOperationFailed(error.toString()))),
      );
    }
  }

  Future<bool> _persist() async {
    try {
      await _storage.saveJournalOnly(_journal);
      if (_hasDrawnToday) {
        await _storage.saveDailyDraw(
          card: _dailyCard,
          date: DateTime.now(),
          orientation: _dailyOrientation,
        );
      }
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

  Future<void> _onFirebaseUserChanged(User? user) async {
    if (!mounted) return;
    setState(() {
      _firebaseUser = user;
      _hasChosenAccess = true;
      _tab = user == null ? 0 : 3;
    });
    if (user == null) {
      try {
        await _storage.setGuestAccessAccepted(true);
      } catch (error) {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.storageOperationFailed(error.toString())),
            ),
          );
        }
      }
      return;
    }
    if (!_isRestoring && _journalSyncUserUid == user.uid) {
      unawaited(_synchronizeJournal(user).catchError(_showJournalSyncError));
    }
  }

  Future<void> _continueAsGuest() async {
    try {
      await _storage.setGuestAccessAccepted(true);
      if (mounted) setState(() => _hasChosenAccess = true);
    } catch (error) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.storageOperationFailed(error.toString()))),
      );
    }
  }

  Future<void> _signInWithGoogle() async {
    final l10n = AppLocalizations.of(context)!;
    if (!AppConfig.isFirebaseAuthConfigured ||
        !FirebaseAuthService.isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.firebaseConfigurationRequired)),
      );
      return;
    }
    if (_isSigningIn) return;
    setState(() => _isSigningIn = true);
    try {
      final user = await _auth.signInWithGoogle();
      if (user != null) await _onFirebaseUserChanged(user);
    } on FirebaseAuthException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.message ?? error.code)));
      }
    } on GoogleSignInException catch (error) {
      if (mounted && error.code != GoogleSignInExceptionCode.canceled) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.description ?? error.code.name)),
        );
      }
    } finally {
      if (mounted) setState(() => _isSigningIn = false);
    }
  }

  Future<void> _signInWithFacebook() async {
    final l10n = AppLocalizations.of(context)!;
    if (!AppConfig.isFacebookAuthConfigured ||
        !FirebaseAuthService.isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.facebookConfigurationRequired)),
      );
      return;
    }
    if (_isFacebookSigningIn) return;
    setState(() => _isFacebookSigningIn = true);
    try {
      final user = await _auth.signInWithFacebook();
      if (user != null) await _onFirebaseUserChanged(user);
    } on FirebaseAuthException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.message ?? error.code)));
      }
    } on PlatformException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message ?? l10n.facebookConfigurationRequired),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isFacebookSigningIn = false);
    }
  }

  Future<void> _showAccountGate(String destination) async {
    final l10n = AppLocalizations.of(context)!;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) => AccountAccessSheet(
        destination: destination,
        showFacebook: AppConfig.facebookSignInVisible,
        onGoogleSignIn: () {
          Navigator.of(sheetContext).pop();
          unawaited(_signInWithGoogle());
        },
        onFacebookSignIn: () {
          Navigator.of(sheetContext).pop();
          unawaited(_signInWithFacebook());
        },
        onExplorePremium: () {
          Navigator.of(sheetContext).pop();
          if (mounted) setState(() => _tab = 2);
        },
        l10n: l10n,
      ),
    );
  }

  void _openProfile() {
    if (_firebaseUser == null) {
      unawaited(_showAccountGate(AppLocalizations.of(context)!.profile));
      return;
    }
    setState(() => _tab = 3);
  }

  void _showJournalSyncError(Object error) {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.journalSyncFailed(error.toString()))),
    );
  }

  Future<bool> _showAdPlaceholder() async {
    if (!AppConfig.adPlaceholderEnabled || AppConfig.premiumEnabled) {
      return true;
    }
    final l10n = AppLocalizations.of(context)!;
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            icon: const Icon(Icons.hourglass_bottom),
            title: Text(l10n.adPlaceholderTitle),
            content: Text(l10n.adPlaceholderBody),
            actions: [
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(l10n.continueLabel),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _drawDaily() async {
    if (_isDailyDrawing || _hasDrawnToday || _isRestoring) return;
    setState(() => _isDailyDrawing = true);
    try {
      if (!await _showAdPlaceholder() || !mounted) return;
      final orientation = _orientationFor(_dailyCard);
      final entry = JournalEntry(
        card: _dailyCard,
        orientation: orientation,
        createdAt: DateTime.now(),
        drawType: 'daily',
        syncOwnerUid: _firebaseUser?.uid,
      );
      setState(() {
        _hasDrawnToday = true;
        _dailyOrientation = orientation;
        _card = _dailyCard;
        _orientation = orientation;
        _drawType = 'daily';
        _journal.insert(0, entry);
      });
      if (!await _persist() && mounted) {
        setState(() {
          _hasDrawnToday = false;
          _dailyOrientation = CardOrientation.upright;
          _card = _freeCard ?? _dailyCard;
          _orientation = _freeCard == null
              ? CardOrientation.upright
              : _freeOrientation;
          _drawType = _freeCard == null ? 'daily' : 'free';
          _journal.remove(entry);
        });
      }
    } finally {
      if (mounted) setState(() => _isDailyDrawing = false);
    }
  }

  Future<void> _draw() async {
    if (!_hasShownFreeAdPlaceholder &&
        AppConfig.adPlaceholderEnabled &&
        !AppConfig.premiumEnabled) {
      if (!await _showAdPlaceholder()) return;
      _hasShownFreeAdPlaceholder = true;
      if (!mounted) return;
    }
    final nextCard = tarotDeck[Random().nextInt(tarotDeck.length)];
    final nextOrientation = _orientationFor(nextCard);
    const nextDrawType = 'free';
    final entry = JournalEntry(
      card: nextCard,
      orientation: nextOrientation,
      createdAt: DateTime.now(),
      drawType: nextDrawType,
      syncOwnerUid: _firebaseUser?.uid,
    );
    setState(() {
      _freeCard = nextCard;
      _freeOrientation = nextOrientation;
      _card = nextCard;
      _orientation = nextOrientation;
      _drawType = nextDrawType;
      _journal.insert(0, entry);
    });
    if (!await _persist() && mounted) {
      setState(() {
        _freeCard = null;
        _freeOrientation = CardOrientation.upright;
        _card = _dailyCard;
        _orientation = _dailyOrientation;
        _drawType = 'daily';
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
      _freeCard = null;
      _hasDrawnToday = false;
      _dailyCard = _cardForDate(DateTime.now());
      _dailyOrientation = CardOrientation.upright;
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
    final isSignedIn = _firebaseUser != null;
    final pages = <Widget>[
      ReadingScreen(
        dailyCard: _dailyCard,
        dailyOrientation: _dailyOrientation,
        hasDrawnToday: _hasDrawnToday,
        freeCard: _freeCard,
        freeOrientation: _freeOrientation,
        onDrawDaily: _drawDaily,
        onDrawFree: _draw,
        isRestoring: _isRestoring,
        showAccessChoices: !_hasChosenAccess && !isSignedIn,
        startupPreviewCard: _startupPreviewCard,
        isDailyDrawing: _isDailyDrawing,
        isSigningIn: _isSigningIn,
        isFacebookSigningIn: _isFacebookSigningIn,
        onGoogleSignIn: _signInWithGoogle,
        onFacebookSignIn: _signInWithFacebook,
        onContinueAsGuest: _continueAsGuest,
      ),
      if (isSignedIn)
        JournalScreen(
          entries: _journal,
          onSave: _saveJournalEntry,
          onDelete: _deleteJournalEntry,
          onClearData: _onDataCleared,
        )
      else
        const SizedBox.shrink(),
      PremiumScreen(onOpenProfile: _openProfile),
      if (isSignedIn)
        ProfileScreen(
          initialUser: _firebaseUser!,
          isSelected: _tab == 3,
          onFirebaseUserChanged: _onFirebaseUserChanged,
          onEnableJournalSync: _enableJournalSync,
          onDisableJournalSync: _disableJournalSync,
        )
      else
        const SizedBox.shrink(),
    ];
    final destinations = <NavigationDestination>[
      NavigationDestination(
        icon: const Icon(Icons.auto_awesome_outlined),
        selectedIcon: const Icon(Icons.auto_awesome),
        label: l10n.reading,
      ),
    ];
    destinations.add(
      NavigationDestination(
        key: const Key('journal'),
        icon: const Icon(Icons.menu_book_outlined),
        selectedIcon: const Icon(Icons.menu_book),
        label: l10n.journal,
      ),
    );
    destinations.add(
      NavigationDestination(
        icon: const Icon(Icons.workspace_premium_outlined),
        selectedIcon: const Icon(Icons.workspace_premium),
        label: l10n.premium,
      ),
    );
    destinations.add(
      NavigationDestination(
        icon: const Icon(Icons.person_outline),
        selectedIcon: const Icon(Icons.person),
        label: l10n.profile,
      ),
    );
    final selectedIndex = _tab.clamp(0, destinations.length - 1);

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: selectedIndex, children: pages),
      ),
      bottomNavigationBar: !_isRestoring && _hasChosenAccess
          ? NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) {
                if (!isSignedIn && (index == 1 || index == 3)) {
                  unawaited(
                    _showAccountGate(index == 1 ? l10n.journal : l10n.profile),
                  );
                  return;
                }
                setState(() => _tab = index);
              },
              destinations: destinations,
            )
          : null,
    );
  }
}
