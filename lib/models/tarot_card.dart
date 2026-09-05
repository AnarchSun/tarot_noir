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
