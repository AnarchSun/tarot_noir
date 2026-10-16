import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../models/journal_entry.dart';
import '../models/spread.dart';
import '../models/tarot_card_text.dart';
import '../screens/preferences_screen.dart';
import 'orion_premium_insight.dart';

class JournalSection extends StatelessWidget {
  const JournalSection({
    required this.entries,
    required this.onUpdateNote,
    required this.onDelete,
    required this.onClearData,
    required this.isPremiumUnlocked,
    required this.onOpenPremium,
    super.key,
  });

  final List<JournalEntry> entries;
  final Future<void> Function(JournalEntry entry, String note) onUpdateNote;
  final Future<void> Function(JournalEntry entry) onDelete;
  final VoidCallback onClearData;
  final bool isPremiumUnlocked;
  final VoidCallback onOpenPremium;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      key: const Key('journal-section'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                l10n.journalTitle,
                style: Theme.of(context).textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            IconButton(
              tooltip: l10n.preferences,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => PreferencesScreen(onDataCleared: onClearData),
                ),
              ),
              icon: const Icon(Icons.tune),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(l10n.journalSubtitle),
        const SizedBox(height: 12),
        if (entries.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(child: Text(l10n.journalEmpty)),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: entries.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (_, i) => JournalEntryTile(
              key: ValueKey(entries[i].syncId),
              entry: entries[i],
              onUpdateNote: onUpdateNote,
              onDelete: onDelete,
              isPremiumUnlocked: isPremiumUnlocked,
              onOpenPremium: onOpenPremium,
            ),
          ),
      ],
    );
  }
}

class JournalEntryTile extends StatefulWidget {
  const JournalEntryTile({
    required this.entry,
    required this.onUpdateNote,
    required this.onDelete,
    required this.isPremiumUnlocked,
    required this.onOpenPremium,
    super.key,
  });

  final JournalEntry entry;
  final Future<void> Function(JournalEntry entry, String note) onUpdateNote;
  final Future<void> Function(JournalEntry entry) onDelete;
  final bool isPremiumUnlocked;
  final VoidCallback onOpenPremium;

  @override
  State<JournalEntryTile> createState() => _JournalEntryTileState();
}

class _JournalEntryTileState extends State<JournalEntryTile> {
  late final TextEditingController _controller;
  bool _notesVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.entry.note ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isDirty =>
      _controller.text.trim() != (widget.entry.note ?? '').trim();

  Future<void> _saveNote() async {
    await widget.onUpdateNote(widget.entry, _controller.text);
    if (mounted) setState(() {});
  }

  void _showDetails() {
    final l10n = AppLocalizations.of(context)!;
    final entry = widget.entry;
    final date = DateFormat.yMd(l10n.localeName).format(entry.createdAt);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.journalDetails,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              Center(child: _Thumbnail(entry: entry, width: 150, height: 220)),
              const SizedBox(height: 16),
              Text(
                entry.card.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(l10n.drawDate(date)),
              const SizedBox(height: 16),
              if (!entry.card.isMinorArcana)
                _DetailSection(
                  label: l10n.keywordLabel,
                  value: entry.card.localizedKeyword(l10n.localeName),
                ),
              _DetailSection(
                label: l10n.interpretationLabel,
                value: entry.card.localizedMessage(l10n.localeName),
              ),
              _DetailSection(
                label: l10n.drawTypeLabel,
                value: _drawTypeText(l10n, entry),
              ),
              if (entry.note?.isNotEmpty == true)
                _DetailSection(label: l10n.noteLabel, value: entry.note!),
              if (entry.mood != null)
                _DetailSection(label: '', value: l10n.moodValue(entry.mood!)),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    Navigator.of(sheetContext).pop();
                    await widget.onDelete(entry);
                  },
                  icon: const Icon(Icons.delete_outline),
                  label: Text(l10n.deleteJournalEntry),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _drawTypeText(AppLocalizations l10n, JournalEntry entry) =>
      drawTypeLabel(
        entry.drawType,
        l10n.localeName,
        daily: l10n.dailyDrawType,
        free: l10n.freeDrawType,
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final entry = widget.entry;
    final date = DateFormat.yMd(l10n.localeName).format(entry.createdAt);
    final hasNote = entry.note?.trim().isNotEmpty == true;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          onTap: _showDetails,
          leading: _Thumbnail(entry: entry, width: 42, height: 58),
          title: Text(entry.card.name),
          subtitle: Text(
            [
              if (!entry.card.isMinorArcana)
                entry.card.localizedKeyword(l10n.localeName),
              '$date · ${_drawTypeText(l10n, entry)}',
            ].join('\n'),
          ),
          trailing: TextButton.icon(
            key: Key('journal-notes-toggle-${entry.syncId}'),
            onPressed: () => setState(() => _notesVisible = !_notesVisible),
            iconAlignment: IconAlignment.end,
            icon: Icon(_notesVisible ? Icons.expand_less : Icons.expand_more),
            label: Text(hasNote ? '${l10n.notesToggle} •' : l10n.notesToggle),
          ),
        ),
        if (_notesVisible)
          Padding(
            key: Key('journal-notes-${entry.syncId}'),
            padding: const EdgeInsets.only(bottom: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _controller,
                  minLines: 2,
                  maxLines: 6,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    filled: true,
                    hintText: l10n.journalNoteHint,
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.tonalIcon(
                    onPressed: _isDirty ? _saveNote : null,
                    icon: const Icon(Icons.bookmark_add_outlined),
                    label: Text(l10n.saveNote),
                  ),
                ),
                const SizedBox(height: 8),
                if (widget.isPremiumUnlocked) ...[
                  OrionPremiumInsight(
                    card: entry.card,
                    orientation: entry.orientation,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.orionAskSoon,
                    style: const TextStyle(color: Color(0xFFB9AFBE)),
                  ),
                ] else
                  ListTile(
                    key: Key('journal-orion-locked-${entry.syncId}'),
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.lock_outline),
                    title: Text(l10n.orionLockedHint),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: widget.onOpenPremium,
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({
    required this.entry,
    required this.width,
    required this.height,
  });

  final JournalEntry entry;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF211839),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        entry.card.symbol,
        style: TextStyle(fontSize: width / 2.3, color: const Color(0xFFD4AF59)),
      ),
    );
    if (entry.thumbnailPath.isEmpty) return fallback;
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: RotatedBox(
          quarterTurns: entry.orientation.isReversed ? 2 : 0,
          child: Image.asset(
            entry.thumbnailPath,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => fallback,
          ),
        ),
      ),
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFFD4AF59),
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
        if (label.isNotEmpty) const SizedBox(height: 4),
        Text(value, style: const TextStyle(height: 1.4)),
      ],
    ),
  );
}
