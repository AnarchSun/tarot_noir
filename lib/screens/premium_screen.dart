import 'package:flutter/material.dart';

import '../app_config.dart';
import '../l10n/app_localizations.dart';
import '../widgets/plan_comparison_table.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          l10n.premiumTitle,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Text(l10n.comparisonIntro),
        const SizedBox(height: 10),
        Text(l10n.premiumIntro),
        const SizedBox(height: 24),
        PlanComparisonTable(l10n: l10n),
        const SizedBox(height: 24),
        Text(l10n.extendedReadingsDetail, style: const TextStyle(height: 1.45)),
        const SizedBox(height: 10),
        Text(l10n.nftAvatarsDetail, style: const TextStyle(height: 1.45)),
        const SizedBox(height: 10),
        Text(l10n.adFreeDetail, style: const TextStyle(height: 1.45)),
        const SizedBox(height: 24),
        OutlinedButton(onPressed: null, child: Text(l10n.walletSoon)),
        const SizedBox(height: 12),
        Text(
          l10n.networkConfigured(AppConfig.solanaCluster),
          style: const TextStyle(fontSize: 12, color: Color(0xFFB9AFBE)),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.endpointLabel(AppConfig.solanaClusterUrl),
          style: const TextStyle(fontSize: 12, color: Color(0xFFB9AFBE)),
        ),
      ],
    );
  }
}
