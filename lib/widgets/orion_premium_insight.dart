import 'package:flutter/material.dart';

import '../models/premium_reading.dart';
import '../l10n/app_localizations.dart';
import '../models/tarot_card.dart';

class OrionPremiumInsight extends StatelessWidget {
  const OrionPremiumInsight({
    required this.card,
    required this.orientation,
    super.key,
  });

  final TarotCard card;
  final CardOrientation orientation;

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!.localeName;
    final reading = PremiumReadingCatalog.forCard(card, orientation, lang);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF211839),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD4AF59).withValues(alpha: .55),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            PremiumReadingCatalog.title(lang),
            style: const TextStyle(
              color: Color(0xFFD4AF59),
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(reading.essence, style: const TextStyle(height: 1.5)),
          const SizedBox(height: 12),
          Text(reading.shadow, style: const TextStyle(height: 1.5)),
          const SizedBox(height: 12),
          Text(reading.ritual, style: const TextStyle(height: 1.5)),
        ],
      ),
    );
  }
}
