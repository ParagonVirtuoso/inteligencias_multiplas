import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inteligencias_multiplas/controller/homeController/home_controller.dart';
import 'package:inteligencias_multiplas/screens/homePage/componentes/button_drawer.dart';
import 'package:inteligencias_multiplas/utils/cores.dart';
import 'package:inteligencias_multiplas/utils/strings.dart';

class DrawerCustom extends StatefulWidget {
  final String profilePic;
  final String user;
  final String email;

  const DrawerCustom({
    Key? key,
    required this.profilePic,
    required this.user,
    required this.email,
  }) : super(key: key);

  @override
  State<DrawerCustom> createState() => _DrawerCustomState();
}

class _DrawerCustomState extends State<DrawerCustom> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 600.h,
          decoration: const BoxDecoration(
            color: Cores.kBorderColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 50.w, vertical: 50.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: 170.w,
                  height: 150.h,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      widget.profilePic,
                    ),
                  ),
                ),
                Container(
                  height: 150.h,
                  width: 380.w,
                  padding: EdgeInsets.only(left: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.user,
                        style: TextStyle(
                          fontSize: 42.sp,
                          color: Cores.kBlackColor,
                          fontWeight: FontWeight.w700,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        width: 400.w,
                        child: Text(
                          widget.email,
                          style: TextStyle(
                            fontSize: 30.sp,
                            color: Cores.kDeepGreyColor,
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50.h,
            ),
            ButtonDrawer(
              icon: Strings.refazerIconAsset,
              text: Strings.refazer,
              corFundo: Cores.kAzulBotaoItemColor,
              corTexto: Cores.kWhiteColor,
              onTap: () {},
            ),
            ButtonDrawer(
              icon: Strings.starIconAsset,
              text: Strings.teste,
              corFundo: Cores.kAzulDrawerItemColor,
              corTexto: Cores.kTertiaryColor,
              onTap: () {
                HomeController().navTeste(context);
              },
            ),
            ButtonDrawer(
              icon: Strings.desenvolvedoresIconAsset,
              text: Strings.desenvolvedores,
              corFundo: Cores.kAzulDrawerItemColor,
              corTexto: Cores.kTertiaryColor,
              onTap: () {
                HomeController().navDevelopers(context);
              },
            ),
            ButtonDrawer(
              icon: Strings.termosUsoAppIconAsset,
              text: Strings.termosUso,
              corFundo: Cores.kAzulDrawerItemColor,
              corTexto: Cores.kTertiaryColor,
              onTap: () {},
            ),
            ButtonDrawer(
              icon: Strings.sobreAppIconAsset,
              text: Strings.sobreApp,
              corFundo: Cores.kAzulDrawerItemColor,
              corTexto: Cores.kTertiaryColor,
              onTap: () {},
            ),
            SizedBox(height: 290.h),
            ButtonDrawer(
              icon: Strings.sairAppIconAsset,
              text: Strings.sair,
              corFundo: Cores.kBorderColor,
              corTexto: Cores.kDeepGreyColor,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(Strings.sair),
                      content: const Text(Strings.desejaSair),
                      actions: [
                        TextButton(
                          child: const Text(Strings.sim),
                          onPressed: () async {
                            await HomeController().signOut();
                            _navigateToLoginPage();
                          },
                        ),
                        TextButton(
                          child: const Text(Strings.nao),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            Container(
              margin: EdgeInsets.only(top: 20.h),
              child: Text(
                'Versão 1.0.0',
                style: TextStyle(
                  fontSize: 30.sp,
                  color: Cores.kDeepGreyColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _navigateToLoginPage() {
    Navigator.pushReplacementNamed(context, '/');
  }
}
