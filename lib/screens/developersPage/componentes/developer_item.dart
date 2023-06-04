import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/cores.dart';
import '../../../utils/strings.dart';

class DeveloperItem extends StatelessWidget {
  const DeveloperItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 200.w,
          height: 200.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            image: const DecorationImage(
              image: AssetImage(''),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Denys Fernandes',
              style: TextStyle(
                fontSize: 45.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'Denysfernandes21@gmail.com',
              style: TextStyle(fontSize: 38.sp, color: Cores.kDeepGreyColor),
            ),
            SizedBox(height: 10.h),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 100.w,
                    height: 100.h,
                    color: Colors.amber,
                    child: Image.asset(
                      Strings.githubIconAsset,
                    ),
                  ),
                  Container(
                    width: 100.w,
                    height: 100.h,
                    child: Image.asset(
                      Strings.linkedinIconAsset,
                    ),
                  ),
                  Container(
                    width: 100.w,
                    height: 100.h,
                    child: Image.asset(
                      Strings.instagramIconAsset,
                    ),
                  ),
                ])
          ],
        ),
      ],
    );
  }
}
