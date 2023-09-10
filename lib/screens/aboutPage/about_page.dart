import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../componentes/descriptor_content.dart';
import '../../utils/strings.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DesciptorContent(
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(bottom: 50.h),
          child: Text(
            Strings.sobreApp,
            style: TextStyle(
                fontSize: 65.sp,
                fontFamily: 'Roboto-Regular',
                fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(bottom: 50.h),
          child: Text(
            Strings.sobreAppDescricao,
            style: TextStyle(
                fontSize: 55.sp,
                fontFamily: 'Roboto-Regular',
                fontWeight: FontWeight.normal),
          ),
        ),
      ]),
    );
  }
}
