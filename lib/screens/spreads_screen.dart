import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/spread.dart';
import '../models/tarot_card.dart';
import '../models/tarot_card_text.dart';
import '../widgets/tarot_card_view.dart';

class DrawnSpreadCard {
  const DrawnSpreadCard(this.card, this.orientation);

  final TarotCard card;
  final CardOrientation orientation;
}

class SpreadsScreen extends StatelessWidget {
  const SpreadsScreen({
    required this.isPremiumUnlocked,
    required this.onDraw,
    required this.onOpenPremium,
    super.key,
  });

  final bool isPremiumUnlocked;
  final Future<void> Function(SpreadDefinition spread) onDraw;
  final VoidCallback onOpenPremium;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lang = l10n.localeName;
    return ListView(
      key: const Key('spreads-screen'),
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          l10n.spreads,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(l10n.spreadsIntro, style: const TextStyle(height: 1.4)),
        const SizedBox(height: 16),
        for (final spread in spreadCatalog)
          _SpreadTile(
            key: Key('spread-${spread.id}'),
            text: spreadText(spread, lang),
            cardCount: spread.cardCount,
            isFree: spread.isFree,
            isLocked: !spread.isFree && !isPremiumUnlocked,
            onTap: () {
              if (!spread.isFree && !isPremiumUnlocked) {
                onOpenPremium();
              } else {
                onDraw(spread);
              }
            },
          ),
      ],
    );
  }
}

class _SpreadTile extends StatelessWidget {
  const _SpreadTile({
    required this.text,
    required this.cardCount,
    required this.isFree,
    required this.isLocked,
    required this.onTap,
    super.key,
  });

  final SpreadText text;
  final int cardCount;
  final bool isFree;
  final bool isLocked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const gold = Color(0xFFD4AF59);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: const Color(0xFF171220),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: gold.withValues(alpha: isLocked ? .25 : .6)),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  isLocked ? Icons.lock_outline : Icons.auto_awesome,
                  color: isLocked ? const Color(0xFFB9AFBE) : gold,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text.title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        text.description,
                        style: const TextStyle(
                          height: 1.35,
                          color: Color(0xFFCFC6D4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${l10n.spreadCardCount(cardCount)} · '
                        '${isFree ? l10n.spreadFreeBadge : l10n.spreadPremiumBadge}',
                        style: const TextStyle(
                          color: gold,
                          fontSize: 12,
                          letterSpacing: .6,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SpreadResultScreen extends StatelessWidget {
  const SpreadResultScreen({
    required this.spread,
    required this.cards,
    super.key,
  });

  final SpreadDefinition spread;
  final List<DrawnSpreadCard> cards;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lang = l10n.localeName;
    final text = spreadText(spread, lang);
    return Scaffold(
      appBar: AppBar(title: Text(text.title)),
      body: SafeArea(
        child: ListView(
          key: const Key('spread-result'),
          padding: const EdgeInsets.all(20),
          children: [
            for (var i = 0; i < cards.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 110,
                      child: TarotCardView(
                        card: cards[i].card,
                        orientation: cards[i].orientation,
                        height: 180,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${i + 1}. ${text.positions[i].toUpperCase()}',
                            style: const TextStyle(
                              color: Color(0xFFD4AF59),
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            cards[i].card.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            cards[i].card.localizedMessage(lang),
                            style: const TextStyle(height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            Text(
              l10n.spreadSavedToJournal,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFFB9AFBE)),
            ),
          ],
        ),
      ),
    );
  }
}
