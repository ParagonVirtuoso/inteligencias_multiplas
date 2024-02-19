import 'package:flutter/material.dart';

class FinishResultController {
  void navFinishTest(context, data) {
    Navigator.of(context).pushNamed('/finishTest', arguments: data);
  }

  void navResult(context, resultadoTeste) {
    Navigator.of(context).pushNamed('/result', arguments: resultadoTeste);
  }
}
