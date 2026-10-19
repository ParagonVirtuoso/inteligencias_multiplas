import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import '../../componentes/modal_vincular_conta.dart';
import '../../controller/homeController/home_controller.dart';
import '../../controller/resultController/result_controller.dart';
import '../../utils/cores.dart';
import '../../utils/strings.dart';
import 'componentes/modal_detalhe_inteligencia.dart';

class ResultPage extends StatefulWidget {
  final bool? isWebOverride;
  final ResultController? resultControllerOverride;
  final Future<void> Function(XFile file)? onSaveFile;

  const ResultPage({
    super.key,
    this.isWebOverride,
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

  bool get _isWeb => widget.isWebOverride ?? kIsWeb;

  bool _detectIsWeb(BuildContext context) {
    if (widget.isWebOverride != null) return widget.isWebOverride!;
    if (kIsWeb) return true;
    final width = MediaQuery.maybeOf(context)?.size.width ?? 0;
    return width > 600;
  }

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
    ModalVincularConta.show(
      context: context,
      isWebOverride: widget.isWebOverride,
      onGooglePressed: () => _vincularGoogle(),
      onFacebookPressed: () => _vincularFacebook(),
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
    final screenWidth = MediaQuery.maybeOf(context)?.size.width ?? 360.0;
    final isDesktop = screenWidth > 680;
    final double horizontalAppBarOffset =
        isDesktop ? ((screenWidth - 680.0) / 2.0).clamp(16.0, 620.0) : 0.0;

    return Scaffold(
      backgroundColor: Cores.kAzulBotaoItemColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        leadingWidth: isDesktop ? (horizontalAppBarOffset + 48.0) : null,
        leading: isDesktop && Navigator.canPop(context)
            ? Padding(
                padding: EdgeInsets.only(left: horizontalAppBarOffset),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  tooltip: Strings.voltar,
                  onPressed: () => Navigator.pop(context),
                ),
              )
            : null,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: horizontalAppBarOffset),
            child: _compartilhandoPdf
                ? const SizedBox(
                    width: 48.0,
                    height: 48.0,
                    child: Center(
                      child: SizedBox(
                        width: 22.0,
                        height: 22.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                    ),
                  )
                : IconButton(
                    icon: Icon(
                      _isWeb ? Icons.download : Icons.share,
                      color: Colors.white,
                    ),
                    tooltip: _isWeb
                        ? Strings.baixarResultadoPdf
                        : Strings.compartilharResultadoPdf,
                    onPressed: _compartilharPdf,
                  ),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Container(
            margin: EdgeInsets.only(
              left: (50.w).clamp(16.0, 24.0),
              right: (50.w).clamp(16.0, 24.0),
              top: (10.h).clamp(4.0, 10.0),
              bottom: (10.h).clamp(8.0, 16.0),
            ),
            child: ListView(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (resultadoOrdenadoMaiorParaMenor?.isNotEmpty ?? false)
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(
                            top: (5.h).clamp(4.0, 8.0),
                            bottom: (50.h).clamp(20.0, 32.0),
                          ),
                          child: Text(
                            Strings.deslizeResultados,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: (50.sp).clamp(14.0, 24.0),
                              color: Cores.kWhiteColor,
                              fontFamily: 'Roboto-Regular',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    if (_isVisitante)
                      Container(
                        margin: EdgeInsets.only(
                          bottom: (36.h).clamp(14.0, 22.0),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: (36.w).clamp(12.0, 24.0),
                          vertical: (26.h).clamp(12.0, 20.0),
                        ),
                        decoration: BoxDecoration(
                          color: Cores.kWhiteColor,
                          borderRadius: BorderRadius.circular(
                            (40.r).clamp(16.0, 24.0),
                          ),
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
                            Container(
                              width: (84.r).clamp(32.0, 48.0),
                              height: (84.r).clamp(32.0, 48.0),
                              decoration: const BoxDecoration(
                                color: Cores.kAzulDrawerItemColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.cloud_upload_outlined,
                                color: Cores.kAzulBotaoItemColor,
                                size: (46.sp).clamp(18.0, 24.0),
                              ),
                            ),
                            SizedBox(width: (24.w).clamp(8.0, 16.0)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    Strings.salvarResultado,
                                    style: TextStyle(
                                      fontSize: (38.sp).clamp(12.0, 17.5),
                                      fontWeight: FontWeight.bold,
                                      color: Cores.kQuaternaryColor,
                                      fontFamily: 'Roboto-Regular',
                                    ),
                                  ),
                                  SizedBox(height: (6.h).clamp(2.0, 4.0)),
                                  Text(
                                    Strings.salvarResultadoDescricao,
                                    style: TextStyle(
                                      fontSize: (28.sp).clamp(10.0, 14.0),
                                      color: Cores.kDeepGreyColor,
                                      fontFamily: 'Roboto-Regular',
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: (20.w).clamp(8.0, 16.0)),
                            Tooltip(
                              message: Strings.salvarConta,
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: ElevatedButton(
                                  onPressed: _abrirModalVincularConta,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Cores.kAzulBotaoItemColor,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        (25.r).clamp(12.0, 20.0),
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: (24.w).clamp(12.0, 22.0),
                                      vertical: (12.h).clamp(8.0, 14.0),
                                    ),
                                  ),
                                  child: Text(
                                    Strings.salvarConta,
                                    style: TextStyle(
                                      fontSize: (32.sp).clamp(11.0, 15.0),
                                      color: Cores.kWhiteColor,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Roboto-Regular',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    for (final item
                        in resultadoOrdenadoMaiorParaMenor ??
                            const <MapEntry<String, int>>[])
                      Container(
                        height: (380.h).clamp(160.0, 210.0),
                        margin: EdgeInsets.only(
                          bottom: (36.h).clamp(14.0, 20.0),
                        ),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Cores.kWhiteColor,
                    borderRadius: BorderRadius.circular(
                      (60.r).clamp(20.0, 28.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: (20.w).clamp(8.0, 20.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                resultList[item.key]!['key']!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: (50.sp).clamp(14.0, 22.0),
                                  color: Cores.kTertiaryColor,
                                  fontFamily: 'Roboto-Regular',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${item.value} ${Strings.pontos}',
                                style: TextStyle(
                                  fontSize: (45.sp).clamp(12.5, 18.0),
                                  color: Cores.kDeepGreyColor,
                                  fontFamily: 'Roboto-Regular',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Tooltip(
                                message: Strings.verMais,
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      backgroundColor: Colors.transparent,
                                      side: const BorderSide(
                                        width: 0,
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    onPressed: () {
                                      exibirDetalhesInteligencia(
                                        resultList[item.key]!['key']!,
                                        resultList[item.key]!['descricao']!,
                                      );
                                    },
                                    child: Container(
                                      width: (250.w).clamp(100.0, 150.0),
                                      height: (70.h).clamp(32.0, 42.0),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Cores.kAzulBotaoItemColor,
                                        borderRadius: BorderRadius.circular(
                                          (20.r).clamp(10.0, 16.0),
                                        ),
                                      ),
                                      child: Text(
                                        Strings.verMais,
                                        style: TextStyle(
                                          fontSize: (38.sp).clamp(11.0, 16.0),
                                          color: Cores.kWhiteColor,
                                          fontFamily: 'Roboto-Regular',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: EdgeInsets.all((16.r).clamp(6.0, 14.0)),
                          child: Image.asset(
                            resultList[item.key]!['asset']!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
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

  void exibirDetalhesInteligencia(String title, String description) {
    ModalDetalheInteligencia.show(
      context: context,
      title: title,
      description: description,
      isWebOverride: _detectIsWeb(context),
    );
  }

  Future<void> solicitarAvaliacaoInApp() async {
    if (kIsWeb) return;
    if (_tentouSolicitarAvaliacao ||
        !mounted ||
        !resultadoPositivoDisponivel()) {
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
