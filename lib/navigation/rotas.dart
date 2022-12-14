import 'package:flutter/material.dart';
import 'package:inteligencias_multiplas/screens/questionsPage/question_page.dart';
import '../screens/homePage/home_page.dart';
import '../screens/loginPage/login_page.dart';

class Rotas {
  static Map<String, Widget Function(BuildContext)> routes = {
    '/': (context) => const LoginPage(),
    '/home': (context) => const HomePage(),
    '/questions': (context) => const QuestionsPage()
  };
}
