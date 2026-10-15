import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:in_app_review/in_app_review.dart';

class HomeController {
  FirebaseAuth get _auth => FirebaseAuth.instance;
  Future<void> signOut() async {
    await _auth.signOut();
  }

  void navTeste(context) {
    Navigator.of(context).pushNamed('/questions');
  }

  void navDevelopers(context) {
    Navigator.of(context).pushNamed('/developers');
  }

  void navAbout(context) {
    Navigator.of(context).pushNamed('/about');
  }

  void navTerms(context) {
    Navigator.of(context).pushNamed('/terms');
  }

  Future<void> avaliarApp({InAppReview? inAppReview, String? appStoreId}) async {
    if (kIsWeb) return;
    final review = inAppReview ?? InAppReview.instance;
    try {
      await review.openStoreListing(appStoreId: appStoreId);
    } catch (_) {
      try {
        final reviewDisponivel = await review.isAvailable();
        if (reviewDisponivel) {
          await review.requestReview();
        }
      } catch (_) {}
    }
  }

  static String extrairEmail(User? user, {String fallback = ''}) {
    if (user == null) return fallback;
    if (user.email != null && user.email!.trim().isNotEmpty) {
      return user.email!.trim();
    }
    for (final provider in user.providerData) {
      if (provider.email != null && provider.email!.trim().isNotEmpty) {
        return provider.email!.trim();
      }
    }
    return fallback;
  }

  static String extrairNome(User? user, {String fallback = ''}) {
    if (user == null) return fallback;
    if (user.displayName != null && user.displayName!.trim().isNotEmpty) {
      return user.displayName!.trim();
    }
    for (final provider in user.providerData) {
      if (provider.displayName != null &&
          provider.displayName!.trim().isNotEmpty) {
        return provider.displayName!.trim();
      }
    }
    final email = extrairEmail(user);
    if (email.isNotEmpty && email.contains('@')) {
      final part = email.split('@').first;
      if (part.isNotEmpty) return part;
    }
    return fallback;
  }

  static String extrairFoto(User? user, {String fallback = ''}) {
    if (user == null) return fallback;
    if (user.photoURL != null && user.photoURL!.trim().isNotEmpty) {
      return user.photoURL!.trim();
    }
    for (final provider in user.providerData) {
      if (provider.photoURL != null && provider.photoURL!.trim().isNotEmpty) {
        return provider.photoURL!.trim();
      }
    }
    return fallback;
  }

