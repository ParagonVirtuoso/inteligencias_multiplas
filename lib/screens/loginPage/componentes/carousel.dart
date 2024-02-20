import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/strings.dart';
import '../../../utils/cores.dart';

class Carousel extends StatefulWidget {
  const Carousel({super.key});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  final CarouselController _controllerCarousel = CarouselController();
  int _indicadorCarousel = 0;

  final List<String> textCarouselList = [
    Strings.logoAsset,
    Strings.teoriaInteligenciaTelaLogin,
    Strings.diferentesTiposInteligenciaTelaLogin,
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          carouselController: _controllerCarousel,
          options: CarouselOptions(
              enlargeCenterPage: true,
              autoPlay: true,
              viewportFraction: 0.9,
              height: 770.h,
              onPageChanged: (index, reason) {
                setState(() {
                  _indicadorCarousel = index;
                });
              }),
          items: textCarouselList.map((textoIndicado) {
            return Builder(
              builder: (BuildContext context) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 400.h,
                        width: 1080.w,
                        child: _indicadorCarousel == 0
                            ? Image.asset(
                                textCarouselList[0],
                                fit: BoxFit.contain,
                              )
                            : Container(
                                padding: EdgeInsets.only(
                                    left: 5.w,
                                    right: 5.w,
                                    bottom: 50.h,
                                    top: 50.h),
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(horizontal: 5.w),
                                child: Text(
                                  textoIndicado,
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                      color: Cores.kWhiteColor,
                                      fontSize: 45.sp,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Roboto-Regular'),
                                )))
                  ],
                );
              },
            );
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: textCarouselList.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controllerCarousel.animateToPage(entry.key),
              child: Container(
                width: 20.w,
                height: 30.h,
                margin: EdgeInsets.symmetric(vertical: 25.h, horizontal: 10.w),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (_indicadorCarousel == entry.key
                        ? Cores.kTertiaryColor
                        : Colors.white)),
              ),
            );
          }).toList(),
        )
      ],
    );
  }
}
