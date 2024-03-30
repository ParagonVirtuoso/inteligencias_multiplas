import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/cores.dart';
import '../../../utils/strings.dart';

class ModalDetalheInteligencia extends StatelessWidget {
  final String title;
  final String description;
  const ModalDetalheInteligencia(
      {required this.title, required this.description, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 800.h,
      padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 25.h),
      decoration: const BoxDecoration(
        color: Cores.kWhiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: 50.sp,
                    color: Cores.kQuaternaryColor,
                    fontFamily: 'Roboto-Regular',
                    fontWeight: FontWeight.w500),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Image.asset(
                  Strings.arrowdetailresult,
                  width: 70.w,
                  height: 70.h,
                  fit: BoxFit.contain,
                ),
              )
            ],
          ),
          Expanded(
              child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Text(
              description,
              style: TextStyle(
                  fontSize: 40.sp,
                  color: Cores.kQuaternaryColor,
                  fontFamily: 'Roboto-Regular',
                  fontWeight: FontWeight.w500),
            ),
          ))
        ],
      ),
    );
  }
}
