import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inteligencias_multiplas/utils/cores.dart';
import 'package:inteligencias_multiplas/utils/strings.dart';

class StarRate extends StatefulWidget {
  final int selectedStar;
  final Function(int) selecionarEstrela;
  final List<dynamic> listaJaRespondida;

  const StarRate(
      {super.key,
      required this.selectedStar,
      required this.selecionarEstrela,
      required this.listaJaRespondida});

  @override
  State<StarRate> createState() => _StarRateState();
}

class _StarRateState extends State<StarRate> {
  @override
  Widget build(BuildContext context) {
    final totalStars = widget.listaJaRespondida.length;
    return Container(
      height: 150.h,
      margin: EdgeInsets.only(top: 40.h, bottom: 40.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        color: Cores.kAzulDrawerItemColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(totalStars, (index) {
          final starValue = index + 1;
          final jaRespondida = index < widget.listaJaRespondida.length &&
              widget.listaJaRespondida[index] == true;
          return GestureDetector(
            onTap: () {
              widget.selecionarEstrela(starValue);
            },
            child: Opacity(
              opacity: jaRespondida ? 0.5 : 1.0,
              child: Image(
                image: AssetImage(widget.selectedStar >= starValue
                    ? Strings.starFullIconAsset
                    : Strings.starIconAsset),
                width: totalStars > 7 ? 78.w : null,
              ),
            ),
          );
        }),
      ),
    );
  }
}
