import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inteligencias_multiplas/screens/questionsPage/componentes/star_rate.dart';
import 'package:inteligencias_multiplas/utils/cores.dart';
import 'package:inteligencias_multiplas/utils/strings.dart';
import '../../controller/finishTestController/finish_test_controller.dart';
import '../../utils/etapas.dart';
import '../../utils/perguntas.dart';
import 'componentes/modal_alerta_resposta.dart';

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({super.key});

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  double get progressoTotal {
    final int total = respostas.length * 9;
    final int respondidas =
        respostas.fold(0, (s, etapa) => s + etapa.where((r) => r != 0).length);
    return respondidas / total;
  }

  int selectedStar = 0;
  int currentStep = 0;
  int currentQuestion = 0;
  bool editing = false;
  Color corBotaoNext = Cores.kAzulBotaoDisableItemColor;
  dynamic data;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase database = FirebaseDatabase.instance;

  List<List<int>> respostas =
      List.generate(10, (i) => List.filled(9, 0), growable: true);
  var listaJaRespondida = List.filled(9, false);

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if (!mounted) return;
      data = ModalRoute.of(context)?.settings.arguments;
      if (data != null && mounted) {
        tratarDadosFirebase(context, data);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final asset in Strings.ilustracoesPerguntas) {
      precacheImage(AssetImage(asset), context);
    }
    _precacheEtapaImages(currentStep);
  }

  void _precacheEtapaImages(int step) {
    if (step < 0 || step >= 10) return;
    for (int i = 0; i < 9; i++) {
      precacheImage(AssetImage(obterCaminhoPergunta(step, i)), context);
    }
  }

  String obterCaminhoPergunta(int safeStep, int safeQuestion) {
    return 'assets/etapas/etapa-${safeStep + 1}/pergunta-${safeQuestion + 1}.png';
  }

  String obterIlustracaoPadrao(int safeQuestion) {
    if (safeQuestion >= 0 && safeQuestion < Strings.ilustracoesPerguntas.length) {
      return Strings.ilustracoesPerguntas[safeQuestion];
    }
    return Strings.cinestesicaAsset;
  }

  @override
  Widget build(BuildContext context) {
    final int safeStep = currentStep.clamp(0, perguntas.length - 1);
    final int safeQuestion =
        currentQuestion.clamp(0, (perguntas[safeStep] as List).length - 1);
    final String etapaTitulo =
        safeStep < etapas.length ? etapas[safeStep].toString() : '';
    final String perguntaTexto = perguntas[safeStep][safeQuestion];

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
                          '${Strings.etapa} ${safeStep + 1}',
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
                        width: 900.w,
                        alignment: Alignment.center,
                        child: SingleChildScrollView(
                          child: Text(
                            etapaTitulo,
                            style: TextStyle(
                                fontSize: 60.sp,
                                fontFamily: 'Roboto-Regular',
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                            textScaler: TextScaler.noScaling,
                          ),
                        ),
                      ),
                      Expanded(
                          child: Container(
                        margin: EdgeInsets.only(top: 20.h, bottom: 20.h),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: Image.asset(
                            obterCaminhoPergunta(safeStep, safeQuestion),
                            key: ValueKey<String>('$safeStep-$safeQuestion'),
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                obterIlustracaoPadrao(safeQuestion),
                                fit: BoxFit.contain,
                              );
                            },
                          ),
                        ),
                      )),
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
                      Text('${(progressoTotal * 100).round()}% completo',
                          style: TextStyle(
                              fontSize: 33.sp,
                              fontFamily: 'Roboto-Regular',
                              fontWeight: FontWeight.w500,
                              color: Cores.kTertiaryColor)),
                      Container(
                        margin: EdgeInsets.only(top: 20.h),
                        width: 900.w,
                        alignment: Alignment.center,
                        child: Text(perguntaTexto,
                            textAlign: TextAlign.center,
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

    for (int i = 0; i < 9; i++) {
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
    listaJaRespondida[selectedStar - 1] = true;
    selectedStar = 0;

    final int proximaPergunta = obterProximaPergunta();
    if (proximaPergunta >= 9) {
      await salvarListaJaRespondidaFirebase();
      if (!mounted) return;
      if (currentStep >= 9) {
        navegarParaResultados();
        return;
      }
      setState(() {
        currentStep++;
        currentQuestion = 0;
        listaJaRespondida = List.filled(9, false);
        corBotaoNext = Cores.kAzulBotaoDisableItemColor;
      });
      _precacheEtapaImages(currentStep);
    } else {
      if (!mounted) return;
      setState(() {
        currentQuestion = proximaPergunta;
        corBotaoNext = Cores.kAzulBotaoDisableItemColor;
      });
    }

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
    for (int i = 0; i < 9; i++) {
      int next = (currentQuestion + i) % 9;
      if (respostas[currentStep][next] == 0) {
        return next;
      }
    }
    return 9;
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
          content: Text(Strings.salveEdicaoAtualAntes),
          backgroundColor: Cores.kAlertaColor,
        ),
      );
      return;
    }

    editing = true;
    setState(() {
      final int previousStar = respostas[currentStep][questionToEdit];
      if (previousStar >= 1 && previousStar <= 9) {
        listaJaRespondida[previousStar - 1] = false;
      }
      corBotaoNext = Cores.kAzulBotaoDisableItemColor;
      respostas[currentStep][questionToEdit] = 0;
      selectedStar = 0;
      currentQuestion = questionToEdit;
    });
  }

  void verificarConclusao(BuildContext context, dynamic data) {
    if (data['TOTAL'] != null) {
      List<List<int>>? respostasSalvas;
      if (data['ETAPA 1'] != null) {
        respostasSalvas = List.generate(10, (i) {
          final etapaData = data['ETAPA ${i + 1}'];
          if (etapaData != null) {
            final totalEtapa = etapaData['RESPOSTA9'] != null ? 9 : 7;
            return List.generate(totalEtapa, (j) {
              final val = etapaData['RESPOSTA${j + 1}'];
              return val is num ? val.toInt() : 0;
            });
          }
          return List.generate(9, (j) => 0);
        });
      }
      setState(() {
        FinishResultController().navResult(context, {
          'total': data['TOTAL'],
          'respostas': respostasSalvas ?? respostas,
        });
      });
    } else if (data['ETAPA 10'] != null) {
      setState(() {
        final totalEtapa = data['ETAPA 10']['RESPOSTA9'] != null ? 9 : 7;
        for (int j = 0; j < totalEtapa && j < respostas[9].length; j++) {
          final val = data['ETAPA 10']['RESPOSTA${j + 1}'];
          if (val is num) {
            respostas[9][j] = val.toInt();
          }
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
          final totalEtapa = data['ETAPA $i']['RESPOSTA9'] != null ? 9 : 7;
          for (int j = 0; j < totalEtapa && j < respostas[i - 1].length; j++) {
            final val = data['ETAPA $i']['RESPOSTA${j + 1}'];
            if (val is num) {
              respostas[i - 1][j] = val.toInt();
            }
          }
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

    try {
      final mapRespostas = <String, dynamic>{};
      for (int j = 0; j < respostas[currentStep].length; j++) {
        mapRespostas['RESPOSTA${j + 1}'] = respostas[currentStep][j];
      }
      await database
          .ref()
          .child('usuarios')
          .child(_auth.currentUser!.uid)
          .child('ETAPA ${currentStep + 1}')
          .set(mapRespostas);
    } catch (e) {
      debugPrint('Erro ao salvar no Firebase: $e');
    }
  }
}
