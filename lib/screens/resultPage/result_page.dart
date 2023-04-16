import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/cores.dart';
import '../../utils/strings.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
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
                height: 380.h,
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
                            'Musical',
                            style: TextStyle(
                                fontSize: 50.sp,
                                color: Cores.kTertiaryColor,
                                fontFamily: 'Roboto-Regular',
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '50 pontos',
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
                              onPressed: () {},
                              child: Container(
                                width: 250.w,
                                height: 70.h,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Cores.kAzulBotaoItemColor,
                                    borderRadius: BorderRadius.circular(20.r)),
                                child: Text(
                                  'Ver mais',
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
                          Strings.concluidoAsset,
                          fit: BoxFit.cover,
                        ),
                      )
                    ]),
              )
            ])));
  }
}
