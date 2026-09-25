import 'dart:convert';

import 'tarot_card.dart';

class JournalEntry {
  const JournalEntry({
    required this.card,
    required this.createdAt,
    this.orientation = CardOrientation.upright,
    this.drawType = 'daily',
    this.note,
    this.mood,
  });

  final TarotCard card;
  final DateTime createdAt;
  final CardOrientation orientation;
  final String drawType;
  final String? note;
  final int? mood;

  String get thumbnailPath => card.imagePath;
  String get shortExplanation => card.message;

  Map<String, dynamic> toJson() => {
    'cardId': card.id,
    'thumbnailPath': thumbnailPath,
    'shortExplanation': shortExplanation,
    'createdAt': createdAt.toIso8601String(),
    'orientation': orientation.name,
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
        orientation: CardOrientation.fromStorage(json['orientation']),
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
