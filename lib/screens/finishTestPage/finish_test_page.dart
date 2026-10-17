import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../componentes/botao_voltar.dart';
import '../../controller/finishTestController/finish_test_controller.dart';
import '../../utils/cores.dart';
import '../../utils/strings.dart';

class FinishTest extends StatefulWidget {
  const FinishTest({super.key});

  @override
  State<FinishTest> createState() => _FinishTestState();
}

class _FinishTestState extends State<FinishTest> {
  dynamic respostas;

  FirebaseAuth? get _auth {
    try {
      return FirebaseAuth.instance;
    } catch (_) {
      return null;
    }
  }

  FirebaseDatabase? get _database {
    try {
      return FirebaseDatabase.instance;
    } catch (_) {
      return null;
    }
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    respostas = ModalRoute.of(context)?.settings.arguments;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isDesktop = mediaQuery.size.width > 600;

    return Scaffold(
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
                  // Top Header with componentized BotaoVoltar
                  Row(
                    key: const Key('finish_header_row'),
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      BotaoVoltar(
                        key: const Key('finish_back_button'),
                        onTap: () {
                          Navigator.pop(context);
                        },
                        tooltip: Strings.voltar,
                      ),
                      const Spacer(),
                    ],
                  ),

                  SizedBox(height: (12.h).clamp(8.0, 16.0)),

                  // Body with completion illustration and title
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          Strings.questionarioConcluido,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Cores.kQuaternaryColor,
                            fontSize: (50.sp).clamp(18.0, 22.0),
                            fontFamily: 'Roboto-Regular',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: (16.h).clamp(10.0, 20.0)),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: isDesktop
                                    ? 280.0
                                    : (450.h).clamp(180.0, 240.0),
                              ),
                              child: Image.asset(
                                Strings.concluidoAsset,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: (18.h).clamp(16.0, 22.0)),

                  // Bottom Action Button: Ver Resultados
                  GestureDetector(
                    key: const Key('finish_results_button'),
                    behavior: HitTestBehavior.opaque,
                    onTap: salvarResultado,
                    child: Container(
                      height: (105.h).clamp(48.0, 56.0),
                      width: (420.w).clamp(240.0, 340.0),
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      margin: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.r),
                        color: Cores.kAzulBotaoItemColor,
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
                                Strings.verResultados,
                                style: TextStyle(
                                  fontSize: (48.sp).clamp(16.0, 18.0),
                                  color: Cores.kWhiteColor,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Roboto-Regular',
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
          ),
        ),
      ),
    );
  }

  void salvarResultado() {
    final int numInteligencias =
        respostas != null && (respostas as List).isNotEmpty
            ? (respostas[0] as List).length
            : 9;
    var notas = List.generate(
        numInteligencias, (i) => List.generate(10, (j) => respostas[j][i]));
    var total = {
      'Cinestesica': notas[0].reduce((a, b) => a + b),
      'Espacial': notas[1].reduce((a, b) => a + b),
      'Interpessoal': notas[2].reduce((a, b) => a + b),
      'Intrapessoal': notas[3].reduce((a, b) => a + b),
      'Linguistica': notas[4].reduce((a, b) => a + b),
      'Logico': notas[5].reduce((a, b) => a + b),
      'Musical': notas[6].reduce((a, b) => a + b),
      if (numInteligencias >= 8)
        'Naturalista': notas[7].reduce((a, b) => a + b),
      if (numInteligencias >= 9)
        'Existencial': notas[8].reduce((a, b) => a + b),
    };
    salvarTotalFirebase(total);
    FinishResultController().navResult(context, {
      'total': total,
      'respostas': respostas,
    });
  }

  Future<void> salvarTotalFirebase(total) async {
    final user = _auth?.currentUser;
    if (user == null) {
      return;
    }
    await _database
        ?.ref()
        .child('usuarios')
        .child(user.uid)
        .child('TOTAL')
        .set(total);
  }
}
