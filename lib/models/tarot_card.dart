/// Modèle représentant une carte de Tarot.
///
/// Chaque carte possède :
/// - un identifiant unique,
/// - un nom français,
/// - une image associée,
/// - une signification courte optionnelle.
class TarotCard {
final String id;
final String nameFr;
final String imagePath;
final String? meaningFr;

const TarotCard({
required this.id,
required this.nameFr,
required this.imagePath,
this.meaningFr,
});

@override
String toString() {
return 'TarotCard(id: $id, nameFr: $nameFr, imagePath: $imagePath)';
}
}

