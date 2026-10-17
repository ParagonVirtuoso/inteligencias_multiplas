import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inteligencias_multiplas/controller/homeController/home_controller.dart';
import 'package:inteligencias_multiplas/screens/homePage/componentes/dialog_sair.dart';
import 'package:inteligencias_multiplas/screens/homePage/componentes/drawer_custom.dart';
import 'package:inteligencias_multiplas/utils/cores.dart';
import 'package:inteligencias_multiplas/utils/strings.dart';

class _FakeHomeController extends HomeController {
  bool signOutCalled = false;

  @override
  Future<void> signOut() async {
    signOutCalled = true;
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

  group('DialogSair widget and interaction tests', () {
    testWidgets('renders DialogSair with custom app style and assets',
        (WidgetTester tester) async {
      bool confirmCalled = false;
      bool cancelCalled = false;

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(1080, 1920),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: DialogSair(
                onConfirm: () {
                  confirmCalled = true;
                },
                onCancel: () {
                  cancelCalled = true;
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(DialogSair), findsOneWidget);
      expect(find.text(Strings.sair), findsOneWidget);
      expect(find.text(Strings.desejaSair), findsOneWidget);
      expect(find.text(Strings.sim), findsOneWidget);
      expect(find.text(Strings.nao), findsOneWidget);

      final imageFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName == Strings.sairAppIconAsset,
      );
      expect(imageFinder, findsOneWidget);

      await tester.tap(find.text(Strings.nao));
      await tester.pump();
      expect(cancelCalled, isTrue);

      await tester.tap(find.text(Strings.sim));
      await tester.pump();
      expect(confirmCalled, isTrue);
    });

    testWidgets('DrawerCustom opens DialogSair on tapping Sair button and handles confirm',
        (WidgetTester tester) async {
      final fakeHomeController = _FakeHomeController();

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
            initialRoute: '/home',
            routes: {
              '/home': (context) => Scaffold(
                    drawer: Drawer(
                      child: DrawerCustom(
                        profilePic: 'https://example.com/user.png',
                        user: 'Usuario Teste',
                        email: 'user@teste.com',
                        homeController: fakeHomeController,
                      ),
                    ),
                    body: Builder(
                      builder: (scaffoldContext) => ElevatedButton(
                        onPressed: () {
                          Scaffold.of(scaffoldContext).openDrawer();
                        },
                        child: const Text('Open'),
                      ),
                    ),
                  ),
              '/': (context) => const Scaffold(body: Text('Login Screen')),
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Open drawer
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Tap Sair in Drawer
      final drawerSairFinder = find.text(Strings.sair);
      expect(drawerSairFinder, findsOneWidget);
      await tester.ensureVisible(drawerSairFinder);
      await tester.pumpAndSettle();

      await tester.tap(drawerSairFinder);
      await tester.pumpAndSettle();

      // DialogSair is now visible
      expect(find.byType(DialogSair), findsOneWidget);
      expect(find.text(Strings.sairConta), findsOneWidget);
      expect(find.text(Strings.desejaSairConta), findsOneWidget);

      // Tap Sair inside DialogSair
      final dialogConfirmFinder = find.descendant(
        of: find.byType(DialogSair),
        matching: find.text(Strings.confirmarSairConta),
      );
      expect(dialogConfirmFinder, findsOneWidget);
      await tester.tap(dialogConfirmFinder);
      await tester.pumpAndSettle();

      // Signs out and navigates to login screen ('/')
      expect(fakeHomeController.signOutCalled, isTrue);
      expect(find.text('Login Screen'), findsOneWidget);
    });

    testWidgets('DialogSair dismisses on tapping Cancelar inside DrawerCustom',
        (WidgetTester tester) async {
      final fakeHomeController = _FakeHomeController();

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
                  profilePic: 'https://example.com/user.png',
                  user: 'Usuario Teste',
                  email: 'user@teste.com',
                  homeController: fakeHomeController,
                ),
              ),
              body: Builder(
                builder: (scaffoldContext) => ElevatedButton(
                  onPressed: () {
                    Scaffold.of(scaffoldContext).openDrawer();
                  },
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Open drawer
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Tap Sair in Drawer
      final drawerSairFinder = find.text(Strings.sair);
      await tester.ensureVisible(drawerSairFinder);
      await tester.pumpAndSettle();

      await tester.tap(drawerSairFinder);
      await tester.pumpAndSettle();

      expect(find.byType(DialogSair), findsOneWidget);

      // Tap Cancelar
      await tester.tap(find.text(Strings.cancelar));
      await tester.pumpAndSettle();

      // Dialog is dismissed, sign out is not called
      expect(find.byType(DialogSair), findsNothing);
      expect(fakeHomeController.signOutCalled, isFalse);
    });

    testWidgets('DialogSair.teste renders warning icon and test-specific texts',
        (WidgetTester tester) async {
      bool confirmCalled = false;
      bool cancelCalled = false;

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(1080, 1920),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: DialogSair.teste(
                onConfirm: () => confirmCalled = true,
                onCancel: () => cancelCalled = true,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DialogSair), findsOneWidget);
      expect(find.text(Strings.sairDoTeste), findsOneWidget);
      expect(find.text(Strings.desejaSairDoTeste), findsOneWidget);
      expect(find.text(Strings.continuarTeste), findsOneWidget);
      expect(find.text(Strings.confirmarSairDoTeste), findsOneWidget);
      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);

      // Verify inverted colors: "Continuar teste" is primary highlighted, "Sair do teste" is secondary
      final continuarButtonFinder = find.ancestor(
        of: find.text(Strings.continuarTeste),
        matching: find.byType(ElevatedButton),
      );
      final sairButtonFinder = find.ancestor(
        of: find.text(Strings.confirmarSairDoTeste),
        matching: find.byType(ElevatedButton),
      );

      final ElevatedButton continuarButton = tester.widget(continuarButtonFinder);
      final ElevatedButton sairButton = tester.widget(sairButtonFinder);

      expect(continuarButton.style?.backgroundColor?.resolve({}), equals(Cores.kAzulBotaoItemColor));
      expect(sairButton.style?.backgroundColor?.resolve({}), equals(Cores.kWhiteColor));

      final Text continuarText = tester.widget(find.text(Strings.continuarTeste));
      final Text sairText = tester.widget(find.text(Strings.confirmarSairDoTeste));
      expect(continuarText.style?.color, equals(Cores.kWhiteColor));
      expect(sairText.style?.color, equals(Cores.kDeepGreyColor));

      await tester.tap(find.text(Strings.continuarTeste));
      await tester.pump();
      expect(cancelCalled, isTrue);

      await tester.tap(find.text(Strings.confirmarSairDoTeste));
      await tester.pump();
      expect(confirmCalled, isTrue);
    });

    testWidgets('DialogSair.conta renders account logout elements and actions',
        (WidgetTester tester) async {
      bool confirmCalled = false;
      bool cancelCalled = false;

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(1080, 1920),
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: DialogSair.conta(
                onConfirm: () => confirmCalled = true,
                onCancel: () => cancelCalled = true,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DialogSair), findsOneWidget);
      expect(find.text(Strings.sairConta), findsOneWidget);
      expect(find.text(Strings.desejaSairConta), findsOneWidget);
      expect(find.text(Strings.cancelar), findsOneWidget);
      expect(find.text(Strings.confirmarSairConta), findsOneWidget);

      final imageFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            (widget.image as AssetImage).assetName == Strings.sairAppIconAsset,
      );
      expect(imageFinder, findsOneWidget);

      await tester.tap(find.text(Strings.cancelar));
      await tester.pump();
      expect(cancelCalled, isTrue);

      await tester.tap(find.text(Strings.confirmarSairConta));
      await tester.pump();
      expect(confirmCalled, isTrue);
    });

