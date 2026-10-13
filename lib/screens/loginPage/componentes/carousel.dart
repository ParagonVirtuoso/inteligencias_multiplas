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
  final CarouselSliderController _controllerCarousel =
      CarouselSliderController();
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
        Expanded(
          child: CarouselSlider(
            carouselController: _controllerCarousel,
            options: CarouselOptions(
                enlargeCenterPage: true,
                autoPlay: true,
                viewportFraction: 0.9,
                height: 720.h,
                onPageChanged: (index, reason) {
                  setState(() {
                    _indicadorCarousel = index;
                  });
                }),
            items: textCarouselList.map((textoIndicado) {
              return Builder(
                builder: (BuildContext context) {
                  return Center(
                    child: SizedBox(
                        height: 500.h,
                        width: 1080.w,
                        child: textoIndicado == textCarouselList[0]
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    textCarouselList[0],
                                    height: 250.h,
                                    fit: BoxFit.contain,
                                  ),
                                  SizedBox(height: 20.h),
                                  Text(
                                    Strings.subtituloHeroLogin,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Cores.kWhiteColor,
                                      fontSize: 42.sp,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Roboto-Regular',
                                    ),
                                  ),
                                ],
                              )
                            : Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(horizontal: 10.w),
                                child: Text(
                                  textoIndicado,
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                      color: Cores.kWhiteColor,
                                      fontSize: 45.sp,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Roboto-Regular'),
                                ))),
                  );
                },
              );
            }).toList(),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: textCarouselList.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controllerCarousel.animateToPage(entry.key),
              child: Container(
                width: 22.w,
                height: 22.w,
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (_indicadorCarousel == entry.key
                        ? const Color(0xFF1E1E1E).withValues(alpha: 0.6)
                        : Colors.white)),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 35.h),
      ],
    );
  }
}
