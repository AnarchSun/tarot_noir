import 'package:flutter/material.dart';

import '../app_config.dart';
import '../l10n/app_localizations.dart';
import 'access_comparison_table.dart';

class AccountAccessSheet extends StatelessWidget {
  const AccountAccessSheet({
    required this.destination,
    this.onContinueAsGuest,
    required this.showFacebook,
    required this.onGoogleSignIn,
    required this.onFacebookSignIn,
    required this.onExplorePremium,
    required this.l10n,
    super.key,
  });

  final String destination;
  final VoidCallback? onContinueAsGuest;
  final bool showFacebook;
  final VoidCallback onGoogleSignIn;
  final VoidCallback onFacebookSignIn;
  final VoidCallback onExplorePremium;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            onContinueAsGuest != null
                ? l10n.guestPopupTitle
                : l10n.accountGateTitle(destination),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: const Color(0xFFE3D8C7),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            onContinueAsGuest != null
                ? l10n.guestPopupBody
                : l10n.accountGateBody,
            style: Theme.of(context).textTheme.bodyLarge
                ?.copyWith(height: 1.45),
          ),
          const SizedBox(height: 16),
          AccessComparisonTable(
            key: const Key('access-comparison'),
            l10n: l10n,
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
          if (onContinueAsGuest != null) ...[
            const SizedBox(height: 8),
            OutlinedButton(
              key: const Key('guest-popup-continue'),
              onPressed: onContinueAsGuest,
              child: Text(l10n.guestContinueAction),
            ),
            if (AppConfig.adPlaceholderEnabled) ...[
              const SizedBox(height: 12),
              _GuestAdBanner(l10n: l10n),
            ],
          ],
          if (onContinueAsGuest == null)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: onExplorePremium,
                child: Text(l10n.discoverOrionPlus),
              ),
            ),
        ],
      ),
    ),
  );
}

class _GuestAdBanner extends StatelessWidget {
  const _GuestAdBanner({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) => Container(
    key: const Key('guest-ad-banner'),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFF140F1C),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFF3F3449)),
    ),
    child: Row(
      children: [
        Text(
          l10n.guestAdLabel.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            letterSpacing: 1,
            color: Color(0xFFB9AFBE),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            l10n.guestAdBody,
            style: const TextStyle(color: Color(0xFFCFC6D4)),
          ),
        ),
      ],
    ),
  );
}
