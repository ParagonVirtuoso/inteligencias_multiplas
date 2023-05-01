import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> signOut() async {
    await _auth.signOut();
  }

  void navTeste(context) {
    Navigator.of(context).pushNamed('/questions');
  }

  void navDevelopers(context) {
    Navigator.of(context).pushNamed('/developers');
  }
}
