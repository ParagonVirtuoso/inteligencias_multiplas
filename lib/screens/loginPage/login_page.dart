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
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool carrega = true;

  var _checkBoxValue = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance
        .addPostFrameCallback((_) => _recuperarDadosUsuario());
  }

  Future _realizarLoginGoogle() async {
    if (!_checkBoxValue) {
      _showErrorSnackBar();
      return;
    }

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
      debugPrint(e.toString());
    } finally {
      setState(() => carrega = false);
    }
  }

  void _showErrorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(Strings.erroAceiteTermosTelaLogin),
        backgroundColor: Cores.kErroColor,
      ),
    );
  }

  Future _realizarLoginFacebook() async {
    setState(() {
      carrega = true;
    });
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
      await FacebookAuth.instance.getUserData();
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        carrega = false;
      });
    }
    setState(() {
      carrega = false;
    });
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  Future _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      Navigator.pushReplacementNamed(context, Strings.homeNavigate);
    }
    setState(() {
      carrega = false;
    });
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
                    padding: EdgeInsets.only(top: 160.h),
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
                Container(
                  width: 1080.w,
                  height: 900.h,
                  decoration: BoxDecoration(
                    color: Cores.kWhiteColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(70.r),
                        topRight: Radius.circular(70.r)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        Strings.conecteTelaLogin,
                        style: TextStyle(
                            color: Cores.kTertiaryColor,
                            fontSize: 95.sp,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Roboto-Regular'),
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        width: 1000.w,
                        margin: EdgeInsets.only(top: 50.h),
                        child: OutlinedButton(
                            onPressed: _realizarLoginGoogle,
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              side: const BorderSide(
                                  width: 0, color: Colors.transparent),
                            ),
                            child: Container(
                              height: 135.h,
                              decoration: BoxDecoration(
                                color: Cores.kWhiteColor,
                                borderRadius: BorderRadius.circular(30.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 3,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      height: 100.h,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 30.w),
                                      child: Image.asset(
                                        Strings.googleIconAsset,
                                        fit: BoxFit.cover,
                                        alignment: Alignment.center,
                                      )),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.only(left: 10.w),
                                    child: Text(
                                        Strings.entrarComGoogleTelaLogin,
                                        style: TextStyle(
                                            color: Cores.kTertiaryColor,
                                            fontSize: 50.sp,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Roboto-Regular')),
                                  )
                                ],
                              ),
                            )),
                      ),
                      Container(
                        width: 1000.w,
                        height: 90.h,
                        alignment: Alignment.center,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 300.w,
                              height: 20.h,
                              child: const Divider(
                                color: Colors.black,
                                thickness: 1.3,
                              ),
                            ),
                            Text(Strings.ouTelaLogin,
                                style: TextStyle(
                                    color: Cores.kTertiaryColor,
                                    fontSize: 50.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Roboto-Regular')),
                            SizedBox(
                              width: 300.w,
                              height: 20.h,
                              child: const Divider(
                                color: Colors.black,
                                thickness: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 1000.w,
                        margin: EdgeInsets.only(bottom: 20.h),
                        child: OutlinedButton(
                            onPressed: _realizarLoginFacebook,
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              side: const BorderSide(
                                  width: 0, color: Colors.transparent),
                            ),
                            child: Container(
                              height: 135.h,
                              decoration: BoxDecoration(
                                color: Cores.kWhiteColor,
                                borderRadius: BorderRadius.circular(30.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 3,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      height: 100.h,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 30.w),
                                      child: Image.asset(
                                        Strings.facebookIconAsset,
                                        fit: BoxFit.cover,
                                        alignment: Alignment.center,
                                      )),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        Strings.entrarComFacebookTelaLogin,
                                        style: TextStyle(
                                            color: Cores.kTertiaryColor,
                                            fontSize: 50.sp,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Roboto-Regular')),
                                  )
                                ],
                              ),
                            )),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _checkBoxValue = !_checkBoxValue;
                          });
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Checkbox(
                                value: _checkBoxValue,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _checkBoxValue = value!;
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                              ),
                              Text(Strings.aceitoTermosTelaLogin,
                                  style: TextStyle(
                                      color: Cores.kTertiaryColor,
                                      fontSize: 50.sp,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.underline,
                                      fontFamily: 'Roboto-Regular')),
                            ]),
                      )
                    ],
                  ),
                )
              ],
            ),
          ));
    }
  }
}
