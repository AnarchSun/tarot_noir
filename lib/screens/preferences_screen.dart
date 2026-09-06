import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  bool _orionMemory = false;
  bool _personalizedGuidance = false;
  bool _dailyReminder = false;
  String _tone = 'Mystique et direct';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.preferences)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            l10n.preferencesTitle,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Text(l10n.preferencesIntro),
          const SizedBox(height: 18),
          SwitchListTile(
            value: _orionMemory,
            onChanged: (value) => setState(() => _orionMemory = value),
            title: Text(l10n.orionMemory),
            subtitle: Text(l10n.orionMemoryDetail),
          ),
          SwitchListTile(
            value: _personalizedGuidance,
            onChanged: (value) => setState(() => _personalizedGuidance = value),
            title: Text(l10n.personalizedGuidance),
            subtitle: Text(l10n.personalizedGuidanceDetail),
          ),
          SwitchListTile(
            value: _dailyReminder,
            onChanged: (value) => setState(() => _dailyReminder = value),
            title: Text(l10n.dailyReminder),
            subtitle: Text(l10n.dailyReminderDetail),
          ),
          const Divider(height: 34),
          Text(
            l10n.orionTone,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _tone,
            decoration: const InputDecoration(filled: true),
            items: const [
              DropdownMenuItem(
                value: 'Mystique et direct',
                child: Text('Mystique et direct'),
              ),
              DropdownMenuItem(
                value: 'Doux et contemplatif',
                child: Text('Doux et contemplatif'),
              ),
              DropdownMenuItem(
                value: 'Symbolique et concret',
                child: Text('Symbolique et concret'),
              ),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _tone = value);
            },
          ),
          const Divider(height: 34),
          Text(
            l10n.dataAndInterests,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(l10n.dataPolicy),
            ),
          ),
          TextButton.icon(
            onPressed: () =>
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(l10n.noDataToErase))),
            icon: const Icon(Icons.delete_outline),
            label: Text(l10n.eraseLocalData),
          ),
        ],
      ),
    );
  }
}
