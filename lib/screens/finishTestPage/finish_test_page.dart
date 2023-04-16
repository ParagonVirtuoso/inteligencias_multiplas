import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/cores.dart';
import '../../utils/strings.dart';

class FinishTest extends StatefulWidget {
  const FinishTest({super.key});

  @override
  State<FinishTest> createState() => _FinishTestState();
}

class _FinishTestState extends State<FinishTest> {
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
                        Navigator.pushNamed(context, '/result');
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
}
