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
    this.syncOwnerUid,
  });

  final TarotCard card;
  final DateTime createdAt;
  final CardOrientation orientation;
  final String drawType;
  final String? note;
  final int? mood;
  final String? syncOwnerUid;

  String get thumbnailPath => card.imagePath;
  String get shortExplanation => card.message;
  bool canSyncTo(String uid) => syncOwnerUid == null || syncOwnerUid == uid;
  String get syncId => base64Url
      .encode(
        utf8.encode(
          '${createdAt.toUtc().toIso8601String()}|${card.id}|$drawType',
        ),
      )
      .replaceAll('=', '');

  JournalEntry copyWith({
    String? note,
    bool clearNote = false,
    int? mood,
    String? syncOwnerUid,
  }) => JournalEntry(
    card: card,
    createdAt: createdAt,
    orientation: orientation,
    drawType: drawType,
    note: clearNote ? null : (note ?? this.note),
    mood: mood ?? this.mood,
    syncOwnerUid: syncOwnerUid ?? this.syncOwnerUid,
  );

  Map<String, dynamic> toJson() => {
    'cardId': card.id,
    'thumbnailPath': thumbnailPath,
    'shortExplanation': shortExplanation,
    'createdAt': createdAt.toIso8601String(),
    'orientation': orientation.name,
    'drawType': drawType,
    if (note != null) 'note': note,
    if (mood != null) 'mood': mood,
    if (syncOwnerUid != null) 'syncOwnerUid': syncOwnerUid,
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
        syncOwnerUid: json['syncOwnerUid'] as String?,
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
