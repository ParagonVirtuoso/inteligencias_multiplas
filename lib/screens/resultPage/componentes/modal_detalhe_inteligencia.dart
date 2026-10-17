import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/cores.dart';
import '../../../utils/strings.dart';

class ModalDetalheInteligencia extends StatelessWidget {
  final String title;
  final String description;
  final bool? isWebOverride;

  const ModalDetalheInteligencia({
    required this.title,
    required this.description,
    this.isWebOverride,
    super.key,
  });

  static bool _detectIsWeb(BuildContext context, [bool? override]) {
    if (override != null) return override;
    if (kIsWeb) return true;
    final width = MediaQuery.maybeOf(context)?.size.width ?? 0;
    return width > 600;
  }

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String description,
    bool? isWebOverride,
  }) {
    final isWeb = _detectIsWeb(context, isWebOverride);
    if (isWeb) {
      return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          final screenHeight =
              MediaQuery.maybeOf(dialogContext)?.size.height ?? 800.0;
          return Dialog(
            backgroundColor: Cores.kWhiteColor,
            surfaceTintColor: Colors.transparent,
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
            ),
            insetPadding: EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: screenHeight < 500 ? 16.0 : 32.0,
            ),
            clipBehavior: Clip.antiAlias,
            child: ModalDetalheInteligencia(
              title: title,
              description: description,
              isWebOverride: true,
            ),
          );
        },
      );
    }

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext modalContext) {
        return ModalDetalheInteligencia(
          title: title,
          description: description,
          isWebOverride: false,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = _detectIsWeb(context, isWebOverride);
    final screenHeight = MediaQuery.maybeOf(context)?.size.height ?? 800.0;

    if (isWeb) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 500.0,
          maxHeight: (screenHeight * 0.85).clamp(240.0, 560.0),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28.0, 24.0, 28.0, 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22.0,
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
                      icon: const Icon(
                        Icons.close,
                        color: Cores.kDeepGreyColor,
                        size: 22.0,
                      ),
                      tooltip: Strings.fechar,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 48.0,
                        minHeight: 48.0,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              const Divider(thickness: 1, height: 1),
              const SizedBox(height: 20.0),
              Flexible(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Text(
                    description,
                    style: const TextStyle(
                      fontSize: 15.5,
                      color: Cores.kQuaternaryColor,
                      fontFamily: 'Roboto-Regular',
                      height: 1.55,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              SizedBox(
                width: double.infinity,
                height: 48.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Cores.kAzulBotaoItemColor,
                    foregroundColor: Cores.kWhiteColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    Strings.entendido,
                    style: TextStyle(
                      color: Cores.kWhiteColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Roboto-Regular',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        top: false,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 680),
          height: (800.h).clamp(
            260.0,
            (screenHeight * 0.85).clamp(260.0, 560.0),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: (50.w).clamp(20.0, 32.0),
            vertical: (25.h).clamp(16.0, 24.0),
          ),
          decoration: BoxDecoration(
            color: Cores.kWhiteColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular((50.r).clamp(24.0, 32.0)),
              topRight: Radius.circular((50.r).clamp(24.0, 32.0)),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                key: const Key('detail_modal_drag_handle'),
                width: (100.w).clamp(36.0, 48.0),
                height: (10.h).clamp(4.0, 6.0),
                margin: EdgeInsets.only(bottom: (16.h).clamp(10.0, 16.0)),
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
                      title,
                      style: TextStyle(
                        fontSize: (50.sp).clamp(18.0, 22.0),
                        color: Cores.kQuaternaryColor,
                        fontFamily: 'Roboto-Regular',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    tooltip: Strings.fechar,
                    constraints: const BoxConstraints(
                      minWidth: 48.0,
                      minHeight: 48.0,
                    ),
                    icon: Image.asset(
                      Strings.arrowdetailresult,
                      width: (70.r).clamp(28.0, 36.0),
                      height: (70.r).clamp(28.0, 36.0),
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
              SizedBox(height: (12.h).clamp(8.0, 12.0)),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Text(
                    description,
                    style: TextStyle(
                      fontSize: (40.sp).clamp(14.5, 17.0),
                      color: Cores.kQuaternaryColor,
                      fontFamily: 'Roboto-Regular',
                      fontWeight: FontWeight.w400,
                      height: 1.45,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
