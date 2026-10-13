import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/cores.dart';
import '../../../utils/strings.dart';

class DialogSair extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const DialogSair({
    super.key,
    required this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Cores.kWhiteColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.r),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 70.w, vertical: 40.h),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 50.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 140.w,
              height: 140.h,
              decoration: const BoxDecoration(
                color: Cores.kAzulDrawerItemColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(
                  Strings.sairAppIconAsset,
                  width: 70.w,
                  height: 70.h,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(height: 30.h),
            Text(
              Strings.sair,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 55.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto-Regular',
                color: Cores.kQuaternaryColor,
              ),
            ),
            SizedBox(height: 15.h),
            Text(
              Strings.desejaSair,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 42.sp,
                fontFamily: 'Roboto-Regular',
                color: Cores.kDeepGreyColor,
              ),
            ),
            SizedBox(height: 50.h),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 115.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Cores.kWhiteColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                          side: BorderSide(
                            color: Cores.kAzulBotaoItemColor,
                            width: 3.sp,
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (onCancel != null) {
                          onCancel!();
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        Strings.nao,
                        style: TextStyle(
                          color: Cores.kAzulBotaoItemColor,
                          fontSize: 42.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto-Regular',
                        ),
                        textScaler: TextScaler.noScaling,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 30.w),
                Expanded(
                  child: SizedBox(
                    height: 115.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Cores.kAzulBotaoItemColor,
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                      ),
                      onPressed: onConfirm,
                      child: Text(
                        Strings.sim,
                        style: TextStyle(
                          color: Cores.kWhiteColor,
                          fontSize: 42.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto-Regular',
                        ),
                        textScaler: TextScaler.noScaling,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
