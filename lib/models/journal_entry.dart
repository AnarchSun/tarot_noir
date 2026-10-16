import 'dart:convert';

import 'tarot_card.dart';

class OrionQa {
  const OrionQa({
    required this.question,
    required this.answer,
    required this.createdAt,
  });

  final String question;
  final String answer;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
    'question': question,
    'answer': answer,
    'createdAt': createdAt.toIso8601String(),
  };

  static OrionQa? fromJson(Object? value) {
    if (value is! Map) return null;
    final question = value['question'];
    final answer = value['answer'];
    final createdAt = DateTime.tryParse('${value['createdAt']}');
    if (question is! String || answer is! String || createdAt == null) {
      return null;
    }
    return OrionQa(question: question, answer: answer, createdAt: createdAt);
  }
}

class JournalEntry {
  const JournalEntry({
    required this.card,
    required this.createdAt,
    this.orientation = CardOrientation.upright,
    this.drawType = 'daily',
    this.note,
    this.mood,
    this.syncOwnerUid,
    this.orionQa = const [],
  });

  final TarotCard card;
  final DateTime createdAt;
  final CardOrientation orientation;
  final String drawType;
  final String? note;
  final int? mood;
  final String? syncOwnerUid;
  final List<OrionQa> orionQa;

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
    List<OrionQa>? orionQa,
  }) => JournalEntry(
    card: card,
    createdAt: createdAt,
    orientation: orientation,
    drawType: drawType,
    note: clearNote ? null : (note ?? this.note),
    mood: mood ?? this.mood,
    syncOwnerUid: syncOwnerUid ?? this.syncOwnerUid,
    orionQa: orionQa ?? this.orionQa,
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
    if (orionQa.isNotEmpty) 'orionQa': [for (final q in orionQa) q.toJson()],
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
        orionQa: [
          for (final raw in (json['orionQa'] as List? ?? const []))
            ?OrionQa.fromJson(raw),
        ],
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
