import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../app_config.dart';

class FirebaseAuthService {
  const FirebaseAuthService();

  static bool get isInitialized => Firebase.apps.isNotEmpty;

  static Future<void> initialize() async {
    if (!AppConfig.isFirebaseAuthConfigured || isInitialized) return;
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: AppConfig.firebaseApiKey,
        appId: AppConfig.firebaseAppId,
        messagingSenderId: AppConfig.firebaseMessagingSenderId,
        projectId: AppConfig.firebaseProjectId,
      ),
    );
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

  Future<void> signOut() => FirebaseAuth.instance.signOut();
}
