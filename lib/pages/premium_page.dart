import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../app_config.dart';

class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});

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
        _PlanComparisonTable(l10n: l10n),

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
          'Endpoint devnet : ${AppConfig.solanaClusterUrl}',
          style: const TextStyle(fontSize: 12, color: Color(0xFFB9AFBE)),
        ),
      ],
    );
  }
}

class _PlanComparisonTable extends StatelessWidget {
  const _PlanComparisonTable({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) => Table(
    border: TableBorder.all(
      color: const Color(0xFF3F3449),
      borderRadius: BorderRadius.circular(12),
    ),
    columnWidths: const {
      0: FlexColumnWidth(1.25),
      1: FlexColumnWidth(),
      2: FlexColumnWidth(),
    },
    children: [
      _row(l10n.comparisonFeature, l10n.freePlan, l10n.orionPlus, header: true),
      _row(l10n.dailyCard, l10n.freeDailyReading, l10n.premiumDailyReading),
      _row(l10n.journalAccess, l10n.localNotes, l10n.linkedJournal),
      _row(
        l10n.interpretation,
        l10n.shortInterpretation,
        l10n.deepInterpretation,
      ),
      _row(
        l10n.extendedReadings,
        l10n.dailyCardOnly,
        l10n.extendedReadingsPlanned,
      ),
      _row(
        l10n.personalizedGuidance,
        l10n.standardGuidance,
        l10n.consentGuidance,
      ),
      _row(l10n.orionMemory, l10n.notIncluded, l10n.optionalMemory),
      _row(l10n.preferences, l10n.included, l10n.included),
      _row(l10n.dailyReminder, l10n.planned, l10n.planned),
      _row(l10n.nftAvatars, l10n.notIncluded, l10n.planned),
      _row(l10n.adFree, l10n.included, l10n.included),
    ],
  );

  TableRow _row(
    String feature,
    String free,
    String premium, {
    bool header = false,
  }) => TableRow(
    decoration: header ? const BoxDecoration(color: Color(0xFF211839)) : null,
    children: [
      _cell(feature, header),
      _cell(free, header),
      _cell(premium, header),
    ],
  );

  Widget _cell(String text, bool header) => Padding(
    padding: const EdgeInsets.all(12),
    child: Text(
      text,
      style: TextStyle(
        fontWeight: header ? FontWeight.w700 : FontWeight.w400,
        fontSize: 12,
      ),
    ),
  );
}
