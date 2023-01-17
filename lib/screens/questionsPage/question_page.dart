import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inteligencias_multiplas/screens/questionsPage/componentes/star_rate.dart';
import 'package:inteligencias_multiplas/utils/cores.dart';
import 'package:inteligencias_multiplas/utils/etapas.dart';
import 'package:inteligencias_multiplas/utils/strings.dart';
import '../../utils/perguntas.dart';

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({Key? key}) : super(key: key);

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  var progressoTotal = 0.0;
  var selectedStar = 0;
  int currentStep = 0;
  int currentQuestion = 0;
  Color corBotaoNext = Cores.kAzulBotaoDisableItemColor;

  var respostas = List.generate(10, (i) => List.filled(7, 0), growable: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 50.w,
              height: 45.h,
              margin: EdgeInsets.only(left: 40.w, top: 30.h),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Cores.kWhiteColor,
                borderRadius: BorderRadius.circular(13.r),
                border: Border.all(color: Cores.kTertiaryColor, width: 4.w),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Cores.kTertiaryColor,
                size: 13,
              ),
            ),
          ),
          Container(
            width: 900.w,
            margin: EdgeInsets.only(top: 30.h, right: 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${Strings.etapa} ${currentStep + 1}',
                  style: TextStyle(
                      fontSize: 40.sp,
                      fontFamily: 'Roboto-Regular',
                      fontWeight: FontWeight.w500),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30.h),
                  height: 130.h,
                  alignment: Alignment.center,
                  child: Text(
                    etapas[currentStep],
                    style: TextStyle(
                        fontSize: 60.sp,
                        fontFamily: 'Roboto-Regular',
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30.h),
                  child: Image.asset(
                    Strings.pergunta1Asset,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: Cores.kTertiaryColor, width: 4.w),
                    borderRadius: BorderRadius.circular(13.r),
                  ),
                  child: LinearProgressIndicator(
                    value: progressoTotal,
                    backgroundColor: Cores.kWhiteColor,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        Cores.kTertiaryColor),
                  ),
                ),
                Text('${progressoTotal.toStringAsFixed(2)}% completo',
                    style: TextStyle(
                        fontSize: 33.sp,
                        fontFamily: 'Roboto-Regular',
                        fontWeight: FontWeight.w500,
                        color: Cores.kTertiaryColor)),
                Container(
                  margin: EdgeInsets.only(top: 30.h),
                  height: 130.h,
                  alignment: Alignment.center,
                  child: Text(
                    perguntas[currentStep][currentQuestion],
                    style: TextStyle(
                        fontSize: 60.sp,
                        fontFamily: 'Roboto-Regular',
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30.h),
                  child: Text(
                    Strings.quantEstrelaGosta,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 45.sp, fontFamily: 'Roboto-Regular'),
                  ),
                ),
                StarRate(
                  selectedStar: selectedStar,
                  selecionarEstrela: selecionarEstrela,
                ),
                GestureDetector(
                  onTap: () {
                    registrarResposta();
                  },
                  child: Container(
                    height: 130.h,
                    width: 350.w,
                    margin: EdgeInsets.only(top: 5.h, bottom: 5.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.r),
                        color: corBotaoNext),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Image(
                            image: AssetImage(Strings.proximoIconAsset)),
                        SizedBox(
                          width: 20.w,
                        ),
                        Text(
                          Strings.proximo,
                          style: TextStyle(
                            fontSize: 45.sp,
                            color: Cores.kWhiteColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void registrarResposta() {
    var resposta = selectedStar;
    if (selectedStar != 0) {
      if (currentQuestion < 6) {
        for (int i = 0; i < 7; i++) {
          if (respostas[currentStep][i] == selectedStar) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(Strings.voceUsouSelecao),
                backgroundColor: Cores.kErroColor,
              ),
            );
            resposta = 0;
          }
        }
        if (resposta != 0) {
          respostas[currentStep][currentQuestion] = selectedStar;
          setState(() {
            progressoTotal += 0.0142;
            selectedStar = 0;
            corBotaoNext = Cores.kAzulBotaoDisableItemColor;
            currentQuestion += 1;
          });
        }
      } else {
        setState(() {
          progressoTotal += 0.0142;
          selectedStar = 0;
          corBotaoNext = Cores.kAzulBotaoDisableItemColor;
          currentQuestion = 0;
          currentStep += 1;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(Strings.selecioneEstrela),
          backgroundColor: Cores.kAlertaColor,
        ),
      );
    }
  }

  void selecionarEstrela(int index) {
    setState(() {
      selectedStar = index;
      corBotaoNext = Cores.kAzulBotaoItemColor;
    });
  }
}
