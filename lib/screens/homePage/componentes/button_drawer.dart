import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonDrawer extends StatelessWidget {
  final String? icon;
  final Widget? iconWidget;
  final String text;
  final Color corFundo;
  final Color corTexto;
  final VoidCallback onTap;
  const ButtonDrawer({
    super.key,
    this.icon,
    this.iconWidget,
    required this.text,
    required this.corFundo,
    required this.corTexto,
    required this.onTap,
  }) : assert(icon != null || iconWidget != null,
            'Deve fornecer icon ou iconWidget');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            constraints: BoxConstraints(minHeight: 110.h),
            padding: EdgeInsets.symmetric(vertical: 8.h),
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
                    child: iconWidget ??
                        Image(
                          image: AssetImage(
                            icon!,
                          ),
                        )),
                Expanded(
                  child: Text(text,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: 45.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto-Regular',
                          color: corTexto)),
                ),
              ],
            )));
  }
}
