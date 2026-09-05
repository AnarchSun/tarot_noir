import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../models/journal_entry.dart';
import 'preferences_screen.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({required this.entries, required this.onSave, super.key});

  final List<JournalEntry> entries;
  final void Function(String note, int mood) onSave;

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

  void _save() {
    widget.onSave(_controller.text, _mood);
    if (_controller.text.trim().isNotEmpty) {
      _controller.clear();
    }
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
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.asset(
                            entry.card.imagePath,
                            width: 42,
                            height: 58,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Text(
                              entry.card.symbol,
                              style: const TextStyle(
                                fontSize: 28,
                                color: Color(0xFFD4AF59),
                              ),
                            ),
                          ),
                        ),
                        title: Text(entry.card.name),
                        subtitle: Text(
                          [
                            entry.card.keyword,
                            l10n.drawDate(
                              DateFormat.yMd(l10n.localeName)
                                  .format(entry.createdAt),
                            ),
                            entry.drawType == 'daily'
                                ? l10n.dailyDrawType
                                : l10n.freeDrawType,
                            if (entry.note?.isNotEmpty == true) entry.note!,
                            '${entry.mood ?? 3}/5',
                          ].join(' · '),
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
