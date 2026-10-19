import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inteligencias_multiplas/screens/homePage/componentes/dialog_sair.dart';
import 'package:inteligencias_multiplas/screens/questionsPage/componentes/mini_navigator.dart';
import 'package:inteligencias_multiplas/screens/questionsPage/componentes/numeric_chips.dart';
import 'package:inteligencias_multiplas/screens/questionsPage/componentes/smart_swap_modal.dart';
import 'package:inteligencias_multiplas/utils/cores.dart';
import 'package:inteligencias_multiplas/utils/strings.dart';
import '../../componentes/botao_voltar.dart';
import '../../controller/finishTestController/finish_test_controller.dart';
import '../../utils/etapas.dart';
import '../../utils/perguntas.dart';

class QuestionsPage extends StatefulWidget {
  final FirebaseAuth? auth;
  final FirebaseDatabase? database;
  final int initialStep;
  final int initialQuestion;

  const QuestionsPage({
    super.key,
    this.auth,
    this.database,
    this.initialStep = 0,
    this.initialQuestion = 0,
  });

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

  FirebaseAuth? get _auth {
    if (widget.auth != null) return widget.auth;
    try {
      return FirebaseAuth.instance;
    } catch (_) {
      return null;
    }
  }

  FirebaseDatabase? get _database {
    if (widget.database != null) return widget.database;
    try {
      return FirebaseDatabase.instance;
    } catch (_) {
      return null;
    }
  }

  List<List<int>> respostas =
      List.generate(10, (i) => List.filled(9, 0), growable: true);
  var listaJaRespondida = List.filled(9, false);

