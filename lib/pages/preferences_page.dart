import 'package:flutter/material.dart';

import '../controllers/tarot_controller.dart';
import '../models/user_preferences.dart';
import '../l10n/app_localizations.dart';

class PreferencesPage extends StatelessWidget {
  const PreferencesPage({super.key, required this.controller});
  final TarotController controller;

  Future<void> _erase(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.eraseLocalData),
        content: Text(l10n.eraseConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.eraseLocalData),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final saved = await controller.erasePersonalData();
    if (context.mounted && saved) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l10n.dataErased)));
    }
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) {
      final l10n = AppLocalizations.of(context)!;
      final preferences = controller.state.preferences;
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
            if (controller.storageError)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(l10n.storageSaveError),
              ),
            const SizedBox(height: 18),
            SwitchListTile(
              value: preferences.orionMemory,
              onChanged: controller.busy
                  ? null
                  : (v) => controller.updatePreferences(
                      preferences.copyWith(orionMemory: v),
                    ),
              title: Text(l10n.orionMemory),
              subtitle: Text(l10n.orionMemoryDetail),
            ),
            SwitchListTile(
              value: preferences.personalizedGuidance,
              onChanged: controller.busy
                  ? null
                  : (v) => controller.updatePreferences(
                      preferences.copyWith(personalizedGuidance: v),
                    ),
              title: Text(l10n.personalizedGuidance),
              subtitle: Text(l10n.personalizedGuidanceDetail),
            ),
            SwitchListTile(
              value: preferences.dailyReminder,
              onChanged: controller.busy
                  ? null
                  : (v) => controller.updatePreferences(
                      preferences.copyWith(dailyReminder: v),
                    ),
              title: Text(l10n.dailyReminder),
              subtitle: Text(l10n.dailyReminderDetail),
            ),
            const Divider(height: 34),
            Text(
              l10n.orionTone,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<OrionTone>(
              key: ValueKey(preferences.tone),
              initialValue: preferences.tone,
              decoration: const InputDecoration(filled: true),
              items: [
                DropdownMenuItem(
                  value: OrionTone.mystic,
                  child: Text(l10n.toneMystic),
                ),
                DropdownMenuItem(
                  value: OrionTone.gentle,
                  child: Text(l10n.toneGentle),
                ),
                DropdownMenuItem(
                  value: OrionTone.practical,
                  child: Text(l10n.tonePractical),
                ),
              ],
              onChanged: controller.busy
                  ? null
                  : (value) {
                      if (value != null) {
                        controller.updatePreferences(
                          preferences.copyWith(tone: value),
                        );
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
              onPressed: controller.busy ? null : () => _erase(context),
              icon: const Icon(Icons.delete_outline),
              label: Text(l10n.eraseLocalData),
            ),
          ],
        ),
      );
    },
  );
}
