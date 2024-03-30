import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  ordenarResultado(resultadoTeste) {
    var keys = (resultadoTeste as Map<Object?, Object?>).keys.toList();
    var values = (resultadoTeste).values.toList();
    resultadoOrdenadoMaiorParaMenor = [];
    for (var i = 0; i < keys.length; i++) {
      resultadoOrdenadoMaiorParaMenor!
          .add(MapEntry(keys[i] as String, values[i] as int));
    }
    resultadoOrdenadoMaiorParaMenor!.sort((a, b) => b.value.compareTo(a.value));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultadoTeste = ModalRoute.of(context)?.settings.arguments;
    ordenarResultado(resultadoTeste);
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
                  itemCount: resultadoOrdenadoMaiorParaMenor!.length,
                  itemBuilder: (context, index) {
                    final item = resultadoOrdenadoMaiorParaMenor![index];
                    return Container(
                      height: 380.h,
                      margin: EdgeInsets.only(bottom: 40.h),
                      decoration: BoxDecoration(
                          color: Cores.kWhiteColor,
                          borderRadius: BorderRadius.circular(60.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: const Offset(0, 2),
                            ),
                          ]),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  resultList[item.key]!['key']!,
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
                                      backgroundColor: Colors.transparent,
                                      side: const BorderSide(
                                          width: 0, color: Colors.transparent),
                                    ),
                                    onPressed: () {
                                      exibirDetalhesInteligencia(
                                          resultList[item.key]!['key']!,
                                          resultList[item.key]!['descricao']!);
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
                            SizedBox(
                              width: 600.w,
                              child: Image.asset(
                                resultList[item.key]!['asset']!,
                                fit: BoxFit.cover,
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
}