  @override
  void initState() {
    super.initState();
    currentStep = widget.initialStep;
    currentQuestion = widget.initialQuestion;
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

  void atualizarListaJaRespondida() {
    for (int i = 0; i < 9; i++) {
      final val = i + 1;
      listaJaRespondida[i] = respostas[currentStep].contains(val);
    }
  }

  void irParaPergunta(int index) {
    if (index < 0 || index >= 9) return;

    // Se o usuário selecionou uma nota válida e ainda não confirmou, persiste na pergunta anterior
    if (selectedStar > 0 && selectedStar != respostas[currentStep][currentQuestion]) {
      bool isDuplicate = false;
      for (int q = 0; q < 9; q++) {
        if (q != currentQuestion && respostas[currentStep][q] == selectedStar) {
          isDuplicate = true;
          break;
        }
      }
      if (!isDuplicate) {
        respostas[currentStep][currentQuestion] = selectedStar;
        atualizarListaJaRespondida();
      }
    }

    setState(() {
      currentQuestion = index;
      final savedAnswer = respostas[currentStep][currentQuestion];
      selectedStar = savedAnswer;
      corBotaoNext = selectedStar > 0
          ? Cores.kAzulBotaoItemColor
          : Cores.kAzulBotaoDisableItemColor;
    });
  }

  Future<void> _mostrarDialogSairTeste() async {
    return showDialog(
      context: context,
      builder: (dialogCtx) => DialogSair.teste(
        onConfirm: () {
          Navigator.pop(dialogCtx);
          Navigator.pop(context);
        },
      ),
    );
  }

  void abrirSmartSwap(int targetValue, int otherQuestionIndex) {
    final safeStep = currentStep.clamp(0, perguntas.length - 1);
    final currentQText = perguntas[safeStep][currentQuestion];
    final otherQText = perguntas[safeStep][otherQuestionIndex];
    final currentAnswer = selectedStar > 0
        ? selectedStar
        : respostas[currentStep][currentQuestion];

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return SmartSwapModal(
          targetValue: targetValue,
          currentQuestionIndex: currentQuestion,
          currentQuestionText: currentQText,
          currentAnswer: currentAnswer,
          otherQuestionIndex: otherQuestionIndex,
          otherQuestionText: otherQText,
          onConfirm: () {
            confirmarSmartSwap(targetValue, otherQuestionIndex);
          },
        );
      },
    );
  }

  void confirmarSmartSwap(int targetValue, int otherQuestionIndex) {
    setState(() {
      final currentAnswer = selectedStar > 0
          ? selectedStar
          : respostas[currentStep][currentQuestion];
      respostas[currentStep][currentQuestion] = targetValue;
      respostas[currentStep][otherQuestionIndex] = currentAnswer;
      selectedStar = targetValue;
      corBotaoNext = Cores.kAzulBotaoItemColor;
      atualizarListaJaRespondida();
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Nota $targetValue trocada com sucesso com a Pergunta ${otherQuestionIndex + 1}!',
        ),
        backgroundColor: Cores.kSecondaryColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int safeStep = currentStep.clamp(0, perguntas.length - 1);
    final int safeQuestion =
        currentQuestion.clamp(0, (perguntas[safeStep] as List).length - 1);
    final String etapaTitulo =
        safeStep < etapas.length ? etapas[safeStep].toString() : '';
    final String perguntaTexto = perguntas[safeStep][safeQuestion];
    final mediaQuery = MediaQuery.of(context);
    final isDesktop = mediaQuery.size.width > 600;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _mostrarDialogSairTeste();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
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
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isDesktop ? 680 : 820,
                maxHeight: isDesktop
                    ? (mediaQuery.size.height * 0.90).clamp(620.0, 780.0)
                    : double.infinity,
              ),
              child: Container(
                margin: EdgeInsets.only(
                  left: isDesktop ? 20.0 : (28.w).clamp(12.0, 20.0),
                  right: isDesktop ? 20.0 : (28.w).clamp(12.0, 20.0),
                  top: isDesktop ? 16.0 : 6.h,
                  bottom: isDesktop ? 20.0 : (22.h).clamp(18.0, 24.0),
                ),
                child: Column(
                  children: [
                    // Top Header with Back button and Step Title
                    Row(
                      key: const Key('questions_header_row'),
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BotaoVoltar(
                          key: const Key('questions_back_button'),
                          onTap: _mostrarDialogSairTeste,
                          tooltip: Strings.voltar,
                        ),
                        Expanded(
                          child: Text(
                            '${Strings.etapa} ${safeStep + 1}',
                            style: TextStyle(
                              fontSize: 50.sp,
                              fontFamily: 'Roboto-Regular',
                              fontWeight: FontWeight.bold,
                              color: Cores.kTertiaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),

                    SizedBox(height: (10.h).clamp(8.0, 12.0)),

                // Main Quiz Body
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Harmonized Progress & Stage Navigation
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: Row(
                              key: const Key('questions_progress_row'),
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${Strings.etapa} ${safeStep + 1} de 10',
                                  style: TextStyle(
                                    fontSize: 40.sp,
                                    fontFamily: 'Roboto-Regular',
                                    fontWeight: FontWeight.w600,
                                    color: Cores.kTertiaryColor,
                                  ),
                                ),
                                Text(
                                  '${(progressoTotal * 100).round()}% completo',
                                  style: TextStyle(
                                    fontSize: 40.sp,
                                    fontFamily: 'Roboto-Regular',
                                    fontWeight: FontWeight.bold,
                                    color: Cores.kTertiaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: (6.h).clamp(4.0, 6.0)),
                          ClipRRect(
                            key: const Key('questions_linear_progress'),
                            borderRadius: BorderRadius.circular(6.r),
                            child: LinearProgressIndicator(
                              value: progressoTotal,
                              minHeight: (14.h).clamp(5.0, 7.0),
                              backgroundColor: Cores.kAzulDrawerItemColor,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Cores.kTertiaryColor,
                              ),
                            ),
                          ),
                          SizedBox(height: (10.h).clamp(8.0, 12.0)),
                          MiniNavigator(
                            margin: EdgeInsets.zero,
                            currentQuestion: safeQuestion,
                            stepAnswers: respostas[safeStep],
                            currentSelection: selectedStar,
                            onSelectQuestion: (index) {
                              irParaPergunta(index);
                            },
                          ),
                        ],
                      ),

                      SizedBox(height: (10.h).clamp(8.0, 12.0)),

                      // Illustration (Harmonious vertical sizing, filling space comfortably)
                      Expanded(
                        child: Container(
                          key: const Key('questions_illustration_container'),
                          margin: EdgeInsets.zero,
                          alignment: Alignment.center,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: isDesktop
                                    ? 240.0
                                    : (450.h).clamp(170.0, 215.0),
                              ),
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
                          ),
                        ),
                      ),

                      // Unified Enunciado Block (Cohesive reading block: Prefix + Question)
                      Container(
                        key: const Key('unified_question_statement'),
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 2.w),
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: Cores.kAzulDrawerItemColor.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: Cores.kTertiaryColor.withValues(alpha: 0.16),
                            width: 1.2.w,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                etapaTitulo,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 42.sp,
                                  fontFamily: 'Roboto-Regular',
                                  fontWeight: FontWeight.w600,
                                  color: Cores.kTertiaryColor,
                                  height: 1.25,
                                ),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                perguntaTexto,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 50.sp,
                                  fontFamily: 'Roboto-Regular',
                                  fontWeight: FontWeight.bold,
                                  color: Cores.kQuaternaryColor,
                                  height: 1.25,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: (12.h).clamp(10.0, 14.0)),

                      // Instruction text
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Text(
                          Strings.avalieComFichas,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 38.sp,
                            fontFamily: 'Roboto-Regular',
                            color: Cores.kTertiaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      SizedBox(height: (10.h).clamp(8.0, 12.0)),

                      // Fichas 1 a 9 (Single horizontal line, NO scroll, NO grid)
                      NumericChips(
                        margin: EdgeInsets.zero,
                        selectedValue: selectedStar,
                        stepAnswers: respostas[safeStep],
                        currentQuestionIndex: safeQuestion,
                        onSelectValue: selecionarEstrela,
                        onSwapRequested: (value, assignedQuestionIndex) {
                          abrirSmartSwap(value, assignedQuestionIndex);
                        },
                      ),

                      SizedBox(height: (18.h).clamp(16.0, 22.0)),

                      // Next button
                      GestureDetector(
                        key: const Key('questions_next_button'),
                        onTap: registrarResposta,
                        child: Container(
                          height: (105.h).clamp(48.0, 56.0),
                          width: (360.w).clamp(210.0, 310.0),
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          margin: EdgeInsets.zero,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.r),
                            color: corBotaoNext,
                          ),
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    Strings.proximoIconAsset,
                                    width: (48.w).clamp(20.0, 22.0),
                                    height: (48.w).clamp(20.0, 22.0),
                                    fit: BoxFit.contain,
                                  ),
                                  SizedBox(width: (16.w).clamp(10.0, 14.0)),
                                  Text(
                                    Strings.proximo,
                                    style: TextStyle(
                                      fontSize: 48.sp,
                                      color: Cores.kWhiteColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  ),
);
}

  Future<void> registrarResposta() async {
    if (!verificarSelecaoEstrela()) {
      return;
    }

    // Check for duplicate in the current step
    for (int i = 0; i < 9; i++) {
      if (i != currentQuestion && respostas[currentStep][i] == selectedStar) {
        abrirSmartSwap(selectedStar, i);
        return;
      }
    }

    respostas[currentStep][currentQuestion] = selectedStar;
    atualizarListaJaRespondida();

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
        selectedStar = respostas[currentStep][0];
        corBotaoNext = selectedStar > 0
            ? Cores.kAzulBotaoItemColor
            : Cores.kAzulBotaoDisableItemColor;
        atualizarListaJaRespondida();
      });
      _precacheEtapaImages(currentStep);
    } else {
      if (!mounted) return;
      irParaPergunta(proximaPergunta);
    }
  }

  bool verificarSelecaoEstrela() {
    if (selectedStar == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(Strings.selecioneUmaNota),
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

  void setEditarResposta(int questionToEdit) {
    irParaPergunta(questionToEdit);
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
    atualizarListaJaRespondida();
    final savedAnswer = respostas[currentStep][currentQuestion];
    selectedStar = savedAnswer;
    corBotaoNext = selectedStar > 0
        ? Cores.kAzulBotaoItemColor
        : Cores.kAzulBotaoDisableItemColor;
    verificarConclusao(context, data);
  }

  void navegarParaResultados() {
    FinishResultController().navFinishTest(context, respostas);
  }

  Future<void> salvarListaJaRespondidaFirebase() async {
    final auth = _auth;
    if (auth == null || auth.currentUser == null) {
      return;
    }
    final db = _database;
    if (db == null) {
      return;
    }

    try {
      final mapRespostas = <String, dynamic>{};
      for (int j = 0; j < respostas[currentStep].length; j++) {
        mapRespostas['RESPOSTA${j + 1}'] = respostas[currentStep][j];
      }
      await db
          .ref()
          .child('usuarios')
          .child(auth.currentUser!.uid)
          .child('ETAPA ${currentStep + 1}')
          .set(mapRespostas);
    } catch (e) {
      debugPrint('Erro ao salvar no Firebase: $e');
    }
  }
}
