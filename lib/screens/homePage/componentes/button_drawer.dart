import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonDrawer extends StatelessWidget {
  final String? icon;
  final Widget? iconWidget;
  final double? iconSize;
  final String text;
  final Color corFundo;
  final Color corTexto;
  final VoidCallback onTap;
  const ButtonDrawer({
    super.key,
    this.icon,
    this.iconWidget,
    this.iconSize,
    required this.text,
    required this.corFundo,
    required this.corTexto,
    required this.onTap,
  }) : assert(icon != null || iconWidget != null,
            'Deve fornecer icon ou iconWidget');

  @override
  Widget build(BuildContext context) {
    final double effectiveIconSize =
        iconSize ?? (72.r).clamp(22.0, 26.0);

    Widget buildIcon() {
      if (iconWidget != null) {
        return SizedBox(
          width: effectiveIconSize,
          height: effectiveIconSize,
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: iconWidget!,
            ),
          ),
        );
      }
      if (icon != null && icon!.isNotEmpty) {
        return Image(
          image: AssetImage(
            icon!,
          ),
          width: effectiveIconSize,
          height: effectiveIconSize,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.medium,
          excludeFromSemantics: true,
        );
      }
      return SizedBox(
        width: effectiveIconSize,
        height: effectiveIconSize,
      );
    }

    return Semantics(
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          constraints: BoxConstraints(minHeight: (110.h).clamp(46.0, 56.0)),
          padding: EdgeInsets.symmetric(vertical: (8.h).clamp(4.0, 8.0)),
          margin: EdgeInsets.symmetric(
            horizontal: (50.w).clamp(16.0, 32.0),
            vertical: (10.h).clamp(4.0, 8.0),
          ),
          decoration: BoxDecoration(
            color: corFundo,
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(
                  left: (40.w).clamp(16.0, 24.0),
                  right: (30.w).clamp(12.0, 18.0),
                ),
                width: effectiveIconSize,
                height: effectiveIconSize,
                alignment: Alignment.center,
                child: buildIcon(),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: (30.w).clamp(12.0, 18.0),
                  ),
                  child: Text(
                    text,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: (45.sp).clamp(14.0, 16.5),
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Roboto-Regular',
                      color: corTexto,
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
