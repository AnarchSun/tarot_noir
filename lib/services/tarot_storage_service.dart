import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../app_config.dart';
import '../models/journal_entry.dart';
import '../models/tarot_card.dart';
import '../models/user_profile.dart';

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
  static const orionMemoryKey = 'preference_orion_memory';
  static const personalizedGuidanceKey = 'preference_personalized_guidance';
  static const dailyReminderKey = 'preference_daily_reminder';
  static const toneKey = 'preference_orion_tone';
  static const userProfileKey = 'user_profile';
  static const journalSyncUserUidKey = 'journal_sync_user_uid';
  static const deletedJournalEntryIdsKey = 'deleted_journal_entry_ids';
  static const guestAccessAcceptedKey = 'guest_access_accepted';

  Future<void> _migrateLegacyState(
    SharedPreferences preferences,
    Iterable<TarotCard> deck,
  ) async {
    if (preferences.getInt(storageSchemaVersionKey) == storageSchemaVersion) {
      return;
    }
    final raw = preferences.getString(AppConfig.localStateKey);
    if (raw == null) return;
    try {
      final legacy = jsonDecode(raw) as Map<String, dynamic>;
      if (legacy['version'] != AppConfig.localStateVersion) return;
      final cardsByNumber = <String, TarotCard>{
        for (final card in deck) card.number: card,
      };
      final dailyCard = cardsByNumber[legacy['cardId']];
      final day = DateTime.parse(legacy['day'] as String);
      final migratedJournal = <String>[];
      for (final value in legacy['journal'] as List? ?? const []) {
        final entry = value as Map<String, dynamic>;
        final card = cardsByNumber[entry['cardId']];
        if (card == null) continue;
        migratedJournal.add(
          jsonEncode(
            JournalEntry(
              card: card,
              createdAt: DateTime.parse(entry['createdAt'] as String),
              note: entry['note'] as String?,
              mood: entry['mood'] as int?,
            ).toJson(),
          ),
        );
      }
      final oldPreferences = legacy['preferences'] as Map<String, dynamic>?;
      if (dailyCard != null) {
        await preferences.setString(dailyCardKey, dailyCard.id);
        await preferences.setString(dailyDateKey, dateKey(day));
        await preferences.setString(
          dailyOrientationKey,
          CardOrientation.upright.name,
        );
      }
      await preferences.setStringList(journalKey, migratedJournal);
      if (oldPreferences != null) {
        await preferences.setBool(
          orionMemoryKey,
          oldPreferences['orionMemory'] as bool? ?? false,
        );
        await preferences.setBool(
          personalizedGuidanceKey,
          oldPreferences['personalizedGuidance'] as bool? ?? false,
        );
        await preferences.setBool(
          dailyReminderKey,
          oldPreferences['dailyReminder'] as bool? ?? false,
        );
        const tones = <String, String>{
          'mystic': 'Mystique et direct',
          'gentle': 'Doux et contemplatif',
          'practical': 'Symbolique et concret',
        };
        await preferences.setString(
          toneKey,
          tones[oldPreferences['tone']] ?? 'Mystique et direct',
        );
      }
      await preferences.setInt(storageSchemaVersionKey, storageSchemaVersion);
      await preferences.remove(AppConfig.localStateKey);
    } on FormatException {
      return;
    } on TypeError {
      return;
    }
  }

  Future<Map<String, Object>> restorePreferences() async {
    final preferences = await SharedPreferences.getInstance();
    return <String, Object>{
      orionMemoryKey: preferences.getBool(orionMemoryKey) ?? false,
      personalizedGuidanceKey:
          preferences.getBool(personalizedGuidanceKey) ?? false,
      dailyReminderKey: preferences.getBool(dailyReminderKey) ?? false,
      toneKey: preferences.getString(toneKey) ?? 'Mystique et direct',
    };
  }

  Future<UserProfile?> restoreUserProfile() async {
    final preferences = await SharedPreferences.getInstance();
    final raw = preferences.getString(userProfileKey);
    if (raw == null) return null;
    try {
      return UserProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on FormatException {
      return null;
    } on TypeError {
      return null;
    }
  }

  Future<void> saveUserProfile(UserProfile profile) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(userProfileKey, jsonEncode(profile.toJson()));
  }

  Future<bool> isJournalSyncEnabledForUser(String uid) async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(journalSyncUserUidKey) == uid;
  }

  Future<bool> hasAcceptedGuestAccess() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(guestAccessAcceptedKey) ?? false;
  }

  Future<void> setGuestAccessAccepted(bool accepted) async {
    final preferences = await SharedPreferences.getInstance();
    if (!await preferences.setBool(guestAccessAcceptedKey, accepted)) {
      throw StateError('Could not save the guest access choice.');
    }
  }

  Future<String?> journalSyncUserUid() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(journalSyncUserUidKey);
  }

  Future<void> setJournalSyncUser(String? uid) async {
    final preferences = await SharedPreferences.getInstance();
    if (uid == null) {
      if (preferences.containsKey(journalSyncUserUidKey) &&
          !await preferences.remove(journalSyncUserUidKey)) {
        throw StateError('Could not remove journal synchronization consent.');
      }
    } else if (!await preferences.setString(journalSyncUserUidKey, uid)) {
      throw StateError('Could not save journal synchronization consent.');
    }
  }

  Future<List<String>> pendingDeletedJournalEntryIds(String uid) async {
    final preferences = await SharedPreferences.getInstance();
    return _deletedJournalEntries(preferences)[uid] ?? const [];
  }

  Future<void> queueDeletedJournalEntry(String uid, String entryId) async {
    final preferences = await SharedPreferences.getInstance();
    final entries = _deletedJournalEntries(preferences);
    final deletedIds = entries[uid] ?? <String>[];
    if (deletedIds.contains(entryId)) return;
    entries[uid] = [...deletedIds, entryId];
    if (!await preferences.setString(
      deletedJournalEntryIdsKey,
      jsonEncode(entries),
    )) {
      throw StateError('Could not save the pending journal deletion.');
    }
  }

  Future<void> clearDeletedJournalEntries(
    String uid,
    Iterable<String> entryIds,
  ) async {
    final preferences = await SharedPreferences.getInstance();
    final removed = entryIds.toSet();
    final entries = _deletedJournalEntries(preferences);
    final remaining = (entries[uid] ?? [])
        .where((id) => !removed.contains(id))
        .toList();
    if (remaining.isEmpty) {
      entries.remove(uid);
    } else {
      entries[uid] = remaining;
    }
    if (entries.isEmpty) {
      await preferences.remove(deletedJournalEntryIdsKey);
    } else {
      await preferences.setString(
        deletedJournalEntryIdsKey,
        jsonEncode(entries),
      );
    }
  }

  Map<String, List<String>> _deletedJournalEntries(
    SharedPreferences preferences,
  ) {
    final raw = preferences.getString(deletedJournalEntryIdsKey);
    if (raw == null) return {};
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Invalid journal deletion queue.');
    }
    final entries = <String, List<String>>{};
    for (final entry in decoded.entries) {
      final value = entry.value;
      if (value is! List<dynamic> || value.any((id) => id is! String)) {
        throw const FormatException('Invalid journal deletion queue.');
      }
      entries[entry.key] = value.cast<String>();
    }
    return entries;
  }

  Future<void> saveJournal(Iterable<JournalEntry> journal) async {
    final preferences = await SharedPreferences.getInstance();
    if (!await preferences.setStringList(
      journalKey,
      journal.map((entry) => jsonEncode(entry.toJson())).toList(),
    )) {
      throw StateError('Could not save the synchronized journal locally.');
    }
  }

  Future<void> saveBoolPreference(String key, bool value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(key, value);
  }

  Future<void> saveTone(String value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(toneKey, value);
  }

  Future<void> clearAll() async {
    final preferences = await SharedPreferences.getInstance();
    for (final key in <String>{
      storageSchemaVersionKey,
      dailyCardKey,
      dailyDateKey,
      dailyOrientationKey,
      journalKey,
      orionMemoryKey,
      personalizedGuidanceKey,
      dailyReminderKey,
      toneKey,
      userProfileKey,
      journalSyncUserUidKey,
      deletedJournalEntryIdsKey,
      guestAccessAcceptedKey,
    }) {
      if (preferences.containsKey(key) && !await preferences.remove(key)) {
        throw StateError('Could not erase local Tarot Noir data.');
      }
    }
  }

  Future<TarotStorageSnapshot> restore(Iterable<TarotCard> deck) async {
    final preferences = await SharedPreferences.getInstance();
    await _migrateLegacyState(preferences, deck);
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
    await _saveDailyDraw(preferences, dailyCard, date, orientation);
    await _saveJournal(preferences, journal);
  }

  Future<void> saveDailyDraw({
    required TarotCard card,
    required DateTime date,
    required CardOrientation orientation,
  }) async {
    final preferences = await SharedPreferences.getInstance();
    await _saveDailyDraw(preferences, card, date, orientation);
  }

  Future<void> saveJournalOnly(Iterable<JournalEntry> journal) async {
    final preferences = await SharedPreferences.getInstance();
    await _saveJournal(preferences, journal);
  }

  Future<void> _saveDailyDraw(
    SharedPreferences preferences,
    TarotCard card,
    DateTime date,
    CardOrientation orientation,
  ) async {
    if (!await preferences.setInt(
      storageSchemaVersionKey,
      storageSchemaVersion,
    )) {
      throw StateError('Could not update the local storage version.');
    }
    if (!await preferences.setString(dailyCardKey, card.id) ||
        !await preferences.setString(dailyDateKey, dateKey(date)) ||
        !await preferences.setString(dailyOrientationKey, orientation.name)) {
      throw StateError('Could not save the daily card.');
    }
  }

  Future<void> _saveJournal(
    SharedPreferences preferences,
    Iterable<JournalEntry> journal,
  ) async {
    if (!await preferences.setStringList(
      journalKey,
      journal.map((entry) => jsonEncode(entry.toJson())).toList(),
    )) {
      throw StateError('Could not save the local journal.');
    }
  }

  static bool isDailyDrawLocked(String? savedDate, DateTime now) =>
      savedDate != null && savedDate.compareTo(dateKey(now)) >= 0;

  static String dateKey(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
