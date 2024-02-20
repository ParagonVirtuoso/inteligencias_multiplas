import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DescriptionTextItem extends StatelessWidget {
  final String sobreTitulo;
  final String sobreDescricao;

  const DescriptionTextItem({
    super.key,
    required this.sobreTitulo,
    required this.sobreDescricao,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(bottom: 50.h),
          child: Text(
            sobreTitulo,
            style: TextStyle(
              fontSize: 65.sp,
              fontFamily: 'Roboto-Regular',
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(bottom: 50.h),
          child: Text(
            sobreDescricao,
            style: TextStyle(
              fontSize: 55.sp,
              fontFamily: 'Roboto-Regular',
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }
}
