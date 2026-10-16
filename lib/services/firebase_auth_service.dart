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

  Future<void> signOut() async {
    if (!kIsWeb) await GoogleSignIn.instance.signOut();
    await FirebaseAuth.instance.signOut();
  }
}
