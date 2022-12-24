import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  @override
  initState() {
    super.initState();
    _user = _auth.currentUser?.displayName ?? '';
    _profilePic = _auth.currentUser?.photoURL ?? '';
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
            child: Column(
              children: [
                ListTile(
                  title: Text('Item 1'),
                  onTap: () {},
                ),
                ListTile(
                  title: Text('Item 2'),
                  onTap: () {},
                ),
              ],
            ),
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
                        height: 350.h,
                        margin: EdgeInsets.only(left: 50.w, right: 50.w),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            _profilePic,
                          ),
                        ),
                      ),
                      Column(
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
                      ),
                    ],
                  )),
              Container(
                height: 1338.h,
                width: 1080.w,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Column(),
              ),
            ],
          )),
    );
  }
}
