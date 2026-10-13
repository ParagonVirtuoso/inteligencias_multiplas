import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_review/in_app_review.dart';
import '../../controller/homeController/home_controller.dart';
import '../../controller/resultController/result_controller.dart';
import '../../utils/cores.dart';
import '../../utils/strings.dart';
import '../homePage/componentes/modal_vincular_conta.dart';
import 'componentes/modal_detalhe_inteligencia.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  Object? resultadoTeste;
  List<MapEntry<String, int>>? resultadoOrdenadoMaiorParaMenor;
  List<List<int>>? _respostasTeste;
  final InAppReview _inAppReview = InAppReview.instance;
  bool _tentouSolicitarAvaliacao = false;
  bool _isVisitante = false;
  bool _compartilhandoPdf = false;

  @override
  void initState() {
    super.initState();
    _verificarVisitante();
  }

  void _verificarVisitante() {
    try {
      final user = FirebaseAuth.instance.currentUser;
      _isVisitante = user == null || user.isAnonymous;
    } catch (_) {
      _isVisitante = false;
    }
  }

  void _abrirModalVincularConta() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext modalContext) {
        return ModalVincularConta(
          onGooglePressed: () => _vincularGoogle(),
          onFacebookPressed: () => _vincularFacebook(),
        );
      },
    );
  }

  Future<void> _vincularGoogle() async {
    final resultado = await HomeController().vincularContaGoogle();
    if (!mounted) return;

    if (resultado == true) {
      setState(() {
        _isVisitante = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(Strings.contaVinculadaSucesso),
          backgroundColor: Colors.green,
        ),
      );
    } else if (resultado == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(Strings.erroVincularConta),
          backgroundColor: Cores.kErroColor,
        ),
      );
    }
  }

  Future<void> _vincularFacebook() async {
    final resultado = await HomeController().vincularContaFacebook();
    if (!mounted) return;

    if (resultado == true) {
      setState(() {
        _isVisitante = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(Strings.contaVinculadaSucesso),
          backgroundColor: Colors.green,
        ),
      );
    } else if (resultado == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(Strings.erroVincularConta),
          backgroundColor: Cores.kErroColor,
        ),
      );
    }
  }
  var resultList = {
    'Linguistica': {
      'key': Strings.linguistica,
      'asset': Strings.linguisticoAsset,
      'descricao': Strings.linguisticaDescricao
    },
    'Logico': {
      'key': Strings.logico,
      'asset': Strings.logicoAsset,
      'descricao': Strings.logicoDescricao
    },
    'Musical': {
      'key': Strings.musical,
      'asset': Strings.musicalAsset,
      'descricao': Strings.musicalDescricao
    },
    'Cinestesica': {
      'key': Strings.cinestesica,
      'asset': Strings.cinestesicaAsset,
      'descricao': Strings.cinestesicaDescricao
    },
    'Interpessoal': {
      'key': Strings.interpessoal,
      'asset': Strings.interpessoalAsset,
      'descricao': Strings.interpessoalDescricao
    },
    'Intrapessoal': {
      'key': Strings.intrapessoal,
      'asset': Strings.intrapessoalAsset,
      'descricao': Strings.intrapessoalDescricao
    },
    'Espacial': {
      'key': Strings.espacial,
      'asset': Strings.espacialAsset,
      'descricao': Strings.espacialDescricao
    },
  };
  void ordenarResultado(dynamic resultadoTeste) {
    if (resultadoTeste is! Map) {
      resultadoOrdenadoMaiorParaMenor = [];
      return;
    }
    var keys = resultadoTeste.keys.toList();
    var values = resultadoTeste.values.toList();
    resultadoOrdenadoMaiorParaMenor = [];
    for (var i = 0; i < keys.length; i++) {
      resultadoOrdenadoMaiorParaMenor!
          .add(MapEntry(keys[i].toString(), (values[i] as num).toInt()));
    }
    resultadoOrdenadoMaiorParaMenor!.sort((a, b) => b.value.compareTo(a.value));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args.containsKey('total')) {
      resultadoTeste = args['total'];
      final rawRespostas = args['respostas'];
      if (rawRespostas is List) {
        _respostasTeste = rawRespostas.map((etapa) {
          if (etapa is List) {
            return etapa.map((e) => (e as num).toInt()).toList();
          }
          return <int>[];
        }).toList();
      }
    } else {
      resultadoTeste = args;
    }
    ordenarResultado(resultadoTeste);
    _carregarRespostasFirebaseSeNecessario();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      solicitarAvaliacaoInApp();
    });
  }

  Future<void> _carregarRespostasFirebaseSeNecessario() async {
    if (_respostasTeste != null && _respostasTeste!.isNotEmpty) return;
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      final snapshot = await FirebaseDatabase.instance
          .ref()
          .child('usuarios')
          .child(user.uid)
          .get();
      if (!snapshot.exists || snapshot.value == null) return;
      final data = snapshot.value as Map<dynamic, dynamic>?;
      if (data != null && data['ETAPA 1'] != null) {
        final parsed = List.generate(10, (i) {
          final etapaData = data['ETAPA ${i + 1}'] as Map<dynamic, dynamic>?;
          if (etapaData != null) {
            return List.generate(7, (j) {
              final val = etapaData['RESPOSTA${j + 1}'];
              return val is num ? val.toInt() : 0;
            });
          }
          return List.generate(7, (j) => 0);
        });
        if (mounted) {
          setState(() {
            _respostasTeste = parsed;
          });
        }
      }
    } catch (_) {
      // Falha silenciosa
    }
  }

  Future<void> _compartilharPdf() async {
    if (resultadoOrdenadoMaiorParaMenor == null ||
        resultadoOrdenadoMaiorParaMenor!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(Strings.nenhumResultadoCompartilhar),
          backgroundColor: Cores.kAlertaColor,
        ),
      );
      return;
    }

    setState(() {
      _compartilhandoPdf = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      final nome = user != null ? HomeController.extrairNome(user) : null;
      final email = user != null ? HomeController.extrairEmail(user) : null;

      final infoMap = resultList.map(
        (key, value) => MapEntry(key, Map<String, String>.from(value)),
      );

      await ResultController().compartilharResultadoPdf(
        context: context,
        itensOrdenados: resultadoOrdenadoMaiorParaMenor!,
        infoInteligencias: infoMap,
        respostas: _respostasTeste,
        nomeUsuario: nome,
        emailUsuario: email,
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(Strings.erroCompartilharPdf),
            backgroundColor: Cores.kErroColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _compartilhandoPdf = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Cores.kAzulBotaoItemColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          actions: [
            if (_compartilhandoPdf)
              Center(
                child: Container(
                  width: 44.w,
                  height: 44.w,
                  margin: EdgeInsets.only(right: 32.w),
                  child: const CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              )
            else
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                tooltip: Strings.compartilharResultadoPdf,
                onPressed: _compartilharPdf,
              ),
          ],
        ),
        body: Container(
            margin: EdgeInsets.only(
                left: 50.w, right: 50.w, top: 10.h, bottom: 10.h),
            child: Column(children: [
              Container(
                margin: EdgeInsets.only(top: 5.h, bottom: 50.h),
                child: Text(Strings.deslizeResultados,
                    style: TextStyle(
                        fontSize: 50.sp,
                        color: Cores.kWhiteColor,
                        fontFamily: 'Roboto-Regular',
                        fontWeight: FontWeight.w500)),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: (resultadoOrdenadoMaiorParaMenor?.length ?? 0) +
                      (_isVisitante ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (_isVisitante && index == 0) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 40.h),
                        padding: EdgeInsets.symmetric(
                            horizontal: 40.w, vertical: 30.h),
                        decoration: BoxDecoration(
                          color: Cores.kWhiteColor,
                          borderRadius: BorderRadius.circular(40.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.cloud_upload_outlined,
                              color: Cores.kAzulBotaoItemColor,
                              size: 70.sp,
                            ),
                            SizedBox(width: 25.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    Strings.salvarResultado,
                                    style: TextStyle(
                                      fontSize: 38.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Cores.kQuaternaryColor,
                                      fontFamily: 'Roboto-Regular',
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  Text(
                                    Strings.salvarResultadoDescricao,
                                    style: TextStyle(
                                      fontSize: 28.sp,
                                      color: Cores.kDeepGreyColor,
                                      fontFamily: 'Roboto-Regular',
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 20.w),
                            ElevatedButton(
                              onPressed: _abrirModalVincularConta,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Cores.kAzulBotaoItemColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.r),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24.w, vertical: 12.h),
                              ),
                              child: Text(
                                Strings.salvarConta,
                                style: TextStyle(
                                  fontSize: 32.sp,
                                  color: Cores.kWhiteColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    final itemIndex = _isVisitante ? index - 1 : index;
                    final item = resultadoOrdenadoMaiorParaMenor![itemIndex];
                    return Container(
                      height: 380.h,
                      margin: EdgeInsets.only(bottom: 40.h),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          color: Cores.kWhiteColor,
                          borderRadius: BorderRadius.circular(60.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: const Offset(0, 2),
                            ),
                          ]),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    resultList[item.key]!['key']!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 50.sp,
                                        color: Cores.kTertiaryColor,
                                        fontFamily: 'Roboto-Regular',
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    '${item.value} ${Strings.pontos}',
                                    style: TextStyle(
                                        fontSize: 45.sp,
                                        color: Cores.kDeepGreyColor,
                                        fontFamily: 'Roboto-Regular',
                                        fontWeight: FontWeight.w500),
                                  ),
                                  OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        backgroundColor: Colors.transparent,
                                        side: const BorderSide(
                                            width: 0,
                                            color: Colors.transparent),
                                      ),
                                      onPressed: () {
                                        exibirDetalhesInteligencia(
                                            resultList[item.key]!['key']!,
                                            resultList[item.key]![
                                                'descricao']!);
                                      },
                                      child: Container(
                                        width: 250.w,
                                        height: 70.h,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: Cores.kAzulBotaoItemColor,
                                            borderRadius:
                                                BorderRadius.circular(20.r)),
                                        child: Text(
                                          Strings.verMais,
                                          style: TextStyle(
                                              fontSize: 38.sp,
                                              color: Cores.kWhiteColor,
                                              fontFamily: 'Roboto-Regular',
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ))
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Image.asset(
                                resultList[item.key]!['asset']!,
                                fit: BoxFit.cover,
                                height: double.infinity,
                              ),
                            )
                          ]),
                    );
                  },
                ),
              )
            ])));
  }

  void exibirDetalhesInteligencia(title,description) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ModalDetalheInteligencia(title: title,description: description);
        });
  }

  Future<void> solicitarAvaliacaoInApp() async {
    if (_tentouSolicitarAvaliacao || !mounted || !resultadoPositivoDisponivel()) {
      return;
    }

    _tentouSolicitarAvaliacao = true;
    try {
      final reviewDisponivel = await _inAppReview.isAvailable();
      if (reviewDisponivel) {
        await _inAppReview.requestReview();
      }
    } catch (_) {}
  }

  bool resultadoPositivoDisponivel() {
    if (resultadoOrdenadoMaiorParaMenor == null ||
        resultadoOrdenadoMaiorParaMenor!.isEmpty) {
      return false;
    }
    return resultadoOrdenadoMaiorParaMenor!.first.value > 0;
  }
}
