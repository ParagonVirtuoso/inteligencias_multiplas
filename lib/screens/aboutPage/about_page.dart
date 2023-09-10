import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../componentes/descriptor_content.dart';
import '../../utils/strings.dart';
import 'componentes/about_item.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const DesciptorContent(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AboutItem(
              sobreTitulo: Strings.sobreApp,
              sobreDescricao: Strings.sobreAppDescricao,
            ),
            AboutItem(
              sobreTitulo: Strings.objetivo,
              sobreDescricao: Strings.objetivoDescricao,
            ),
          ],
        ),
      ),
    );
  }
}
