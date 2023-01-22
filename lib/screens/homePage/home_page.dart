import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inteligencias_multiplas/screens/homePage/componentes/card_tutorial.dart';
import 'package:inteligencias_multiplas/screens/homePage/componentes/drawer_custom.dart';
import 'package:inteligencias_multiplas/utils/cores.dart';
import 'package:inteligencias_multiplas/utils/strings.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _statusBarIcon = SystemUiOverlayStyle.light;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var _user = '';
  var _profilePic = '';
  var _email = '';

  @override
  initState() {
    super.initState();
    _user = _auth.currentUser?.displayName ?? '';
    _profilePic = _auth.currentUser?.photoURL ?? '';
    _email = _auth.currentUser?.email ?? '';
  }

  @override
  Widget build(BuildContext context) {
    print(_user);
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
            setState(() {
              _statusBarIcon = value
                  ? SystemUiOverlayStyle.dark
                  : SystemUiOverlayStyle.light;
            });
          },
          drawer: Drawer(
            width: 650.w,
            child: DrawerCustom(
                profilePic: _profilePic, user: _user, email: _email),
          ),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            systemOverlayStyle: _statusBarIcon,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Column(
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
                        margin: EdgeInsets.only(left: 50.w, right: 50.w),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            _profilePic,
                          ),
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
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ),
                          Text('$_user.',
                              style: TextStyle(
                                  fontSize: 75.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ))
                    ],
                  )),
              Container(
                height: 1325.h,
                width: 1080.w,
                padding: EdgeInsets.only(top: 50.h, left: 100.w, right: 100.w),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: const CardTutorial(),
              ),
            ],
          )),
    );
  }
}
