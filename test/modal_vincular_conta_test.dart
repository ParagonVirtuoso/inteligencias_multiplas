import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inteligencias_multiplas/controller/homeController/home_controller.dart';
import 'package:inteligencias_multiplas/screens/homePage/componentes/drawer_custom.dart';
import 'package:inteligencias_multiplas/screens/homePage/componentes/modal_vincular_conta.dart';
import 'package:inteligencias_multiplas/utils/strings.dart';

class _FakeHomeController extends HomeController {
  bool googleCalled = false;
  bool facebookCalled = false;

  @override
  Future<bool?> vincularContaGoogle({dynamic auth, dynamic googleSignIn}) async {
    googleCalled = true;
    return true;
  }

  @override
  Future<bool?> vincularContaFacebook({dynamic auth, dynamic facebookAuth}) async {
    facebookCalled = true;
    return true;
  }
}

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
  int get statusCode => 200;

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

  group('ModalVincularConta UI tests', () {
    testWidgets('renders modal with title, subtitle, Google and Facebook buttons',
        (WidgetTester tester) async {
      bool googlePressed = false;
      bool facebookPressed = false;

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(1080, 1920),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: ModalVincularConta(
                onGooglePressed: () async {
                  googlePressed = true;
                },
                onFacebookPressed: () async {
                  facebookPressed = true;
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text(Strings.salvarProgresso), findsOneWidget);
      expect(find.text(Strings.vinculeParaSalvar), findsOneWidget);
      expect(find.text(Strings.continuarComGoogleTelaLogin), findsOneWidget);
      expect(find.text(Strings.continuarComFacebookTelaLogin), findsOneWidget);
      expect(find.text(Strings.agoraNao), findsOneWidget);

      await tester.tap(find.text(Strings.continuarComGoogleTelaLogin));
      await tester.pumpAndSettle();
      expect(googlePressed, isTrue);
      expect(facebookPressed, isFalse);
    });

    testWidgets('tapping Facebook button triggers onFacebookPressed',
        (WidgetTester tester) async {
      bool facebookPressed = false;

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(1080, 1920),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: ModalVincularConta(
                onGooglePressed: () async {},
                onFacebookPressed: () async {
                  facebookPressed = true;
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text(Strings.continuarComFacebookTelaLogin));
      await tester.pumpAndSettle();
      expect(facebookPressed, isTrue);
    });

    testWidgets(
        'ModalVincularConta.show on Web renders centered Dialog without drag handle and with 48dp buttons',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(1080, 1920),
          fontSizeResolver: (fontSize, instance) {
            final factor = (1920 / 1080 * 0.42).clamp(0.36, 0.44);
            return fontSize * factor;
          },
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (ctx) => ElevatedButton(
                  onPressed: () {
                    ModalVincularConta.show(
                      context: ctx,
                      isWebOverride: true,
                      onGooglePressed: () async {},
                      onFacebookPressed: () async {},
                    );
                  },
                  child: const Text(Strings.salvarConta),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(Strings.salvarConta));
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsOneWidget);
      expect(find.byType(BottomSheet), findsNothing);
      expect(find.byKey(const Key('vincular_modal_drag_handle')), findsNothing);
      expect(find.text(Strings.salvarProgresso), findsOneWidget);
      expect(find.text(Strings.continuarComGoogleTelaLogin), findsOneWidget);
      expect(find.text(Strings.continuarComFacebookTelaLogin), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.tap(find.text(Strings.agoraNao));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsNothing);
    });
  });

  group('DrawerCustom visitor options tests', () {
    testWidgets(
        'DrawerCustom shows visitor options and opens modal when user is visitor',
        (WidgetTester tester) async {
      final fakeController = _FakeHomeController();

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
            home: Scaffold(
              drawer: Drawer(
                child: DrawerCustom(
                  profilePic: '',
                  user: 'Visitante',
                  email: '',
                  homeController: fakeController,
                ),
              ),
              body: Builder(
                builder: (scaffoldContext) => ElevatedButton(
                  onPressed: () {
                    Scaffold.of(scaffoldContext).openDrawer();
                  },
                  child: const Text('Abrir Drawer'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Abrir Drawer'));
      await tester.pumpAndSettle();

      // Drawer is open, visitor options should be visible
      expect(find.text(Strings.salvarProgresso), findsOneWidget);
      expect(find.text(Strings.salvarGoogleOuFacebook), findsOneWidget);

      // Tap Salvar progresso card
      await tester.tap(find.text(Strings.salvarProgresso));
      await tester.pumpAndSettle();

      // ModalVincularConta should now be presented
      expect(find.byType(ModalVincularConta), findsOneWidget);
      expect(find.text(Strings.continuarComGoogleTelaLogin), findsOneWidget);
      expect(find.text(Strings.continuarComFacebookTelaLogin), findsOneWidget);

      // Tap Google in modal
      await tester.tap(find.text(Strings.continuarComGoogleTelaLogin));
      await tester.pumpAndSettle();

      expect(fakeController.googleCalled, isTrue);
    });

    testWidgets(
        'DrawerCustom hides visitor login button when user is authenticated with email',
        (WidgetTester tester) async {
      final fakeController = _FakeHomeController();

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
            home: Scaffold(
              drawer: Drawer(
                child: DrawerCustom(
                  profilePic: '',
                  user: 'Denys Fernandes',
                  email: 'denys@gmail.com',
                  homeController: fakeController,
                ),
              ),
              body: Builder(
                builder: (scaffoldContext) => ElevatedButton(
                  onPressed: () {
                    Scaffold.of(scaffoldContext).openDrawer();
                  },
                  child: const Text('Abrir Drawer'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Abrir Drawer'));
      await tester.pumpAndSettle();

      // Should show user email and NOT show visitor login options
      expect(find.text('denys@gmail.com'), findsOneWidget);
      expect(find.text(Strings.progressoSalvoNuvem), findsOneWidget);
      expect(find.text(Strings.salvarGoogleOuFacebook), findsNothing);
    });
  });
}
