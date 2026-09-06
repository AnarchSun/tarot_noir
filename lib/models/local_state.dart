import '../app_config.dart';
import '../data/tarot_deck.dart';
import '../services/reading_policy.dart';
import 'journal_entry.dart';
import 'tarot_card.dart';
import 'user_preferences.dart';

class LocalState {
  LocalState({
    required this.day,
    required this.card,
    this.preferences = const UserPreferences(),
    List<JournalEntry> journal = const [],
  }) : journal = List.unmodifiable(journal);
  final DateTime day;
  final TarotCard card;
  final UserPreferences preferences;
  final List<JournalEntry> journal;

  factory LocalState.initial(DateTime now) => LocalState(
    day: calendarDay(now),
    card: tarotDeck[dailyCardIndex(now, tarotDeck.length)],
  );

  LocalState copyWith({
    DateTime? day,
    TarotCard? card,
    UserPreferences? preferences,
    List<JournalEntry>? journal,
  }) => LocalState(
    day: day ?? this.day,
    card: card ?? this.card,
    preferences: preferences ?? this.preferences,
    journal: journal ?? this.journal,
  );

  LocalState forDate(DateTime now) {
    final today = calendarDay(now);
    // A clock rollback must not issue another daily card.
    if (!today.isAfter(day)) return this;
    return copyWith(
      day: today,
      card: tarotDeck[dailyCardIndex(today, tarotDeck.length)],
    );
  }

  Map<String, dynamic> toJson() => {
    'version': AppConfig.localStateVersion,
    'day': day.toIso8601String(),
    'cardId': card.id,
    'preferences': preferences.toJson(),
    'journal': journal.map((entry) => entry.toJson()).toList(),
  };

  factory LocalState.fromJson(Map<String, dynamic> json) {
    if (json['version'] != AppConfig.localStateVersion) {
      throw const FormatException('Unsupported local state version');
    }
    final card = tarotCardsById[json['cardId']];
    if (card == null) throw const FormatException('Unknown card');
    final day = DateTime.parse(json['day'] as String);
    if (day != calendarDay(day)) throw const FormatException('Invalid day');
    return LocalState(
      day: day,
      card: card,
      preferences: UserPreferences.fromJson(
        json['preferences'] as Map<String, dynamic>,
      ),
      journal: (json['journal'] as List)
          .map((entry) => JournalEntry.fromJson(entry as Map<String, dynamic>))
          .toList(),
    );
  }
}
