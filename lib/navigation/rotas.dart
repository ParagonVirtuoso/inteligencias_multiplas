import 'package:flutter/material.dart';
import '../screens/homePage/home_page.dart';
import '../screens/loginPage/login_page.dart';

class Rotas {
  static Map<String, Widget Function(BuildContext)> routes = {
    '/': (context) => const LoginPage(),
    '/home': (context) => const HomePage()
  };
}
