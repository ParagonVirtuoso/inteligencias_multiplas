import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../componentes/descriptor_content.dart';
import '../../utils/strings.dart';
import 'componentes/developer_item.dart';

class DevelopersPage extends StatefulWidget {
  const DevelopersPage({super.key});

  @override
  State<DevelopersPage> createState() => _DevelopersPageState();
}

class _DevelopersPageState extends State<DevelopersPage> {

  @override
  Widget build(BuildContext context) {
    return DesciptorContent(
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(bottom: 50.h),
            child: Text(
              Strings.desenvolvedores,
              style: TextStyle(
                  fontSize: 65.sp,
                  fontFamily: 'Roboto-Regular',
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const DeveloperItem(
                  name: 'Denys Fernandes',
                  email: 'denysfernandes21@gmail.com',
                  githubUrl: 'https://github.com/ParagonVirtuoso',
                  linkedinUrl:
                      'https://www.linkedin.com/in/denys-fernandes-a1916198/',
                  instagramUrl: 'https://www.instagram.com/denysfh/',
                  imageAsset: Strings.devDenysAsset,
                  imageUrl: Strings.devDenysAsset,
                  cargo: 'Desenvolvedor',
                ),
                SizedBox(height: 40.h),
                const DeveloperItem(
                  name: 'Elias Ribeiro',
                  email: 'Elliasribeiro99@gmail.com',
                  githubUrl: 'https://github.com/sailleribeiro',
                  linkedinUrl:
                      'https://www.linkedin.com/in/elias-ribeiro-b74649174/',
                  instagramUrl: 'https://www.instagram.com/elliasribeiro_',
                  imageAsset: Strings.devEliasAsset,
                  imageUrl: Strings.devEliasAsset,
                  cargo: 'UI / UX Designer',
                )
              ])
        ]),
      ),
    );
  }
}
