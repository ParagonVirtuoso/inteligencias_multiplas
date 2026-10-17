import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inteligencias_multiplas/utils/cores.dart';

class MiniNavigator extends StatefulWidget {
  final int currentQuestion;
  final List<int> stepAnswers;
  final int currentSelection;
  final ValueChanged<int> onSelectQuestion;
  final EdgeInsetsGeometry? margin;

  const MiniNavigator({
    super.key,
    required this.currentQuestion,
    required this.stepAnswers,
    this.currentSelection = 0,
    required this.onSelectQuestion,
    this.margin,
  });

  @override
  State<MiniNavigator> createState() => _MiniNavigatorState();
}

class _MiniNavigatorState extends State<MiniNavigator> {
  int? _lastReportedIndex;

  void _handlePointer(double dx, double dy, double totalWidth, double totalHeight) {
    if (dy < -40 || dy > totalHeight + 40 || dx < -40 || dx > totalWidth + 40) return;
    final double spacing = (3.w).clamp(2.0, 3.5);
    final double step = (totalWidth + spacing) / 9;
    final int index = (dx / step).floor().clamp(0, 8);

    if (_lastReportedIndex != index) {
      _lastReportedIndex = index;
      widget.onSelectQuestion(index);
    }
  }

  void _onPointerDown(double dx, double dy, double totalWidth, double totalHeight) {
    _lastReportedIndex = null;
    _handlePointer(dx, dy, totalWidth, totalHeight);
  }

  void _onPointerUp() {
    // Retain _lastReportedIndex momentarily so child GestureDetector.onTap does not fire redundant duplicate
  }

  @override
  Widget build(BuildContext context) {
    final double height = (105.h).clamp(48.0, 60.0);
    return Container(
      height: height,
      margin: widget.margin ?? EdgeInsets.symmetric(vertical: 4.h),
      padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 2.h),
      decoration: BoxDecoration(
        color: Cores.kWhiteColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Cores.kBorderColor.withValues(alpha: 0.8),
          width: 1.5.w,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          return Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (event) =>
                _onPointerDown(event.localPosition.dx, event.localPosition.dy, totalWidth, height),
            onPointerMove: (event) =>
                _handlePointer(event.localPosition.dx, event.localPosition.dy, totalWidth, height),
            onPointerUp: (_) => _onPointerUp(),
            onPointerCancel: (_) => _onPointerUp(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _buildNavItems(),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildNavItems() {
    final List<Widget> items = [];
    for (int index = 0; index < 9; index++) {
      final isCurrent = widget.currentQuestion == index;
      final answer = index < widget.stepAnswers.length ? widget.stepAnswers[index] : 0;
      final effectiveAnswer =
          isCurrent && widget.currentSelection > 0 ? widget.currentSelection : answer;
      final isAnswered = effectiveAnswer > 0;

      Color bgColor;
      Border? border;
      Color titleColor;
      Color valueColor;

      if (isCurrent) {
        bgColor = Cores.kAzulDrawerItemColor;
        border = Border.all(color: Cores.kAzulBotaoItemColor, width: 1.5.w);
        titleColor = Cores.kTertiaryColor;
        valueColor = Cores.kAzulBotaoItemColor;
      } else if (isAnswered) {
        bgColor = const Color(0xFFF0FDF4);
        border = null;
        titleColor = Cores.kTertiaryColor;
        valueColor = Cores.kTertiaryColor;
      } else {
        bgColor = Cores.kWhiteColor;
        border = null;
        titleColor = const Color(0xFF64748B);
        valueColor = const Color(0xFF94A3B8);
      }

      if (index > 0) {
        items.add(SizedBox(width: (3.w).clamp(2.0, 3.5)));
      }

      items.add(
        Expanded(
          child: GestureDetector(
            key: Key('mini_nav_question_$index'),
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (_lastReportedIndex == index) return;
              _lastReportedIndex = index;
              widget.onSelectQuestion(index);
            },
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 32,
                minHeight: 48,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12.r),
                  border: border,
                ),
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'P${index + 1}',
                          style: TextStyle(
                            fontSize: 38.sp,
                            fontWeight:
                                isCurrent ? FontWeight.bold : FontWeight.w600,
                            color: titleColor,
                            fontFamily: 'Roboto-Regular',
                            height: 1.0,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          isAnswered ? '★$effectiveAnswer' : '—',
                          style: TextStyle(
                            fontSize: 40.sp,
                            fontWeight:
                                isAnswered ? FontWeight.bold : FontWeight.w600,
                            color: valueColor,
                            fontFamily: 'Roboto-Regular',
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return items;
  }
}
