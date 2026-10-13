import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
}
