import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:inteligencias_multiplas/componentes/modal_vincular_conta.dart';
import 'package:inteligencias_multiplas/controller/homeController/home_controller.dart';
import 'package:inteligencias_multiplas/screens/homePage/componentes/button_drawer.dart';
import 'package:inteligencias_multiplas/screens/homePage/componentes/dialog_sair.dart';
import 'package:inteligencias_multiplas/utils/cores.dart';
import 'package:inteligencias_multiplas/utils/strings.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DrawerCustom extends StatefulWidget {
  final String profilePic;
  final String user;
  final String email;
  final FirebaseAuth? auth;
  final HomeController? homeController;
  final InAppReview? inAppReview;
  final VoidCallback? onAccountLinked;
  final String? appVersion;

  const DrawerCustom({
    super.key,
    required this.profilePic,
    required this.user,
    required this.email,
    this.auth,
    this.homeController,
    this.inAppReview,
    this.onAccountLinked,
    this.appVersion,
  });

  @override
  State<DrawerCustom> createState() => _DrawerCustomState();
}

class _DrawerCustomState extends State<DrawerCustom> {
  late String _user;
  late String _email;
  late String _profilePic;
  late bool _isVisitante;
  String? _appVersion;
  StreamSubscription<User?>? _authSubscription;

  @override
  void initState() {
    super.initState();
    _appVersion = widget.appVersion;
    _atualizarDados();
    _carregarVersaoApp();
    try {
      final auth = widget.auth ?? FirebaseAuth.instance;
      _authSubscription = auth.userChanges().listen((_) {
        if (mounted) {
          setState(() {
            _atualizarDados();
          });
        }
      });
    } catch (_) {}
  }

