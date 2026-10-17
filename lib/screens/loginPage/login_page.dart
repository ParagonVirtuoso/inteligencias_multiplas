import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inteligencias_multiplas/utils/cores.dart';
import 'package:inteligencias_multiplas/utils/strings.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'componentes/carousel.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class LoginPage extends StatefulWidget {
  final bool? isWebOverride;

  const LoginPage({super.key, this.isWebOverride});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool carrega = true;

  bool _detectIsWeb(BuildContext context) {
    if (widget.isWebOverride != null) return widget.isWebOverride!;
    if (kIsWeb) return true;
    final width = MediaQuery.maybeOf(context)?.size.width ?? 0;
    return width > 600;
  }

  double _calculateWebTopHeight(double screenHeight) {
    final ratio =
        (0.38 + 0.14 * ((screenHeight - 500.0) / 580.0)).clamp(0.38, 0.52);
    return screenHeight * ratio;
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance
        .addPostFrameCallback((_) => _recuperarDadosUsuario());
  }

  Future<void> _realizarLoginGoogle() async {
    setState(() => carrega = true);

    try {
      final User? user;
      if (kIsWeb) {
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        final result =
            await FirebaseAuth.instance.signInWithPopup(googleProvider);
        user = result.user;
      } else {
        final googleUser = await GoogleSignIn().signIn();
        final googleAuth = await googleUser?.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        final result =
            await FirebaseAuth.instance.signInWithCredential(credential);
        user = result.user;
      }

      if (user != null) _navigateToHome();
    } catch (e) {
      debugPrint('Erro no login com Google: $e');
    } finally {
      if (mounted) {
        setState(() => carrega = false);
      }
    }
  }

  Future<void> _realizarLoginFacebook() async {
    setState(() {
      carrega = true;
    });
    try {
      final User? user;
      if (kIsWeb) {
        final FacebookAuthProvider facebookProvider = FacebookAuthProvider();
        final result =
            await FirebaseAuth.instance.signInWithPopup(facebookProvider);
        user = result.user;
      } else {
        final LoginResult loginResult = await FacebookAuth.instance.login();
        if (loginResult.status == LoginStatus.success &&
            loginResult.accessToken != null) {
          final OAuthCredential facebookAuthCredential =
              FacebookAuthProvider.credential(
                  loginResult.accessToken!.tokenString);

          final result = await FirebaseAuth.instance
              .signInWithCredential(facebookAuthCredential);
          await FacebookAuth.instance.getUserData();
          user = result.user;
        } else {
          user = null;
        }
      }
      if (user != null) {
        _navigateToHome();
      }
    } catch (e) {
      debugPrint('Erro no login com Facebook: $e');
    } finally {
      if (mounted) {
        setState(() {
          carrega = false;
        });
      }
    }
  }

  Future<void> _continuarComoVisitante() async {
    setState(() => carrega = true);
    try {
      if (FirebaseAuth.instance.currentUser == null) {
        await FirebaseAuth.instance.signInAnonymously();
      }
    } catch (e) {
      debugPrint('Continuando como visitante: $e');
    } finally {
      if (mounted) {
        setState(() => carrega = false);
        _navigateToHome();
      }
    }
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  Future<void> _recuperarDadosUsuario() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? user = auth.currentUser;
      if (user != null) {
        Navigator.pushReplacementNamed(context, Strings.homeNavigate);
      }
    } catch (_) {}
    if (mounted) {
      setState(() {
        carrega = false;
      });
    }
  }

  void _exibirModalTermos() {
    final isWeb = _detectIsWeb(context);
    if (isWeb) {
      _exibirModalTermosWeb();
    } else {
      _exibirModalTermosMobile();
    }
  }

  void _exibirModalTermosWeb() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext modalContext) {
        final screenHeight =
            MediaQuery.maybeOf(modalContext)?.size.height ?? 800.0;
        return Dialog(
          backgroundColor: Cores.kWhiteColor,
          surfaceTintColor: Colors.transparent,
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          insetPadding: EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: screenHeight < 500 ? 16.0 : 32.0,
          ),
          clipBehavior: Clip.antiAlias,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 500.0,
              maxHeight: (screenHeight * 0.85).clamp(240.0, 580.0),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28.0, 24.0, 28.0, 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          Strings.termosUso,
                          style: const TextStyle(
                            fontSize: 22.0,
                            color: Cores.kQuaternaryColor,
                            fontFamily: 'Roboto-Regular',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(modalContext),
                        icon: const Icon(
                          Icons.close,
                          color: Cores.kDeepGreyColor,
                          size: 22.0,
                        ),
                        tooltip: 'Fechar',
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 36.0,
                          minHeight: 36.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  const Divider(thickness: 1, height: 1),
                  const SizedBox(height: 20.0),
                  Flexible(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Strings.termosDescricao,
                            style: const TextStyle(
                              fontSize: 15.0,
                              color: Cores.kQuaternaryColor,
                              fontFamily: 'Roboto-Regular',
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Text(
                            Strings.sobreAppDescricao,
                            style: const TextStyle(
                              fontSize: 13.5,
                              color: Cores.kDeepGreyColor,
                              fontFamily: 'Roboto-Regular',
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  SizedBox(
                    width: double.infinity,
                    height: 48.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Cores.kAzulBotaoItemColor,
                        foregroundColor: Cores.kWhiteColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                      ),
                      onPressed: () => Navigator.pop(modalContext),
                      child: const Text(
                        'Entendido',
                        style: TextStyle(
                          color: Cores.kWhiteColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Roboto-Regular',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _exibirModalTermosMobile() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext modalContext) {
        final screenHeight =
            MediaQuery.maybeOf(modalContext)?.size.height ?? 800.0;
        return Align(
          alignment: Alignment.bottomCenter,
          child: SafeArea(
            top: false,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 640),
              height: (1050.h)
                  .clamp(260.0, (screenHeight * 0.85).clamp(260.0, 680.0)),
              padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 30.h),
              decoration: BoxDecoration(
                color: Cores.kWhiteColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.r),
                  topRight: Radius.circular(50.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    key: const Key('terms_modal_drag_handle'),
                    width: 100.w,
                    height: 10.h,
                    margin: EdgeInsets.only(bottom: 25.h),
                    decoration: BoxDecoration(
                      color: Cores.kDarkGreyColor.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          Strings.termosUso,
                          style: TextStyle(
                            fontSize: 52.sp,
                            color: Cores.kQuaternaryColor,
                            fontFamily: 'Roboto-Regular',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(modalContext),
                        icon: const Icon(
                          Icons.close,
                          color: Cores.kDeepGreyColor,
                        ),
                      ),
                    ],
                  ),
                  const Divider(thickness: 1),
                  SizedBox(height: 20.h),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Strings.termosDescricao,
                            style: TextStyle(
                              fontSize: 42.sp,
                              color: Cores.kQuaternaryColor,
                              fontFamily: 'Roboto-Regular',
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: 30.h),
                          Text(
                            Strings.sobreAppDescricao,
                            style: TextStyle(
                              fontSize: 38.sp,
                              color: Cores.kDeepGreyColor,
                              fontFamily: 'Roboto-Regular',
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    width: double.infinity,
                    height: 115.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Cores.kAzulBotaoItemColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                      ),
                      onPressed: () => Navigator.pop(modalContext),
                      child: Text(
                        'Entendido',
                        style: TextStyle(
                          color: Cores.kWhiteColor,
                          fontSize: 42.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Roboto-Regular',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (carrega == true) {
      return const Scaffold(
        backgroundColor: Cores.kSecondaryColor,
        body: Center(
          child: CircularProgressIndicator(
            color: Cores.kWhiteColor,
          ),
        ),
      );
    } else {
      final isWeb = _detectIsWeb(context);
      final mediaQuery = MediaQuery.of(context);
      final screenHeight = mediaQuery.size.height;

      return Scaffold(
          backgroundColor: Cores.kSecondaryColor,
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: Cores.statusBarColorTransp,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                    padding: EdgeInsets.only(
                      top: isWeb
                          ? (screenHeight * 0.035).clamp(12.0, 38.0)
                          : 150.h,
                    ),
                    width: double.infinity,
                    height:
                        isWeb ? _calculateWebTopHeight(screenHeight) : 1020.h,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(Strings.fundoBrainAsset),
                          fit: BoxFit.contain,
                          alignment: Alignment.topLeft,
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Cores.kTertiaryColor,
                            Cores.kSecondaryColor,
                          ],
                        )),
                    child: Carousel(isWebOverride: isWeb)),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Cores.kWhiteColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(80.r),
                          topRight: Radius.circular(80.r)),
                    ),
                    child: LayoutBuilder(
                      builder: (context, cardConstraints) {
                        return SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: cardConstraints.maxHeight,
                            ),
                            child: Center(
                              child: ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 480),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: (65.w).clamp(20.0, 32.0),
                                    vertical: isWeb
                                        ? (screenHeight < 650 ? 10.0 : 16.0)
                                        : (35.h).clamp(16.0, 30.0),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      if (!isWeb) SizedBox(height: 20.h),
                                      Text(
                                        Strings.entrarTelaLogin,
                                        style: TextStyle(
                                            color: const Color(0xFF202124),
                                            fontSize: isWeb
                                                ? (screenHeight < 650
                                                    ? 56.sp
                                                    : 64.sp)
                                                : 70.sp,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Roboto-Regular'),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                          height: isWeb
                                              ? (screenHeight < 650 ? 6.0 : 8.0)
                                              : 12.h),
                                      Text(
                                        Strings.auxAcesseSalvarProgresso,
                                        style: TextStyle(
                                            color: const Color(0xFF5F6368),
                                            fontSize: isWeb
                                                ? (screenHeight < 650
                                                    ? 32.sp
                                                    : 36.sp)
                                                : 38.sp,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Roboto-Regular'),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                          height: isWeb
                                              ? (screenHeight < 650
                                                  ? 16.0
                                                  : 20.0)
                                              : 50.h),
                                      // Botão Google
                                      GestureDetector(
                                        onTap: _realizarLoginGoogle,
                                        behavior: HitTestBehavior.opaque,
                                        child: Container(
                                          height: isWeb
                                              ? (screenHeight < 650
                                                  ? 46.0
                                                  : 48.0)
                                              : (135.h).clamp(48.0, 54.0),
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  (20.w).clamp(12.0, 20.0)),
                                          decoration: BoxDecoration(
                                            color: Cores.kWhiteColor,
                                            borderRadius:
                                                BorderRadius.circular(30.r),
                                            border: Border.all(
                                              color: const Color(0xFFDADCE0),
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                Strings.googleIconAsset,
                                                width: isWeb ? 22.0 : 48.r,
                                                height: isWeb ? 22.0 : 48.r,
                                                fit: BoxFit.contain,
                                              ),
                                              SizedBox(
                                                  width: isWeb
                                                      ? 12.0
                                                      : (25.w)
                                                          .clamp(10.0, 16.0)),
                                              Flexible(
                                                child: Text(
                                                  Strings
                                                      .continuarComGoogleTelaLogin,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color:
                                                        const Color(0xFF3C4043),
                                                    fontSize: isWeb
                                                        ? (screenHeight < 650
                                                            ? 32.sp
                                                            : 36.sp)
                                                        : 38.sp,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily:
                                                        'Roboto-Regular',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          height: isWeb
                                              ? (screenHeight < 650
                                                  ? 10.0
                                                  : 12.0)
                                              : 32.h),
                                      // Botão Facebook
                                      GestureDetector(
                                        onTap: _realizarLoginFacebook,
                                        behavior: HitTestBehavior.opaque,
                                        child: Container(
                                          height: isWeb
                                              ? (screenHeight < 650
                                                  ? 46.0
                                                  : 48.0)
                                              : (135.h).clamp(48.0, 54.0),
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  (20.w).clamp(12.0, 20.0)),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF1877F2),
                                            borderRadius:
                                                BorderRadius.circular(30.r),
                                            border: Border.all(
                                              color: const Color(0xFF1877F2),
                                              width: 1.5,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                Strings.facebookIconAsset,
                                                width: isWeb ? 22.0 : 48.r,
                                                height: isWeb ? 22.0 : 48.r,
                                                fit: BoxFit.contain,
                                              ),
                                              SizedBox(
                                                  width: isWeb
                                                      ? 12.0
                                                      : (25.w)
                                                          .clamp(10.0, 16.0)),
                                              Flexible(
                                                child: Text(
                                                  Strings
                                                      .continuarComFacebookTelaLogin,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: isWeb
                                                        ? (screenHeight < 650
                                                            ? 32.sp
                                                            : 36.sp)
                                                        : 38.sp,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily:
                                                        'Roboto-Regular',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          height: isWeb
                                              ? (screenHeight < 650
                                                  ? 10.0
                                                  : 12.0)
                                              : 36.h),
                                      // Continuar como visitante
                                      GestureDetector(
                                        onTap: _continuarComoVisitante,
                                        behavior: HitTestBehavior.opaque,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: isWeb
                                                  ? (screenHeight < 650
                                                      ? 3.0
                                                      : 4.0)
                                                  : 15.h),
                                          child: Text(
                                            Strings
                                                .continuarComoVisitanteTelaLogin,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: const Color(0xFF5F6368),
                                              fontSize: isWeb
                                                  ? (screenHeight < 650
                                                      ? 32.sp
                                                      : 36.sp)
                                                  : 40.sp,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Roboto-Regular',
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          height: isWeb
                                              ? (screenHeight < 650
                                                  ? 10.0
                                                  : 14.0)
                                              : 55.h),
                                      // Termos e Política de Privacidade no rodapé
                                      MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: GestureDetector(
                                          onTap: _exibirModalTermos,
                                          behavior: HitTestBehavior.opaque,
                                        child: Text(
                                          Strings.termosPoliticaRodapeTelaLogin,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: const Color(0xFF70757A),
                                            fontSize: isWeb
                                                ? (screenHeight < 650
                                                    ? 26.sp
                                                    : 28.sp)
                                                : 32.sp,
                                            fontFamily: 'Roboto-Regular',
                                            height: 1.3,
                                          ),
                                        ),
                                      ),
                                    ),
                                      if (!isWeb) SizedBox(height: 20.h),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ));
    }
  }
}
