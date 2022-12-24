import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Cores {
  static const kPrimaryColor = Color(0xff61bbf2);
  static const kSecondaryColor = Color(0xff179df0);
  static const kTertiaryColor = Color(0xff0b4970);
  static const kQuaternaryColor = Color(0xff1e1e1e);
  static const kErroColor = Color(0xfff10e0e);
  static const kAlertaColor = Color(0xfff57d37);
  static const kAzulGradientUpColor = Color(0xff0053be);
  static const kAzulGradientDownColor = Color(0xff006fff);

  static const kGreyColor = Color(0xFFEEEEEE);
  static const kBlackColor = Color(0xFF000000);
  static const kDarkGreyColor = Color(0xFF9E9E9E);
  static const kBorderColor = Color(0xFFEFEFEF);
  static const kWhiteColor = Color(0xFFFFFFFF);
  static const kcinzaColor = Color(0xFFD1D2D1);

  static const statusBarColorQuat = SystemUiOverlayStyle(
      statusBarColor: Cores.kQuaternaryColor,
      statusBarIconBrightness: Brightness.dark);
  static const statusBarColorWhit = SystemUiOverlayStyle(
      statusBarColor: Cores.kWhiteColor,
      statusBarIconBrightness: Brightness.dark);
  static const statusBarColorTransp = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark);
}