  Future<bool?> vincularContaGoogle({
    FirebaseAuth? auth,
    GoogleSignIn? googleSignIn,
  }) async {
    final firebaseAuth = auth ?? _auth;

    if (kIsWeb) {
      try {
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        final currentUser = firebaseAuth.currentUser;
        if (currentUser != null && currentUser.isAnonymous) {
          try {
            final userCredential =
                await currentUser.linkWithPopup(googleProvider);
            await userCredential.user?.reload();
            return true;
          } on FirebaseAuthException catch (e) {
            if (e.code == 'credential-already-in-use') {
              final userCredential =
                  await firebaseAuth.signInWithPopup(googleProvider);
              await userCredential.user?.reload();
              return true;
            }
            if (e.code == 'popup-closed-by-user') {
              return null;
            }
            return false;
          }
        } else {
          final userCredential =
              await firebaseAuth.signInWithPopup(googleProvider);
          await userCredential.user?.reload();
          return true;
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'popup-closed-by-user') return null;
        debugPrint('Erro ao vincular conta Google no Web: $e');
        return false;
      } catch (e) {
        debugPrint('Erro ao vincular conta Google no Web: $e');
        return false;
      }
    }

    final google = googleSignIn ?? GoogleSignIn();

    try {
      final googleUser = await google.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final currentUser = firebaseAuth.currentUser;
      if (currentUser != null && currentUser.isAnonymous) {
        try {
          final userCredential =
              await currentUser.linkWithCredential(credential);
          final user = userCredential.user ?? firebaseAuth.currentUser;
          if (user != null) {
            if ((user.displayName == null || user.displayName!.isEmpty) &&
                googleUser.displayName != null &&
                googleUser.displayName!.isNotEmpty) {
              await user.updateDisplayName(googleUser.displayName);
            }
            if ((user.photoURL == null || user.photoURL!.isEmpty) &&
                googleUser.photoUrl != null &&
                googleUser.photoUrl!.isNotEmpty) {
              await user.updatePhotoURL(googleUser.photoUrl);
            }
            await user.reload();
          }
          return true;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'credential-already-in-use') {
            final userCredential =
                await firebaseAuth.signInWithCredential(credential);
            await userCredential.user?.reload();
            return true;
          }
          return false;
        }
      } else {
        final userCredential =
            await firebaseAuth.signInWithCredential(credential);
        await userCredential.user?.reload();
        return true;
      }
    } catch (e) {
      debugPrint('Erro ao vincular conta Google: $e');
      return false;
    }
  }

  Future<bool?> vincularContaFacebook({
    FirebaseAuth? auth,
    FacebookAuth? facebookAuth,
  }) async {
    final firebaseAuth = auth ?? _auth;

    if (kIsWeb) {
      try {
        final FacebookAuthProvider facebookProvider = FacebookAuthProvider();
        final currentUser = firebaseAuth.currentUser;
        if (currentUser != null && currentUser.isAnonymous) {
          try {
            final userCredential =
                await currentUser.linkWithPopup(facebookProvider);
            await userCredential.user?.reload();
            return true;
          } on FirebaseAuthException catch (e) {
            if (e.code == 'credential-already-in-use') {
              final userCredential =
                  await firebaseAuth.signInWithPopup(facebookProvider);
              await userCredential.user?.reload();
              return true;
            }
            if (e.code == 'popup-closed-by-user') {
              return null;
            }
            return false;
          }
        } else {
          final userCredential =
              await firebaseAuth.signInWithPopup(facebookProvider);
          await userCredential.user?.reload();
          return true;
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'popup-closed-by-user') return null;
        debugPrint('Erro ao vincular conta Facebook no Web: $e');
        return false;
      } catch (e) {
        debugPrint('Erro ao vincular conta Facebook no Web: $e');
        return false;
      }
    }

    final fb = facebookAuth ?? FacebookAuth.instance;

    try {
      final LoginResult loginResult = await fb.login();
      if (loginResult.status != LoginStatus.success ||
          loginResult.accessToken == null) {
        return null;
      }

      final OAuthCredential credential = FacebookAuthProvider.credential(
        loginResult.accessToken!.tokenString,
      );

      final currentUser = firebaseAuth.currentUser;
      if (currentUser != null && currentUser.isAnonymous) {
        try {
          final userCredential =
              await currentUser.linkWithCredential(credential);
          final userData = await fb.getUserData();
          final user = userCredential.user ?? firebaseAuth.currentUser;
          if (user != null) {
            final fbName = userData['name'] as String?;
            final fbPic = (userData['picture'] is Map &&
                    userData['picture']['data'] is Map)
                ? userData['picture']['data']['url'] as String?
                : null;
            if ((user.displayName == null || user.displayName!.isEmpty) &&
                fbName != null &&
                fbName.isNotEmpty) {
              await user.updateDisplayName(fbName);
            }
            if ((user.photoURL == null || user.photoURL!.isEmpty) &&
                fbPic != null &&
                fbPic.isNotEmpty) {
              await user.updatePhotoURL(fbPic);
            }
            await user.reload();
          }
          return true;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'credential-already-in-use') {
            final userCredential =
                await firebaseAuth.signInWithCredential(credential);
            await fb.getUserData();
            await userCredential.user?.reload();
            return true;
          }
          return false;
        }
      } else {
        final userCredential =
            await firebaseAuth.signInWithCredential(credential);
        await fb.getUserData();
        await userCredential.user?.reload();
        return true;
      }
    } catch (e) {
      debugPrint('Erro ao vincular conta Facebook: $e');
      return false;
    }
  }
}
