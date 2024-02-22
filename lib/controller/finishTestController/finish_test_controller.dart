import 'package:flutter/material.dart';

class FinishResultController {
  void navFinishTest(context, data) {
    Navigator.of(context).pushReplacementNamed('/finishTest', arguments: data);
  }

  void navResult(context, resultadoTeste) {
    Navigator.of(context).pushReplacementNamed('/result', arguments: resultadoTeste);
  }
}
