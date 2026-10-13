import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inteligencias_multiplas/controller/homeController/home_controller.dart';
import 'package:inteligencias_multiplas/screens/homePage/componentes/card_tutorial.dart';
import 'package:inteligencias_multiplas/screens/homePage/componentes/drawer_custom.dart';
import 'package:inteligencias_multiplas/utils/cores.dart';
import 'package:inteligencias_multiplas/utils/strings.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _statusBarIcon = SystemUiOverlayStyle.light;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription<User?>? _authSubscription;
  var _user = '';
  var _profilePic = '';
  var _email = '';

  @override
  void initState() {
    super.initState();
    _atualizarDadosUsuario();
    buscarDadosTeste();
    try {
      _authSubscription = _auth.userChanges().listen((_) {
        if (mounted) {
          setState(() {
            _atualizarDadosUsuario();
          });
        }
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  void _atualizarDadosUsuario() {
    User? currentUser;
    try {
      currentUser = _auth.currentUser;
    } catch (_) {
      currentUser = null;
    }
    _user = HomeController.extrairNome(currentUser, fallback: '');
    _profilePic = HomeController.extrairFoto(currentUser, fallback: '');
    _email = HomeController.extrairEmail(currentUser, fallback: '');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Cores.kAzulGradientUpColor,
            Cores.kAzulGradientDownColor,
          ],
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          onDrawerChanged: (value) {
            if (value) {
              _atualizarDadosUsuario();
            }
            setState(() {
              _statusBarIcon = value
                  ? SystemUiOverlayStyle.dark
                  : SystemUiOverlayStyle.light;
            });
          },
          drawer: Drawer(
            width: 780.w,
            child: DrawerCustom(
              profilePic: _profilePic,
              user: _user,
              email: _email,
              onAccountLinked: () {
                setState(() {
                  _atualizarDadosUsuario();
                });
              },
            ),
          ),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            systemOverlayStyle: _statusBarIcon,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Flex(
            direction: Axis.vertical,
            children: [
              Container(
                  height: 370.h,
                  width: 1080.w,
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Container(
                        width: 200.w,
                        height: 200.h,
                        margin: EdgeInsets.only(left: 40.w, right: 40.w),
                        child: CircleAvatar(
                          backgroundColor: Colors.white24,
                          backgroundImage: _profilePic.trim().isNotEmpty
                              ? NetworkImage(_profilePic)
                              : null,
                          child: _profilePic.trim().isEmpty
                              ? const Icon(Icons.person,
                                  color: Colors.white, size: 40)
                              : null,
                        ),
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            Strings.bemVindoTelaHome,
                            style: TextStyle(
                                fontSize: 65.sp,
                                fontFamily: 'Roboto-Regular',
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                              _user.trim().isNotEmpty
                                  ? '$_user.'
                                  : 'Visitante.',
                              style: TextStyle(
                                  fontSize: 75.sp,
                                  color: Colors.white,
                                  fontFamily: 'Roboto-Regular',
                                  fontWeight: FontWeight.w700)),
                        ],
                      ))
                    ],
                  )),
              Expanded(
                flex: 1,
                child: Container(
                  padding:
                      EdgeInsets.only(top: 50.h, left: 90.w, right: 90.w),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: CardTutorial(buscarDadosTeste: buscarDadosTeste),
                ),
              )
            ],
          )),
    );
  }

  Future<dynamic> buscarDadosTeste() async {
    final user = _auth.currentUser;
    if (user == null) return true;
    FirebaseDatabase database = FirebaseDatabase.instance;
    final userProgressDataSnapshot = await database
        .ref()
        .child('usuarios')
        .child(user.uid)
        .get();
    if (userProgressDataSnapshot.exists) {
      if (userProgressDataSnapshot.value != null) {
        Map<Object?, Object?>? data =
            userProgressDataSnapshot.value as Map<Object?, Object?>?;
        var etapa1 = data!['ETAPA 1'];
        if (etapa1 != null) {
          navigateToQuestions(data);
          return false;
        }
      }
    }
    return true;
  }

  void navigateToQuestions(dynamic data) {
    Navigator.pushNamed(context, '/questions', arguments: data);
  }
}
