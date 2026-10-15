import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inteligencias_multiplas/utils/cores.dart';
import 'package:inteligencias_multiplas/utils/strings.dart';

class SmartSwapModal extends StatelessWidget {
  final int targetValue;
  final int currentQuestionIndex;
  final String currentQuestionText;
  final int currentAnswer;
  final int otherQuestionIndex;
  final String otherQuestionText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const SmartSwapModal({
    super.key,
    required this.targetValue,
    required this.currentQuestionIndex,
    required this.currentQuestionText,
    required this.currentAnswer,
    required this.otherQuestionIndex,
    required this.otherQuestionText,
    required this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 640),
        padding: EdgeInsets.only(
          left: 40.w,
          right: 40.w,
          top: 25.h,
          bottom: 40.h,
        ),
        decoration: BoxDecoration(
          color: Cores.kWhiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.r),
            topRight: Radius.circular(40.r),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top drag handle
                Container(
                  width: 90.w,
                  height: 8.h,
                  margin: EdgeInsets.only(bottom: 25.h),
                  decoration: BoxDecoration(
                    color: Cores.kDarkGreyColor.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),

                // Swap icon
                Container(
                  width: 130.r,
                  height: 130.r,
                  decoration: const BoxDecoration(
                    color: Cores.kAzulDrawerItemColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.swap_horiz_rounded,
                      size: 70.sp,
                      color: Cores.kAzulBotaoItemColor,
                    ),
                  ),
                ),
              SizedBox(height: 20.h),

              // Title
              Text(
                '${Strings.trocarNota} $targetValue?',
                style: TextStyle(
                  fontSize: 55.sp,
                  fontWeight: FontWeight.bold,
                  color: Cores.kQuaternaryColor,
                  fontFamily: 'Roboto-Regular',
                ),
                textAlign: TextAlign.center,
                textScaler: TextScaler.noScaling,
              ),
              SizedBox(height: 12.h),

              // Subtitle
              Text(
                'A nota $targetValue já está atribuída à Pergunta ${otherQuestionIndex + 1}. Deseja efetuar a troca?',
                style: TextStyle(
                  fontSize: 38.sp,
                  color: Cores.kDeepGreyColor,
                  fontFamily: 'Roboto-Regular',
                ),
                textAlign: TextAlign.center,
                textScaler: TextScaler.noScaling,
              ),
              SizedBox(height: 30.h),

              // Comparison Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 25.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2.w),
                ),
                child: Column(
                  children: [
                    _buildQuestionRow(
                      context: context,
                      label: 'Pergunta ${currentQuestionIndex + 1} (Atual)',
                      questionText: currentQuestionText,
                      oldNoteText: currentAnswer > 0 ? '$currentAnswer' : Strings.semNota,
                      newNoteText: '$targetValue',
                      highlightNew: true,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 18.h),
                      child: Divider(color: const Color(0xFFE2E8F0), height: 1.h),
                    ),
                    _buildQuestionRow(
                      context: context,
                      label: 'Pergunta ${otherQuestionIndex + 1}',
                      questionText: otherQuestionText,
                      oldNoteText: '$targetValue',
                      newNoteText: currentAnswer > 0 ? '$currentAnswer' : Strings.pendente,
                      highlightNew: false,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.h),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: (120.h).clamp(46.0, 56.0),
                      child: ElevatedButton(
                        key: const Key('smart_swap_cancel_button'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Cores.kWhiteColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                            side: BorderSide(
                              color: Cores.kAzulBotaoItemColor,
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
                            Strings.cancelar,
                            style: TextStyle(
                              color: Cores.kAzulBotaoItemColor,
                              fontSize: 42.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Roboto-Regular',
                            ),
                            textScaler: TextScaler.noScaling,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 25.w),
                  Expanded(
                    child: SizedBox(
                      height: (120.h).clamp(46.0, 56.0),
                      child: ElevatedButton(
                        key: const Key('smart_swap_confirm_button'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Cores.kAzulBotaoItemColor,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                            side: BorderSide(
                              color: Cores.kAzulBotaoItemColor,
                              width: 1.5.w,
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          onConfirm();
                        },
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.swap_horiz,
                                color: Cores.kWhiteColor,
                                size: 20,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                Strings.confirmarTroca,
                                style: TextStyle(
                                  color: Cores.kWhiteColor,
                                  fontSize: 42.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Roboto-Regular',
                                ),
                                textScaler: TextScaler.noScaling,
                              ),
                            ],
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
    ),
  );
}

  Widget _buildQuestionRow({
    required BuildContext context,
    required String label,
    required String questionText,
    required String oldNoteText,
    required String newNoteText,
    required bool highlightNew,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 34.sp,
                  fontWeight: FontWeight.bold,
                  color: Cores.kTertiaryColor,
                  fontFamily: 'Roboto-Regular',
                ),
                textScaler: TextScaler.noScaling,
              ),
            ),
            SizedBox(width: 8.w),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  oldNoteText,
                  style: TextStyle(
                    fontSize: 34.sp,
                    color: Cores.kDarkGreyColor,
                    decoration: TextDecoration.lineThrough,
                    fontFamily: 'Roboto-Regular',
                  ),
                  textScaler: TextScaler.noScaling,
                ),
                SizedBox(width: 8.w),
                const Icon(
                  Icons.arrow_forward,
                  size: 14,
                  color: Cores.kDeepGreyColor,
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: highlightNew
                        ? Cores.kAzulBotaoItemColor
                        : const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    newNoteText,
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      color: highlightNew
                          ? Cores.kWhiteColor
                          : Cores.kQuaternaryColor,
                      fontFamily: 'Roboto-Regular',
                    ),
                    textScaler: TextScaler.noScaling,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 6.h),
        Text(
          questionText,
          style: TextStyle(
            fontSize: 32.sp,
            color: Cores.kQuaternaryColor,
            fontFamily: 'Roboto-Regular',
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textScaler: TextScaler.noScaling,
        ),
      ],
    );
  }
}
