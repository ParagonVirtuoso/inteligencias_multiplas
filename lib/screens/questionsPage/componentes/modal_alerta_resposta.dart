import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/cores.dart';
import '../../../utils/strings.dart';

class ModalAlertaResposta extends StatefulWidget {
  final Function setEditarResposta;
  final int respostaIgual;
  const ModalAlertaResposta(
      {super.key,
      required currentQuestion,
      required this.respostaIgual,
      required this.setEditarResposta});

  @override
  State<ModalAlertaResposta> createState() => _ModalAlertaRespostaState();
}

class _ModalAlertaRespostaState extends State<ModalAlertaResposta> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1000.h,
      padding:
          EdgeInsets.only(left: 50.w, right: 50.w, bottom: 50.h, top: 50.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            Strings.atencaoPerguntaAvaliada,
            style: TextStyle(
                fontSize: 65.sp,
                fontFamily: 'Roboto-Regular',
                fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: Strings.seVoce,
              style: TextStyle(
                  color: Cores.kBlackColor,
                  fontSize: 55.sp,
                  fontFamily: 'Roboto-Regular',
                  fontWeight: FontWeight.w400),
              children: <TextSpan>[
                TextSpan(
                  text: Strings.continuarError,
                  style: TextStyle(
                      color: Cores.kBlackColor,
                      fontSize: 55.sp,
                      fontFamily: 'Roboto-Regular',
                      fontWeight: FontWeight.bold),
                ),
                TextSpan(
                    text: Strings.escolherOutraClassifica,
                    style: TextStyle(
                        color: Cores.kBlackColor,
                        fontSize: 55.sp,
                        fontFamily: 'Roboto-Regular',
                        fontWeight: FontWeight.w400)),
                TextSpan(
                    text: Strings.editarError,
                    style: TextStyle(
                        color: Cores.kBlackColor,
                        fontSize: 55.sp,
                        fontFamily: 'Roboto-Regular',
                        fontWeight: FontWeight.bold)),
                TextSpan(
                    text: Strings.classifiAnterior,
                    style: TextStyle(
                        color: Cores.kBlackColor,
                        fontSize: 55.sp,
                        fontFamily: 'Roboto-Regular',
                        fontWeight: FontWeight.w400))
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 390.w,
                height: 125.h,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Cores.kWhiteColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                        side: BorderSide(
                            color: Cores.kAzulBotaoItemColor, width: 6.sp),
                      ),
                    ),
                    onPressed: () => {
                          widget.setEditarResposta(widget.respostaIgual),
                          Navigator.pop(context)
                        },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(right: 20.w),
                            child: Image.asset(
                              Strings.editIconAsset,
                              fit: BoxFit.cover,
                            )),
                        Text(
                          Strings.editar,
                          style: TextStyle(
                              color: Cores.kAzulBotaoItemColor,
                              fontSize: 45.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Roboto-Regular'),
                            textScaler: TextScaler.noScaling
                        ),
                      ],
                    )),
              ),
              SizedBox(
                width: 390.w,
                height: 125.h,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Cores.kAzulBotaoItemColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(right: 20.w),
                          child: Image.asset(
                            Strings.proximoIconAsset,
                            fit: BoxFit.cover,
                          )),
                      Text(
                        Strings.continuar,
                        style: TextStyle(
                            color: Cores.kWhiteColor,
                            fontSize: 45.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Roboto-Regular'),
                          textScaler: TextScaler.noScaling
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
