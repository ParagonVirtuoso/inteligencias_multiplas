import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inteligencias_multiplas/main.dart';
import 'package:inteligencias_multiplas/screens/loginPage/componentes/carousel.dart';
import 'package:inteligencias_multiplas/screens/loginPage/login_page.dart';
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
  @override
  int get statusCode => 200;

  @override
  int get contentLength => 0;

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
    return const Stream<List<int>>.empty().listen(
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

  group('LoginPage Web Layout & Zero-Scroll Tests', () {
    final webResolutions = <String, Size>{
      '4K Desktop (3840x2160)': const Size(3840, 2160),
      '2K Desktop (2560x1440)': const Size(2560, 1440),
      'Full HD Desktop (1920x1080)': const Size(1920, 1080),
      'MacBook / 1440x900 Desktop': const Size(1440, 900),
      '13" Laptop (1280x800)': const Size(1280, 800),
      'Standard Laptop (1366x768)': const Size(1366, 768),
      'Compact Desktop / Tablet Landscape (1024x768)': const Size(1024, 768),
      '720p HD (1280x720)': const Size(1280, 720),
      'Laptop Browser Window (1366x620)': const Size(1366, 620),
      'Small Browser Window (800x600)': const Size(800, 600),
      'Scaled Laptop Window (1280x560)': const Size(1280, 560),
      'Compact Window (1024x500)': const Size(1024, 500),
      'Wide Compact Window (1280x500)': const Size(1280, 500),
    };

    for (final entry in webResolutions.entries) {
      testWidgets('White card has zero scroll extent on ${entry.key}', (tester) async {
        tester.view.physicalSize = entry.value;
        tester.view.devicePixelRatio = 1.0;

        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          const MyApp(isWebOverride: true),
        );
        await tester.pumpAndSettle();

        // 1. Verify LoginPage and Carousel rendered
        expect(find.byType(LoginPage), findsOneWidget);
        expect(find.byType(Carousel), findsOneWidget);

        // 2. Verify all login interactive elements are on screen
        expect(find.text(Strings.entrarTelaLogin), findsOneWidget);
        expect(find.text(Strings.auxAcesseSalvarProgresso), findsOneWidget);
        expect(find.text(Strings.continuarComGoogleTelaLogin), findsOneWidget);
        expect(find.text(Strings.continuarComFacebookTelaLogin), findsOneWidget);
        expect(find.text(Strings.continuarComoVisitanteTelaLogin), findsOneWidget);
        expect(find.text(Strings.termosPoliticaRodapeTelaLogin), findsOneWidget);

        // 3. Verify white card SingleChildScrollView has ZERO scroll extent
        final scrollableFinder = find.descendant(
          of: find.byType(LoginPage),
          matching: find.byType(Scrollable),
        );
        final whiteCardScrollable = scrollableFinder.last;
        final scrollableState = tester.state<ScrollableState>(whiteCardScrollable);

        expect(
          scrollableState.position.maxScrollExtent,
          0.0,
          reason: 'White card should not have scroll on ${entry.key}',
        );

        // 4. Verify no uncaught exceptions
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('Gracefully scrolls on extremely short browser height (< 420px) without overflow',
        (tester) async {
      tester.view.physicalSize = const Size(1280, 400);
      tester.view.devicePixelRatio = 1.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const MyApp(isWebOverride: true),
      );
      await tester.pumpAndSettle();

      final scrollableFinder = find.descendant(
        of: find.byType(LoginPage),
        matching: find.byType(Scrollable),
      );
      final whiteCardScrollable = scrollableFinder.last;
      final scrollableState = tester.state<ScrollableState>(whiteCardScrollable);

      // On extreme short viewport, scrolling is allowed as fallback
      expect(scrollableState.position.maxScrollExtent, greaterThan(0.0));
      expect(tester.takeException(), isNull);
    });

    testWidgets('Mobile viewport preserves mobile proportions without regressions',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.75;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const MyApp(isWebOverride: false),
      );
      await tester.pumpAndSettle();

      expect(find.byType(LoginPage), findsOneWidget);
      expect(find.text(Strings.subtituloHeroLogin), findsOneWidget);
      expect(find.text(Strings.entrarTelaLogin), findsOneWidget);
      expect(find.text(Strings.continuarComGoogleTelaLogin), findsOneWidget);
      expect(find.text(Strings.continuarComFacebookTelaLogin), findsOneWidget);
      expect(find.text(Strings.continuarComoVisitanteTelaLogin), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
    testWidgets('Top carousel and logo maintain prominent proportions on Web (not tiny)',
        (tester) async {
      // 1. Full HD (1920x1080)
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(const MyApp(isWebOverride: true));
      await tester.pumpAndSettle();

      final carouselRenderBox1080 =
          tester.renderObject<RenderBox>(find.byType(Carousel));
      expect(carouselRenderBox1080.size.height, greaterThan(500.0),
          reason: 'Carousel height on 1080p must be prominent (>500px)');

      final logoFinder1080 = find.byWidgetPredicate((widget) =>
          widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName == Strings.logoAsset);
      final logoRenderBox1080 =
          tester.renderObject<RenderBox>(logoFinder1080);
      expect(logoRenderBox1080.size.height, greaterThanOrEqualTo(200.0),
          reason: 'Logo height on 1080p must be prominent (>=200px)');

      // 2. MacBook / 900p (1440x900)
      tester.view.physicalSize = const Size(1440, 900);
      await tester.pumpWidget(const MyApp(isWebOverride: true));
      await tester.pumpAndSettle();

      final carouselRenderBox900 =
          tester.renderObject<RenderBox>(find.byType(Carousel));
      expect(carouselRenderBox900.size.height, greaterThan(380.0),
          reason: 'Carousel height on 900p must be prominent (>380px)');

      final logoFinder900 = find.byWidgetPredicate((widget) =>
          widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName == Strings.logoAsset);
      final logoRenderBox900 = tester.renderObject<RenderBox>(logoFinder900);
      expect(logoRenderBox900.size.height, greaterThanOrEqualTo(170.0),
          reason: 'Logo height on 900p must be prominent (>=170px)');

      // 3. Standard Laptop (1366x768)
      tester.view.physicalSize = const Size(1366, 768);
      await tester.pumpWidget(const MyApp(isWebOverride: true));
      await tester.pumpAndSettle();

      final carouselRenderBox768 =
          tester.renderObject<RenderBox>(find.byType(Carousel));
      expect(carouselRenderBox768.size.height, greaterThan(300.0),
          reason: 'Carousel height on 768p must be prominent (>300px)');

      final logoFinder768 = find.byWidgetPredicate((widget) =>
          widget is Image &&
          widget.image is AssetImage &&
          (widget.image as AssetImage).assetName == Strings.logoAsset);
      final logoRenderBox768 = tester.renderObject<RenderBox>(logoFinder768);
      expect(logoRenderBox768.size.height, greaterThanOrEqualTo(135.0),
          reason: 'Logo height on 768p must be prominent (>=135px)');
    });
  });
}
