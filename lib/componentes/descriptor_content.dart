import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/cores.dart';
import '../../utils/strings.dart';
import '../screens/homePage/componentes/drawer_custom.dart';

class DesciptorContent extends StatefulWidget {
  final Widget? child;
  const DesciptorContent({super.key, this.child});

  @override
  State<DesciptorContent> createState() => _DesciptorContentState();
}

class _DesciptorContentState extends State<DesciptorContent> {
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
                    child: Image.asset(Strings.logoMarcaAsset),
                  )),
              Expanded(
                child: Container(
                  padding:
                      EdgeInsets.only(top: 80.h, left: 100.w, right: 100.w),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: widget.child,
                ),
              )
            ],
          )),
    );
  }
}
