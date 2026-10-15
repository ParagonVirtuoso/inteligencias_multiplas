import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inteligencias_multiplas/utils/cores.dart';
import 'package:inteligencias_multiplas/utils/strings.dart';

class CardTutorial extends StatefulWidget {
  final Future<dynamic> Function() buscarDadosTeste;
  final bool hasSavedProgress;

  const CardTutorial({
    super.key,
    required this.buscarDadosTeste,
    this.hasSavedProgress = false,
  });

  @override
  State<CardTutorial> createState() => _CardTutorialState();
}

class _CardTutorialState extends State<CardTutorial> {
  int _selectedChip = 5;
  // Key: chip value (1-9), Value: question index (0-8)
  final Map<int, int> _assignedChips = {3: 1, 7: 3};
  String? _swapFeedback;

  void _onChipTap(int value) {
    setState(() {
      if (_selectedChip == value) return;

      if (_assignedChips.containsKey(value)) {
        final oldAssignedQ = _assignedChips[value]!;
        _assignedChips.remove(value);
        _assignedChips[_selectedChip] = oldAssignedQ;
        _selectedChip = value;
        _swapFeedback = Strings.tutorialNotasTrocadas(oldAssignedQ + 1);
      } else {
        _selectedChip = value;
        _swapFeedback = Strings.tutorialNotaSelecionada(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: (8.h).clamp(4.0, 10.0)),
              Text(
                Strings.comoFunciona,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: (56.sp).clamp(22.0, 28.0),
                  color: Cores.kTertiaryColor,
                  fontFamily: 'Roboto-Regular',
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: (14.h).clamp(10.0, 16.0)),
              Text(
                Strings.avalieCadaQuestao,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: (38.sp).clamp(13.5, 15.5),
                  color: Cores.kQuaternaryColor,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Roboto-Regular',
                  height: 1.35,
                ),
              ),
              SizedBox(height: (12.h).clamp(8.0, 14.0)),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: (34.sp).clamp(12.5, 14.0),
                    color: Cores.kQuaternaryColor,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Roboto-Regular',
                  ),
                  children: <TextSpan>[
                    const TextSpan(text: Strings.voce),
                    TextSpan(
                      text: Strings.naoRepetirRespesta,
                      style: TextStyle(
                        fontSize: (34.sp).clamp(12.5, 14.0),
                        color: Cores.kTertiaryColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto-Regular',
                      ),
                    ),
                    const TextSpan(text: Strings.naoRepetirRespestaDescricao),
                  ],
                ),
              ),
              SizedBox(height: (14.h).clamp(10.0, 16.0)),
              _buildChipsPreview(context),
              SizedBox(height: (14.h).clamp(10.0, 16.0)),
              _buildFeatureTile(
                key: const Key('tutorial_feature_chips'),
                icon: Icons.format_list_numbered_rounded,
                title: Strings.tutorialFichasTitulo,
                description: Strings.tutorialFichasDescricao,
              ),
              _buildFeatureTile(
                key: const Key('tutorial_feature_swap'),
                icon: Icons.swap_horiz_rounded,
                title: Strings.tutorialSwapTitulo,
                description: Strings.tutorialSwapDescricao,
              ),
              _buildFeatureTile(
                key: const Key('tutorial_feature_nav'),
                icon: Icons.explore_outlined,
                title: Strings.tutorialNavTitulo,
                description: Strings.tutorialNavDescricao,
              ),
              SizedBox(height: (12.h).clamp(8.0, 14.0)),
              _buildTipBanner(),
              SizedBox(height: (10.h).clamp(6.0, 12.0)),
              _buildStartButton(context),
              SizedBox(height: (16.h).clamp(8.0, 16.0)),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildTipBanner() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: (16.w).clamp(12.0, 18.0),
        vertical: (10.h).clamp(8.0, 12.0),
      ),
      decoration: BoxDecoration(
        color: Cores.kAzulDrawerItemColor.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Cores.kTertiaryColor.withValues(alpha: 0.12),
          width: 1.w,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.lightbulb_outline_rounded,
            color: Cores.kTertiaryColor,
            size: 20,
          ),
          SizedBox(width: (10.w).clamp(8.0, 12.0)),
          Expanded(
            child: Text(
              Strings.naoExisteRespostaCerta,
              style: TextStyle(
                fontSize: (30.sp).clamp(12.0, 13.5),
                color: Cores.kTertiaryColor,
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto-Regular',
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return GestureDetector(
      key: const Key('home_start_test_button'),
      onTap: () async {
        var dataTest = await widget.buscarDadosTeste();
        if (context.mounted && dataTest) {
          Navigator.pushNamed(context, Strings.questionsNavigate);
        }
      },
      child: Container(
        height: (120.h).clamp(48.0, 56.0),
        width: (650.w).clamp(260.0, 380.0),
        margin: EdgeInsets.symmetric(
          vertical: (24.h).clamp(16.0, 24.0),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          color: Cores.kAzulGradientDownColor,
          boxShadow: [
            BoxShadow(
              color: Cores.kAzulGradientDownColor.withValues(alpha: 0.35),
              blurRadius: 8.r,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(
          horizontal: (24.w).clamp(12.0, 24.0),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Image(image: AssetImage(Strings.playIconAsset)),
              SizedBox(width: (20.w).clamp(12.0, 20.0)),
              Text(
                widget.hasSavedProgress
                    ? Strings.continuarTeste
                    : Strings.iniciarTeste,
                style: TextStyle(
                  fontSize: (42.sp).clamp(16.0, 18.0),
                  color: Cores.kWhiteColor,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Roboto-Regular',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChipsPreview(BuildContext context) {
    final double height = (105.h).clamp(48.0, 54.0);
    return Container(
      key: const Key('tutorial_chips_container'),
      padding: EdgeInsets.symmetric(
        horizontal: (10.w).clamp(8.0, 14.0),
        vertical: (10.h).clamp(8.0, 12.0),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: Cores.kAzulDrawerItemColor.withValues(alpha: 0.55),
        border: Border.all(
          color: Cores.kTertiaryColor.withValues(alpha: 0.14),
          width: 1.w,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: (8.h).clamp(6.0, 10.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    Strings.tutorialFichasTitulo,
                    style: TextStyle(
                      fontSize: (30.sp).clamp(11.5, 13.0),
                      fontWeight: FontWeight.w700,
                      color: Cores.kTertiaryColor,
                      fontFamily: 'Roboto-Regular',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8.w),
                Flexible(
                  child: Text(
                    Strings.toqueParaTestar,
                    style: TextStyle(
                      fontSize: (26.sp).clamp(10.5, 12.0),
                      fontWeight: FontWeight.w500,
                      color: Cores.kDeepGreyColor,
                      fontFamily: 'Roboto-Regular',
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: height,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _buildPreviewChips(),
            ),
          ),
          if (_swapFeedback != null) ...[
            Padding(
              padding: EdgeInsets.only(top: 6.h),
              child: Text(
                _swapFeedback!,
                key: const Key('tutorial_swap_feedback'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: (26.sp).clamp(11.0, 12.5),
                  color: Cores.kAzulBotaoItemColor,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Roboto-Regular',
                ),
              ),
            ),
          ],
          Padding(
            padding: EdgeInsets.only(top: (10.h).clamp(8.0, 12.0)),
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: (16.w).clamp(8.0, 16.0),
              runSpacing: 4.h,
              children: [
                _buildLegendItem(
                  badge: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Cores.kAzulBotaoItemColor,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: const Icon(Icons.check, size: 11, color: Colors.white),
                  ),
                  label: Strings.legendaSuaNota,
                ),
                _buildLegendItem(
                  badge: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Cores.kWhiteColor,
                      borderRadius: BorderRadius.circular(4.r),
                      border: Border.all(
                        color: Cores.kTertiaryColor.withValues(alpha: 0.35),
                        width: 1,
                      ),
                    ),
                  ),
                  label: Strings.legendaDisponivel,
                ),
                _buildLegendItem(
                  badge: Container(
                    width: 16,
                    height: 16,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(4.r),
                      border: Border.all(
                        color: const Color(0xFFCBD5E1),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      Strings.legendaBadgePerguntaExemplo,
                      style: TextStyle(
                        fontSize: 9.0,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF64748B),
                        fontFamily: 'Roboto-Regular',
                      ),
                    ),
                  ),
                  label: Strings.legendaAtribuida,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPreviewChips() {
    final List<Widget> items = [];
    for (int index = 0; index < 9; index++) {
      final value = index + 1;
      final isSelected = _selectedChip == value;
      final assignedQuestion = _assignedChips[value];
      final isAssigned = !isSelected && assignedQuestion != null;

      if (index > 0) {
        items.add(const SizedBox(width: 4.0));
      }

      final String tooltipMessage = isSelected
          ? Strings.tooltipNotaSelecionada(value)
          : isAssigned
              ? Strings.tooltipNotaAtribuida(value, assignedQuestion + 1)
              : Strings.tooltipNotaDisponivel(value);

      items.add(
        Expanded(
          child: Semantics(
            label: tooltipMessage,
            button: true,
            selected: isSelected,
            child: Tooltip(
              message: tooltipMessage,
              child: GestureDetector(
                key: Key('tutorial_chip_$value'),
                behavior: HitTestBehavior.opaque,
                onTap: () => _onChipTap(value),
                child: _buildSingleChip(
                  value: value,
                  isSelected: isSelected,
                  isAssigned: isAssigned,
                  assignedQuestion: assignedQuestion,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return items;
  }

  Widget _buildSingleChip({
    required int value,
    required bool isSelected,
    required bool isAssigned,
    int? assignedQuestion,
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
    } else if (isAssigned) {
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

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14.r),
        border: border,
        boxShadow: boxShadow,
      ),
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
                fontSize: isAssigned ? 34.sp : (isSelected ? 38.sp : 42.sp),
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto-Regular',
                height: 1.0,
              ),
            ),
            if (isSelected) ...[
              SizedBox(height: 2.h),
              Icon(
                Icons.check,
                size: 16.sp,
                color: textColor,
              ),
            ] else if (isAssigned && assignedQuestion != null) ...[
              SizedBox(height: 2.h),
              Text(
                Strings.rotuloPerguntaAbreviada(assignedQuestion + 1),
                style: TextStyle(
                  color: textColor,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto-Regular',
                  height: 1.0,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem({
    required Widget badge,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        badge,
        SizedBox(width: (6.w).clamp(4.0, 8.0)),
        Text(
          label,
          style: TextStyle(
            fontSize: (26.sp).clamp(11.0, 12.5),
            color: Cores.kDeepGreyColor,
            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto-Regular',
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureTile({
    required IconData icon,
    required String title,
    required String description,
    required Key key,
  }) {
    return Container(
      key: key,
      margin: EdgeInsets.symmetric(vertical: (6.h).clamp(4.0, 8.0)),
      padding: EdgeInsets.symmetric(
        horizontal: (14.w).clamp(12.0, 18.0),
        vertical: (12.h).clamp(10.0, 14.0),
      ),
      decoration: BoxDecoration(
        color: Cores.kAzulDrawerItemColor.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Cores.kTertiaryColor.withValues(alpha: 0.10),
          width: 1.w,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: (38.r).clamp(34.0, 42.0),
            height: (38.r).clamp(34.0, 42.0),
            decoration: BoxDecoration(
              color: Cores.kWhiteColor,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: Cores.kTertiaryColor.withValues(alpha: 0.15),
                width: 1.w,
              ),
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              size: (22.r).clamp(18.0, 22.0),
              color: Cores.kAzulBotaoItemColor,
            ),
          ),
          SizedBox(width: (12.w).clamp(10.0, 14.0)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: (36.sp).clamp(14.0, 15.5),
                    color: Cores.kTertiaryColor,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Roboto-Regular',
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: (30.sp).clamp(12.0, 13.5),
                    color: Cores.kQuaternaryColor,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Roboto-Regular',
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
