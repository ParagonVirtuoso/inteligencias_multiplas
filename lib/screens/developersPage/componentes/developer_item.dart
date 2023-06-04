import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../utils/cores.dart';
import '../../../utils/strings.dart';

class DeveloperItem extends StatelessWidget {
  final String name;
  final String email;
  final String githubUrl;
  final String linkedinUrl;
  final String instagramUrl;
  final String imageUrl;
  final String cargo;

  const DeveloperItem({
    Key? key,
    required this.name,
    required this.email,
    required this.githubUrl,
    required this.linkedinUrl,
    required this.instagramUrl,
    required this.imageUrl,
    required this.cargo,
  }) : super(key: key);

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Não foi possível abrir: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 30.h),
      decoration: BoxDecoration(
        color: Cores.kGreyColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 220.w,
                height: 220.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 50.w),
                height: 180.h,
                width: 560.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 45.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: 38.sp,
                        color: Cores.kDeepGreyColor,
                        overflow: TextOverflow.ellipsis,
                      ),
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
                              _launchUrl(githubUrl);
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
                              _launchUrl(linkedinUrl);
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
                              _launchUrl(instagramUrl);
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
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Container(
              alignment: Alignment.centerLeft,
              child: Text(
                cargo,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: Cores.kDeepGreyColor,
                ),
              )),
        ],
      ),
    );
  }
}
