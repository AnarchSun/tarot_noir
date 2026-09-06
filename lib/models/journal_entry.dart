import '../data/tarot_deck.dart';
import 'tarot_card.dart';

class JournalEntry {
  const JournalEntry({
    required this.card,
    required this.createdAt,
    this.note,
    this.mood,
  });
  final TarotCard card;
  final DateTime createdAt;
  final String? note;
  final int? mood;

  Map<String, dynamic> toJson() => {
    'cardId': card.id,
    'createdAt': createdAt.toIso8601String(),
    'note': note,
    'mood': mood,
  };
  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    final card = tarotCardsById[json['cardId']];
    final mood = json['mood'] as int?;
    if (card == null || (mood != null && (mood < 1 || mood > 5))) {
      throw const FormatException('Invalid journal entry');
    }
    return JournalEntry(
      card: card,
      createdAt: DateTime.parse(json['createdAt'] as String),
      note: json['note'] as String?,
      mood: mood,
    );
  }
}
