enum CardOrientation {
  upright,
  reversed;

  bool get isReversed => this == CardOrientation.reversed;

  static CardOrientation fromStorage(Object? value) =>
      value == CardOrientation.reversed.name
      ? CardOrientation.reversed
      : CardOrientation.upright;
}

class TarotCard {
  const TarotCard(
    this.number,
    this.name,
    this.symbol,
    this.keyword,
    this.message,
    this.imagePath,
  );

  final String number;
  final String name;
  final String symbol;
  final String keyword;
  final String message;
  final String imagePath;

  bool get hasIllustration => imagePath.isNotEmpty;
  bool get supportsReversedOrientation => number.contains('-');

  String get id => '$number-$name';
  String get nameFr => name;

  @override
  String toString() {
    return 'TarotCard('
        'id: $id, '
        'nameFr: $nameFr, '
        'imagePath: $imagePath'
        ')';
  }
}