    testWidgets('DrawerCustom displays dynamic app version',
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
          builder: (context, child) => const MaterialApp(
            home: Scaffold(
              drawer: Drawer(
                child: DrawerCustom(
                  profilePic: '',
                  user: 'Visitante',
                  email: '',
                  appVersion: '4.7.2',
                ),
              ),
              body: Center(child: Text('Body')),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      final scaffoldState = tester.state<ScaffoldState>(find.byType(Scaffold));
      scaffoldState.openDrawer();
      await tester.pumpAndSettle();

      expect(find.text('Versão 4.7.2'), findsOneWidget);
    });

    testWidgets(
        'DialogSair maintains single-line buttons and comfortable width on ultrawide web (2560x1440) without vertical letter wrapping',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(2560, 1440);
      tester.view.devicePixelRatio = 1.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(1080, 1920),
          fontSizeResolver: (fontSize, instance) {
            final factor = (2560 / 1080 * 0.42).clamp(0.36, 0.44);
            return fontSize * factor;
          },
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: Center(
                child: DialogSair(
                  onConfirm: () {},
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(DialogSair), findsOneWidget);

      // Verify buttons are rendered
      final naoFinder = find.text(Strings.nao);
      final simFinder = find.text(Strings.sim);
      expect(naoFinder, findsOneWidget);
      expect(simFinder, findsOneWidget);

      // Verify button widths are generous and not squished into vertical letters
      final naoButtonFinder = find.ancestor(
        of: naoFinder,
        matching: find.byType(ElevatedButton),
      );
      final simButtonFinder = find.ancestor(
        of: simFinder,
        matching: find.byType(ElevatedButton),
      );

      final naoBox = tester.renderObject<RenderBox>(naoButtonFinder);
      final simBox = tester.renderObject<RenderBox>(simButtonFinder);

      expect(naoBox.size.width, greaterThanOrEqualTo(100.0));
      expect(simBox.size.width, greaterThanOrEqualTo(100.0));

      // Verify text widget in button has softWrap false and maxLines 1
      final naoTextWidget = tester.widget<Text>(naoFinder);
      expect(naoTextWidget.softWrap, isFalse);
      expect(naoTextWidget.maxLines, 1);
    });
  });
}
