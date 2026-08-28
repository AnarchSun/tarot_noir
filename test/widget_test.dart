import 'package:flutter_test/flutter_test.dart';
import 'package:tarot_noir/main.dart';

void main() {
  testWidgets('falls back to English for an unsupported device locale', (tester) async {
    await tester.pumpWidget(const TarotNoirApp());
    expect(find.text('Daily reading'), findsOneWidget);
    expect(find.text('TAROT NOIR'), findsOneWidget);
  });
}
