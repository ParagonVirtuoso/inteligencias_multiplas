import 'package:firebase_auth/firebase_auth.dart';
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
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool carrega = true;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance
        .addPostFrameCallback((_) => _recuperarDadosUsuario());
  }

  Future<void> _realizarLoginGoogle() async {
    setState(() => carrega = true);

    try {
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final result =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final user = result.user;

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
      final LoginResult loginResult = await FacebookAuth.instance.login();
      if (loginResult.status == LoginStatus.success &&
          loginResult.accessToken != null) {
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(
                loginResult.accessToken!.tokenString);

        final result = await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);
        await FacebookAuth.instance.getUserData();
        if (result.user != null) {
          _navigateToHome();
        }
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext modalContext) {
        return Container(
          height: 1050.h,
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
                  Text(
                    Strings.termosUso,
                    style: TextStyle(
                      fontSize: 52.sp,
                      color: Cores.kQuaternaryColor,
                      fontFamily: 'Roboto-Regular',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(modalContext),
                    icon: const Icon(Icons.close, color: Cores.kDeepGreyColor),
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (carrega == true) {
      return Scaffold(
        body: Align(
          alignment: FractionalOffset.center,
          child: Container(
              color: Cores.kWhiteColor,
              width: 250.w,
              height: 200.h,
              child: const Center(
                  child: CircularProgressIndicator(
                color: Cores.kSecondaryColor,
              ))),
        ),
      );
    } else {
      return Scaffold(
          backgroundColor: Cores.kSecondaryColor,
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: Cores.statusBarColorTransp,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    padding: EdgeInsets.only(top: 150.h),
                    width: 1080.w,
                    height: 1020.h,
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
                    child: const Carousel()),
                Expanded(
                  child: Container(
                    width: 1080.w,
                    decoration: BoxDecoration(
                      color: Cores.kWhiteColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(80.r),
                          topRight: Radius.circular(80.r)),
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 65.w, vertical: 35.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 20.h),
                            Text(
                              Strings.entrarTelaLogin,
                              style: TextStyle(
                                  color: const Color(0xFF202124),
                                  fontSize: 70.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto-Regular'),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              Strings.auxAcesseSalvarProgresso,
                              style: TextStyle(
                                  color: const Color(0xFF5F6368),
                                  fontSize: 38.sp,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Roboto-Regular'),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 50.h),
                            // Botão Google
                            GestureDetector(
                              onTap: _realizarLoginGoogle,
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                height: 135.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Cores.kWhiteColor,
                                  borderRadius: BorderRadius.circular(30.r),
                                  border: Border.all(
                                    color: const Color(0xFFDADCE0),
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      Strings.googleIconAsset,
                                      width: 48.w,
                                      height: 48.h,
                                      fit: BoxFit.contain,
                                    ),
                                    SizedBox(width: 25.w),
                                    Flexible(
                                      child: Text(
                                        Strings.continuarComGoogleTelaLogin,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: const Color(0xFF3C4043),
                                          fontSize: 38.sp,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Roboto-Regular',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 32.h),
                            // Botão Facebook
                            GestureDetector(
                              onTap: _realizarLoginFacebook,
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                height: 135.h,
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1877F2),
                                  borderRadius: BorderRadius.circular(30.r),
                                  border: Border.all(
                                    color: const Color(0xFF1877F2),
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      Strings.facebookIconAsset,
                                      width: 48.w,
                                      height: 48.h,
                                      fit: BoxFit.contain,
                                    ),
                                    SizedBox(width: 25.w),
                                    Flexible(
                                      child: Text(
                                        Strings.continuarComFacebookTelaLogin,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 38.sp,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Roboto-Regular',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 36.h),
                            // Continuar como visitante
                            GestureDetector(
                              onTap: _continuarComoVisitante,
                              behavior: HitTestBehavior.opaque,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 15.h),
                                child: Text(
                                  Strings.continuarComoVisitanteTelaLogin,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(0xFF5F6368),
                                    fontSize: 40.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Roboto-Regular',
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 55.h),
                            // Termos e Política de Privacidade no rodapé
                            GestureDetector(
                              onTap: _exibirModalTermos,
                              behavior: HitTestBehavior.opaque,
                              child: Text(
                                Strings.termosPoliticaRodapeTelaLogin,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color(0xFF70757A),
                                  fontSize: 32.sp,
                                  fontFamily: 'Roboto-Regular',
                                  height: 1.4,
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ));
    }
  }
}
