import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inteligencias_multiplas/utils/cores.dart';

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({Key? key}) : super(key: key);

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
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
                      fontSize: 45.sp,
                      fontFamily: 'Roboto-Regular',
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
