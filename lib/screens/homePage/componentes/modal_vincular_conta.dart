import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/cores.dart';
import '../../../utils/strings.dart';

class ModalVincularConta extends StatelessWidget {
  final Future<void> Function() onGooglePressed;
  final Future<void> Function() onFacebookPressed;

  const ModalVincularConta({
    super.key,
    required this.onGooglePressed,
    required this.onFacebookPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 580),
        padding: EdgeInsets.symmetric(horizontal: 60.w, vertical: 30.h),
        decoration: BoxDecoration(
          color: Cores.kWhiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50.r),
            topRight: Radius.circular(50.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 100.w,
              height: 10.h,
              margin: EdgeInsets.only(bottom: 25.h),
              decoration: BoxDecoration(
                color: Cores.kDarkGreyColor.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    Strings.salvarProgresso,
                    style: TextStyle(
                      fontSize: 52.sp,
                      color: Cores.kQuaternaryColor,
                      fontFamily: 'Roboto-Regular',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Cores.kDeepGreyColor),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Text(
              Strings.vinculeParaSalvar,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 38.sp,
                color: Cores.kDeepGreyColor,
                fontFamily: 'Roboto-Regular',
                height: 1.4,
              ),
            ),
            SizedBox(height: 40.h),
            // Botão Google
            GestureDetector(
              onTap: () async {
                Navigator.pop(context);
                await onGooglePressed();
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: (130.h).clamp(48.0, 58.0),
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  color: Cores.kWhiteColor,
                  borderRadius: BorderRadius.circular(30.r),
                  border: Border.all(
                    color: const Color(0xFFDADCE0),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      Strings.googleIconAsset,
                      width: 48.r,
                      height: 48.r,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 25.w),
                    Flexible(
                      child: Text(
                        Strings.continuarComGoogleTelaLogin,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: const Color(0xFF3C4043),
                          fontSize: 38.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto-Regular',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 25.h),
            // Botão Facebook
            GestureDetector(
              onTap: () async {
                Navigator.pop(context);
                await onFacebookPressed();
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: (130.h).clamp(48.0, 58.0),
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF1877F2),
                  borderRadius: BorderRadius.circular(30.r),
                  border: Border.all(
                    color: const Color(0xFF1877F2),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      Strings.facebookIconAsset,
                      width: 48.r,
                      height: 48.r,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(width: 25.w),
                    Flexible(
                      child: Text(
                        Strings.continuarComFacebookTelaLogin,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 38.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto-Regular',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                Strings.agoraNao,
                style: TextStyle(
                  color: Cores.kDeepGreyColor,
                  fontSize: 36.sp,
                  fontFamily: 'Roboto-Regular',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
