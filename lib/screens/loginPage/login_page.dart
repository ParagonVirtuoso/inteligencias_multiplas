import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                )
              ],
            ),
          ));
    }
  }
}
