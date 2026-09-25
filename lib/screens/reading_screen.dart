import 'package:flutter/material.dart';

import '../app_config.dart';
import '../l10n/app_localizations.dart';
import '../models/tarot_card.dart';
import '../widgets/orion_premium_insight.dart';
import '../widgets/tarot_card_view.dart';

class ReadingScreen extends StatelessWidget {
  const ReadingScreen({
    required this.card,
    required this.orientation,
    required this.onDraw,
    required this.hasDrawnToday,
    required this.isRestoring,
    super.key,
  });

  final TarotCard card;
  final CardOrientation orientation;
  final VoidCallback onDraw;
  final bool hasDrawnToday;
  final bool isRestoring;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
      children: [
        Text(
          l10n.appTitle.toUpperCase(),
          style: const TextStyle(
            letterSpacing: 4,
            color: Color(0xFFD4AF59),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.dailyReading,
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 24),
        if (hasDrawnToday) ...[
          TarotCardView(card: card, orientation: orientation),
          const SizedBox(height: 24),
          Text(
            card.keyword,
            style: const TextStyle(
              letterSpacing: 2,
              color: Color(0xFFD4AF59),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            card.message,
            style: const TextStyle(
              fontSize: 18,
              height: 1.5,
              color: Color(0xFFE7DFEA),
            ),
          ),
          const SizedBox(height: 20),
          if (AppConfig.premiumEnabled)
            OrionPremiumInsight(card: card, orientation: orientation),
        ] else
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: const Color(0xFF171220),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF49395D)),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.auto_awesome,
                  size: 46,
                  color: Color(0xFFD4AF59),
                ),
                const SizedBox(height: 14),
                Text(
                  isRestoring ? l10n.restoringRitual : l10n.drawPrompt,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, height: 1.45),
                ),
              ],
            ),
          ),
        const SizedBox(height: 28),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: hasDrawnToday || isRestoring ? null : onDraw,
            icon: Icon(
              hasDrawnToday
                  ? Icons.lock_outline
                  : isRestoring
                  ? Icons.hourglass_top
                  : Icons.casino_outlined,
            ),
            label: Text(
              hasDrawnToday
                  ? l10n.dailyDrawLocked
                  : isRestoring
                  ? l10n.restoringRitual
                  : l10n.drawDaily,
            ),
          ),
        ),
      ],
    );
  }
}
