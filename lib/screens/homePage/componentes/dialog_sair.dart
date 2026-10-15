import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/cores.dart';
import '../../../utils/strings.dart';

class DialogSair extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final Widget? icon;
  final String? iconAsset;
  final Color iconBackgroundColor;
  final Color confirmButtonColor;
  final Color? confirmButtonBorderColor;
  final Color confirmTextColor;
  final double confirmButtonElevation;
  final Color cancelButtonTextColor;
  final Color cancelButtonBorderColor;
  final Color cancelButtonBackgroundColor;
  final double cancelButtonElevation;

  const DialogSair({
    super.key,
    required this.onConfirm,
    this.onCancel,
    this.title = Strings.sair,
    this.message = Strings.desejaSair,
    this.confirmText = Strings.sim,
    this.cancelText = Strings.nao,
    this.icon,
    this.iconAsset = Strings.sairAppIconAsset,
    this.iconBackgroundColor = Cores.kAzulDrawerItemColor,
    this.confirmButtonColor = Cores.kAzulBotaoItemColor,
    this.confirmButtonBorderColor,
    this.confirmTextColor = Cores.kWhiteColor,
    this.confirmButtonElevation = 1,
    this.cancelButtonTextColor = Cores.kAzulBotaoItemColor,
    this.cancelButtonBorderColor = Cores.kAzulBotaoItemColor,
    this.cancelButtonBackgroundColor = Cores.kWhiteColor,
    this.cancelButtonElevation = 0,
  });

  /// Modal especializado para encerrar sessão / sair da conta (usado no Drawer)
  const DialogSair.conta({
    super.key,
    required this.onConfirm,
    this.onCancel,
    this.title = Strings.sairConta,
    this.message = Strings.desejaSairConta,
    this.confirmText = Strings.confirmarSairConta,
    this.cancelText = Strings.cancelar,
    this.icon,
    this.iconAsset = Strings.sairAppIconAsset,
    this.iconBackgroundColor = Cores.kAzulDrawerItemColor,
    this.confirmButtonColor = Cores.kAzulBotaoItemColor,
    this.confirmButtonBorderColor,
    this.confirmTextColor = Cores.kWhiteColor,
    this.confirmButtonElevation = 1,
    this.cancelButtonTextColor = Cores.kDeepGreyColor,
    this.cancelButtonBorderColor = Cores.kcinzaColor,
    this.cancelButtonBackgroundColor = Cores.kWhiteColor,
    this.cancelButtonElevation = 0,
  });

  /// Modal especializado para sair / interromper um teste em andamento (usado no QuestionsPage)
  /// Com cores invertidas para destacar a ação de continuar o teste.
  const DialogSair.teste({
    super.key,
    required this.onConfirm,
    this.onCancel,
    this.title = Strings.sairDoTeste,
    this.message = Strings.desejaSairDoTeste,
    this.confirmText = Strings.confirmarSairDoTeste,
    this.cancelText = Strings.continuarTeste,
    this.icon,
    this.iconAsset,
    this.iconBackgroundColor = const Color(0xFFFFF3E0),
    this.confirmButtonColor = Cores.kWhiteColor,
    this.confirmButtonBorderColor = Cores.kcinzaColor,
    this.confirmTextColor = Cores.kDeepGreyColor,
    this.confirmButtonElevation = 0,
    this.cancelButtonTextColor = Cores.kWhiteColor,
    this.cancelButtonBorderColor = Cores.kAzulBotaoItemColor,
    this.cancelButtonBackgroundColor = Cores.kAzulBotaoItemColor,
    this.cancelButtonElevation = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Cores.kWhiteColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.r),
      ),
      insetPadding: EdgeInsets.symmetric(
        horizontal: (70.w).clamp(16.0, 40.0),
        vertical: (40.h).clamp(16.0, 40.0),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Container(
          width: (800.w).clamp(280.0, 400.0),
          padding: EdgeInsets.symmetric(
            horizontal: (50.w).clamp(16.0, 32.0),
            vertical: (50.h).clamp(20.0, 36.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: (140.r).clamp(56.0, 72.0),
                height: (140.r).clamp(56.0, 72.0),
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: icon ??
                      (iconAsset != null
                          ? Image.asset(
                              iconAsset!,
                              width: (70.r).clamp(28.0, 36.0),
                              height: (70.r).clamp(28.0, 36.0),
                              fit: BoxFit.contain,
                            )
                          : Icon(
                              Icons.warning_amber_rounded,
                              size: (70.r).clamp(28.0, 36.0),
                              color: Cores.kAlertaColor,
                            )),
                ),
              ),
              SizedBox(height: (30.h).clamp(12.0, 20.0)),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: (55.sp).clamp(18.0, 24.0),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto-Regular',
                  color: Cores.kQuaternaryColor,
                ),
              ),
              SizedBox(height: (15.h).clamp(8.0, 14.0)),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: (42.sp).clamp(13.0, 16.0),
                  fontFamily: 'Roboto-Regular',
                  color: Cores.kDeepGreyColor,
                  height: 1.35,
                ),
              ),
              SizedBox(height: (50.h).clamp(20.0, 32.0)),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: (115.h).clamp(44.0, 52.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cancelButtonBackgroundColor,
                          elevation: cancelButtonElevation,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                            side: BorderSide(
                              color: cancelButtonBorderColor,
                              width: 1.5.w,
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
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            cancelText,
                            maxLines: 1,
                            softWrap: false,
                            style: TextStyle(
                              color: cancelButtonTextColor,
                              fontSize: (42.sp).clamp(14.0, 16.0),
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Roboto-Regular',
                            ),
                            textScaler: TextScaler.noScaling,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: (30.w).clamp(12.0, 20.0)),
                  Expanded(
                    child: SizedBox(
                      height: (115.h).clamp(44.0, 52.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: confirmButtonColor,
                          elevation: confirmButtonElevation,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                            side: BorderSide(
                              color: confirmButtonBorderColor ?? confirmButtonColor,
                              width: 1.5.w,
                            ),
                          ),
                        ),
                        onPressed: onConfirm,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            confirmText,
                            maxLines: 1,
                            softWrap: false,
                            style: TextStyle(
                              color: confirmTextColor,
                              fontSize: (42.sp).clamp(14.0, 16.0),
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Roboto-Regular',
                            ),
                            textScaler: TextScaler.noScaling,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
