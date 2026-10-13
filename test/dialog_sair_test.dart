import 'dart:async';
import 'dart:io';

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
      final sairButtonFinder = find.widgetWithText(ElevatedButton, Strings.sair);
      // Wait: in drawer it's ButtonDrawer with text Strings.sair
      final drawerSairFinder = find.text(Strings.sair);
      expect(drawerSairFinder, findsOneWidget);

      await tester.tap(drawerSairFinder);
      await tester.pumpAndSettle();

      // DialogSair is now visible
      expect(find.byType(DialogSair), findsOneWidget);
      expect(find.text(Strings.desejaSair), findsOneWidget);

      // Tap Sim
      await tester.tap(find.text(Strings.sim));
      await tester.pumpAndSettle();

      // Signs out and navigates to login screen ('/')
      expect(fakeHomeController.signOutCalled, isTrue);
      expect(find.text('Login Screen'), findsOneWidget);
    });

    testWidgets('DialogSair dismisses on tapping Nao inside DrawerCustom',
        (WidgetTester tester) async {
      final fakeHomeController = _FakeHomeController();

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
      await tester.tap(find.text(Strings.sair));
      await tester.pumpAndSettle();

      expect(find.byType(DialogSair), findsOneWidget);

      // Tap Nao
      await tester.tap(find.text(Strings.nao));
      await tester.pumpAndSettle();

      // Dialog is dismissed, sign out is not called
      expect(find.byType(DialogSair), findsNothing);
      expect(fakeHomeController.signOutCalled, isFalse);
    });
  });
}
