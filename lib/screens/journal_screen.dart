import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../models/journal_entry.dart';
import 'preferences_screen.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({
    required this.entries,
    required this.onSave,
    required this.onDelete,
    super.key,
  });

  final List<JournalEntry> entries;
  final Future<void> Function(String note, int mood) onSave;
  final Future<void> Function(JournalEntry entry) onDelete;

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final _controller = TextEditingController();
  int _mood = 3;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    await widget.onSave(_controller.text, _mood);
    if (_controller.text.trim().isNotEmpty) {
      _controller.clear();
    }
  }

  void _showDetails(BuildContext context, JournalEntry entry) {
    final l10n = AppLocalizations.of(context)!;
    final date = DateFormat.yMd(l10n.localeName).format(entry.createdAt);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SafeArea(
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
              Center(
                child: entry.thumbnailPath.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: RotatedBox(
                          quarterTurns: entry.orientation.isReversed ? 2 : 0,
                          child: Image.asset(
                            entry.thumbnailPath,
                            height: 220,
                            width: 150,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                _JournalCardFallback(entry: entry),
                          ),
                        ),
                      )
                    : _JournalCardFallback(entry: entry),
              ),
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
              _DetailSection(
                label: l10n.keywordLabel,
                value: entry.card.keyword,
              ),
              _DetailSection(
                label: l10n.interpretationLabel,
                value: entry.shortExplanation,
              ),
              _DetailSection(
                label: l10n.drawTypeLabel,
                value: entry.drawType == 'daily'
                    ? l10n.dailyDrawType
                    : l10n.freeDrawType,
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
                    Navigator.of(context).pop();
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.journalTitle,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              IconButton(
                tooltip: l10n.preferences,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PreferencesScreen()),
                ),
                icon: const Icon(Icons.tune),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(l10n.journalSubtitle),
          const SizedBox(height: 20),
          TextField(
            controller: _controller,
            minLines: 3,
            maxLines: 6,
            decoration: InputDecoration(
              filled: true,
              hintText: l10n.journalNoteHint,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.moodLabel(_mood),
            style: const TextStyle(fontSize: 12, letterSpacing: 1.2),
          ),
          Slider(
            value: _mood.toDouble(),
            min: 1,
            max: 5,
            divisions: 4,
            label: '$_mood / 5',
            onChanged: (value) => setState(() => _mood = value.round()),
          ),
          FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.bookmark_add_outlined),
            label: Text(l10n.sealNote),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: widget.entries.isEmpty
                ? Center(child: Text(l10n.journalEmpty))
                : ListView.separated(
                    itemCount: widget.entries.length,
                    separatorBuilder: (_, _) => const Divider(),
                    itemBuilder: (_, i) {
                      final entry = widget.entries[i];
                      return ListTile(
                        onTap: () => _showDetails(context, entry),
                        leading: entry.thumbnailPath.isNotEmpty
                            ? SizedBox(
                                width: 42,
                                height: 58,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: RotatedBox(
                                    quarterTurns: entry.orientation.isReversed
                                        ? 2
                                        : 0,
                                    child: Image.asset(
                                      entry.thumbnailPath,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, _, _) => Center(
                                        child: Text(
                                          entry.card.symbol,
                                          style: const TextStyle(
                                            fontSize: 28,
                                            color: Color(0xFFD4AF59),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Text(
                                entry.card.symbol,
                                style: const TextStyle(
                                  fontSize: 28,
                                  color: Color(0xFFD4AF59),
                                ),
                              ),
                        title: Text(entry.card.name),
                        subtitle: Text(
                          [
                            entry.shortExplanation,
                            l10n.drawDate(
                              DateFormat.yMd(l10n.localeName)
                                  .format(entry.createdAt),
                            ),
                            entry.drawType == 'daily'
                                ? l10n.dailyDrawType
                                : l10n.freeDrawType,
                            if (entry.note?.isNotEmpty == true) entry.note!,
                          ].join('\n'),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    },
                  ),
          ),
        ],
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

class _JournalCardFallback extends StatelessWidget {
  const _JournalCardFallback({required this.entry});

  final JournalEntry entry;

  @override
  Widget build(BuildContext context) => Container(
    height: 220,
    width: 150,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: const Color(0xFF211839),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      entry.card.symbol,
      style: const TextStyle(fontSize: 64, color: Color(0xFFD4AF59)),
    ),
  );
}
