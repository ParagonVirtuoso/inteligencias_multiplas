import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase database = FirebaseDatabase.instance;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    respostas = ModalRoute.of(context)?.settings.arguments;
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    border: Border.all(color: Cores.kTertiaryColor, width: 4.w),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Cores.kTertiaryColor,
                    size: 13,
                  ),
                ),
              ),
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text(Strings.questionarioConcluido,
                        style: TextStyle(
                            color: Cores.kQuaternaryColor,
                            fontSize: 45.sp,
                            fontFamily: 'Roboto-Regular',
                            fontWeight: FontWeight.bold)),
                  ),
                  Image.asset(
                    Strings.concluidoAsset,
                    fit: BoxFit.cover,
                  ),
                ],
              )),
              Container(
                  alignment: Alignment.center,
                  height: 400.h,
                  child: OutlinedButton(
                      onPressed: () {
                        salvarResultado();
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        side: const BorderSide(
                            width: 0, color: Colors.transparent),
                      ),
                      child: Container(
                        height: 100.h,
                        width: 580.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Cores.kAzulBotaoItemColor,
                          borderRadius: BorderRadius.circular(30.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 3,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Image(
                                image: AssetImage(Strings.proximoIconAsset)),
                            Text(Strings.verResultados,
                                style: TextStyle(
                                    color: Cores.kWhiteColor,
                                    fontSize: 45.sp,
                                    fontFamily: 'Roboto-Regular',
                                    fontWeight: FontWeight.w500))
                          ],
                        ),
                      )))
            ],
          ),
        ));
  }

  void salvarResultado() {
    var notas =
        List.generate(7, (i) => List.generate(10, (j) => respostas[j][i]));
    var total = {
      'Cinestesica': notas[0].reduce((a, b) => a + b),
      'Espacial': notas[1].reduce((a, b) => a + b),
      'Interpessoal': notas[2].reduce((a, b) => a + b),
      'Intrapessoal': notas[3].reduce((a, b) => a + b),
      'Linguistica': notas[4].reduce((a, b) => a + b),
      'Logico': notas[5].reduce((a, b) => a + b),
      'Musical': notas[6].reduce((a, b) => a + b),
    };
    salvarTotalFirebase(total);
    FinishResultController().navResult(context, total);
  }

  Future<void> salvarTotalFirebase(total) async {
    if (_auth.currentUser == null) {
      return;
    }
    await database
        .ref()
        .child('usuarios')
        .child(_auth.currentUser!.uid)
        .child('TOTAL')
        .set(total);
  }
}
