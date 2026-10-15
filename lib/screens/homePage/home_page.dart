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
  FirebaseAuth? get _auth {
    try {
      return FirebaseAuth.instance;
    } catch (_) {
      return null;
    }
  }
  StreamSubscription<User?>? _authSubscription;
  var _user = '';
  var _profilePic = '';
  var _email = '';
  bool _hasSavedProgress = false;

  @override
  void initState() {
    super.initState();
    _atualizarDadosUsuario();
    _verificarProgressoSalvo();
    try {
      _authSubscription = _auth?.userChanges().listen((_) {
        if (mounted) {
          setState(() {
            _atualizarDadosUsuario();
          });
          _verificarProgressoSalvo();
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
      currentUser = _auth?.currentUser;
    } catch (_) {
      currentUser = null;
    }
    _user = HomeController.extrairNome(currentUser, fallback: '');
    _profilePic = HomeController.extrairFoto(currentUser, fallback: '');
    _email = HomeController.extrairEmail(currentUser, fallback: '');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 840;

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
            width: (780.w).clamp(280.0, 360.0),
            child: DrawerCustom(
              profilePic: _profilePic,
              user: _user,
              email: _email,
              onAccountLinked: () {
                setState(() {
                  _atualizarDadosUsuario();
                });
                _verificarProgressoSalvo();
              },
            ),
          ),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            systemOverlayStyle: _statusBarIcon,
            iconTheme: const IconThemeData(color: Colors.white),
            toolbarHeight: isDesktop ? 88.0 : null,
            automaticallyImplyLeading: !isDesktop,
            leadingWidth: isDesktop
                ? null
                : ((32.w).clamp(12.0, 24.0) + 48.0),
            leading: isDesktop
                ? null
                : Builder(
                    builder: (scaffoldContext) => Padding(
                      padding: EdgeInsets.only(
                        left: (32.w).clamp(12.0, 24.0),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.menu),
                        tooltip: MaterialLocalizations.of(scaffoldContext)
                            .openAppDrawerTooltip,
                        onPressed: () =>
                            Scaffold.of(scaffoldContext).openDrawer(),
                      ),
                    ),
                  ),
            titleSpacing: isDesktop ? 0 : null,
            title: isDesktop
                ? Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 680),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Builder(
                              builder: (scaffoldContext) => IconButton(
                                icon: const Icon(Icons.menu,
                                    color: Colors.white, size: 26),
                                tooltip:
                                    MaterialLocalizations.of(scaffoldContext)
                                        .openAppDrawerTooltip,
                                onPressed: () => Scaffold.of(scaffoldContext)
                                    .openDrawer(),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Container(
                              width: 48,
                              height: 48,
                              decoration:
                                  const BoxDecoration(shape: BoxShape.circle),
                              child: CircleAvatar(
                                backgroundColor: Colors.white24,
                                backgroundImage: _profilePic.trim().isNotEmpty
                                    ? NetworkImage(_profilePic)
                                    : null,
                                child: _profilePic.trim().isEmpty
                                    ? const Icon(Icons.person,
                                        color: Colors.white, size: 28)
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  Strings.bemVindoTelaHome,
                                  style: const TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: 'Roboto-Regular',
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                    _user.trim().isNotEmpty
                                        ? '$_user.'
                                        : Strings.visitantePonto,
                                    style: const TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.white,
                                        fontFamily: 'Roboto-Regular',
                                        fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : null,
          ),
          body: Flex(
            direction: Axis.vertical,
            children: [
              if (!isDesktop)
                Container(
                    height: (370.h).clamp(100.0, 140.0),
                    width: double.infinity,
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        Container(
                          width: (200.r).clamp(60.0, 90.0),
                          height: (200.r).clamp(60.0, 90.0),
                          margin: EdgeInsets.only(
                              left: (40.w).clamp(16.0, 32.0),
                              right: (40.w).clamp(16.0, 32.0)),
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
                            child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                Strings.bemVindoTelaHome,
                                style: TextStyle(
                                    fontSize: (65.sp).clamp(18.0, 24.0),
                                    fontFamily: 'Roboto-Regular',
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                  _user.trim().isNotEmpty
                                      ? '$_user.'
                                      : Strings.visitantePonto,
                                  style: TextStyle(
                                      fontSize: (75.sp).clamp(20.0, 28.0),
                                      color: Colors.white,
                                      fontFamily: 'Roboto-Regular',
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ))
                      ],
                    )),
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                      top: isDesktop ? 28.0 : (50.h).clamp(24.0, 40.0),
                      left: isDesktop ? 28.0 : (90.w).clamp(24.0, 48.0),
                      right: isDesktop ? 28.0 : (90.w).clamp(24.0, 48.0),
                      bottom: isDesktop ? 16.0 : 0.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 680),
                      child: CardTutorial(
                        buscarDadosTeste: buscarDadosTeste,
                        hasSavedProgress: _hasSavedProgress,
                      ),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }

  Future<void> _verificarProgressoSalvo() async {
    final user = _auth?.currentUser;
    if (user == null) {
      if (mounted && _hasSavedProgress) {
        setState(() {
          _hasSavedProgress = false;
        });
      }
      return;
    }

    try {
      FirebaseDatabase database = FirebaseDatabase.instance;
      final userProgressDataSnapshot = await database
          .ref()
          .child('usuarios')
          .child(user.uid)
          .get();

      if (userProgressDataSnapshot.exists &&
          userProgressDataSnapshot.value != null) {
        final data = userProgressDataSnapshot.value as Map<Object?, Object?>?;
        if (data != null) {
          bool temEtapa = false;
          for (int i = 1; i <= 10; i++) {
            if (data['ETAPA $i'] != null) {
              temEtapa = true;
              break;
            }
          }
          if (mounted) {
            setState(() {
              _hasSavedProgress = temEtapa;
            });
            return;
          }
        }
      }
    } catch (_) {}

    if (mounted && _hasSavedProgress) {
      setState(() {
        _hasSavedProgress = false;
      });
    }
  }

  Future<dynamic> buscarDadosTeste() async {
    final user = _auth?.currentUser;
    if (user == null) return true;
    try {
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
          if (data != null) {
            bool temEtapa = false;
            for (int i = 1; i <= 10; i++) {
              if (data['ETAPA $i'] != null) {
                temEtapa = true;
                break;
              }
            }
            if (temEtapa) {
              await navigateToQuestions(data);
              return false;
            }
          }
        }
      }
    } catch (_) {}
    return true;
  }

  Future<void> navigateToQuestions(dynamic data) async {
    await Navigator.pushNamed(context, Strings.questionsNavigate, arguments: data);
    if (mounted) {
      _verificarProgressoSalvo();
    }
  }
}
