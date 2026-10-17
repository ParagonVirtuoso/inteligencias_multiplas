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
  var _user = '';
  var _profilePic = '';
  var _email = '';

  @override
  initState() {
    super.initState();
    try {
      final user = FirebaseAuth.instance.currentUser;
      _user = user?.displayName ?? '';
      _profilePic = user?.photoURL ?? '';
      _email = user?.email ?? '';
    } catch (_) {}
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
            width: (650.w).clamp(260.0, 360.0),
            child: DrawerCustom(
                profilePic: _profilePic, user: _user, email: _email),
          ),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            systemOverlayStyle: _statusBarIcon,
            iconTheme: const IconThemeData(color: Colors.white),
            leading: Navigator.canPop(context)
                ? IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  )
                : null,
          ),
          body: Column(
            children: [
              Container(
                  height: (370.h).clamp(120.0, 200.0),
                  width: double.infinity,
                  color: Colors.transparent,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(
                        (50.w).clamp(16.0, 36.0),
                        (40.h).clamp(16.0, 32.0),
                        (50.w).clamp(16.0, 36.0),
                        (40.h).clamp(16.0, 32.0)),
                    child: Image.asset(Strings.logoMarcaAsset),
                  )),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(
                      top: (80.h).clamp(32.0, 56.0),
                      left: (100.w).clamp(24.0, 48.0),
                      right: (100.w).clamp(24.0, 48.0)),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 860),
                      child: widget.child,
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
