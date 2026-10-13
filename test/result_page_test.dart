import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inteligencias_multiplas/screens/resultPage/result_page.dart';

void main() {
  final mockResults = {
    'Linguistica': 25,
    'Logico': 35,
    'Musical': 15,
    'Cinestesica': 42,
    'Interpessoal': 30,
    'Intrapessoal': 28,
    'Espacial': 20,
  };

  testWidgets('ResultPage renders without RenderFlex overflow on narrow screen',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(1080, 1920),
        builder: (context, child) => MaterialApp(
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => const ResultPage(),
              settings: RouteSettings(name: '/result', arguments: mockResults),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);

    expect(find.text('42 Pontos'), findsOneWidget);
    expect(find.text('35 Pontos'), findsOneWidget);
  });

  testWidgets(
      'ResultPage renders without RenderFlex overflow on very small screen (320px)',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(640, 1136);
    tester.view.devicePixelRatio = 2.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(1080, 1920),
        builder: (context, child) => MaterialApp(
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => const ResultPage(),
              settings: RouteSettings(name: '/result', arguments: mockResults),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('42 Pontos'), findsOneWidget);
  });

  testWidgets('ResultPage handles null or empty arguments gracefully',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(1080, 1920),
        builder: (context, child) => const MaterialApp(
          home: ResultPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
