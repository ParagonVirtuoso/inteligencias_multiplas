import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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
  const QuestionsPage({super.key});

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  double progressoTotal = 0.0;
  int selectedStar = 0;
  int currentStep = 0;
  int currentQuestion = 0;
  bool editing = false;
  Color corBotaoNext = Cores.kAzulBotaoDisableItemColor;
  dynamic data;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase database = FirebaseDatabase.instance;

  List<List<int>> respostas =
      List.generate(10, (i) => List.filled(7, 0), growable: true);
  var listaJaRespondida = [false, false, false, false, false, false, false];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      data = ModalRoute.of(context)?.settings.arguments;
      if (data != null) {
        tratarDadosFirebase(context, data);
      }
    });
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
                        child: Text(etapas[currentStep],
                            style: TextStyle(
                                fontSize: 60.sp,
                                fontFamily: 'Roboto-Regular',
                                fontWeight: FontWeight.w500),
                            textScaler: TextScaler.noScaling),
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
                        child: Text(perguntas[currentStep][currentQuestion],
                            style: TextStyle(
                                fontSize: 60.sp,
                                fontFamily: 'Roboto-Regular',
                                fontWeight: FontWeight.w500),
                            textScaler: TextScaler.noScaling),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20.h),
                        child: Text(Strings.quantEstrelaGosta,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 45.sp, fontFamily: 'Roboto-Regular'),
                            textScaler: TextScaler.noScaling),
                      ),
                      StarRate(
                          selectedStar: selectedStar,
                          selecionarEstrela: selecionarEstrela,
                          listaJaRespondida: listaJaRespondida),
                      GestureDetector(
                        onTap: registrarResposta,
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

  Future<void> registrarResposta() async {
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
      await salvarListaJaRespondidaFirebase();
      if (currentStep == 9) {
        navegarParaResultados();
        return;
      }
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
    editing = false;
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

  setEditarResposta(int questionToEdit) {
    if (editing) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              Strings.salveEdicaoAtualAntes),
          backgroundColor: Cores.kAlertaColor,
        ),
      );
      return;
    }

    editing = true;
    setState(() {
      listaJaRespondida[questionToEdit] = false;
      corBotaoNext = Cores.kAzulBotaoDisableItemColor;
      respostas[currentStep][questionToEdit] = 0;
      selectedStar = 0;
      currentQuestion = questionToEdit;
      progressoTotal -= 0.0142;
    });
  }

  void verificarConclusao(BuildContext context, dynamic data) {
    if (data['TOTAL'] != null) {
      setState(() {
        FinishResultController().navResult(context, data['TOTAL']);
      });
    } else if (data['ETAPA 10'] != null) {
      setState(() {
        for (int j = 0; j < 7; j++) {
          respostas[9][j] = data['ETAPA 10']['RESPOSTA${j + 1}'];
        }
        FinishResultController().navFinishTest(context, respostas);
      });
    }
  }

  void tratarDadosFirebase(BuildContext context, dynamic data) {
    for (int i = 1; i <= 9; i++) {
      if (data['ETAPA $i'] != null) {
        setState(() {
          currentStep = i;
          for (int j = 0; j < 7; j++) {
            respostas[i - 1][j] = data['ETAPA $i']['RESPOSTA${j + 1}'];
          }
          progressoTotal += 0.0142 * 7;
        });
      }
    }
    verificarConclusao(context, data);
  }

  void navegarParaResultados() {
    FinishResultController().navFinishTest(context, respostas);
  }

  Future<void> salvarListaJaRespondidaFirebase() async {
    if (_auth.currentUser == null) {
      return;
    }

    await database
        .ref()
        .child('usuarios')
        .child(_auth.currentUser!.uid)
        .child('ETAPA ${currentStep + 1}')
        .set({
      'RESPOSTA1': respostas[currentStep][0],
      'RESPOSTA2': respostas[currentStep][1],
      'RESPOSTA3': respostas[currentStep][2],
      'RESPOSTA4': respostas[currentStep][3],
      'RESPOSTA5': respostas[currentStep][4],
      'RESPOSTA6': respostas[currentStep][5],
      'RESPOSTA7': respostas[currentStep][6],
    });
  }
}
