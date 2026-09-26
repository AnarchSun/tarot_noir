import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/user_profile.dart';

class ProfileCompletionSheet extends StatefulWidget {
  const ProfileCompletionSheet({
    super.key,
    this.walletAddress,
    this.firebaseUid,
    this.suggestedDisplayName,
    this.suggestedEmail,
    this.initialProfile,
  }) : assert(walletAddress != null || firebaseUid != null);

  final String? walletAddress;
  final String? firebaseUid;
  final String? suggestedDisplayName;
  final String? suggestedEmail;
  final UserProfile? initialProfile;

  @override
  State<ProfileCompletionSheet> createState() => _ProfileCompletionSheetState();
}

class _ProfileCompletionSheetState extends State<ProfileCompletionSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _displayNameController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController(
      text:
          widget.initialProfile?.displayName ??
          widget.suggestedDisplayName ??
          '',
    );
    _emailController = TextEditingController(
      text: widget.initialProfile?.email ?? widget.suggestedEmail ?? '',
    );
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final email = _emailController.text.trim();
    Navigator.of(context).pop(
      UserProfile(
        displayName: _displayNameController.text.trim(),
        email: email.isEmpty ? null : email,
        walletAddress:
            widget.walletAddress ?? widget.initialProfile?.walletAddress,
        firebaseUid: widget.firebaseUid ?? widget.initialProfile?.firebaseUid,
        completedAt: DateTime.now().toUtc(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          24,
          24,
          24 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.completeProfileTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(l10n.completeProfileIntro),
                const SizedBox(height: 20),
                TextFormField(
                  key: const Key('profile-display-name'),
                  controller: _displayNameController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: l10n.displayNameLabel),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? l10n.displayNameRequired
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  key: const Key('profile-email'),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: l10n.emailOptional),
                  validator: (value) {
                    final email = value?.trim() ?? '';
                    return email.isNotEmpty && !email.contains('@')
                        ? l10n.emailInvalid
                        : null;
                  },
                ),
                if (widget.walletAddress case final address?) ...[
                  const SizedBox(height: 12),
                  Text(
                    l10n.publicWalletLabel(address),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
                const SizedBox(height: 20),
                FilledButton(
                  key: const Key('save-profile'),
                  onPressed: _save,
                  child: Text(l10n.saveProfile),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
