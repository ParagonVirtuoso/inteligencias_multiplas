import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inteligencias_multiplas/screens/homePage/componentes/card_tutorial.dart';
import 'package:inteligencias_multiplas/screens/homePage/home_page.dart';
import 'package:inteligencias_multiplas/utils/strings.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    final fontLoader = FontLoader('Roboto-Regular');
    final fontData = File('assets/fonts/Roboto-Regular.ttf').readAsBytesSync();
    fontLoader.addFont(Future.value(ByteData.view(fontData.buffer)));
    await fontLoader.load();
  });

  Widget wrapWithScreenUtil(
    Widget child, {
    Size designSize = const Size(1080, 1920),
    double textScale = 1.0,
  }) {
    return ScreenUtilInit(
      designSize: designSize,
      builder: (context, _) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(textScale),
        ),
        child: MaterialApp(
          theme: ThemeData(fontFamily: 'Roboto-Regular'),
          home: Scaffold(
            body: child,
          ),
        ),
      ),
    );
  }

  void configureViewport(
    WidgetTester tester, {
    Size size = const Size(1080, 2400),
    double pixelRatio = 2.75,
  }) {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = pixelRatio;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  Future<void> preloadImages(WidgetTester tester) async {
    await tester.runAsync(() async {
      final element = tester.element(find.byType(CardTutorial));
      await precacheImage(const AssetImage(Strings.playIconAsset), element);
    });
  }

  group('CardTutorial component tests', () {
    testWidgets(
        'renders CardTutorial with updated texts and without star rating icons',
        (WidgetTester tester) async {
      configureViewport(tester);

      await tester.pumpWidget(
        wrapWithScreenUtil(
          CardTutorial(buscarDadosTeste: () async => true),
        ),
      );
      await preloadImages(tester);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);

      // Title & Subtitle
      expect(find.text(Strings.comoFunciona), findsOneWidget);
      expect(find.text(Strings.avalieCadaQuestao), findsOneWidget);

      // RichText instruction (no repeated note per step)
      expect(find.textContaining(Strings.voce.trim(), findRichText: true),
          findsWidgets);
      expect(
          find.textContaining(Strings.naoRepetirRespesta.trim(),
              findRichText: true),
          findsWidgets);
      expect(
          find.textContaining(Strings.naoRepetirRespestaDescricao.trim(),
              findRichText: true),
          findsWidgets);

      // Encouraging message
      expect(find.text(Strings.naoExisteRespostaCerta), findsOneWidget);

      // Start test button
      expect(find.byKey(const Key('home_start_test_button')), findsOneWidget);
      expect(find.text(Strings.iniciarTeste), findsOneWidget);

      // Verify NO star icons are used in CardTutorial
      final images = tester.widgetList<Image>(find.descendant(
        of: find.byType(CardTutorial),
        matching: find.byType(Image),
      ));
      for (final img in images) {
        if (img.image is AssetImage) {
          final asset = img.image as AssetImage;
          expect(asset.assetName, isNot(contains('star')));
        }
      }
    });

    testWidgets(
        'renders 9 numeric chips preview with legend and status indicators',
        (WidgetTester tester) async {
      configureViewport(tester);

      await tester.pumpWidget(
        wrapWithScreenUtil(
          CardTutorial(buscarDadosTeste: () async => true),
        ),
      );
      await preloadImages(tester);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('tutorial_chips_container')), findsOneWidget);

      // All 9 chips present
      for (int i = 1; i <= 9; i++) {
        expect(find.byKey(Key('tutorial_chip_$i')), findsOneWidget);
      }

      // Header & Legend items
      expect(find.text(Strings.toqueParaTestar), findsOneWidget);
      expect(find.text(Strings.legendaSuaNota), findsOneWidget);
      expect(find.text(Strings.legendaDisponivel), findsOneWidget);
      expect(find.text(Strings.legendaAtribuida), findsOneWidget);
      expect(find.text(Strings.legendaBadgePerguntaExemplo), findsOneWidget);

      // Default state: chip 5 is selected (has check icon)
      expect(
        find.descendant(
          of: find.byKey(const Key('tutorial_chip_5')),
          matching: find.byIcon(Icons.check),
        ),
        findsOneWidget,
      );

      // Chips 3 and 7 show assigned labels P2 and P4
      expect(
        find.descendant(
          of: find.byKey(const Key('tutorial_chip_3')),
          matching: find.text('P2'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byKey(const Key('tutorial_chip_7')),
          matching: find.text('P4'),
        ),
        findsOneWidget,
      );

      // Verify tooltips and semantics
      expect(
        find.byTooltip(Strings.tooltipNotaSelecionada(5)),
        findsOneWidget,
      );
      expect(
        find.byTooltip(Strings.tooltipNotaAtribuida(3, 2)),
        findsOneWidget,
      );
      expect(
        find.byTooltip(Strings.tooltipNotaDisponivel(1)),
        findsOneWidget,
      );
    });

    testWidgets(
        'renders feature highlight tiles for chips, smart swap, and navigation',
        (WidgetTester tester) async {
      configureViewport(tester);

      await tester.pumpWidget(
        wrapWithScreenUtil(
          CardTutorial(buscarDadosTeste: () async => true),
        ),
      );
      await preloadImages(tester);
      await tester.pumpAndSettle();

      // Feature Tile 1: Fichas de 1 a 9
      final chipsTile = find.byKey(const Key('tutorial_feature_chips'));
      expect(chipsTile, findsOneWidget);
      expect(
        find.descendant(of: chipsTile, matching: find.text(Strings.tutorialFichasTitulo)),
        findsOneWidget,
      );
      expect(find.text(Strings.tutorialFichasDescricao), findsOneWidget);

      // Feature Tile 2: Smart Swap
      expect(find.byKey(const Key('tutorial_feature_swap')), findsOneWidget);
      expect(find.text(Strings.tutorialSwapTitulo), findsOneWidget);
      expect(find.text(Strings.tutorialSwapDescricao), findsOneWidget);

      // Feature Tile 3: Mini-Navigator and back button
      expect(find.byKey(const Key('tutorial_feature_nav')), findsOneWidget);
      expect(find.text(Strings.tutorialNavTitulo), findsOneWidget);
      expect(find.text(Strings.tutorialNavDescricao), findsOneWidget);
    });

    testWidgets('tapping an available chip updates selection in preview',
        (WidgetTester tester) async {
      configureViewport(tester);

      await tester.pumpWidget(
        wrapWithScreenUtil(
          CardTutorial(buscarDadosTeste: () async => true),
        ),
      );
      await preloadImages(tester);
      await tester.pumpAndSettle();

      // Tap chip 2 (available)
      await tester.tap(find.byKey(const Key('tutorial_chip_2')));
      await tester.pumpAndSettle();

      // Chip 2 should now have the checkmark icon
      expect(
        find.descendant(
          of: find.byKey(const Key('tutorial_chip_2')),
          matching: find.byIcon(Icons.check),
        ),
        findsOneWidget,
      );

      // Chip 5 should no longer have checkmark icon
      expect(
        find.descendant(
          of: find.byKey(const Key('tutorial_chip_5')),
          matching: find.byIcon(Icons.check),
        ),
        findsNothing,
      );

      // Feedback message shown
      expect(find.byKey(const Key('tutorial_swap_feedback')), findsOneWidget);
      expect(find.text(Strings.tutorialNotaSelecionada(2)), findsOneWidget);
    });

    testWidgets(
        'tapping an assigned chip demonstrates Smart Swap with feedback',
        (WidgetTester tester) async {
      configureViewport(tester);

      await tester.pumpWidget(
        wrapWithScreenUtil(
          CardTutorial(buscarDadosTeste: () async => true),
        ),
      );
      await preloadImages(tester);
      await tester.pumpAndSettle();

      // Initial: chip 5 is selected, chip 3 assigned to P2
      expect(
        find.descendant(
          of: find.byKey(const Key('tutorial_chip_3')),
          matching: find.text('P2'),
        ),
        findsOneWidget,
      );

      // Tap chip 3 (assigned to P2)
      await tester.tap(find.byKey(const Key('tutorial_chip_3')));
      await tester.pumpAndSettle();

      // Chip 3 is now selected (has checkmark)
      expect(
        find.descendant(
          of: find.byKey(const Key('tutorial_chip_3')),
          matching: find.byIcon(Icons.check),
        ),
        findsOneWidget,
      );

      // Chip 5 now has P2 assigned label (swapped!)
      expect(
        find.descendant(
          of: find.byKey(const Key('tutorial_chip_5')),
          matching: find.text('P2'),
        ),
        findsOneWidget,
      );

      // Feedback mentions swap
      expect(find.byKey(const Key('tutorial_swap_feedback')), findsOneWidget);
      expect(
        find.text(Strings.tutorialNotasTrocadas(2)),
        findsOneWidget,
      );
    });

    testWidgets('tapping Iniciar Teste triggers buscarDadosTeste callback',
        (WidgetTester tester) async {
      configureViewport(tester);

      bool called = false;
      await tester.pumpWidget(
        wrapWithScreenUtil(
          CardTutorial(buscarDadosTeste: () async {
            called = true;
            return false;
          }),
        ),
      );
      await preloadImages(tester);
      await tester.pumpAndSettle();

      // Scroll down to start button and tap
      await tester.ensureVisible(find.byKey(const Key('home_start_test_button')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('home_start_test_button')));
      await tester.pumpAndSettle();

      expect(called, isTrue);
    });

    testWidgets('renders Iniciar Teste when hasSavedProgress is false',
        (WidgetTester tester) async {
      configureViewport(tester);

      await tester.pumpWidget(
        wrapWithScreenUtil(
          CardTutorial(
            buscarDadosTeste: () async => true,
            hasSavedProgress: false,
          ),
        ),
      );
      await preloadImages(tester);
      await tester.pumpAndSettle();

      expect(find.text(Strings.iniciarTeste), findsOneWidget);
      expect(find.text(Strings.continuarTeste), findsNothing);
    });

    testWidgets('renders Continuar teste when hasSavedProgress is true',
        (WidgetTester tester) async {
      configureViewport(tester);

      await tester.pumpWidget(
        wrapWithScreenUtil(
          CardTutorial(
            buscarDadosTeste: () async => true,
            hasSavedProgress: true,
          ),
        ),
      );
      await preloadImages(tester);
      await tester.pumpAndSettle();

      expect(find.text(Strings.continuarTeste), findsOneWidget);
      expect(find.text(Strings.iniciarTeste), findsNothing);
    });

    testWidgets('renders cleanly on compact screen (320x568 dp) without overflow',
        (WidgetTester tester) async {
      configureViewport(tester, size: const Size(640, 1136), pixelRatio: 2.0);

      await tester.pumpWidget(
        wrapWithScreenUtil(
          CardTutorial(buscarDadosTeste: () async => true),
        ),
      );
      await preloadImages(tester);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(CardTutorial), findsOneWidget);
    });

    testWidgets(
        'renders cleanly on ultra-compact screen (320x480 dp) without overflow',
        (WidgetTester tester) async {
      configureViewport(tester, size: const Size(640, 960), pixelRatio: 2.0);

      await tester.pumpWidget(
        wrapWithScreenUtil(
          CardTutorial(buscarDadosTeste: () async => true),
        ),
      );
      await preloadImages(tester);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(CardTutorial), findsOneWidget);
    });

    testWidgets(
        'renders cleanly under 2.0x accessibility font scale without overflow',
        (WidgetTester tester) async {
      configureViewport(tester);

      await tester.pumpWidget(
        wrapWithScreenUtil(
          CardTutorial(buscarDadosTeste: () async => true),
          textScale: 2.0,
        ),
      );
      await preloadImages(tester);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(CardTutorial), findsOneWidget);
    });

    testWidgets('renders cleanly on desktop web viewport (1280x800 dp)',
        (WidgetTester tester) async {
      configureViewport(tester, size: const Size(1280, 800), pixelRatio: 1.0);

      await tester.pumpWidget(
        wrapWithScreenUtil(
          CardTutorial(buscarDadosTeste: () async => true),
        ),
      );
      await preloadImages(tester);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(CardTutorial), findsOneWidget);
    });
  });

  group('HomePage integration tests', () {
    testWidgets('renders HomePage with CardTutorial on standard phone without overflow',
        (WidgetTester tester) async {
      configureViewport(tester, size: const Size(1080, 2400), pixelRatio: 2.75);

      await tester.pumpWidget(
        wrapWithScreenUtil(const HomePage()),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(HomePage), findsOneWidget);
      expect(find.byType(CardTutorial), findsOneWidget);
      expect(find.text(Strings.comoFunciona), findsOneWidget);
    });

    testWidgets('renders HomePage with CardTutorial on compact screen (320x568 dp) without overflow',
        (WidgetTester tester) async {
      configureViewport(tester, size: const Size(640, 1136), pixelRatio: 2.0);

      await tester.pumpWidget(
        wrapWithScreenUtil(const HomePage()),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(HomePage), findsOneWidget);
      expect(find.byType(CardTutorial), findsOneWidget);
    });

    testWidgets('renders HomePage on ultra-compact screen (320x480 dp) without overflow',
        (WidgetTester tester) async {
      configureViewport(tester, size: const Size(640, 960), pixelRatio: 2.0);

      await tester.pumpWidget(
        wrapWithScreenUtil(const HomePage()),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(HomePage), findsOneWidget);
      expect(find.byType(CardTutorial), findsOneWidget);
    });

    testWidgets('renders HomePage under 2.0x accessibility font scale without overflow',
        (WidgetTester tester) async {
      configureViewport(tester, size: const Size(1080, 2400), pixelRatio: 2.75);

      await tester.pumpWidget(
        wrapWithScreenUtil(const HomePage(), textScale: 2.0),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(HomePage), findsOneWidget);
      expect(find.byType(CardTutorial), findsOneWidget);
    });

    testWidgets('renders HomePage on desktop web viewport (1280x800 dp) without overflow',
        (WidgetTester tester) async {
      configureViewport(tester, size: const Size(1280, 800), pixelRatio: 1.0);

      await tester.pumpWidget(
        wrapWithScreenUtil(const HomePage()),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(HomePage), findsOneWidget);
      expect(find.byType(CardTutorial), findsOneWidget);
      expect(find.text(Strings.bemVindoTelaHome), findsOneWidget);
      expect(find.text(Strings.comoFunciona), findsOneWidget);
      expect(find.byKey(const Key('home_start_test_button')), findsOneWidget);
    });

    testWidgets('renders desktop top bar on large monitor (1920x1080 dp)',
        (WidgetTester tester) async {
      configureViewport(tester, size: const Size(1920, 1080), pixelRatio: 1.0);

      await tester.pumpWidget(
        wrapWithScreenUtil(const HomePage()),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(AppBar), findsOneWidget);
      // Hamburger button, avatar and greeting are present
      expect(find.byIcon(Icons.menu), findsOneWidget);
      expect(find.text(Strings.bemVindoTelaHome), findsOneWidget);
      expect(find.text(Strings.visitantePonto), findsOneWidget);
      // Both columns in CardTutorial are present
      expect(find.byKey(const Key('tutorial_chips_container')), findsOneWidget);
      expect(find.byKey(const Key('tutorial_feature_chips')), findsOneWidget);
      expect(find.byKey(const Key('tutorial_feature_swap')), findsOneWidget);
      expect(find.byKey(const Key('tutorial_feature_nav')), findsOneWidget);
      expect(find.byKey(const Key('home_start_test_button')), findsOneWidget);
    });
  });
}

