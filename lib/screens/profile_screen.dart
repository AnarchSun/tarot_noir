import 'package:flutter/material.dart';

import '../app_config.dart';
import '../l10n/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    void explainConfiguration() {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.facebookConfigurationRequired)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profile)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const CircleAvatar(
            radius: 42,
            child: Icon(Icons.person_outline, size: 44),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.profileTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.profileIntro,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 28),
          FilledButton.icon(
            key: const Key('facebook-sign-in'),
            onPressed: explainConfiguration,
            icon: const Icon(Icons.facebook),
            label: Text(l10n.continueWithFacebook),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: explainConfiguration,
            icon: const Icon(Icons.email_outlined),
            label: Text(l10n.continueWithEmail),
          ),
          const SizedBox(height: 24),
          Card(
            child: ListTile(
              leading: Icon(
                AppConfig.isFacebookAuthConfigured
                    ? Icons.check_circle_outline
                    : Icons.lock_outline,
              ),
              title: Text(
                AppConfig.isFacebookAuthConfigured
                    ? l10n.authenticationConfigured
                    : l10n.authenticationNotConfigured,
              ),
              subtitle: Text(l10n.authenticationPrivacy),
            ),
          ),
        ],
      ),
    );
  }
}
