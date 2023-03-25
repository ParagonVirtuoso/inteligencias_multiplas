import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inteligencias_multiplas/utils/cores.dart';
import 'package:inteligencias_multiplas/utils/strings.dart';

class StarRate extends StatefulWidget {
  int selectedStar;
  var selecionarEstrela;
  var listaJaRespondida;

  StarRate(
      {Key? key,
      required this.selectedStar,
      required this.selecionarEstrela,
      required this.listaJaRespondida})
      : super(key: key);

  @override
  State<StarRate> createState() => _StarRateState();
}

class _StarRateState extends State<StarRate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.h,
      margin: EdgeInsets.only(top: 40.h, bottom: 40.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        color: Cores.kBorderColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
              onTap: () {
                widget.selecionarEstrela(1);
              },
              child: Opacity(
                opacity: widget.listaJaRespondida[0] ? 0.5 : 1,
                child: Image(
                    image: AssetImage(widget.selectedStar >= 1
                        ? Strings.starFullIconAsset
                        : Strings.starIconAsset)),
              )),
          GestureDetector(
              onTap: () {
                widget.selecionarEstrela(2);
              },
              child: Opacity(
                opacity: widget.listaJaRespondida[1] ? 0.5 : 1,
                child: Image(
                    image: AssetImage(widget.selectedStar >= 2
                        ? Strings.starFullIconAsset
                        : Strings.starIconAsset)),
              )),
          GestureDetector(
              onTap: () {
                widget.selecionarEstrela(3);
              },
              child: Opacity(
                opacity: widget.listaJaRespondida[2] ? 0.5 : 1,
                child: Image(
                    image: AssetImage(widget.selectedStar >= 3
                        ? Strings.starFullIconAsset
                        : Strings.starIconAsset)),
              )),
          GestureDetector(
              onTap: () {
                widget.selecionarEstrela(4);
              },
              child: Opacity(
                opacity: widget.listaJaRespondida[3] ? 0.5 : 1,
                child: Image(
                    image: AssetImage(widget.selectedStar >= 4
                        ? Strings.starFullIconAsset
                        : Strings.starIconAsset)),
              )),
          GestureDetector(
              onTap: () {
                widget.selecionarEstrela(5);
              },
              child: Opacity(
                opacity: widget.listaJaRespondida[4] ? 0.5 : 1,
                child: Image(
                    image: AssetImage(widget.selectedStar >= 5
                        ? Strings.starFullIconAsset
                        : Strings.starIconAsset)),
              )),
          GestureDetector(
              onTap: () {
                widget.selecionarEstrela(6);
              },
              child: Opacity(
                opacity: widget.listaJaRespondida[5] ? 0.5 : 1,
                child: Image(
                    image: AssetImage(widget.selectedStar >= 6
                        ? Strings.starFullIconAsset
                        : Strings.starIconAsset)),
              )),
          GestureDetector(
              onTap: () {
                widget.selecionarEstrela(7);
              },
              child: Opacity(
                opacity: widget.listaJaRespondida[6] ? 0.5 : 1,
                child: Image(
                    image: AssetImage(widget.selectedStar >= 7
                        ? Strings.starFullIconAsset
                        : Strings.starIconAsset)),
              ))
        ],
      ),
    );
  }
}
