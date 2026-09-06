import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/tarot_card.dart';

class ReadingPage extends StatelessWidget {
  const ReadingPage({
    super.key,
    required this.card,
    required this.onDraw,
    required this.premium,
    required this.busy,
  });

  final TarotCard card;
  final VoidCallback onDraw;
  final bool premium;
  final bool busy;

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

        // IMAGE DE LA CARTE
        _TarotCardView(card: card),

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

        if (premium) _OrionPremiumInsight(card: card),

        const SizedBox(height: 28),

        // ============================================================
        // BOUTON : TIRER UNE AUTRE CARTE
        // ============================================================
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: premium && !busy ? onDraw : null,
            icon: const Icon(Icons.casino_outlined),
            label: Text(premium ? l10n.drawAnother : l10n.dailyLimitReached),
          ),
        ),
      ],
    );
  }
}

class _TarotCardView extends StatelessWidget {
  const _TarotCardView({required this.card});

  final TarotCard card;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 430,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF251935), Color(0xFF0E0A16)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFD4AF59), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          card.imagePath,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    card.symbol,
                    style: const TextStyle(
                      fontSize: 90,
                      color: Color(0xFFD4AF59),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    card.name.toUpperCase(),
                    style: const TextStyle(
                      letterSpacing: 2,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _OrionPremiumInsight extends StatelessWidget {
  const _OrionPremiumInsight({required this.card});

  final TarotCard card;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: const Color(0xFF211839),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFFD4AF59).withValues(alpha: .55)),
    ),
    child: Text(
      'ORION+ · Avec ${card.name}, choisis un geste minuscule mais réel. Note-le dans ton Journal, puis reviens observer ce qu’il a déplacé.',
      style: const TextStyle(height: 1.45),
    ),
  );
}