  Future<void> _carregarVersaoApp() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (mounted && info.version.isNotEmpty) {
        setState(() {
          _appVersion = info.version;
        });
      }
    } catch (_) {}
  }

  @override
  void didUpdateWidget(covariant DrawerCustom oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.appVersion != oldWidget.appVersion) {
      _appVersion = widget.appVersion;
    }
    _atualizarDados();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  void _atualizarDados() {
    User? currentUser;
    try {
      final auth = widget.auth ?? FirebaseAuth.instance;
      currentUser = auth.currentUser;
    } catch (_) {
      currentUser = null;
    }

    if (currentUser != null) {
      _isVisitante = currentUser.isAnonymous;
      final nome = HomeController.extrairNome(currentUser);
      _user = nome.isNotEmpty
          ? nome
          : (widget.user.trim().isNotEmpty ? widget.user : 'Visitante');
      _email = HomeController.extrairEmail(currentUser, fallback: widget.email);
      _profilePic =
          HomeController.extrairFoto(currentUser, fallback: widget.profilePic);
    } else {
      _isVisitante = widget.email.trim().isEmpty ||
          widget.user.trim().isEmpty ||
          widget.user.trim().toLowerCase() == 'visitante';
      _user = widget.user.trim().isNotEmpty ? widget.user : 'Visitante';
      _email = widget.email;
      _profilePic = widget.profilePic;
    }
  }

  void _abrirModalVincularConta() {
    ModalVincularConta.show(
      context: context,
      onGooglePressed: () => _vincularGoogle(),
      onFacebookPressed: () => _vincularFacebook(),
    );
  }

  Future<void> _vincularGoogle() async {
    final controller = widget.homeController ?? HomeController();
    final resultado = await controller.vincularContaGoogle(auth: widget.auth);
    if (!mounted) return;

    if (resultado == true) {
      try {
        final auth = widget.auth ?? FirebaseAuth.instance;
        await auth.currentUser?.reload();
      } catch (_) {}
      if (mounted) {
        setState(() {
          _atualizarDados();
        });
        widget.onAccountLinked?.call();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(Strings.contaVinculadaSucesso),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else if (resultado == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(Strings.erroVincularConta),
          backgroundColor: Cores.kErroColor,
        ),
      );
    }
  }

  Future<void> _vincularFacebook() async {
    final controller = widget.homeController ?? HomeController();
    final resultado = await controller.vincularContaFacebook(auth: widget.auth);
    if (!mounted) return;

    if (resultado == true) {
      try {
        final auth = widget.auth ?? FirebaseAuth.instance;
        await auth.currentUser?.reload();
      } catch (_) {}
      if (mounted) {
        setState(() {
          _atualizarDados();
        });
        widget.onAccountLinked?.call();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(Strings.contaVinculadaSucesso),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else if (resultado == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(Strings.erroVincularConta),
          backgroundColor: Cores.kErroColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.hasBoundedHeight
                  ? constraints.maxHeight
                  : 0.0,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Cores.kAzulGradientUpColor,
                  Cores.kAzulGradientDownColor,
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x330053BE),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  (40.w).clamp(14.0, 24.0),
                  (42.h).clamp(16.0, 26.0),
                  (40.w).clamp(14.0, 24.0),
                  (42.h).clamp(16.0, 26.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _isVisitante ? _abrirModalVincularConta : null,
                          child: Container(
                            width: (175.w).clamp(56.0, 72.0),
                            height: (175.w).clamp(56.0, 72.0),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colors.white24,
                              backgroundImage: _profilePic.trim().isNotEmpty
                                  ? NetworkImage(_profilePic)
                                  : null,
                              child: _profilePic.trim().isEmpty
                                  ? const Icon(Icons.person,
                                      color: Colors.white, size: 36)
                                  : null,
                            ),
                          ),
                        ),
                        SizedBox(width: (28.w).clamp(10.0, 16.0)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _user.trim().isNotEmpty ? _user : 'Visitante',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: (52.sp).clamp(18.0, 22.0),
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Roboto-Regular',
                                ),
                              ),
                              SizedBox(height: 10.h),
                              if (_isVisitante)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: (20.w).clamp(10.0, 16.0),
                                      vertical: (7.h).clamp(4.0, 8.0)),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.22),
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.person,
                                          color: Colors.white, size: (28.sp).clamp(14.0, 18.0)),
                                      SizedBox(width: (8.w).clamp(4.0, 8.0)),
                                      Flexible(
                                        child: Text(
                                          Strings.modoVisitante,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: (28.sp).clamp(11.5, 13.5),
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              else
                                Row(
                                  children: [
                                    Icon(Icons.check_circle,
                                        color: Colors.lightGreenAccent,
                                        size: (34.sp).clamp(16.0, 20.0)),
                                    SizedBox(width: (10.w).clamp(6.0, 10.0)),
                                    Expanded(
                                      child: Text(
                                        _email.trim().isNotEmpty
                                            ? _email
                                            : Strings.contaConectada,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: (32.sp).clamp(12.0, 14.5),
                                          color: Colors.white
                                              .withValues(alpha: 0.95),
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Roboto-Regular',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (_isVisitante) ...[
                      SizedBox(height: (30.h).clamp(12.0, 20.0)),
                      GestureDetector(
                        onTap: _abrirModalVincularConta,
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: (26.w).clamp(12.0, 18.0),
                            vertical: (20.h).clamp(10.0, 14.0),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: (72.r).clamp(32.0, 42.0),
                                height: (72.r).clamp(32.0, 42.0),
                                decoration: const BoxDecoration(
                                  color: Cores.kAzulDrawerItemColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.cloud_upload_outlined,
                                  color: Cores.kAzulBotaoItemColor,
                                  size: (40.sp).clamp(18.0, 22.0),
                                ),
                              ),
                              SizedBox(width: (20.w).clamp(8.0, 14.0)),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      Strings.salvarProgresso,
                                      style: TextStyle(
                                        fontSize: (34.sp).clamp(13.5, 15.5),
                                        color: Cores.kTertiaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Roboto-Regular',
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      Strings.salvarGoogleOuFacebook,
                                      style: TextStyle(
                                        fontSize: (26.sp).clamp(11.0, 12.5),
                                        color: Cores.kDeepGreyColor,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Roboto-Regular',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: (28.sp).clamp(14.0, 18.0),
                                color: Cores.kDeepGreyColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ] else ...[
                      SizedBox(height: (24.h).clamp(10.0, 16.0)),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: (24.w).clamp(12.0, 18.0),
                          vertical: (16.h).clamp(8.0, 12.0),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.25),
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.cloud_done_rounded,
                              color: Colors.white,
                              size: (34.sp).clamp(16.0, 20.0),
                            ),
                            SizedBox(width: (16.w).clamp(8.0, 12.0)),
                            Expanded(
                              child: Text(
                                Strings.progressoSalvoNuvem,
                                style: TextStyle(
                                  fontSize: (28.sp).clamp(11.5, 13.5),
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Roboto-Regular',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: (40.h).clamp(14.0, 24.0),
          ),
          ButtonDrawer(
            icon: Strings.refazerIconAsset,
            text: Strings.refazer,
            corFundo: Cores.kAzulBotaoItemColor,
            corTexto: Cores.kWhiteColor,
            onTap: _resetTest,
          ),
          ButtonDrawer(
            icon: Strings.starIconAsset,
            text: Strings.teste,
            corFundo: Cores.kAzulDrawerItemColor,
            corTexto: Cores.kTertiaryColor,
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/home');
            },
          ),
          ButtonDrawer(
            icon: Strings.desenvolvedoresIconAsset,
            text: Strings.desenvolvedores,
            corFundo: Cores.kAzulDrawerItemColor,
            corTexto: Cores.kTertiaryColor,
            onTap: () {
              HomeController().navDevelopers(context);
            },
          ),
          ButtonDrawer(
            icon: Strings.termosUsoAppIconAsset,
            text: Strings.termosUso,
            corFundo: Cores.kAzulDrawerItemColor,
            corTexto: Cores.kTertiaryColor,
            onTap: () {
              HomeController().navTerms(context);
            },
          ),
          ButtonDrawer(
            icon: Strings.sobreAppIconAsset,
            text: Strings.sobreApp,
            corFundo: Cores.kAzulDrawerItemColor,
            corTexto: Cores.kTertiaryColor,
            onTap: () {
              HomeController().navAbout(context);
            },
          ),
          ButtonDrawer(
            icon: Strings.starFullIconAsset,
            text: Strings.avaliarApp,
            corFundo: Cores.kAzulDrawerItemColor,
            corTexto: Cores.kTertiaryColor,
            onTap: _avaliarApp,
          ),
          const Spacer(),
          SizedBox(height: (24.h).clamp(12.0, 20.0)),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: ButtonDrawer(
              icon: Strings.sairAppIconAsset,
              text: Strings.sair,
              corFundo: Cores.kCinzaSairBotao,
              corTexto: Cores.kCinzaTextoIconeSair,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return DialogSair.conta(
                      onConfirm: () async {
                        Navigator.pop(dialogContext);
                        await (widget.homeController ?? HomeController())
                            .signOut();
                        _navigateToLoginPage();
                      },
                    );
                  },
                );
              },
            ),
          ),
          if (_appVersion != null && _appVersion!.trim().isNotEmpty)
            Container(
              margin: EdgeInsets.only(
                top: (20.h).clamp(10.0, 16.0),
                bottom: (40.h).clamp(16.0, 28.0) +
                    MediaQuery.paddingOf(context).bottom,
              ),
              child: Text(
                'Versão $_appVersion',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: (30.sp).clamp(11.5, 13.5),
                  color: Cores.kDeepGreyColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          else
            SizedBox(
              height: (40.h).clamp(16.0, 28.0) +
                  MediaQuery.paddingOf(context).bottom,
            ),
        ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _avaliarApp() async {
    final controller = widget.homeController ?? HomeController();
    final review = widget.inAppReview;
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    await controller.avaliarApp(inAppReview: review);
  }

  void _navigateToLoginPage() {
    Navigator.pushReplacementNamed(context, '/');
  }

  Future<void> _resetTest() async {
    final auth = widget.auth ?? FirebaseAuth.instance;
    final currentUser = auth.currentUser;
    if (currentUser == null) {
      _showSnackBar(Strings.dadosTesteVazio, Cores.kAlertaColor);
      return;
    }
    final databaseRef = FirebaseDatabase.instance
        .ref()
        .child('usuarios')
        .child(currentUser.uid);
    final userProgressDataSnapshot = await databaseRef.get();

    if (userProgressDataSnapshot.exists &&
        userProgressDataSnapshot.value != null) {
      await databaseRef
          .remove()
          .onError((error, stackTrace) =>
              _showSnackBar(Strings.erroApagarDados, Cores.kErroColor))
          .then((value) =>
              _showSnackBar(Strings.dadosTesteApagado, Colors.green));
    } else {
      _showSnackBar(Strings.dadosTesteVazio, Cores.kAlertaColor);
    }
  }

  void _showSnackBar(String messageError, Color color) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(messageError),
        backgroundColor: color,
      ),
    );
  }
}
