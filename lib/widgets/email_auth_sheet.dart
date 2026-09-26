import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/firebase_auth_service.dart';

class EmailAuthSheet extends StatefulWidget {
  const EmailAuthSheet({super.key, required this.auth});

  final FirebaseAuthService auth;

  @override
  State<EmailAuthSheet> createState() => _EmailAuthSheetState();
}

class _EmailAuthSheetState extends State<EmailAuthSheet> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _createAccount = false;
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      final user = _createAccount
          ? await widget.auth.createAccount(email: email, password: password)
          : await widget.auth.signIn(email: email, password: password);
      if (mounted) Navigator.of(context).pop(user);
    } on FirebaseAuthException catch (error) {
      if (mounted) setState(() => _error = error.message ?? error.code);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
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
                  _createAccount ? l10n.createAccount : l10n.emailSignIn,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const Key('auth-email'),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  decoration: InputDecoration(labelText: l10n.emailLabel),
                  validator: (value) => (value?.contains('@') ?? false)
                      ? null
                      : l10n.emailInvalid,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  key: const Key('auth-password'),
                  controller: _passwordController,
                  obscureText: true,
                  autofillHints: const [AutofillHints.password],
                  decoration: InputDecoration(labelText: l10n.passwordLabel),
                  validator: (value) =>
                      (value?.length ?? 0) >= 6 ? null : l10n.passwordTooShort,
                  onFieldSubmitted: (_) => _submitting ? null : _submit(),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                FilledButton(
                  key: const Key('submit-email-auth'),
                  onPressed: _submitting ? null : _submit,
                  child: _submitting
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(_createAccount ? l10n.createAccount : l10n.signIn),
                ),
                TextButton(
                  onPressed: _submitting
                      ? null
                      : () => setState(() => _createAccount = !_createAccount),
                  child: Text(
                    _createAccount ? l10n.alreadyHaveAccount : l10n.needAccount,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
