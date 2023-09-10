import 'package:flutter/material.dart';
import '../../componentes/descriptor_content.dart';
import '../../utils/strings.dart';
import '../../componentes/description_text_item.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const DesciptorContent(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DescriptionTextItem(
              sobreTitulo: Strings.sobreApp,
              sobreDescricao: Strings.sobreAppDescricao,
            ),
            DescriptionTextItem(
              sobreTitulo: Strings.objetivo,
              sobreDescricao: Strings.objetivoDescricao,
            ),
          ],
        ),
      ),
    );
  }
}
