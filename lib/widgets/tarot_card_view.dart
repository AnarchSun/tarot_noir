import 'package:flutter/material.dart';

import '../models/tarot_card.dart';

class TarotCardView extends StatelessWidget {
  const TarotCardView({
    required this.card,
    this.orientation = CardOrientation.upright,
    super.key,
  });

  final TarotCard card;
  final CardOrientation orientation;

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
        child: card.hasIllustration
            ? RotatedBox(
                quarterTurns: orientation.isReversed ? 2 : 0,
                child: Image.asset(
                  card.imagePath,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) =>
                      _UnavailableIllustration(card: card),
                ),
              )
            : _UnavailableIllustration(card: card),
      ),
    );
  }
}

class _UnavailableIllustration extends StatelessWidget {
  const _UnavailableIllustration({required this.card});

  final TarotCard card;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          card.symbol,
          style: const TextStyle(fontSize: 90, color: Color(0xFFD4AF59)),
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
        const SizedBox(height: 8),
        const Text(
          'Illustration non disponible',
          style: TextStyle(color: Color(0xFFB9AFBE)),
        ),
      ],
    ),
  );
}
