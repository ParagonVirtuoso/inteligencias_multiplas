import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inteligencias_multiplas/utils/cores.dart';

class DrawerCustom extends StatefulWidget {
  final String profilePic;
  final String user;
  final String email;

  const DrawerCustom(
      {Key? key,
      required this.profilePic,
      required this.user,
      required this.email})
      : super(key: key);

  @override
  State<DrawerCustom> createState() => _DrawerCustomState();
}

class _DrawerCustomState extends State<DrawerCustom> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 600.h,
          decoration: const BoxDecoration(
            color: Cores.kBorderColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 170.w,
                height: 150.h,
                margin: EdgeInsets.only(bottom: 20.h),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    widget.profilePic,
                  ),
                ),
              ),
              Container(
                height: 150.h,
                margin: EdgeInsets.only(bottom: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.user,
                        style: TextStyle(
                            fontSize: 45.sp,
                            color: Cores.kBlackColor,
                            fontWeight: FontWeight.w700)),
                    SizedBox(
                        width: 400.w,
                        child: Text(widget.email,
                            style: TextStyle(
                                fontSize: 30.sp,
                                color: Cores.kDeepGreyColor,
                                fontWeight: FontWeight.w500))),
                  ],
                ),
              )
            ],
          ),
        ),
        ListTile(
          title: Text('Item 1'),
          onTap: () {},
        ),
        ListTile(
          title: Text('Item 2'),
          onTap: () {},
        ),
      ],
    );
  }
}
