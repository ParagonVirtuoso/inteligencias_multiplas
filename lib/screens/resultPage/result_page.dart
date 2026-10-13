import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_review/in_app_review.dart';
import '../../utils/cores.dart';
import '../../utils/strings.dart';
import 'componentes/modal_detalhe_inteligencia.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  Object? resultadoTeste;
  List<MapEntry<String, int>>? resultadoOrdenadoMaiorParaMenor;
  final InAppReview _inAppReview = InAppReview.instance;
  bool _tentouSolicitarAvaliacao = false;
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
    resultadoTeste = ModalRoute.of(context)?.settings.arguments;
    ordenarResultado(resultadoTeste);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      solicitarAvaliacaoInApp();
    });
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
                  itemCount: resultadoOrdenadoMaiorParaMenor?.length ?? 0,
                  itemBuilder: (context, index) {
                    final item = resultadoOrdenadoMaiorParaMenor![index];
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
