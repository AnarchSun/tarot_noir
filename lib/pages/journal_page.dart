import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/journal_entry.dart';
import '../controllers/tarot_controller.dart';
import 'preferences_page.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({
    super.key,
    required this.entries,
    required this.onSave,
    required this.controller,
  });

  final List<JournalEntry> entries;
  final Future<bool> Function(String note, int mood) onSave;
  final TarotController controller;

  @override
  State<JournalPage> createState() => JournalPageState();
}

class JournalPageState extends State<JournalPage> {
  final _controller = TextEditingController();
  int _mood = 3;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final saved = await widget.onSave(_controller.text, _mood);
    if (mounted && saved) _controller.clear();
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
              Expanded(
                child: Text(
                  l10n.journalTitle,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                tooltip: l10n.preferences,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        PreferencesPage(controller: widget.controller),
                  ),
                ),
                icon: const Icon(Icons.tune),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(l10n.journalSubtitle),
          const SizedBox(height: 20),
          TextField(
            enabled: !widget.controller.busy,
            controller: _controller,
            minLines: 3,
            maxLines: 6,
            decoration: const InputDecoration(
              filled: true,
              hintText: 'Écris ce que la carte remue ou éclaire en toi…',
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'INTENSITÉ DU JOUR · $_mood/5',
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
            onPressed: widget.controller.busy ? null : _save,
            icon: const Icon(Icons.bookmark_add_outlined),
            label: const Text('Sceller cette note'),
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
                          entry.note?.isNotEmpty == true
                              ? '${entry.note} · ${entry.mood ?? 3}/5'
                              : '${entry.card.keyword} · ${entry.mood ?? 3}/5',
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
