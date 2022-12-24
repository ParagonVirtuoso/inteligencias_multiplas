import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inteligencias_multiplas/utils/cores.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _statusBarIcon = SystemUiOverlayStyle.light;

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
          ),
          body: Column(
            children: [
              Container(
                height: 350.h,
                width: 100.w,
                color: Colors.transparent,
              ),
              Container(
                height: 1355.h,
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
