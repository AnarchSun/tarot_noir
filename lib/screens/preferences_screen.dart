import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/tarot_storage_service.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({required this.onDataCleared, super.key});

  final VoidCallback onDataCleared;

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  bool _orionMemory = false;
  bool _personalizedGuidance = false;
  bool _dailyReminder = false;
  String _tone = 'Mystique et direct';
  final _storage = TarotStorageService();

  @override
  void initState() {
    super.initState();
    _restore();
  }

  Future<void> _restore() async {
    final values = await _storage.restorePreferences();
    if (!mounted) return;
    setState(() {
      _orionMemory = values[TarotStorageService.orionMemoryKey] as bool;
      _personalizedGuidance =
          values[TarotStorageService.personalizedGuidanceKey] as bool;
      _dailyReminder = values[TarotStorageService.dailyReminderKey] as bool;
      _tone = values[TarotStorageService.toneKey] as String;
    });
  }

  Future<void> _confirmClearData() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.eraseLocalData),
        content: Text(l10n.eraseLocalDataConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.erase),
          ),
        ],
      ),
    );
    if (confirmed == true) await _clearData();
  }

  Future<void> _clearData() async {
    await _storage.clearAll();
    if (!mounted) return;
    setState(() {
      _orionMemory = false;
      _personalizedGuidance = false;
      _dailyReminder = false;
      _tone = 'Mystique et direct';
    });
    widget.onDataCleared();
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.localDataErased)));
  }

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
            onChanged: (value) {
              setState(() => _orionMemory = value);
              _storage.saveBoolPreference(
                TarotStorageService.orionMemoryKey,
                value,
              );
            },
            title: Text(l10n.orionMemory),
            subtitle: Text(l10n.orionMemoryDetail),
          ),
          SwitchListTile(
            value: _personalizedGuidance,
            onChanged: (value) {
              setState(() => _personalizedGuidance = value);
              _storage.saveBoolPreference(
                TarotStorageService.personalizedGuidanceKey,
                value,
              );
            },
            title: Text(l10n.personalizedGuidance),
            subtitle: Text(l10n.personalizedGuidanceDetail),
          ),
          SwitchListTile(
            value: _dailyReminder,
            onChanged: (value) {
              setState(() => _dailyReminder = value);
              _storage.saveBoolPreference(
                TarotStorageService.dailyReminderKey,
                value,
              );
            },
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
              if (value != null) {
                setState(() => _tone = value);
                _storage.saveTone(value);
              }
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
            onPressed: _confirmClearData,
            icon: const Icon(Icons.delete_outline),
            label: Text(l10n.eraseLocalData),
          ),
        ],
      ),
    );
  }
}
