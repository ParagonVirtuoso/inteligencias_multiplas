import 'package:flutter/material.dart';

class FinishResultController {
  void navFinishTest(context) {
    Navigator.of(context).pushNamed('/finishTest');
  }

  void navResult(context) {
    Navigator.of(context).pushNamed('/result');
  }
}
