import 'package:flutter/material.dart';

import '../models/tarot_card.dart';

class OrionPremiumInsight extends StatelessWidget {
  const OrionPremiumInsight({required this.card, super.key});

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
