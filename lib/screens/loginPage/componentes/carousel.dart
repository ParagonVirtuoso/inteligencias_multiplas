import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/strings.dart';
import '../../../utils/cores.dart';

class Carousel extends StatefulWidget {
  final bool isWebOverride;

  const Carousel({super.key, this.isWebOverride = kIsWeb});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  final CarouselSliderController _controllerCarousel =
      CarouselSliderController();
  int _indicadorCarousel = 0;

  bool _detectIsWeb(BuildContext context) {
    if (widget.isWebOverride || kIsWeb) return true;
    final width = MediaQuery.maybeOf(context)?.size.width ?? 0;
    return width > 600;
  }

  final List<String> textCarouselList = [
    Strings.logoAsset,
    Strings.teoriaInteligenciaTelaLogin,
    Strings.diferentesTiposInteligenciaTelaLogin,
  ];

  @override
  Widget build(BuildContext context) {
    final isWeb = _detectIsWeb(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalHeight = constraints.maxHeight;
        final dotsHeight = isWeb
            ? (totalHeight < 180 ? 6.0 : 8.0)
            : (22.w).clamp(8.0, 12.0);
        final dotsBottomSpacing = isWeb
            ? (totalHeight < 180 ? 8.0 : 16.0)
            : (35.h).clamp(12.0, 24.0);
        final sliderHeight = (totalHeight - dotsHeight - dotsBottomSpacing)
            .clamp(40.0, double.infinity);

        return Column(
          children: [
            Expanded(
              child: CarouselSlider(
                carouselController: _controllerCarousel,
                options: CarouselOptions(
                    enlargeCenterPage: true,
                    autoPlay: true,
                    viewportFraction: 0.9,
                    height: sliderHeight,
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
                            height: sliderHeight,
                            width: double.infinity,
                            child: textoIndicado == textCarouselList[0]
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        textCarouselList[0],
                                        height: isWeb
                                            ? (sliderHeight * 0.48)
                                                .clamp(60.0, 220.0)
                                            : (sliderHeight * 0.50)
                                                .clamp(90.0, 160.0),
                                        fit: BoxFit.contain,
                                      ),
                                      SizedBox(
                                        height: isWeb
                                            ? (sliderHeight * 0.05)
                                                .clamp(4.0, 18.0)
                                            : (sliderHeight * 0.08)
                                                .clamp(6.0, 14.0),
                                      ),
                                      Text(
                                        Strings.subtituloHeroLogin,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Cores.kWhiteColor,
                                          fontSize: isWeb
                                              ? (sliderHeight < 160
                                                  ? 34.sp
                                                  : 42.sp)
                                              : 42.sp,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Roboto-Regular',
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(
                                    alignment: Alignment.center,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10.w),
                                    child: ConstrainedBox(
                                      constraints:
                                          const BoxConstraints(maxWidth: 680),
                                      child: Text(
                                        textoIndicado,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Cores.kWhiteColor,
                                            fontSize: isWeb
                                                ? (sliderHeight < 160
                                                    ? 34.sp
                                                    : 44.sp)
                                                : 45.sp,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Roboto-Regular'),
                                      ),
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
                    width: dotsHeight,
                    height: dotsHeight,
                    margin: EdgeInsets.symmetric(
                        horizontal: (10.w).clamp(4.0, 8.0)),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (_indicadorCarousel == entry.key
                            ? const Color(0xFF1E1E1E).withValues(alpha: 0.6)
                            : Colors.white)),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: dotsBottomSpacing),
          ],
        );
      },
    );
  }
}
