import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../app_config.dart';
import '../l10n/app_localizations.dart';
import '../models/user_profile.dart';
import '../services/firebase_auth_service.dart';
import '../services/tarot_storage_service.dart';
import '../widgets/email_auth_sheet.dart';
import '../widgets/profile_completion_sheet.dart';
import '../widgets/wallet_connect_panel.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _storage = TarotStorageService();
  final _auth = const FirebaseAuthService();
  UserProfile? _profile;
  User? _authUser;
  bool _facebookSigningIn = false;

  @override
  void initState() {
    super.initState();
    _authUser = _auth.currentUser;
    _restoreProfile();
  }

  Future<void> _restoreProfile() async {
    final profile = await _storage.restoreUserProfile();
    if (mounted) setState(() => _profile = profile);
  }

  Future<void> _completeProfile(String walletAddress) async {
    if (_profile?.belongsToWallet(walletAddress) == true) return;
    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;
    await _showProfileForm(walletAddress: walletAddress);
  }

  Future<void> _completeFirebaseProfile(User user) async {
    if (_profile?.belongsToFirebaseUser(user.uid) == true) return;
    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;
    await _showProfileForm(
      firebaseUid: user.uid,
      suggestedDisplayName: user.displayName,
      suggestedEmail: user.email,
    );
  }

  Future<void> _showProfileForm({
    String? walletAddress,
    String? firebaseUid,
    String? suggestedDisplayName,
    String? suggestedEmail,
  }) async {
    final profile = await showModalBottomSheet<UserProfile>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => ProfileCompletionSheet(
        walletAddress: walletAddress,
        firebaseUid: firebaseUid,
        suggestedDisplayName: suggestedDisplayName,
        suggestedEmail: suggestedEmail,
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

  Future<void> _signInWithFacebook() async {
    final l10n = AppLocalizations.of(context)!;
    if (!AppConfig.isFacebookAuthConfigured ||
        !FirebaseAuthService.isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.facebookConfigurationRequired)),
      );
      return;
    }
    setState(() => _facebookSigningIn = true);
    try {
      final user = await _auth.signInWithFacebook();
      if (user != null && mounted) {
        setState(() => _authUser = user);
        await _completeFirebaseProfile(user);
      }
    } on FirebaseAuthException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.message ?? error.code)));
      }
    } finally {
      if (mounted) setState(() => _facebookSigningIn = false);
    }
  }

  Future<void> _openEmailAuth() async {
    final l10n = AppLocalizations.of(context)!;
    if (!AppConfig.isFirebaseAuthConfigured ||
        !FirebaseAuthService.isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.firebaseConfigurationRequired)),
      );
      return;
    }
    final user = await showModalBottomSheet<User>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => EmailAuthSheet(auth: _auth),
    );
    if (user != null && mounted) {
      setState(() => _authUser = user);
      if (!user.emailVerified) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.verificationEmailSent)));
      }
      await _completeFirebaseProfile(user);
    }
  }

  Future<void> _resendVerification() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      await _auth.resendEmailVerification();
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.verificationEmailSent)));
      }
    } on FirebaseAuthException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.message ?? error.code)));
      }
    }
  }

  Future<void> _refreshVerification() async {
    final user = await _auth.reloadCurrentUser();
    if (!mounted) return;
    setState(() => _authUser = user);
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          user?.emailVerified == true
              ? l10n.emailVerified
              : l10n.emailStillUnverified,
        ),
      ),
    );
  }

  Future<void> _signOut() async {
    await _auth.signOut();
    if (mounted) setState(() => _authUser = null);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final profile = _profile;
    final authUser = _authUser;
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
            authUser?.email ?? profile?.email ?? l10n.profileIntro,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (profile != null) ...[
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () => _showProfileForm(
                walletAddress: profile.walletAddress,
                firebaseUid: profile.firebaseUid,
              ),
              icon: const Icon(Icons.edit_outlined),
              label: Text(l10n.editProfile),
            ),
          ],
          const SizedBox(height: 28),
          FilledButton.icon(
            key: const Key('facebook-sign-in'),
            onPressed: _facebookSigningIn ? null : _signInWithFacebook,
            icon: _facebookSigningIn
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.facebook),
            label: Text(l10n.continueWithFacebook),
          ),
          const SizedBox(height: 12),
          if (authUser == null)
            OutlinedButton.icon(
              key: const Key('email-sign-in'),
              onPressed: _openEmailAuth,
              icon: const Icon(Icons.email_outlined),
              label: Text(l10n.continueWithEmail),
            )
          else
            OutlinedButton.icon(
              key: const Key('sign-out'),
              onPressed: _signOut,
              icon: const Icon(Icons.logout),
              label: Text(l10n.signOut),
            ),
          if (authUser != null && !authUser.emailVerified) ...[
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(l10n.emailNotVerified),
                    const SizedBox(height: 8),
                    Wrap(
                      alignment: WrapAlignment.end,
                      spacing: 8,
                      children: [
                        TextButton(
                          key: const Key('resend-verification'),
                          onPressed: _resendVerification,
                          child: Text(l10n.resendVerification),
                        ),
                        TextButton(
                          key: const Key('refresh-verification'),
                          onPressed: _refreshVerification,
                          child: Text(l10n.refreshVerification),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
          Card(
            child: ListTile(
              leading: Icon(
                authUser != null ? Icons.verified_user : Icons.lock_outline,
              ),
              title: Text(
                authUser?.email == null
                    ? (AppConfig.isFirebaseAuthConfigured
                          ? l10n.authenticationConfigured
                          : l10n.authenticationNotConfigured)
                    : l10n.signedInAs(authUser!.email!),
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
