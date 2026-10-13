import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
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

  group('LoginPage updated wireframe UI tests', () {
    testWidgets('renders all updated login elements matching wireframe',
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
            initialRoute: '/',
            routes: {
              '/': (context) => const LoginPage(),
              '/home': (context) => const Scaffold(body: Text('Home Screen')),
              '/terms': (context) => const Scaffold(body: Text('Terms Screen')),
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Top carousel hero subtitle
      expect(find.text(Strings.subtituloHeroLogin), findsOneWidget);

      // Card title and auxiliary text
      expect(find.text(Strings.entrarTelaLogin), findsOneWidget);
      expect(find.text(Strings.auxAcesseSalvarProgresso), findsOneWidget);

      // Buttons with new text
      expect(find.text(Strings.continuarComGoogleTelaLogin), findsOneWidget);
      expect(find.text(Strings.continuarComFacebookTelaLogin), findsOneWidget);

      // "Ou" divider is removed
      expect(find.text(Strings.ouTelaLogin), findsNothing);

      // Visitor action
      expect(find.text(Strings.continuarComoVisitanteTelaLogin), findsOneWidget);

      // Footer terms
      expect(find.text(Strings.termosPoliticaRodapeTelaLogin), findsOneWidget);

      // Verify Google button has icon and text centered together
      final googleFinder = find.text(Strings.continuarComGoogleTelaLogin);
      expect(googleFinder, findsOneWidget);

      // Verify tapping terms opens modal bottom sheet
      await tester.tap(find.text(Strings.termosPoliticaRodapeTelaLogin));
      await tester.pumpAndSettle();
      expect(find.text(Strings.termosUso), findsOneWidget);
      expect(find.text(Strings.termosDescricao), findsOneWidget);
      expect(find.text('Entendido'), findsOneWidget);

      // Dismiss modal by tapping 'Entendido'
      await tester.tap(find.text('Entendido'));
      await tester.pumpAndSettle();
      expect(find.text(Strings.termosDescricao), findsNothing);
      expect(find.text(Strings.entrarTelaLogin), findsOneWidget);
    });

    testWidgets('tapping visitor action navigates to home without blocking',
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
            initialRoute: '/',
            routes: {
              '/': (context) => const LoginPage(),
              '/home': (context) => const Scaffold(body: Text('Home Screen')),
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      final visitorFinder =
          find.text(Strings.continuarComoVisitanteTelaLogin);
      expect(visitorFinder, findsOneWidget);

      await tester.tap(visitorFinder);
      await tester.pumpAndSettle();

      expect(find.text('Home Screen'), findsOneWidget);
    });
  });
}
