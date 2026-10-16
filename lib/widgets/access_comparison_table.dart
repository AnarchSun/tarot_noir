import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

class AccessComparisonTable extends StatelessWidget {
  const AccessComparisonTable({required this.l10n, super.key});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final rows = <(String, bool, bool, bool)>[
      (l10n.compareRowDaily, true, true, true),
      (l10n.compareRowPersonal, true, true, true),
      (l10n.compareRowCross, true, true, true),
      (l10n.compareRowJournal, false, true, true),
      (l10n.compareRowProfile, false, true, true),
      (l10n.compareRowExtended, false, false, true),
      (l10n.compareRowDeepReading, false, false, true),
      (l10n.compareRowNoAds, false, false, true),
      (l10n.compareRowNft, false, false, true),
    ];
    return Table(
      border: TableBorder.all(
        color: const Color(0xFF3F3449),
        borderRadius: BorderRadius.circular(12),
      ),
      columnWidths: const {
        0: FlexColumnWidth(1.7),
        1: FlexColumnWidth(),
        2: FlexColumnWidth(),
        3: FlexColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          decoration: const BoxDecoration(color: Color(0xFF211839)),
          children: [
            const SizedBox.shrink(),
            _header(l10n.compareGuest),
            _header(l10n.compareAccount),
            _header(l10n.orionPlus, accent: true),
          ],
        ),
        for (final row in rows)
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(row.$1, style: const TextStyle(fontSize: 12)),
              ),
              _mark(row.$2),
              _mark(row.$3),
              _mark(row.$4),
            ],
          ),
      ],
    );
  }

  Widget _header(String text, {bool accent = false}) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: accent ? const Color(0xFFD4AF59) : null,
      ),
    ),
  );

  Widget _mark(bool included) => Padding(
    padding: const EdgeInsets.all(8),
    child: Icon(
      included ? Icons.check_circle : Icons.remove,
      size: 18,
      semanticLabel: included ? '✓' : '—',
      color: included ? const Color(0xFFD4AF59) : const Color(0xFF6B6075),
    ),
  );
}
