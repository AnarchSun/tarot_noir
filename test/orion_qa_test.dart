import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tarot_noir/l10n/app_localizations.dart';
import 'package:tarot_noir/models/journal_entry.dart';
import 'package:tarot_noir/models/orion_answer.dart';
import 'package:tarot_noir/models/tarot_card.dart';
import 'package:tarot_noir/models/tarot_deck.dart';
import 'package:tarot_noir/widgets/orion_ask_panel.dart';

void main() {
  test('journal entries keep Orion questions and answers', () {
    final qa = OrionQa(
      question: 'Mon travail ?',
      answer: 'Réponse',
      createdAt: DateTime(2026, 1, 2, 3),
    );
    final entry = JournalEntry(
      card: tarotDeck.first,
      createdAt: DateTime(2026, 1, 2),
    ).copyWith(orionQa: [qa]);
    final back = JournalEntry.fromJson(jsonEncode(entry.toJson()), tarotDeck)!;
    expect(back.orionQa.single.question, 'Mon travail ?');
    expect(back.orionQa.single.answer, 'Réponse');
    expect(back.syncId, entry.syncId);
  });

  test('answers adapt to the question topic', () {
    expect(
      OrionAnswerCatalog.topicOf('Mon amour me quittera-t-il ?'),
      OrionTopic.love,
    );
    expect(OrionAnswerCatalog.topicOf('Mon travail'), OrionTopic.work);
    expect(OrionAnswerCatalog.topicOf('bla'), OrionTopic.general);
  });

  testWidgets('ask panel needs the ad, then saves the answer', (tester) async {
    var ads = 0;
    final saved = <OrionQa>[];
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: OrionAskPanel(
              requiresAd: true,
              onRequestAd: () async {
                ads++;
                return true;
              },
              onSaved: (qa) async => saved.add(qa),
              cards: [
                OrionQuestionCard(
                  card: tarotDeck.first,
                  orientation: CardOrientation.upright,
                  position: 'Today',
                ),
              ],
            ),
          ),
        ),
      ),
    );
    expect(find.byKey(const Key('spread-ai-question')), findsNothing);
    await tester.tap(find.byKey(const Key('orion-ask-unlock')));
    await tester.pumpAndSettle();
    expect(ads, 1);
    await tester.enterText(
      find.byKey(const Key('spread-ai-question')),
      'My work?',
    );
    await tester.tap(find.byKey(const Key('spread-ai-ask')));
    await tester.pumpAndSettle();
    expect(saved.single.question, 'My work?');
    expect(find.byKey(const Key('spread-ai-answer')), findsOneWidget);
  });
}
