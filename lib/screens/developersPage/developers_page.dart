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
        SizedBox(
            height: 700.h,
            child: const Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DeveloperItem(
                    name: 'Denys Fernandes',
                    email: 'denysfernandes21@gmail.com',
                    githubUrl: 'https://github.com/ParagonVirtuoso',
                    linkedinUrl:
                        'https://www.linkedin.com/in/denys-fernandes-a1916198/',
                    instagramUrl: 'https://www.instagram.com/denysfh/',
                    imageUrl:
                        'https://firebasestorage.googleapis.com/v0/b/fury-db-ifmi.appspot.com/o/1684283591595-modified.png?alt=media&token=b56fd741-3e92-4e18-aa31-0c669fff9094',
                    cargo: 'Desenvolvedor',
                  ),
                  DeveloperItem(
                    name: 'Elias Ribeiro',
                    email: 'Elliasribeiro99@gmail.com',
                    githubUrl: 'https://github.com/sailleribeiro',
                    linkedinUrl:
                        'https://www.linkedin.com/in/elias-ribeiro-b74649174/',
                    instagramUrl: 'https://www.instagram.com/elliasribeiro_',
                    imageUrl:
                        'https://firebasestorage.googleapis.com/v0/b/fury-db-ifmi.appspot.com/o/perfil_eelias%20(2).png?alt=media&token=e2f6b9ca-4b43-4791-a2cc-9f9046be53cf',
                    cargo: 'UI / UX Designer',
                  )
                ]))
      ]),
    );
  }
}
