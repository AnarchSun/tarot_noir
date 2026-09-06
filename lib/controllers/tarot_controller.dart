import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../data/tarot_deck.dart';
import '../models/journal_entry.dart';
import '../models/local_state.dart';
import '../models/user_preferences.dart';
import '../repositories/local_repository.dart';
import '../services/reading_policy.dart';

class TarotController extends ChangeNotifier {
  TarotController({
    required this.repository,
    this.policy = const ReadingPolicy(),
    DateTime Function()? clock,
    Random? random,
  }) : clock = clock ?? DateTime.now,
       _random = random ?? Random();

  final LocalRepository repository;
  final ReadingPolicy policy;
  final DateTime Function() clock;
  final Random _random;
  LocalState? _state;
  LocalState get state => _state!;
  bool get ready => _state != null;
  bool busy = false;
  bool storageError = false;
  bool _disposed = false;
  bool _refreshQueued = false;

  void _emit() {
    if (!_disposed) notifyListeners();
  }

  Future<bool> initialize() async {
    if (busy || ready) return ready;
    busy = true;
    storageError = false;
    _emit();
    try {
      final saved = await repository.load();
      final next = (saved ?? LocalState.initial(clock())).forDate(clock());
      await repository.save(next);
      _state = next;
      return true;
    } catch (_) {
      storageError = true;
      return false;
    } finally {
      _finishOperation();
    }
  }

  // One write at a time. Publish state only after the storage operation succeeds.
  Future<bool> _commit(LocalState next) async {
    if (busy || !ready) return false;
    busy = true;
    storageError = false;
    _emit();
    try {
      await repository.save(next);
      _state = next;
      return true;
    } catch (_) {
      storageError = true;
      return false;
    } finally {
      _finishOperation();
    }
  }

  void _finishOperation() {
    busy = false;
    _emit();
    if (_refreshQueued && !_disposed) {
      _refreshQueued = false;
      unawaited(refreshDay());
    }
  }

  void dismissStorageError() {
    storageError = false;
    _emit();
  }

  Future<bool> refreshDay() async {
    if (busy) {
      _refreshQueued = true;
      return false;
    }
    if (!ready) return false;
    final next = state.forDate(clock());
    if (identical(next, state)) return true;
    return _commit(next);
  }

  Future<bool> draw() async {
    if (!ready || busy || !policy.canRedraw) return false;
    final now = clock();
    final next = state.forDate(now);
    final card = tarotDeck[_random.nextInt(tarotDeck.length)];
    return _commit(
      next.copyWith(
        card: card,
        journal: [
          JournalEntry(card: card, createdAt: now),
          ...next.journal,
        ],
      ),
    );
  }

  Future<bool> saveNote(String note, int mood) async {
    if (!ready || busy || note.trim().isEmpty || mood < 1 || mood > 5) {
      return false;
    }
    final now = clock();
    final next = state.forDate(now);
    return _commit(
      next.copyWith(
        journal: [
          JournalEntry(
            card: next.card,
            createdAt: now,
            note: note.trim(),
            mood: mood,
          ),
          ...next.journal,
        ],
      ),
    );
  }

  Future<bool> updatePreferences(UserPreferences preferences) async {
    if (!ready || busy) return false;
    return _commit(state.copyWith(preferences: preferences));
  }

  /// Remove personal content, retaining the daily card to preserve the free limit.
  Future<bool> erasePersonalData() async {
    if (!ready || busy) return false;
    return _commit(
      state.copyWith(preferences: const UserPreferences(), journal: []),
    );
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
