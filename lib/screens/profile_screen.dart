import 'package:flutter/material.dart';

import '../app_config.dart';
import '../l10n/app_localizations.dart';
import '../models/user_profile.dart';
import '../services/tarot_storage_service.dart';
import '../widgets/profile_completion_sheet.dart';
import '../widgets/wallet_connect_panel.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _storage = TarotStorageService();
  UserProfile? _profile;

  @override
  void initState() {
    super.initState();
    _restoreProfile();
  }

  Future<void> _restoreProfile() async {
    final profile = await _storage.restoreUserProfile();
    if (mounted) setState(() => _profile = profile);
  }

  Future<void> _completeProfile(String walletAddress) async {
    if (_profile?.walletAddress == walletAddress) return;
    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;
    await _showProfileForm(walletAddress);
  }

  Future<void> _showProfileForm(String walletAddress) async {
    final profile = await showModalBottomSheet<UserProfile>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => ProfileCompletionSheet(
        walletAddress: walletAddress,
        initialProfile: _profile,
      ),
    );
    if (profile == null) return;
    await _storage.saveUserProfile(profile);
    if (!mounted) return;
    setState(() => _profile = profile);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.profileSaved)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    void explainConfiguration() {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.facebookConfigurationRequired)),
      );
    }

    final profile = _profile;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.profile)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          CircleAvatar(
            radius: 42,
            child: profile == null
                ? const Icon(Icons.person_outline, size: 44)
                : Text(
                    profile.displayName.characters.first.toUpperCase(),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
          ),
          const SizedBox(height: 20),
          Text(
            profile?.displayName ?? l10n.profileTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            profile?.email ?? l10n.profileIntro,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (profile != null) ...[
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () => _showProfileForm(profile.walletAddress),
              icon: const Icon(Icons.edit_outlined),
              label: Text(l10n.editProfile),
            ),
          ],
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
          const SizedBox(height: 24),
          WalletConnectPanel(onConnected: _completeProfile),
        ],
      ),
    );
  }
}
