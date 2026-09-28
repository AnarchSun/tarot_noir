import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/firebase_auth_service.dart';

class PhoneAuthSheet extends StatefulWidget {
  const PhoneAuthSheet({super.key, required this.auth});

  final FirebaseAuthService auth;

  @override
  State<PhoneAuthSheet> createState() => _PhoneAuthSheetState();
}

class _PhoneAuthSheetState extends State<PhoneAuthSheet> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  bool _submitting = false;
  String? _verificationId;
  String? _error;

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _requestCode() async {
    final phoneNumber = _phoneController.text.trim();
    if (!RegExp(r'^\+[1-9]\d{7,14}$').hasMatch(phoneNumber)) {
      setState(() => _error = AppLocalizations.of(context)!.phoneNumberInvalid);
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await widget.auth.requestPhoneVerification(
        phoneNumber: phoneNumber,
        onCodeSent: (verificationId, _) {
          if (!mounted) return;
          setState(() {
            _verificationId = verificationId;
            _submitting = false;
          });
        },
        onVerificationCompleted: _completeSignIn,
        onVerificationFailed: _showError,
      );
    } on FirebaseAuthException catch (error) {
      _showError(error);
    } finally {
      if (mounted && _verificationId == null) {
        setState(() => _submitting = false);
      }
    }
  }

  Future<void> _submitCode() async {
    final verificationId = _verificationId;
    if (verificationId == null) return;
    final smsCode = _codeController.text.trim();
    if (!RegExp(r'^\d{6}$').hasMatch(smsCode)) {
      setState(() {
        _error = AppLocalizations.of(context)!.verificationCodeInvalid;
      });
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final user = await widget.auth.signInWithPhoneVerificationCode(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      _completeSignIn(user);
    } on FirebaseAuthException catch (error) {
      _showError(error);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _completeSignIn(User user) {
    if (mounted) Navigator.of(context).pop(user);
  }

  void _showError(FirebaseAuthException error) {
    if (mounted) {
      setState(() {
        _error = error.message ?? error.code;
        _submitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final codeSent = _verificationId != null;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          24,
          24,
          24 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.phoneSignIn,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              if (!codeSent)
                TextField(
                  key: const Key('phone-number'),
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  autofillHints: const [AutofillHints.telephoneNumber],
                  decoration: InputDecoration(
                    labelText: l10n.phoneNumberLabel,
                    hintText: '+14155552671',
                  ),
                )
              else ...[
                Text(l10n.phoneCodeSent),
                const SizedBox(height: 12),
                TextField(
                  key: const Key('phone-verification-code'),
                  controller: _codeController,
                  keyboardType: TextInputType.number,
                  autofillHints: const [AutofillHints.oneTimeCode],
                  maxLength: 6,
                  decoration: InputDecoration(
                    labelText: l10n.verificationCodeLabel,
                  ),
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
              const SizedBox(height: 20),
              FilledButton(
                key: const Key('submit-phone-auth'),
                onPressed: _submitting
                    ? null
                    : codeSent
                    ? _submitCode
                    : _requestCode,
                child: _submitting
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(codeSent ? l10n.signIn : l10n.sendVerificationCode),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
