import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inteligencias_multiplas/utils/cores.dart';
import 'package:inteligencias_multiplas/utils/strings.dart';

class CardTutorial extends StatelessWidget {
  final Future<dynamic> Function() buscarDadosTeste;

  const CardTutorial({Key? key, required this.buscarDadosTeste})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          Strings.comoFunciona,
          style: TextStyle(
            fontSize: 60.sp,
            color: Cores.kTertiaryColor,
            fontFamily: 'Roboto-Regular',
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: 40.h,
        ),
        Text(
          Strings.avalieCadaQuestao,
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontSize: 45.sp,
            color: Cores.kQuaternaryColor,
            fontWeight: FontWeight.w400,
          ),
        ),
        Container(
          height: 150.h,
          margin: EdgeInsets.only(top: 70.h, bottom: 70.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            color: Cores.kBorderColor,
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image(image: AssetImage(Strings.starIconAsset)),
              Image(image: AssetImage(Strings.starIconAsset)),
              Image(image: AssetImage(Strings.starIconAsset)),
              Image(image: AssetImage(Strings.starIconAsset)),
              Image(image: AssetImage(Strings.starIconAsset)),
              Image(image: AssetImage(Strings.starIconAsset)),
              Image(image: AssetImage(Strings.starIconAsset)),
            ],
          ),
        ),
        Text(
          Strings.naoExisteRespostaCerta,
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontSize: 45.sp,
            color: Cores.kQuaternaryColor,
            fontWeight: FontWeight.w400,
          ),
        ),
        GestureDetector(
          onTap: () async {
            var dataTest = await buscarDadosTeste();
            if (dataTest) {
              Navigator.pushNamed(context, '/questions');
            }
          },
          child: Container(
            height: 130.h,
            width: 650.w,
            margin: EdgeInsets.only(top: 70.h, bottom: 70.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.r),
              color: Cores.kAzulGradientDownColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Image(image: AssetImage(Strings.playIconAsset)),
                SizedBox(
                  width: 20.w,
                ),
                Text(
                  Strings.iniciarTeste,
                  style: TextStyle(
                    fontSize: 45.sp,
                    color: Cores.kWhiteColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
