import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inteligencias_multiplas/utils/cores.dart';

class ButtonDrawer extends StatelessWidget {
  final String icon;
  final String text;
  final Null Function() onTap;
  final Color corFundo;
  final Color corTexto;
  const ButtonDrawer(
      {Key? key,
      required this.icon,
      required this.text,
      required this.onTap,
      required this.corFundo,
      required this.corTexto})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110.h,
      margin: EdgeInsets.only(left: 50.w, right: 50.w, top: 10.h, bottom: 10.h),
      decoration: BoxDecoration(
        color: corFundo,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Image(
              image: AssetImage(
                icon,
              ),
          )),
          Text(text,
              style: TextStyle(
                  fontSize: 45.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Roboto',
                  color: corTexto))
        ],
      )
    );
  }
}
