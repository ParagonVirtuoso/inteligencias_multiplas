import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inteligencias_multiplas/screens/questionsPage/componentes/modal_alerta_resposta.dart';
import 'package:inteligencias_multiplas/utils/strings.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    final fontLoader = FontLoader('Roboto-Regular');
    final fontData = File('assets/fonts/Roboto-Regular.ttf').readAsBytesSync();
    fontLoader.addFont(Future.value(ByteData.view(fontData.buffer)));
    await fontLoader.load();
  });

  Widget createTestWidget({
    required int respostaIgual,
    required void Function(int) setEditarResposta,
    double textScale = 1.0,
  }) {
    return ScreenUtilInit(
      designSize: const Size(1080, 1920),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(textScale),
        ),
        child: MaterialApp(
          theme: ThemeData(fontFamily: 'Roboto-Regular'),
          home: Scaffold(
            body: ModalAlertaResposta(
              currentQuestion: 0,
              respostaIgual: respostaIgual,
              setEditarResposta: setEditarResposta,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> preloadAssets(WidgetTester tester) async {
    await tester.runAsync(() async {
      final element = tester.element(find.byType(ModalAlertaResposta));
      await precacheImage(const AssetImage(Strings.proximoIconAsset), element);
      await precacheImage(const AssetImage(Strings.editIconAsset), element);
    });
  }

  group('ModalAlertaResposta layout and overflow tests', () {
    testWidgets(
        'renders without RenderFlex overflow on device from error log (1080x2400 @ 2.75x)',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.75;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        createTestWidget(
          respostaIgual: 3,
          setEditarResposta: (_) {},
        ),
      );

      await preloadAssets(tester);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text(Strings.editar), findsOneWidget);
      expect(find.text(Strings.continuar), findsOneWidget);
    });

    testWidgets(
        'renders without RenderFlex overflow on narrow screen (320px width)',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(640, 1136);
      tester.view.devicePixelRatio = 2.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        createTestWidget(
          respostaIgual: 2,
          setEditarResposta: (_) {},
        ),
      );

      await preloadAssets(tester);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text(Strings.editar), findsOneWidget);
      expect(find.text(Strings.continuar), findsOneWidget);
    });

    testWidgets('renders without overflow under high text scale factor (1.5x)',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.75;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        createTestWidget(
          respostaIgual: 4,
          setEditarResposta: (_) {},
          textScale: 1.5,
        ),
      );

      await preloadAssets(tester);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text(Strings.editar), findsOneWidget);
      expect(find.text(Strings.continuar), findsOneWidget);
    });

    testWidgets(
        'renders without overflow under extreme text scale factor (2.5x)',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.75;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        createTestWidget(
          respostaIgual: 4,
          setEditarResposta: (_) {},
          textScale: 2.5,
        ),
      );

      await preloadAssets(tester);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text(Strings.editar), findsOneWidget);
      expect(find.text(Strings.continuar), findsOneWidget);
    });

    testWidgets('renders without overflow in landscape orientation (2400x1080)',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(2400, 1080);
      tester.view.devicePixelRatio = 2.75;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        createTestWidget(
          respostaIgual: 4,
          setEditarResposta: (_) {},
        ),
      );

      await preloadAssets(tester);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text(Strings.editar), findsOneWidget);
      expect(find.text(Strings.continuar), findsOneWidget);
    });

    testWidgets(
        'renders without overflow on ultra-compact screen (280px width)',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(560, 1120);
      tester.view.devicePixelRatio = 2.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        createTestWidget(
          respostaIgual: 1,
          setEditarResposta: (_) {},
        ),
      );

      await preloadAssets(tester);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text(Strings.editar), findsOneWidget);
      expect(find.text(Strings.continuar), findsOneWidget);
    });

    testWidgets(
        'renders without overflow in landscape orientation with 2.0x text scale',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(2400, 1080);
      tester.view.devicePixelRatio = 2.75;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        createTestWidget(
          respostaIgual: 4,
          setEditarResposta: (_) {},
          textScale: 2.0,
        ),
      );

      await preloadAssets(tester);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text(Strings.editar), findsOneWidget);
      expect(find.text(Strings.continuar), findsOneWidget);
    });

    testWidgets(
        'tapping Editar triggers callback with respostaIgual and pops dialog/modal',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.75;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      int? editedAnswer;

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(1080, 1920),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (scaffoldContext) => ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: scaffoldContext,
                      builder: (bottomSheetContext) => ModalAlertaResposta(
                        currentQuestion: 0,
                        respostaIgual: 5,
                        setEditarResposta: (val) {
                          editedAnswer = val;
                        },
                      ),
                    );
                  },
                  child: const Text('Open Modal'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Open bottom sheet
      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      expect(find.byType(ModalAlertaResposta), findsOneWidget);
      expect(find.text(Strings.editar), findsOneWidget);

      // Tap Editar
      await tester.tap(find.text(Strings.editar));
      await tester.pumpAndSettle();

      expect(editedAnswer, equals(5));
      expect(find.byType(ModalAlertaResposta), findsNothing);
    });

    testWidgets('tapping Continuar dismisses the bottom sheet',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.75;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      bool callbackCalled = false;

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(1080, 1920),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (scaffoldContext) => ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: scaffoldContext,
                      builder: (bottomSheetContext) => ModalAlertaResposta(
                        currentQuestion: 0,
                        respostaIgual: 3,
                        setEditarResposta: (val) {
                          callbackCalled = true;
                        },
                      ),
                    );
                  },
                  child: const Text('Open Modal'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Open bottom sheet
      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      expect(find.byType(ModalAlertaResposta), findsOneWidget);

      // Tap Continuar
      await tester.tap(find.text(Strings.continuar));
      await tester.pumpAndSettle();

      expect(callbackCalled, isFalse);
      expect(find.byType(ModalAlertaResposta), findsNothing);
    });
  });
}
