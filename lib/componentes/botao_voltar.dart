import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/cores.dart';

class BotaoVoltar extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final double iconSize;
  final Color iconColor;
  final Color backgroundColor;
  final Color borderColor;
  final double? borderWidth;
  final double? borderRadius;
  final String? tooltip;

  const BotaoVoltar({
    super.key,
    required this.onTap,
    this.icon = Icons.arrow_back_ios_new,
    this.iconSize = 16.0,
    this.iconColor = Cores.kTertiaryColor,
    this.backgroundColor = Cores.kWhiteColor,
    this.borderColor = Cores.kTertiaryColor,
    this.borderWidth,
    this.borderRadius,
    this.tooltip,
  });

  const BotaoVoltar.fechar({
    super.key,
    required this.onTap,
    this.icon = Icons.close_rounded,
    this.iconSize = 18.0,
    this.iconColor = Cores.kTertiaryColor,
    this.backgroundColor = Cores.kWhiteColor,
    this.borderColor = Cores.kTertiaryColor,
    this.borderWidth,
    this.borderRadius,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final double effectiveBorderWidth = borderWidth ?? 1.5.w;
    final double effectiveBorderRadius = borderRadius ?? 12.r;

    Widget button = MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 48,
            minHeight: 48,
          ),
          child: Container(
            width: (70.w).clamp(36.0, 44.0),
            height: (65.h).clamp(36.0, 44.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
              border: Border.all(
                color: borderColor,
                width: effectiveBorderWidth,
              ),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: iconSize,
            ),
          ),
        ),
      ),
    );

    if (tooltip != null && tooltip!.isNotEmpty) {
      button = Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }
}
