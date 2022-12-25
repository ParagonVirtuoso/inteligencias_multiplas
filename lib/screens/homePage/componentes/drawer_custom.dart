import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
              Container(
                height: 150.h,
                margin: EdgeInsets.only(bottom: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
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
                ),
              )
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
            ButtonDrawer(
              icon: Strings.refazerIconAsset,
              text: Strings.refazer,
              corFundo: Cores.kAzulBotaoItemColor,
              corTexto: Cores.kWhiteColor,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ButtonDrawer(
              icon: Strings.starIconAsset,
              text: 'Teste',
              corFundo: Cores.kAzulDrawerItemColor,
              corTexto: Cores.kTertiaryColor,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ButtonDrawer(
              icon: Strings.desenvolvedoresIconAsset,
              text: 'Desenvolvedores',
              corFundo: Cores.kAzulDrawerItemColor,
              corTexto: Cores.kTertiaryColor,
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ButtonDrawer(
              icon: Strings.centralAjudaIconAsset,
              text: 'Central de Ajuda',
              corFundo: Cores.kAzulDrawerItemColor,
              corTexto: Cores.kTertiaryColor,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ButtonDrawer(
              icon: Strings.termosUsoAppIconAsset,
              text: 'Termos de Uso',
              corFundo: Cores.kAzulDrawerItemColor,
              corTexto: Cores.kTertiaryColor,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ButtonDrawer(
              icon: Strings.sobreAppIconAsset,
              text: 'Sobre o App',
              corFundo: Cores.kAzulDrawerItemColor,
              corTexto: Cores.kTertiaryColor,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 290.h),
            ButtonDrawer(
              icon: Strings.sairAppIconAsset,
              text: 'Sair',
              corFundo: Cores.kBorderColor,
              corTexto: Cores.kDeepGreyColor,
              onTap: () {
                Navigator.pop(context);
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
}
