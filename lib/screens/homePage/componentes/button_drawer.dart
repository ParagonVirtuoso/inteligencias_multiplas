import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonDrawer extends StatelessWidget {
  final String icon;
  final String text;
  final Color corFundo;
  final Color corTexto;
  final VoidCallback onTap;
  const ButtonDrawer({
    Key? key,
    required this.icon,
    required this.text,
    required this.corFundo,
    required this.corTexto,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            height: 110.h,
            margin: EdgeInsets.only(
                left: 50.w, right: 50.w, top: 10.h, bottom: 10.h),
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
                        fontFamily: 'Roboto-Regular',
                        color: corTexto))
              ],
            )));
  }
}
