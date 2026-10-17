import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inteligencias_multiplas/screens/homePage/componentes/button_drawer.dart';
import 'package:inteligencias_multiplas/screens/homePage/componentes/drawer_custom.dart';
import 'package:inteligencias_multiplas/utils/cores.dart';
import 'package:inteligencias_multiplas/utils/strings.dart';

class _TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) => _MockHttpClient();
}

class _MockHttpClient implements HttpClient {
  @override
  bool autoUncompress = false;

  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _MockHttpClientRequest();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockHttpClientRequest implements HttpClientRequest {
  @override
  final HttpHeaders headers = _MockHttpHeaders();

  @override
  Future<HttpClientResponse> close() async => _MockHttpClientResponse();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockHttpHeaders implements HttpHeaders {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _MockHttpClientResponse implements HttpClientResponse {
  static final Uint8List _transparent1x1Png = Uint8List.fromList(<int>[
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
    0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
    0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
    0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
    0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
    0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
  ]);

  @override
  int get statusCode => HttpStatus.ok;

  @override
  int get contentLength => _transparent1x1Png.length;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.value(_transparent1x1Png).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUpAll(() {
    HttpOverrides.global = _TestHttpOverrides();
  });

  tearDownAll(() {
    HttpOverrides.global = null;
  });

  Widget buildTestableButton({
    String? icon,
    Widget? iconWidget,
    double? iconSize,
    String text = 'Refazer',
    VoidCallback? onTap,
    Size surfaceSize = const Size(360, 800),
  }) {
    return ScreenUtilInit(
      designSize: const Size(1080, 1920),
      builder: (context, child) => MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 300,
              child: ButtonDrawer(
                icon: icon,
                iconWidget: iconWidget,
                iconSize: iconSize,
                text: text,
                corFundo: Cores.kAzulBotaoItemColor,
                corTexto: Cores.kWhiteColor,
                onTap: onTap ?? () {},
              ),
            ),
          ),
        ),
      ),
    );
  }

  group('ButtonDrawer icon sizing and layout tests', () {
    testWidgets('renders high-resolution asset icon with bounded dimensions without blowing out button height',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 3.0; // 360x800 dp

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        buildTestableButton(
          icon: Strings.refazerIconAsset,
          text: Strings.refazer,
        ),
      );
      await tester.pumpAndSettle();

      final buttonFinder = find.byType(ButtonDrawer);
      expect(buttonFinder, findsOneWidget);

      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);

      final Image imageWidget = tester.widget<Image>(imageFinder);
      expect(imageWidget.width, isNotNull);
      expect(imageWidget.height, isNotNull);
      expect(imageWidget.fit, BoxFit.contain);
      expect(imageWidget.filterQuality, FilterQuality.medium);
      expect(imageWidget.excludeFromSemantics, isTrue);

      // Verify image logical size is properly bounded (between 22 and 26 dp)
      expect(imageWidget.width!, inInclusiveRange(22.0, 26.0));
      expect(imageWidget.height!, inInclusiveRange(22.0, 26.0));

      final RenderBox imageBox = tester.renderObject(imageFinder);
      expect(imageBox.size.width, inInclusiveRange(22.0, 26.0));
      expect(imageBox.size.height, inInclusiveRange(22.0, 26.0));

      // Verify the entire button height stays compact (below 65 dp, not blown out to 80+ dp)
      final RenderBox buttonBox = tester.renderObject(buttonFinder);
      expect(buttonBox.size.height, lessThanOrEqualTo(65.0));

      // Verify Semantics contains button role and label
      expect(
        tester.getSemantics(buttonFinder),
        matchesSemantics(
          label: Strings.refazer,
          isButton: true,
          hasTapAction: true,
        ),
      );
    });

    testWidgets('renders iconWidget with scaleDown without upscaling or distorting',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 3.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        buildTestableButton(
          iconWidget: const Icon(Icons.star, size: 50.0), // intentionally large icon
          text: 'Teste Estrela',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ButtonDrawer), findsOneWidget);
      expect(find.byType(FittedBox), findsOneWidget);

      final FittedBox fittedBoxWidget = tester.widget<FittedBox>(find.byType(FittedBox));
      expect(fittedBoxWidget.fit, BoxFit.scaleDown);

      final fittedBoxFinder = find.byType(FittedBox);
      final RenderBox fittedBox = tester.renderObject(fittedBoxFinder);
      expect(fittedBox.size.width, inInclusiveRange(22.0, 26.0));
      expect(fittedBox.size.height, inInclusiveRange(22.0, 26.0));
    });

    testWidgets('handles empty or blank icon string gracefully without exception',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestableButton(
          icon: '',
          iconWidget: const SizedBox(width: 20, height: 20),
          text: 'Icone Vazio',
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Icone Vazio'), findsOneWidget);
    });

    testWidgets('respects right padding on text preventing collision with rounded pill boundary',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestableButton(
          icon: Strings.starFullIconAsset,
          text: Strings.avaliarApp,
        ),
      );
      await tester.pumpAndSettle();

      final textPaddingFinder = find.descendant(
        of: find.byType(Expanded),
        matching: find.byType(Padding),
      );
      expect(textPaddingFinder, findsOneWidget);

      final Padding paddingWidget = tester.widget<Padding>(textPaddingFinder);
      final insets = paddingWidget.padding as EdgeInsets;
      expect(insets.right, inInclusiveRange(12.0, 18.0));
    });

    testWidgets('renders cleanly under 2.0x accessibility font scale without layout overflow',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 3.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(1080, 1920),
          builder: (context, child) => MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(
                textScaler: TextScaler.linear(2.0),
              ),
              child: Scaffold(
                body: Center(
                  child: SizedBox(
                    width: 300,
                    child: ButtonDrawer(
                      icon: Strings.refazerIconAsset,
                      text: Strings.refazer,
                      corFundo: Cores.kAzulBotaoItemColor,
                      corTexto: Cores.kWhiteColor,
                      onTap: () {},
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text(Strings.refazer), findsOneWidget);
    });

    testWidgets('respects explicit iconSize parameter',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 3.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        buildTestableButton(
          icon: Strings.starIconAsset,
          iconSize: 28.0,
          text: Strings.teste,
        ),
      );
      await tester.pumpAndSettle();

      final Image imageWidget = tester.widget<Image>(find.byType(Image));
      expect(imageWidget.width, 28.0);
      expect(imageWidget.height, 28.0);
    });

    testWidgets('triggers onTap callback when tapped',
        (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        buildTestableButton(
          icon: Strings.desenvolvedoresIconAsset,
          text: Strings.desenvolvedores,
          onTap: () {
            tapped = true;
          },
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ButtonDrawer));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });
  });

  group('DrawerCustom with high-resolution icons across screen resolutions', () {
    for (final config in [
      {'name': 'Foldable cover screen (280x653)', 'size': const Size(280, 653), 'dpr': 1.0},
      {'name': 'Compact phone (320x568)', 'size': const Size(320, 568), 'dpr': 1.0},
      {'name': 'Standard Android (360x800)', 'size': const Size(1080, 2400), 'dpr': 3.0},
      {'name': 'iPhone 15 (393x852)', 'size': const Size(1179, 2556), 'dpr': 3.0},
      {'name': 'Foldable unfolded tablet (884x1104)', 'size': const Size(884, 1104), 'dpr': 2.0},
      {'name': 'Desktop Web (1024x768)', 'size': const Size(1024, 768), 'dpr': 1.0},
    ]) {
      testWidgets('renders all drawer icons without overflow on ${config['name']}',
          (WidgetTester tester) async {
        tester.view.physicalSize = config['size'] as Size;
        tester.view.devicePixelRatio = config['dpr'] as double;

        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          ScreenUtilInit(
            designSize: const Size(1080, 1920),
            builder: (context, child) => MaterialApp(
              home: Scaffold(
                drawer: const Drawer(
                  child: DrawerCustom(
                    profilePic: '',
                    user: 'Usuário Teste',
                    email: 'teste@email.com',
                  ),
                ),
                body: Builder(
                  builder: (ctx) => ElevatedButton(
                    onPressed: () => Scaffold.of(ctx).openDrawer(),
                    child: const Text('Abrir'),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Abrir'));
        await tester.pumpAndSettle();

        // Check that all 7 buttons are present
        expect(find.text(Strings.refazer), findsOneWidget);
        expect(find.text(Strings.teste), findsOneWidget);
        expect(find.text(Strings.desenvolvedores), findsOneWidget);
        expect(find.text(Strings.termosUso), findsOneWidget);
        expect(find.text(Strings.sobreApp), findsOneWidget);
        expect(find.text(Strings.avaliarApp), findsOneWidget);
        expect(find.text(Strings.sair), findsOneWidget);

        // Verify that every Image inside ButtonDrawer has bounded dimensions
        final images = tester.widgetList<Image>(find.descendant(
          of: find.byType(ButtonDrawer),
          matching: find.byType(Image),
        ));

        expect(images.length, 7);
        for (final img in images) {
          expect(img.width, isNotNull);
          expect(img.height, isNotNull);
          expect(img.width!, inInclusiveRange(20.0, 28.0));
          expect(img.height!, inInclusiveRange(20.0, 28.0));
          expect(img.fit, BoxFit.contain);
        }

        // Verify no overflow errors were triggered in the tester
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets(
        'Sair button matches Figma mockup positioning and styling on mobile (393x852) and desktop web (1024x768)',
        (WidgetTester tester) async {
      for (final device in [
        {'name': 'mobile', 'size': const Size(1179, 2556), 'dpr': 3.0, 'logicalHeight': 852.0},
        {'name': 'desktop_web', 'size': const Size(1024, 768), 'dpr': 1.0, 'logicalHeight': 768.0},
      ]) {
        tester.view.physicalSize = device['size'] as Size;
        tester.view.devicePixelRatio = device['dpr'] as double;

        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        final scaffoldKey = GlobalKey<ScaffoldState>();

        await tester.pumpWidget(
          ScreenUtilInit(
            designSize: const Size(1080, 1920),
            builder: (context, child) => MaterialApp(
              home: Scaffold(
                key: scaffoldKey,
                drawer: const Drawer(
                  child: DrawerCustom(
                    profilePic: '',
                    user: 'João Gomes',
                    email: 'joaogomes@gmail.com',
                    appVersion: '2.0',
                  ),
                ),
                body: const SizedBox(),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        scaffoldKey.currentState!.openDrawer();
        await tester.pumpAndSettle();

        // 1. Verify Sair button styling matches Figma (#F4F4F4 background, #404040 text)
        final buttonDrawers = tester.widgetList<ButtonDrawer>(find.byType(ButtonDrawer)).toList();
        final sairButton = buttonDrawers.firstWhere((b) => b.text == Strings.sair);
        expect(sairButton.corFundo, Cores.kCinzaSairBotao);
        expect(sairButton.corFundo, const Color(0xFFF4F4F4));
        expect(sairButton.corTexto, Cores.kCinzaTextoIconeSair);
        expect(sairButton.corTexto, const Color(0xFF404040));
        expect(sairButton.icon, Strings.sairAppIconAsset);

        // 2. Verify vertical layout matches Figma:
        // Top buttons -> large gap (Spacer) -> Sair button -> Versão 2.0 -> bottom edge
        final avaliarRect = tester.getRect(find.text(Strings.avaliarApp));
        final sairRect = tester.getRect(find.text(Strings.sair));
        final versaoRect = tester.getRect(find.text('Versão 2.0'));

        // Sair is below the last menu item with substantial gap
        expect(sairRect.top, greaterThan(avaliarRect.bottom + 40.0));

        // Versão is below Sair
        expect(versaoRect.top, greaterThan(sairRect.bottom));

        // Sair and Versão are anchored towards the bottom of the viewport
        final logicalHeight = device['logicalHeight'] as double;
        expect(versaoRect.bottom, lessThanOrEqualTo(logicalHeight));
        expect(sairRect.bottom, closeTo(logicalHeight - 50.0, 60.0));

        expect(tester.takeException(), isNull);
      }
    });
  });
}
