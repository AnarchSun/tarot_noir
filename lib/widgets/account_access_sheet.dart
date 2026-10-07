import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

class AccountAccessSheet extends StatelessWidget {
  const AccountAccessSheet({
    required this.destination,
    required this.showFacebook,
    required this.onGoogleSignIn,
    required this.onFacebookSignIn,
    required this.onExplorePremium,
    required this.l10n,
    super.key,
  });

  final String destination;
  final bool showFacebook;
  final VoidCallback onGoogleSignIn;
  final VoidCallback onFacebookSignIn;
  final VoidCallback onExplorePremium;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.accountGateTitle(destination),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: const Color(0xFFE3D8C7),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.accountGateBody,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.45),
        ),
        const SizedBox(height: 20),
        FilledButton.icon(
          key: const Key('account-gate-google'),
          onPressed: onGoogleSignIn,
          icon: const Icon(Icons.g_mobiledata, size: 28),
          label: Text(l10n.continueWithGoogle),
        ),
        if (showFacebook) ...[
          const SizedBox(height: 8),
          OutlinedButton.icon(
            key: const Key('account-gate-facebook'),
            onPressed: onFacebookSignIn,
            icon: const Icon(Icons.facebook),
            label: Text(l10n.continueWithFacebook),
          ),
        ],
        const SizedBox(height: 20),
        Text(
          l10n.orionPlusTeaser,
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(color: const Color(0xFFB8D5D0), height: 1.4),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: onExplorePremium,
            child: Text(l10n.discoverOrionPlus),
          ),
        ),
      ],
    ),
  );
}
