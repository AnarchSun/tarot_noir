import 'dart:convert';

import 'tarot_card.dart';

class JournalEntry {
  const JournalEntry({
    required this.card,
    required this.createdAt,
    this.drawType = 'daily',
    this.note,
    this.mood,
  });

  final TarotCard card;
  final DateTime createdAt;
  final String drawType;
  final String? note;
  final int? mood;

  Map<String, dynamic> toJson() => {
    'cardId': card.id,
    'createdAt': createdAt.toIso8601String(),
    'drawType': drawType,
    if (note != null) 'note': note,
    if (mood != null) 'mood': mood,
  };

  static JournalEntry? fromJson(String value, Iterable<TarotCard> deck) {
    try {
      final json = jsonDecode(value) as Map<String, dynamic>;
      final card = deck.firstWhere((card) => card.id == json['cardId']);
      return JournalEntry(
        card: card,
        createdAt: DateTime.parse(json['createdAt'] as String),
        drawType: json['drawType'] as String? ?? 'daily',
        note: json['note'] as String?,
        mood: json['mood'] as int?,
      );
    } on FormatException {
      return null;
    } on StateError {
      return null;
    } on TypeError {
      return null;
    }
  }
}
