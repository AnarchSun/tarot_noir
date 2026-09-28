import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../app_config.dart';
import '../firebase_options.dart';

class FirebaseAuthService {
  const FirebaseAuthService();

  static bool get isInitialized => Firebase.apps.isNotEmpty;

  static Future<void> initialize() async {
    if (!AppConfig.isFirebaseAuthConfigured || isInitialized) return;
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    if (!kIsWeb) await GoogleSignIn.instance.initialize();
  }

  User? get currentUser =>
      isInitialized ? FirebaseAuth.instance.currentUser : null;

  Future<User> signIn({required String email, required String password}) async {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user!;
  }

  Future<User> createAccount({
    required String email,
    required String password,
  }) async {
    final credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    final user = credential.user!;
    await user.sendEmailVerification();
    return user;
  }

  Future<void> sendPasswordResetEmail(String email) =>
      FirebaseAuth.instance.sendPasswordResetEmail(email: email);

  Future<User?> signInWithGoogle() async {
    if (kIsWeb) {
      final credential = await FirebaseAuth.instance.signInWithPopup(
        GoogleAuthProvider(),
      );
      return credential.user;
    }

    final account = await GoogleSignIn.instance.authenticate();
    final idToken = account.authentication.idToken;
    if (idToken == null) {
      throw FirebaseAuthException(
        code: 'google-sign-in-failed',
        message: 'Google Sign-In did not return an identity token.',
      );
    }
    final credential = GoogleAuthProvider.credential(idToken: idToken);
    final userCredential = await FirebaseAuth.instance.signInWithCredential(
      credential,
    );
    return userCredential.user;
  }

  Future<void> requestPhoneVerification({
    required String phoneNumber,
    required void Function(String verificationId, int? resendToken) onCodeSent,
    required void Function(User user) onVerificationCompleted,
    required void Function(FirebaseAuthException error) onVerificationFailed,
  }) {
    return FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (credential) {
        unawaited(
          _signInWithPhoneCredential(
            credential,
            onVerificationCompleted,
            onVerificationFailed,
          ),
        );
      },
      verificationFailed: onVerificationFailed,
      codeSent: onCodeSent,
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  Future<void> _signInWithPhoneCredential(
    PhoneAuthCredential credential,
    void Function(User user) onVerificationCompleted,
    void Function(FirebaseAuthException error) onVerificationFailed,
  ) async {
    try {
      final result = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      final user = result.user;
      if (user == null) {
        onVerificationFailed(
          FirebaseAuthException(
            code: 'phone-sign-in-failed',
            message: 'Phone sign-in completed without a Firebase user.',
          ),
        );
        return;
      }
      onVerificationCompleted(user);
    } on FirebaseAuthException catch (error) {
      onVerificationFailed(error);
    }
  }

  Future<User> signInWithPhoneVerificationCode({
    required String verificationId,
    required String smsCode,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    final result = await FirebaseAuth.instance.signInWithCredential(credential);
    final user = result.user;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'phone-sign-in-failed',
        message: 'Phone sign-in completed without a Firebase user.',
      );
    }
    return user;
  }

  Future<User?> signInWithFacebook() async {
    final result = await FacebookAuth.instance.login(
      permissions: const ['email', 'public_profile'],
    );
    if (result.status == LoginStatus.cancelled) return null;
    if (result.status != LoginStatus.success || result.accessToken == null) {
      throw FirebaseAuthException(
        code: 'facebook-sign-in-failed',
        message: result.message,
      );
    }
    final credential = FacebookAuthProvider.credential(
      result.accessToken!.tokenString,
    );
    final firebaseCredential = await FirebaseAuth.instance.signInWithCredential(
      credential,
    );
    return firebaseCredential.user;
  }

  Future<void> resendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || user.emailVerified) return;
    await user.sendEmailVerification();
  }

  Future<User?> reloadCurrentUser() async {
    await FirebaseAuth.instance.currentUser?.reload();
    return FirebaseAuth.instance.currentUser;
  }

  Future<void> signOut() async {
    if (!kIsWeb) await GoogleSignIn.instance.signOut();
    await FirebaseAuth.instance.signOut();
  }
}
