import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:inteligencias_multiplas/controller/homeController/home_controller.dart';
import 'package:inteligencias_multiplas/screens/homePage/componentes/drawer_custom.dart';
import 'package:inteligencias_multiplas/utils/strings.dart';

class _FakeInAppReview implements InAppReview {
  bool openStoreListingCalled = false;
  bool requestReviewCalled = false;
  bool isAvailableResult = true;
  bool openStoreListingShouldThrow = false;
  bool requestReviewShouldThrow = false;
  String? lastAppStoreId;

  @override
  Future<bool> isAvailable() async => isAvailableResult;

  @override
  Future<void> requestReview() async {
    requestReviewCalled = true;
    if (requestReviewShouldThrow) {
      throw Exception('requestReview error');
    }
  }

  @override
  Future<void> openStoreListing({
    String? appStoreId,
    String? microsoftStoreId,
  }) async {
    openStoreListingCalled = true;
    lastAppStoreId = appStoreId;
    if (openStoreListingShouldThrow) {
      throw Exception('openStoreListing error');
    }
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

  group('HomeController.avaliarApp logic tests', () {
    test('calls openStoreListing as primary action when invoked', () async {
      final fakeReview = _FakeInAppReview();
      final controller = HomeController();

      await controller.avaliarApp(inAppReview: fakeReview);

      expect(fakeReview.openStoreListingCalled, isTrue);
      expect(fakeReview.requestReviewCalled, isFalse);
    });

    test('falls back to requestReview when openStoreListing throws and review is available',
        () async {
      final fakeReview = _FakeInAppReview()
        ..openStoreListingShouldThrow = true
        ..isAvailableResult = true;
      final controller = HomeController();

      await controller.avaliarApp(inAppReview: fakeReview);

      expect(fakeReview.openStoreListingCalled, isTrue);
      expect(fakeReview.requestReviewCalled, isTrue);
    });

    test('does not throw when both openStoreListing and requestReview fail', () async {
      final fakeReview = _FakeInAppReview()
        ..openStoreListingShouldThrow = true
        ..requestReviewShouldThrow = true
        ..isAvailableResult = true;
      final controller = HomeController();

      // Must complete normally without throwing
      await expectLater(
        controller.avaliarApp(inAppReview: fakeReview),
        completes,
      );
    });

    test('forwards appStoreId to openStoreListing when provided', () async {
      final fakeReview = _FakeInAppReview();
      final controller = HomeController();

      await controller.avaliarApp(
        inAppReview: fakeReview,
        appStoreId: '123456789',
      );

      expect(fakeReview.openStoreListingCalled, isTrue);
      expect(fakeReview.lastAppStoreId, '123456789');
    });
  });

  group('DrawerCustom review button UI tests', () {
    testWidgets('renders "Avaliar o aplicativo" button inside DrawerCustom',
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
              body: DrawerCustom(
                profilePic: 'https://example.com/user.png',
                user: 'Usuario Teste',
                email: 'usuario@teste.com',
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text(Strings.avaliarApp), findsOneWidget);
    });

    testWidgets('tapping "Avaliar o aplicativo" invokes openStoreListing',
        (WidgetTester tester) async {
      final fakeReview = _FakeInAppReview();

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
              body: DrawerCustom(
                profilePic: 'https://example.com/user.png',
                user: 'Usuario Teste',
                email: 'usuario@teste.com',
                inAppReview: fakeReview,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final buttonFinder = find.text(Strings.avaliarApp);
      expect(buttonFinder, findsOneWidget);

      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();

      expect(fakeReview.openStoreListingCalled, isTrue);
    });

    testWidgets('DrawerCustom scrolls without overflow on small screens',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(640, 960);
      tester.view.devicePixelRatio = 2.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(1080, 1920),
          builder: (context, child) => const MaterialApp(
            home: Scaffold(
              body: DrawerCustom(
                profilePic: 'https://example.com/user.png',
                user: 'Usuario Teste',
                email: 'usuario@teste.com',
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text(Strings.avaliarApp), findsOneWidget);
    });
  });
}
