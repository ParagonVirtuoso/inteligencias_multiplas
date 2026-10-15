import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/cores.dart';
import '../utils/strings.dart';

class ModalVincularConta extends StatelessWidget {
  final Future<void> Function() onGooglePressed;
  final Future<void> Function() onFacebookPressed;
  final bool? isWebOverride;

  const ModalVincularConta({
    super.key,
    required this.onGooglePressed,
    required this.onFacebookPressed,
    this.isWebOverride,
  });

  static bool _detectIsWeb(BuildContext context, [bool? override]) {
    if (override != null) return override;
    if (kIsWeb) return true;
    final width = MediaQuery.maybeOf(context)?.size.width ?? 0;
    return width > 600;
  }

  static Future<void> show({
    required BuildContext context,
    required Future<void> Function() onGooglePressed,
    required Future<void> Function() onFacebookPressed,
    bool? isWebOverride,
  }) {
    final isWeb = _detectIsWeb(context, isWebOverride);
    if (isWeb) {
      return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return Dialog(
            backgroundColor: Cores.kWhiteColor,
            surfaceTintColor: Colors.transparent,
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 24.0,
            ),
            clipBehavior: Clip.antiAlias,
            child: ModalVincularConta(
              onGooglePressed: onGooglePressed,
              onFacebookPressed: onFacebookPressed,
              isWebOverride: true,
            ),
          );
        },
      );
    }

    return showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext modalContext) {
        return ModalVincularConta(
          onGooglePressed: onGooglePressed,
          onFacebookPressed: onFacebookPressed,
          isWebOverride: false,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = _detectIsWeb(context, isWebOverride);

    final Widget content = Container(
      constraints: BoxConstraints(maxWidth: isWeb ? 460.0 : 580.0),
      padding: EdgeInsets.symmetric(
        horizontal: isWeb ? 28.0 : (50.w).clamp(20.0, 32.0),
        vertical: isWeb ? 24.0 : (30.h).clamp(18.0, 28.0),
      ),
      decoration: BoxDecoration(
        color: Cores.kWhiteColor,
        borderRadius: isWeb
            ? BorderRadius.circular(24.0)
            : BorderRadius.only(
                topLeft: Radius.circular((50.r).clamp(24.0, 32.0)),
                topRight: Radius.circular((50.r).clamp(24.0, 32.0)),
              ),
      ),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (!isWeb)
              Container(
                key: const Key('vincular_modal_drag_handle'),
                width: (100.w).clamp(36.0, 48.0),
                height: (10.h).clamp(4.0, 6.0),
                margin: EdgeInsets.only(bottom: (20.h).clamp(12.0, 18.0)),
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
                      fontSize: isWeb ? 22.0 : (52.sp).clamp(18.0, 22.0),
                      color: Cores.kQuaternaryColor,
                      fontFamily: 'Roboto-Regular',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    tooltip: Strings.fechar,
                    constraints: const BoxConstraints(
                      minWidth: 48.0,
                      minHeight: 48.0,
                    ),
                    icon: const Icon(
                      Icons.close,
                      color: Cores.kDeepGreyColor,
                      size: 22.0,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: isWeb ? 8.0 : (10.h).clamp(6.0, 10.0)),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                Strings.vinculeParaSalvar,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: isWeb ? 15.0 : (38.sp).clamp(13.5, 16.0),
                  color: Cores.kDeepGreyColor,
                  fontFamily: 'Roboto-Regular',
                  height: 1.4,
                ),
              ),
            ),
            SizedBox(height: isWeb ? 24.0 : (36.h).clamp(18.0, 26.0)),
            // Botão Google
            Tooltip(
              message: Strings.continuarComGoogleTelaLogin,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                    await onGooglePressed();
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    height: isWeb ? 48.0 : (130.h).clamp(48.0, 56.0),
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: isWeb ? 16.0 : (20.w).clamp(14.0, 20.0),
                    ),
                    decoration: BoxDecoration(
                      color: Cores.kWhiteColor,
                      borderRadius: BorderRadius.circular(
                        isWeb ? 24.0 : (30.r).clamp(20.0, 28.0),
                      ),
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
                          width: isWeb ? 22.0 : (48.r).clamp(20.0, 24.0),
                          height: isWeb ? 22.0 : (48.r).clamp(20.0, 24.0),
                          fit: BoxFit.contain,
                        ),
                        SizedBox(
                          width: isWeb ? 12.0 : (25.w).clamp(10.0, 14.0),
                        ),
                        Flexible(
                          child: Text(
                            Strings.continuarComGoogleTelaLogin,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: const Color(0xFF3C4043),
                              fontSize:
                                  isWeb ? 15.0 : (38.sp).clamp(14.0, 16.0),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Roboto-Regular',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: isWeb ? 12.0 : (24.h).clamp(12.0, 18.0)),
            // Botão Facebook
            Tooltip(
              message: Strings.continuarComFacebookTelaLogin,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                    await onFacebookPressed();
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    height: isWeb ? 48.0 : (130.h).clamp(48.0, 56.0),
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: isWeb ? 16.0 : (20.w).clamp(14.0, 20.0),
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1877F2),
                      borderRadius: BorderRadius.circular(
                        isWeb ? 24.0 : (30.r).clamp(20.0, 28.0),
                      ),
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
                          width: isWeb ? 22.0 : (48.r).clamp(20.0, 24.0),
                          height: isWeb ? 22.0 : (48.r).clamp(20.0, 24.0),
                          fit: BoxFit.contain,
                        ),
                        SizedBox(
                          width: isWeb ? 12.0 : (25.w).clamp(10.0, 14.0),
                        ),
                        Flexible(
                          child: Text(
                            Strings.continuarComFacebookTelaLogin,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Cores.kWhiteColor,
                              fontSize:
                                  isWeb ? 15.0 : (38.sp).clamp(14.0, 16.0),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Roboto-Regular',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: isWeb ? 12.0 : (16.h).clamp(8.0, 14.0)),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: SizedBox(
                height: 48.0,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    Strings.agoraNao,
                    style: TextStyle(
                      color: Cores.kDeepGreyColor,
                      fontSize: isWeb ? 14.5 : (36.sp).clamp(13.5, 15.5),
                      fontFamily: 'Roboto-Regular',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (isWeb) {
      return content;
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        top: false,
        child: content,
      ),
    );
  }
}
