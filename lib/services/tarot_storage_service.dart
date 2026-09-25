import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/journal_entry.dart';
import '../models/tarot_card.dart';

class TarotStorageSnapshot {
  const TarotStorageSnapshot({
    required this.dailyDate,
    required this.dailyCardId,
    required this.dailyOrientation,
    required this.journal,
  });

  final String? dailyDate;
  final String? dailyCardId;
  final CardOrientation dailyOrientation;
  final List<JournalEntry> journal;
}

class TarotStorageService {
  static const storageSchemaVersion = 2;
  static const storageSchemaVersionKey = 'tarot_storage_schema_version';
  static const dailyCardKey = 'daily_card_id';
  static const dailyDateKey = 'daily_card_date';
  static const dailyOrientationKey = 'daily_card_orientation';
  static const journalKey = 'journal_entries';

  Future<TarotStorageSnapshot> restore(Iterable<TarotCard> deck) async {
    final preferences = await SharedPreferences.getInstance();
    final savedJournal = preferences.getStringList(journalKey) ?? [];
    final hasCurrentSchema =
        preferences.getInt(storageSchemaVersionKey) == storageSchemaVersion;

    return TarotStorageSnapshot(
      dailyDate: hasCurrentSchema ? preferences.getString(dailyDateKey) : null,
      dailyCardId: hasCurrentSchema
          ? preferences.getString(dailyCardKey)
          : null,
      dailyOrientation: CardOrientation.fromStorage(
        preferences.getString(dailyOrientationKey),
      ),
      journal: savedJournal
          .map((value) => JournalEntry.fromJson(value, deck))
          .whereType<JournalEntry>()
          .toList(),
    );
  }

  Future<void> persist({
    required TarotCard dailyCard,
    required DateTime date,
    required CardOrientation orientation,
    required Iterable<JournalEntry> journal,
  }) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt(storageSchemaVersionKey, storageSchemaVersion);
    await preferences.setString(dailyCardKey, dailyCard.id);
    await preferences.setString(dailyDateKey, dateKey(date));
    await preferences.setString(dailyOrientationKey, orientation.name);
    await preferences.setStringList(
      journalKey,
      journal.map((entry) => jsonEncode(entry.toJson())).toList(),
    );
  }

  static bool isDailyDrawLocked(String? savedDate, DateTime now) =>
      savedDate != null && savedDate.compareTo(dateKey(now)) >= 0;

  static String dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
