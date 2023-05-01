import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/cores.dart';
import '../../utils/strings.dart';
import '../homePage/componentes/card_tutorial.dart';
import '../homePage/componentes/drawer_custom.dart';

class DevelopersPage extends StatefulWidget {
  const DevelopersPage({super.key});

  @override
  State<DevelopersPage> createState() => _DevelopersPageState();
}

class _DevelopersPageState extends State<DevelopersPage> {
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
                  child: Container(
                    padding: EdgeInsets.fromLTRB(50.w, 40.h, 50.w, 40.h),
                    child: Image.asset(
                        Strings.logoMarcaAsset
                    ),
                  )),
              Container(
                height: 1290.h,
                width: 1080.w,
                padding: EdgeInsets.only(top: 50.h, left: 100.w, right: 100.w),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Container(
                  child: Text('descrição'),
                ),
              ),
            ],
          )),
    );
  }
}
