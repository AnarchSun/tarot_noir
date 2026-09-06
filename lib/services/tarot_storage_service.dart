import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/journal_entry.dart';
import '../models/tarot_card.dart';

class TarotStorageSnapshot {
  const TarotStorageSnapshot({
    required this.dailyDate,
    required this.dailyCardId,
    required this.journal,
  });

  final String? dailyDate;
  final String? dailyCardId;
  final List<JournalEntry> journal;
}

class TarotStorageService {
  static const dailyCardKey = 'daily_card_id';
  static const dailyDateKey = 'daily_card_date';
  static const journalKey = 'journal_entries';

  Future<TarotStorageSnapshot> restore(Iterable<TarotCard> deck) async {
    final preferences = await SharedPreferences.getInstance();
    final savedJournal = preferences.getStringList(journalKey) ?? [];

    return TarotStorageSnapshot(
      dailyDate: preferences.getString(dailyDateKey),
      dailyCardId: preferences.getString(dailyCardKey),
      journal: savedJournal
          .map((value) => JournalEntry.fromJson(value, deck))
          .whereType<JournalEntry>()
          .toList(),
    );
  }

  Future<void> persist({
    required TarotCard dailyCard,
    required DateTime date,
    required Iterable<JournalEntry> journal,
  }) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(dailyCardKey, dailyCard.id);
    await preferences.setString(dailyDateKey, dateKey(date));
    await preferences.setStringList(
      journalKey,
      journal.map((entry) => jsonEncode(entry.toJson())).toList(),
    );
  }

  static String dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
