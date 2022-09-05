import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:inteligencias_multiplas/utils/cores.dart';
import 'package:inteligencias_multiplas/utils/strings.dart';

import 'componentes/carousel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool carrega = true;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance
        .addPostFrameCallback((_) => _recuperarDadosUsuario());
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
    User? result = FirebaseAuth.instance.currentUser;

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
                            fontFamily: 'Roboto'),
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        width: 1000.w,
                        margin: EdgeInsets.only(top: 50.h),
                        child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              side: const BorderSide(
                                  width: 0, color: Colors.transparent),
                            ),
                            child: Container(
                              height: 120.h,
                              decoration: BoxDecoration(
                                color: Cores.kWhiteColor,
                                borderRadius: BorderRadius.circular(50.r),
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      width: 200.w,
                                      height: 100.h,
                                      padding: EdgeInsets.only(left: 40.w),
                                      child: Image.asset(
                                        Strings.googleIconAsset,
                                        fit: BoxFit.cover,
                                      )),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    width: 700.w,
                                    margin: EdgeInsets.only(left: 10.w),
                                    child: Text(
                                        Strings.entrarComGoogleTelaLogin,
                                        style: TextStyle(
                                            color: Cores.kTertiaryColor,
                                            fontSize: 50.sp,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Roboto')),
                                  )
                                ],
                              ),
                            )),
                      ),
                      Container(
                        width: 1000.w,
                        margin: EdgeInsets.only(top: 50.h),
                        child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              side: const BorderSide(
                                  width: 0, color: Colors.transparent),
                            ),
                            child: Container(
                              height: 120.h,
                              decoration: BoxDecoration(
                                color: Cores.kWhiteColor,
                                borderRadius: BorderRadius.circular(50.r),
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      width: 200.w,
                                      height: 80.h,
                                      padding: EdgeInsets.only(left: 50.w),
                                      child: Image.asset(
                                        Strings.facebookIconAsset,
                                        fit: BoxFit.cover,
                                        alignment: Alignment.center,
                                      )),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    width: 700.w,
                                    margin: EdgeInsets.only(left: 10.w),
                                    child: Text(
                                        Strings.entrarComFacebookTelaLogin,
                                        style: TextStyle(
                                            color: Cores.kTertiaryColor,
                                            fontSize: 50.sp,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Roboto')),
                                  )
                                ],
                              ),
                            )),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ));
    }
  }
}
