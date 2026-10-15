import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inteligencias_multiplas/utils/cores.dart';
import 'package:inteligencias_multiplas/utils/strings.dart';

class NumericChips extends StatefulWidget {
  final int selectedValue;
  final List<int> stepAnswers;
  final int currentQuestionIndex;
  final ValueChanged<int> onSelectValue;
  final void Function(int value, int assignedQuestionIndex) onSwapRequested;
  final EdgeInsetsGeometry? margin;

  const NumericChips({
    super.key,
    required this.selectedValue,
    required this.stepAnswers,
    required this.currentQuestionIndex,
    required this.onSelectValue,
    required this.onSwapRequested,
    this.margin,
  });

  @override
  State<NumericChips> createState() => _NumericChipsState();
}

class _NumericChipsState extends State<NumericChips> {
  int? _previewValue;
  bool _isCancelled = false;

  @override
  void didUpdateWidget(covariant NumericChips oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentQuestionIndex != oldWidget.currentQuestionIndex ||
        widget.selectedValue != oldWidget.selectedValue ||
        widget.stepAnswers != oldWidget.stepAnswers) {
      _previewValue = null;
      _isCancelled = false;
    }
  }

  int _getValueFromDx(double dx, double totalWidth) {
    const double chipSpacing = 5.0;
    final double step = (totalWidth + chipSpacing) / 9;
    final int index = (dx / step).floor().clamp(0, 8);
    return index + 1;
  }

  bool _isOutOfBounds(double dx, double dy, double totalWidth, double totalHeight) {
    return dy < -40 || dy > totalHeight + 40 || dx < -40 || dx > totalWidth + 40;
  }

  void _commitValue(int value) {
    int assignedQuestion = -1;
    for (int q = 0; q < widget.stepAnswers.length; q++) {
      if (widget.stepAnswers[q] == value) {
        assignedQuestion = q;
        break;
      }
    }

    final isAssignedToOther = assignedQuestion != -1 &&
        assignedQuestion != widget.currentQuestionIndex;

    if (isAssignedToOther) {
      widget.onSwapRequested(value, assignedQuestion);
    } else {
      widget.onSelectValue(value);
    }
  }

  void _onPointerDown(PointerDownEvent event, double totalWidth, double totalHeight) {
    if (_isOutOfBounds(event.localPosition.dx, event.localPosition.dy, totalWidth, totalHeight)) {
      setState(() {
        _isCancelled = true;
        _previewValue = null;
      });
      return;
    }
    final val = _getValueFromDx(event.localPosition.dx, totalWidth);
    setState(() {
      _isCancelled = false;
      _previewValue = val;
    });
  }

  void _onPointerMove(PointerMoveEvent event, double totalWidth, double totalHeight) {
    if (_isOutOfBounds(event.localPosition.dx, event.localPosition.dy, totalWidth, totalHeight)) {
      if (!_isCancelled) {
        setState(() {
          _isCancelled = true;
          _previewValue = null;
        });
      }
      return;
    }

    final val = _getValueFromDx(event.localPosition.dx, totalWidth);
    if (_isCancelled || _previewValue != val) {
      setState(() {
        _isCancelled = false;
        _previewValue = val;
      });
    }
  }

  void _onPointerUp(PointerUpEvent event, double totalWidth, double totalHeight) {
    final isOut = _isOutOfBounds(event.localPosition.dx, event.localPosition.dy, totalWidth, totalHeight);
    if (!_isCancelled && !isOut) {
      final val = _previewValue ?? _getValueFromDx(event.localPosition.dx, totalWidth);
      _commitValue(val);
    }
    setState(() {
      _previewValue = null;
      _isCancelled = false;
    });
  }

  void _onPointerCancel(PointerCancelEvent event) {
    setState(() {
      _previewValue = null;
      _isCancelled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = (110.h).clamp(52.0, 54.0);
    return Container(
      height: height,
      margin: widget.margin ??
          EdgeInsets.only(
            top: (10.h).clamp(8.0, 12.0),
            bottom: (18.h).clamp(16.0, 22.0),
          ),
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 1.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: Cores.kAzulDrawerItemColor.withValues(alpha: 0.65),
        border: Border.all(
          color: Cores.kTertiaryColor.withValues(alpha: 0.12),
          width: 1.w,
        ),
      ),
      alignment: Alignment.center,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          return Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (event) => _onPointerDown(event, totalWidth, height),
            onPointerMove: (event) => _onPointerMove(event, totalWidth, height),
            onPointerUp: (event) => _onPointerUp(event, totalWidth, height),
            onPointerCancel: _onPointerCancel,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _buildChipsList(context),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildChipsList(BuildContext context) {
    final List<Widget> items = [];
    for (int index = 0; index < 9; index++) {
      final value = index + 1;
      final isPreviewed = _previewValue == value;
      final isCommitted = widget.selectedValue == value;
      final isSelected = _previewValue != null ? isPreviewed : isCommitted;
      final isPreviouslyCommitted =
          _previewValue != null && isCommitted && !isPreviewed;

      int assignedQuestion = -1;
      for (int q = 0; q < widget.stepAnswers.length; q++) {
        if (widget.stepAnswers[q] == value) {
          assignedQuestion = q;
          break;
        }
      }

      final isAssignedToOther = assignedQuestion != -1 &&
          assignedQuestion != widget.currentQuestionIndex;

      if (index > 0) {
        items.add(const SizedBox(width: 5.0));
      }

      items.add(
        Expanded(
          child: _buildChip(
            context: context,
            value: value,
            isSelected: isSelected,
            isPreviewed: isPreviewed,
            isPreviouslyCommitted: isPreviouslyCommitted,
            isAssignedToOther: isAssignedToOther,
            assignedQuestion: assignedQuestion,
          ),
        ),
      );
    }
    return items;
  }

  Widget _buildChip({
    required BuildContext context,
    required int value,
    required bool isSelected,
    required bool isPreviewed,
    required bool isPreviouslyCommitted,
    required bool isAssignedToOther,
    required int assignedQuestion,
  }) {
    Color backgroundColor;
    Color textColor;
    Border border;
    List<BoxShadow>? boxShadow;

    if (isSelected) {
      backgroundColor = Cores.kAzulBotaoItemColor;
      textColor = Cores.kWhiteColor;
      border = Border.all(color: Cores.kTertiaryColor, width: 1.5.w);
      boxShadow = [
        BoxShadow(
          color: Cores.kAzulBotaoItemColor.withValues(alpha: 0.35),
          blurRadius: 4.r,
          offset: const Offset(0, 1.5),
        ),
      ];
    } else if (isPreviouslyCommitted) {
      backgroundColor = Cores.kAzulDrawerItemColor;
      textColor = Cores.kAzulBotaoItemColor;
      border = Border.all(
        color: Cores.kAzulBotaoItemColor.withValues(alpha: 0.6),
        width: 1.5.w,
      );
      boxShadow = null;
    } else if (isAssignedToOther) {
      backgroundColor = const Color(0xFFF1F5F9);
      textColor = const Color(0xFF64748B);
      border = Border.all(color: const Color(0xFFCBD5E1), width: 1.w);
      boxShadow = null;
    } else {
      backgroundColor = Cores.kWhiteColor;
      textColor = Cores.kTertiaryColor;
      border = Border.all(
        color: Cores.kTertiaryColor.withValues(alpha: 0.25),
        width: 1.w,
      );
      boxShadow = [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 2.r,
          offset: const Offset(0, 1),
        ),
      ];
    }

    final bool isActuallySelected = _previewValue != null ? isPreviewed : isSelected;

    return Semantics(
      label: isActuallySelected
          ? 'Nota $value, ${Strings.suaNota}'
          : isAssignedToOther
              ? 'Nota $value, atribuída à Pergunta ${assignedQuestion + 1}'
              : 'Nota $value',
      button: true,
      selected: isActuallySelected,
      onTap: () => _commitValue(value),
      child: Tooltip(
        message: isActuallySelected
            ? 'Nota $value (${Strings.suaNota})'
            : isAssignedToOther
                ? 'Nota $value (Atribuída à P${assignedQuestion + 1})'
                : 'Nota $value',
        child: GestureDetector(
          key: Key('numeric_chip_$value'),
          behavior: HitTestBehavior.opaque,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 48,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(16.r),
                border: border,
                boxShadow: boxShadow,
              ),
              padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 2.h),
              alignment: Alignment.center,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '$value',
                      style: TextStyle(
                        color: textColor,
                        fontSize: isAssignedToOther
                            ? 38.sp
                            : (isSelected || isPreviouslyCommitted)
                                ? 44.sp
                                : 48.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto-Regular',
                        height: 1.0,
                      ),
                    ),
                    if (isSelected && !isAssignedToOther) ...[
                      SizedBox(height: 2.h),
                      Icon(
                        Icons.check,
                        size: 18.sp,
                        color: textColor,
                      ),
                    ] else if (isAssignedToOther) ...[
                      SizedBox(height: 2.h),
                      Text(
                        'P${assignedQuestion + 1}',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto-Regular',
                          height: 1.0,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
