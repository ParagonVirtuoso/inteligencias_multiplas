import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../componentes/descriptor_content.dart';
import '../../utils/cores.dart';
import '../../utils/strings.dart';
import '../homePage/componentes/drawer_custom.dart';
import 'componentes/developer_item.dart';

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
    return DesciptorContent(
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(bottom: 50.h),
          child: Text(
            Strings.desenvolvedores,
            style: TextStyle(
                fontSize: 65.sp,
                fontFamily: 'Roboto-Regular',
                fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ),
        const DeveloperItem()
      ]),
    );
  }
}
