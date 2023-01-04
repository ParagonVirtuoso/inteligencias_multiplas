import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inteligencias_multiplas/utils/cores.dart';
import 'package:inteligencias_multiplas/utils/strings.dart';

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({Key? key}) : super(key: key);

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  var progressoTotal = 0.05;

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
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 50.w,
              height: 45.h,
              margin: EdgeInsets.only(left: 40.w, top: 30.h),
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
          Container(
            width: 900.w,
            margin: EdgeInsets.only(top: 30.h, right: 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Etapa 1',
                  style: TextStyle(
                      fontSize: 40.sp,
                      fontFamily: 'Roboto-Regular',
                      fontWeight: FontWeight.w500),
                ),
                Container(
                  margin: EdgeInsets.only(top: 50.h),
                  child: Text(
                    'Coisas que mais gosto de fazer',
                    style: TextStyle(
                        fontSize: 60.sp,
                        fontFamily: 'Roboto-Regular',
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 50.h),
                  child: Image.asset(
                    Strings.pergunta1Asset,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 50.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: Cores.kTertiaryColor, width: 4.w),
                    borderRadius: BorderRadius.circular(13.r),
                  ),
                  child: LinearProgressIndicator(
                    value: progressoTotal,
                    backgroundColor: Cores.kWhiteColor,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Cores.kTertiaryColor),
                  ),
                ),
                Text('5% completo',
                    style: TextStyle(
                        fontSize: 33.sp,
                        fontFamily: 'Roboto-Regular',
                        fontWeight: FontWeight.w500,
                        color: Cores.kTertiaryColor)),
                Container(
                  margin: EdgeInsets.only(top: 50.h),
                  child: Text(
                    'Praticar Esportes',
                    style: TextStyle(
                        fontSize: 60.sp,
                        fontFamily: 'Roboto-Regular',
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 50.h),
                  child: Text(
                    'Avalie, a quantidade de estrelas significa o quanto você gosta.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 45.sp,
                        fontFamily: 'Roboto-Regular'
                    ),
                  ),
                ),
                Container(
                  height: 150.h,
                  margin: EdgeInsets.only(top: 40.h, bottom: 40.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.r),
                    color: Cores.kBorderColor,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
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
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/questions');
                  },
                  child: Container(
                    height: 130.h,
                    width: 350.w,
                    margin: EdgeInsets.only(top: 40.h, bottom: 40.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.r),
                      color: Cores.kAzulBotaoDisableItemColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Image(image: AssetImage(Strings.proximoIconAsset)),
                        SizedBox(
                          width: 20.w,
                        ),
                        Text(
                          Strings.proximo,
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
            ),
          )
        ],
      ),
    );
  }
}
