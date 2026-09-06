import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

class PlanComparisonTable extends StatelessWidget {
  const PlanComparisonTable({required this.l10n, super.key});

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
