import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import '../../controller/homeController/home_controller.dart';
import '../../controller/resultController/result_controller.dart';
import '../../utils/cores.dart';
import '../../utils/strings.dart';
import '../homePage/componentes/modal_vincular_conta.dart';
import 'componentes/modal_detalhe_inteligencia.dart';

class ResultPage extends StatefulWidget {
  final bool isWebOverride;
  final ResultController? resultControllerOverride;
  final Future<void> Function(XFile file)? onSaveFile;

  const ResultPage({
    super.key,
    this.isWebOverride = kIsWeb,
    this.resultControllerOverride,
    this.onSaveFile,
  });

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

  bool get _isWeb => widget.isWebOverride;

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
    'Naturalista': {
      'key': Strings.naturalista,
      'asset': Strings.naturalistaAsset,
      'descricao': Strings.naturalistaDescricao
    },
    'Existencial': {
      'key': Strings.existencial,
      'asset': Strings.existencialAsset,
      'descricao': Strings.existencialDescricao
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
      User? user;
      try {
        user = FirebaseAuth.instance.currentUser;
      } catch (_) {
        user = null;
      }
      final nome = user != null ? HomeController.extrairNome(user) : null;
      final email = user != null ? HomeController.extrairEmail(user) : null;

      final infoMap = resultList.map(
        (key, value) => MapEntry(key, Map<String, String>.from(value)),
      );

      final controller = widget.resultControllerOverride ?? ResultController();
      if (_isWeb) {
        await controller.baixarResultadoPdf(
          itensOrdenados: resultadoOrdenadoMaiorParaMenor!,
          infoInteligencias: infoMap,
          respostas: _respostasTeste,
          nomeUsuario: nome,
          emailUsuario: email,
          onSaveFile: widget.onSaveFile,
        );
      } else {
        await controller.compartilharResultadoPdf(
          context: context,
          itensOrdenados: resultadoOrdenadoMaiorParaMenor!,
          infoInteligencias: infoMap,
          respostas: _respostasTeste,
          nomeUsuario: nome,
          emailUsuario: email,
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isWeb ? Strings.erroBaixarPdf : Strings.erroCompartilharPdf,
            ),
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
              const SizedBox(
                width: 48.0,
                height: 48.0,
                child: Center(
                  child: SizedBox(
                    width: 22.0,
                    height: 22.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
              )
            else
              IconButton(
                icon: Icon(
                  _isWeb ? Icons.download : Icons.share,
                  color: Colors.white,
                ),
                tooltip: _isWeb
                    ? Strings.baixarResultadoPdf
                    : Strings.compartilharResultadoPdf,
                onPressed: _compartilharPdf,
              ),
          ],
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 860),
            child: Container(
                margin: EdgeInsets.only(
                    left: (50.w).clamp(16.0, 36.0),
                    right: (50.w).clamp(16.0, 36.0),
                    top: 10.h,
                    bottom: 10.h),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: ((resultadoOrdenadoMaiorParaMenor?.isNotEmpty ??
                              false)
                          ? 1
                          : 0) +
                      (_isVisitante ? 1 : 0) +
                      (resultadoOrdenadoMaiorParaMenor?.length ?? 0),
                  itemBuilder: (context, index) {
                    final hasHeader =
                        resultadoOrdenadoMaiorParaMenor?.isNotEmpty ?? false;
                    if (hasHeader && index == 0) {
                      return Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 5.h, bottom: 50.h),
                          child: Text(
                            Strings.deslizeResultados,
                            style: TextStyle(
                              fontSize: 50.sp,
                              color: Cores.kWhiteColor,
                              fontFamily: 'Roboto-Regular',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }
                    final headerOffset = hasHeader ? 1 : 0;
                    if (_isVisitante && index == headerOffset) {
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
                    final itemIndex =
                        index - headerOffset - (_isVisitante ? 1 : 0);
                    final item = resultadoOrdenadoMaiorParaMenor![itemIndex];
                    return Container(
                      height: (380.h).clamp(160.0, 220.0),
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
                                        width: (250.w).clamp(100.0, 160.0),
                                        height: (70.h).clamp(32.0, 42.0),
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
              ),
            ),
          ),
        );
  }

  void exibirDetalhesInteligencia(title,description) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ModalDetalheInteligencia(title: title,description: description);
        });
  }

  Future<void> solicitarAvaliacaoInApp() async {
    if (kIsWeb) return;
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
