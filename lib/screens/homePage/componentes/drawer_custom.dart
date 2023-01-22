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

  const DrawerCustom(
      {Key? key,
      required this.profilePic,
      required this.user,
      required this.email})
      : super(key: key);

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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 170.w,
                height: 150.h,
                margin: EdgeInsets.only(bottom: 20.h),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    widget.profilePic,
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(widget.user,
                          style: TextStyle(
                              fontSize: 45.sp,
                              color: Cores.kBlackColor,
                              fontWeight: FontWeight.w700)),
                      SizedBox(
                          width: 400.w,
                          child: Text(widget.email,
                              style: TextStyle(
                                  fontSize: 30.sp,
                                  color: Cores.kDeepGreyColor,
                                  fontWeight: FontWeight.w500))),
                    ],
                  ))
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50.h,
            ),
            GestureDetector(
              child: const ButtonDrawer(
                icon: Strings.refazerIconAsset,
                text: Strings.refazer,
                corFundo: Cores.kAzulBotaoItemColor,
                corTexto: Cores.kWhiteColor,
              ),
              onTap: () {},
            ),
            GestureDetector(
              child: const ButtonDrawer(
                icon: Strings.starIconAsset,
                text: Strings.teste,
                corFundo: Cores.kAzulDrawerItemColor,
                corTexto: Cores.kTertiaryColor,
              ),
              onTap: () {
                HomeController().navTeste(context);
              },
            ),
            GestureDetector(
              child: const ButtonDrawer(
                icon: Strings.desenvolvedoresIconAsset,
                text: Strings.desenvolvedores,
                corFundo: Cores.kAzulDrawerItemColor,
                corTexto: Cores.kTertiaryColor,
              ),
              onTap: () {},
            ),
            GestureDetector(
              child: const ButtonDrawer(
                icon: Strings.centralAjudaIconAsset,
                text: Strings.centralAjuda,
                corFundo: Cores.kAzulDrawerItemColor,
                corTexto: Cores.kTertiaryColor,
              ),
              onTap: () {},
            ),
            GestureDetector(
              child: const ButtonDrawer(
                icon: Strings.termosUsoAppIconAsset,
                text: Strings.termosUso,
                corFundo: Cores.kAzulDrawerItemColor,
                corTexto: Cores.kTertiaryColor,
              ),
              onTap: () {},
            ),
            GestureDetector(
              child: const ButtonDrawer(
                icon: Strings.sobreAppIconAsset,
                text: Strings.sobreApp,
                corFundo: Cores.kAzulDrawerItemColor,
                corTexto: Cores.kTertiaryColor,
              ),
              onTap: () {},
            ),
            SizedBox(height: 290.h),
            GestureDetector(
              child: const ButtonDrawer(
                icon: Strings.sairAppIconAsset,
                text: Strings.sair,
                corFundo: Cores.kBorderColor,
                corTexto: Cores.kDeepGreyColor,
              ),
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
                            onPressed: () {
                              signOutGoogle();
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
                    });
              },
            ),
            Container(
              margin: EdgeInsets.only(top: 20.h),
              child: Text(
                'Versão 1.0.0',
                style: TextStyle(
                    fontSize: 30.sp,
                    color: Cores.kDeepGreyColor,
                    fontWeight: FontWeight.w500),
              ),
            )
          ],
        )
      ],
    );
  }

  Future<void> signOutGoogle() async {
    await HomeController().signOut();
    navigateOut();
  }

  void navigateOut() {
    Navigator.pushReplacementNamed(context, '/');
  }
}
