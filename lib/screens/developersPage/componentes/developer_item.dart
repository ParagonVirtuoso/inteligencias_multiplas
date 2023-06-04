import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../utils/cores.dart';
import '../../../utils/strings.dart';

class DeveloperItem extends StatelessWidget {
  const DeveloperItem({Key? key}) : super(key: key);

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Não foi possivel abrir : $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 220.w,
          height: 220.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            image: const DecorationImage(
              image: NetworkImage(
                  'https://firebasestorage.googleapis.com/v0/b/fury-db-ifmi.appspot.com/o/1684283591595-modified.png?alt=media&token=b56fd741-3e92-4e18-aa31-0c669fff9094'),
              fit: BoxFit.contain,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 50.w),
          height: 180.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
              Container(
                  width: 400.w,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _launchUrl('https://github.com/ParagonVirtuoso');
                          },
                          child: Container(
                            width: 60.w,
                            height: 60.h,
                            child: Image.asset(
                              Strings.githubIconAsset,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _launchUrl(
                                'https://www.linkedin.com/in/denys-fernandes-a1916198/');
                          },
                          child: Container(
                            width: 60.w,
                            height: 60.h,
                            child: Image.asset(
                              Strings.linkedinIconAsset,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _launchUrl('https://www.instagram.com/denysfh/');
                          },
                          child: Container(
                            width: 60.w,
                            height: 60.h,
                            child: Image.asset(
                              Strings.instagramIconAsset,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ]))
            ],
          ),
        )
      ],
    );
  }
}
