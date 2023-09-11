import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inteligencias_multiplas/screens/questionsPage/componentes/star_rate.dart';
import 'package:inteligencias_multiplas/utils/cores.dart';
import 'package:inteligencias_multiplas/utils/etapas.dart';
import 'package:inteligencias_multiplas/utils/strings.dart';
import '../../controller/finishTestController/finish_test_controller.dart';
import '../../utils/perguntas.dart';
import 'componentes/modal_alerta_resposta.dart';

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({Key? key}) : super(key: key);

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  double progressoTotal = 0.0;
  int selectedStar = 0;
  int currentStep = 0;
  int currentQuestion = 0;
  Color corBotaoNext = Cores.kAzulBotaoDisableItemColor;
  dynamic data;

  List<List<int>> respostas =
      List.generate(10, (i) => List.filled(7, 0), growable: true);
  var listaJaRespondida = [false, false, false, false, false, false, false];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    data = ModalRoute.of(context)?.settings.arguments;
    if (data != null) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        tratarDadosFirebase(context, data);
      });
    }
  }

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
        body: Container(
          margin:
              EdgeInsets.only(left: 50.w, right: 50.w, top: 10.h, bottom: 10.h),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 50.w,
                      height: 45.h,
                      margin: EdgeInsets.only(left: 40.w, top: 20.h),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Cores.kWhiteColor,
                        borderRadius: BorderRadius.circular(13.r),
                        border:
                            Border.all(color: Cores.kTertiaryColor, width: 4.w),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Cores.kTertiaryColor,
                        size: 13,
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.only(right: 50.w),
                        child: Text(
                          '${Strings.etapa} ${currentStep + 1}',
                          style: TextStyle(
                              fontSize: 40.sp,
                              fontFamily: 'Roboto-Regular',
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ))
                ],
              ),
              Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10.h),
                        height: 120.h,
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
                        height: 820.h,
                        margin: EdgeInsets.only(top: 20.h, bottom: 20.h),
                        child: Image.asset(
                          Strings.pergunta1Asset,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20.h),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Cores.kTertiaryColor, width: 4.w),
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
                        margin: EdgeInsets.only(top: 20.h),
                        height: 120.h,
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
                        margin: EdgeInsets.only(top: 20.h),
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
                          listaJaRespondida: listaJaRespondida),
                      GestureDetector(
                        onTap: () {
                          registrarResposta();
                        },
                        child: Container(
                          height: 120.h,
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
                  ))
            ],
          ),
        ));
  }

  void registrarResposta() {
    if (!verificarSelecaoEstrela()) {
      return;
    }

    for (int i = 0; i < 7; i++) {
      if (respostas[currentStep][i] == selectedStar) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(Strings.voceUsouSelecao),
            backgroundColor: Cores.kErroColor,
          ),
        );
        showModalBottomSheet<void>(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(90.r),
              topRight: Radius.circular(90.r),
            ),
          ),
          builder: (BuildContext context) {
            return ModalAlertaResposta(
                currentQuestion: currentQuestion,
                respostaIgual: i,
                setEditarResposta: setEditarResposta);
          },
        );
        selectedStar = 0;
        return;
      }
    }

    respostas[currentStep][currentQuestion] = selectedStar;
    progressoTotal += 0.0142;
    listaJaRespondida[selectedStar - 1] = true;
    selectedStar = 0;

    currentQuestion = obterProximaPergunta();
    if (currentQuestion == 7) {
      currentStep++;
      currentQuestion = 0;
      listaJaRespondida = List.filled(7, false);
    }

    setState(() {
      progressoTotal;
      selectedStar;
      corBotaoNext = Cores.kAzulBotaoDisableItemColor;
      currentQuestion;
      currentStep;
      listaJaRespondida;
    });
  }

  bool verificarSelecaoEstrela() {
    if (selectedStar == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(Strings.selecioneEstrela),
          backgroundColor: Cores.kAlertaColor,
        ),
      );
      return false;
    }
    return true;
  }

  int obterProximaPergunta() {
    int proximaPergunta = currentQuestion;
    while (
        proximaPergunta < 7 && respostas[currentStep][proximaPergunta] != 0) {
      proximaPergunta++;
    }
    return proximaPergunta;
  }

  void selecionarEstrela(int index) {
    setState(() {
      selectedStar = index;
      corBotaoNext = Cores.kAzulBotaoItemColor;
    });
  }

  setEditarResposta(i) {
    setState(() {
      currentQuestion = i;
      respostas[currentStep][currentQuestion] = 0;
    });
  }

  void tratarDadosFirebase(BuildContext context, dynamic data) {
    if (data['TOTAL'] != null) {
      FinishResultController().navResult(context, data['TOTAL']);
      return;
    }
    if (data['ETAPA 1'] != null) {
      currentStep = 1;
      respostas[0][0] = data['ETAPA 1']['RESPOSTA1'];
      respostas[0][1] = data['ETAPA 1']['RESPOSTA2'];
      respostas[0][2] = data['ETAPA 1']['RESPOSTA3'];
      respostas[0][3] = data['ETAPA 1']['RESPOSTA4'];
      respostas[0][4] = data['ETAPA 1']['RESPOSTA5'];
      respostas[0][5] = data['ETAPA 1']['RESPOSTA6'];
      respostas[0][6] = data['ETAPA 1']['RESPOSTA7'];
      progressoTotal += 0.0142 * 7;
    }
    if (data['ETAPA 2'] != null) {
      currentStep = 2;
      respostas[1][0] = data['ETAPA 2']['RESPOSTA1'];
      respostas[1][1] = data['ETAPA 2']['RESPOSTA2'];
      respostas[1][2] = data['ETAPA 2']['RESPOSTA3'];
      respostas[1][3] = data['ETAPA 2']['RESPOSTA4'];
      respostas[1][4] = data['ETAPA 2']['RESPOSTA5'];
      respostas[1][5] = data['ETAPA 2']['RESPOSTA6'];
      respostas[1][6] = data['ETAPA 2']['RESPOSTA7'];
      progressoTotal += 0.0142 * 7;
    }
    if (data['ETAPA 3'] != null) {
      currentStep = 3;
      respostas[2][0] = data['ETAPA 3']['RESPOSTA1'];
      respostas[2][1] = data['ETAPA 3']['RESPOSTA2'];
      respostas[2][2] = data['ETAPA 3']['RESPOSTA3'];
      respostas[2][3] = data['ETAPA 3']['RESPOSTA4'];
      respostas[2][4] = data['ETAPA 3']['RESPOSTA5'];
      respostas[2][5] = data['ETAPA 3']['RESPOSTA6'];
      respostas[2][6] = data['ETAPA 3']['RESPOSTA7'];
      progressoTotal += 0.0142 * 7;
    }
    if (data['ETAPA 4'] != null) {
      currentStep = 4;
      respostas[3][0] = data['ETAPA 4']['RESPOSTA1'];
      respostas[3][1] = data['ETAPA 4']['RESPOSTA2'];
      respostas[3][2] = data['ETAPA 4']['RESPOSTA3'];
      respostas[3][3] = data['ETAPA 4']['RESPOSTA4'];
      respostas[3][4] = data['ETAPA 4']['RESPOSTA5'];
      respostas[3][5] = data['ETAPA 4']['RESPOSTA6'];
      respostas[3][6] = data['ETAPA 4']['RESPOSTA7'];
      progressoTotal += 0.0142 * 7;
    }
    if (data['ETAPA 5'] != null) {
      currentStep = 5;
      respostas[4][0] = data['ETAPA 5']['RESPOSTA1'];
      respostas[4][1] = data['ETAPA 5']['RESPOSTA2'];
      respostas[4][2] = data['ETAPA 5']['RESPOSTA3'];
      respostas[4][3] = data['ETAPA 5']['RESPOSTA4'];
      respostas[4][4] = data['ETAPA 5']['RESPOSTA5'];
      respostas[4][5] = data['ETAPA 5']['RESPOSTA6'];
      respostas[4][6] = data['ETAPA 5']['RESPOSTA7'];
      progressoTotal += 0.0142 * 7;
    }
    if (data['ETAPA 6'] != null) {
      currentStep = 6;
      respostas[5][0] = data['ETAPA 6']['RESPOSTA1'];
      respostas[5][1] = data['ETAPA 6']['RESPOSTA2'];
      respostas[5][2] = data['ETAPA 6']['RESPOSTA3'];
      respostas[5][3] = data['ETAPA 6']['RESPOSTA4'];
      respostas[5][4] = data['ETAPA 6']['RESPOSTA5'];
      respostas[5][5] = data['ETAPA 6']['RESPOSTA6'];
      respostas[5][6] = data['ETAPA 6']['RESPOSTA7'];
      progressoTotal += 0.0142 * 7;
    }
    if (data['ETAPA 7'] != null) {
      currentStep = 7;
      respostas[6][0] = data['ETAPA 7']['RESPOSTA1'];
      respostas[6][1] = data['ETAPA 7']['RESPOSTA2'];
      respostas[6][2] = data['ETAPA 7']['RESPOSTA3'];
      respostas[6][3] = data['ETAPA 7']['RESPOSTA4'];
      respostas[6][4] = data['ETAPA 7']['RESPOSTA5'];
      respostas[6][5] = data['ETAPA 7']['RESPOSTA6'];
      respostas[6][6] = data['ETAPA 7']['RESPOSTA7'];
      progressoTotal += 0.0142 * 7;
    }
    if (data['ETAPA 8'] != null) {
      currentStep = 8;
      respostas[7][0] = data['ETAPA 8']['RESPOSTA1'];
      respostas[7][1] = data['ETAPA 8']['RESPOSTA2'];
      respostas[7][2] = data['ETAPA 8']['RESPOSTA3'];
      respostas[7][3] = data['ETAPA 8']['RESPOSTA4'];
      respostas[7][4] = data['ETAPA 8']['RESPOSTA5'];
      respostas[7][5] = data['ETAPA 8']['RESPOSTA6'];
      respostas[7][6] = data['ETAPA 8']['RESPOSTA7'];
      progressoTotal += 0.0142 * 7;
    }
    if (data['ETAPA 9'] != null) {
      currentStep = 9;
      respostas[8][0] = data['ETAPA 9']['RESPOSTA1'];
      respostas[8][1] = data['ETAPA 9']['RESPOSTA2'];
      respostas[8][2] = data['ETAPA 9']['RESPOSTA3'];
      respostas[8][3] = data['ETAPA 9']['RESPOSTA4'];
      respostas[8][4] = data['ETAPA 9']['RESPOSTA5'];
      respostas[8][5] = data['ETAPA 9']['RESPOSTA6'];
      respostas[8][6] = data['ETAPA 9']['RESPOSTA7'];
      progressoTotal += 0.0142 * 7;
    }
    if (data['ETAPA 10'] != null) {
      respostas[9][0] = data['ETAPA 10']['RESPOSTA1'];
      respostas[9][1] = data['ETAPA 10']['RESPOSTA2'];
      respostas[9][2] = data['ETAPA 10']['RESPOSTA3'];
      respostas[9][3] = data['ETAPA 10']['RESPOSTA4'];
      respostas[9][4] = data['ETAPA 10']['RESPOSTA5'];
      respostas[9][5] = data['ETAPA 10']['RESPOSTA6'];
      respostas[9][6] = data['ETAPA 10']['RESPOSTA7'];
      FinishResultController().navFinishTest(context, respostas);
    }
  }
}
