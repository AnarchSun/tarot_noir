/// Modèle représentant une carte de Tarot.
///
/// Chaque carte possède :
/// - un identifiant unique,
/// - un nom français,
/// - une image associée,
/// - une signification courte optionnelle.
/// Modèle représentant une carte du Tarot.
class TarotCard {
  const TarotCard({
    required this.number,
    required this.id,
    required this.nameFr,
    required this.symbol,
    required this.keyword,
    required this.message,
    required this.imagePath,
  });

  final String number;
  final String id;
  final String nameFr;
  final String symbol;
  final String keyword;
  final String message;
  final String imagePath;

  @override
  String toString() {
    return 'TarotCard('
        'id: $id, '
        'nameFr: $nameFr, '
        'imagePath: $imagePath'
        ')';
  }
}