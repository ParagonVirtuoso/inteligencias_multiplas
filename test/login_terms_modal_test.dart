import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inteligencias_multiplas/main.dart';
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

  Widget buildTestWidget({
    required bool isWebOverride,
  }) {
    return MyApp(isWebOverride: isWebOverride);
  }

  group('Terms of Use Modal - Web vs Mobile Tests', () {
    testWidgets(
        'Web mode: renders centered Dialog with proper constraints, no drag handle, clean button',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        buildTestWidget(isWebOverride: true),
      );
      await tester.pumpAndSettle();

      // Tap footer terms link
      final termsFinder = find.text(Strings.termosPoliticaRodapeTelaLogin);
      expect(termsFinder, findsOneWidget);
      await tester.tap(termsFinder);
      await tester.pumpAndSettle();

      // 1. Must be rendered as a Dialog, NOT a BottomSheet
      expect(find.byType(Dialog), findsOneWidget);
      expect(find.byType(BottomSheet), findsNothing);

      // 2. NO mobile drag handle bar on web
      expect(find.byKey(const Key('terms_modal_drag_handle')), findsNothing);

      // 3. Dialog has proper rounded corners (all 4 corners rounded)
      final dialogWidget = tester.widget<Dialog>(find.byType(Dialog));
      expect(dialogWidget.shape, isA<RoundedRectangleBorder>());
      final shape = dialogWidget.shape as RoundedRectangleBorder;
      expect(shape.borderRadius, BorderRadius.circular(24.0));

      // 4. Proper constraints: maxWidth ~480-520px (specifically 500.0)
      final dialogBoxFinder = find.descendant(
        of: find.byType(Dialog),
        matching: find.byType(ConstrainedBox),
      );
      bool foundMatchingConstraint = false;
      for (final element in tester.widgetList<ConstrainedBox>(dialogBoxFinder)) {
        if (element.constraints.maxWidth >= 480.0 &&
            element.constraints.maxWidth <= 520.0) {
          foundMatchingConstraint = true;
          break;
        }
      }
      expect(
        foundMatchingConstraint,
        isTrue,
        reason: 'Dialog must contain maxWidth constraint within 480-520px',
      );

      // 5. Title, description and Entendido button are rendered
      expect(find.text(Strings.termosUso), findsOneWidget);
      expect(find.text(Strings.termosDescricao), findsOneWidget);
      expect(find.text(Strings.sobreAppDescricao), findsOneWidget);

      final buttonFinder = find.widgetWithText(ElevatedButton, 'Entendido');
      expect(buttonFinder, findsOneWidget);

      // 6. Entendido button has properly sized height (48.0)
      final buttonSize = tester.getSize(buttonFinder);
      expect(buttonSize.height, 48.0);

      // 7. Dismiss modal by tapping 'Entendido'
      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsNothing);
      expect(find.text(Strings.termosUso), findsNothing);
    });

    testWidgets('Web mode: close icon button dismisses dialog',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        buildTestWidget(isWebOverride: true),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(Strings.termosPoliticaRodapeTelaLogin));
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsOneWidget);

      // Tap close icon button
      final closeBtnFinder = find.descendant(
        of: find.byType(Dialog),
        matching: find.byIcon(Icons.close),
      );
      expect(closeBtnFinder, findsOneWidget);
      await tester.tap(closeBtnFinder);
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsNothing);
    });

    testWidgets(
        'Web mode: short window height (420px) does not overflow and scrolls cleanly',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 420);
      tester.view.devicePixelRatio = 1.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        buildTestWidget(isWebOverride: true),
      );
      await tester.pumpAndSettle();

      final termsFinder = find.text(Strings.termosPoliticaRodapeTelaLogin);
      await tester.ensureVisible(termsFinder);
      await tester.pumpAndSettle();
      await tester.tap(termsFinder);
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsOneWidget);
      expect(find.text(Strings.termosUso), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Entendido is visible and clickable
      final buttonFinder = find.widgetWithText(ElevatedButton, 'Entendido');
      expect(buttonFinder, findsOneWidget);
      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsNothing);
    });

    testWidgets(
        'Mobile mode: preserves native bottom sheet with drag handle and bottom alignment',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.75;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        buildTestWidget(isWebOverride: false),
      );
      await tester.pumpAndSettle();

      // Tap footer terms link
      final termsFinder = find.text(Strings.termosPoliticaRodapeTelaLogin);
      expect(termsFinder, findsOneWidget);
      await tester.tap(termsFinder);
      await tester.pumpAndSettle();

      // 1. Must be rendered as a BottomSheet, NOT a Dialog
      expect(find.byType(BottomSheet), findsOneWidget);
      expect(find.byType(Dialog), findsNothing);

      // 2. Mobile drag handle bar is present
      expect(find.byKey(const Key('terms_modal_drag_handle')), findsOneWidget);

      // 3. Anchored at bottomCenter
      final alignFinder = find.descendant(
        of: find.byType(BottomSheet),
        matching: find.byWidgetPredicate(
          (w) => w is Align && w.alignment == Alignment.bottomCenter,
        ),
      );
      expect(alignFinder, findsWidgets);

      // 4. Texts and button are present
      expect(find.text(Strings.termosUso), findsOneWidget);
      expect(find.text(Strings.termosDescricao), findsOneWidget);
      expect(find.text('Entendido'), findsOneWidget);

      // 5. Dismiss modal by tapping 'Entendido'
      await tester.tap(find.text('Entendido'));
      await tester.pumpAndSettle();
      expect(find.byType(BottomSheet), findsNothing);
      expect(find.text(Strings.termosUso), findsNothing);
    });

    testWidgets(
        'Mobile mode: tablet screen (800x1200) with isWebOverride: false preserves mobile bottom sheet',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        buildTestWidget(isWebOverride: false),
      );
      await tester.pumpAndSettle();

      final termsFinder = find.text(Strings.termosPoliticaRodapeTelaLogin);
      expect(termsFinder, findsOneWidget);
      await tester.ensureVisible(termsFinder);
      await tester.pumpAndSettle();
      await tester.tap(termsFinder);
      await tester.pumpAndSettle();

      expect(find.byType(BottomSheet), findsOneWidget);
      expect(find.byType(Dialog), findsNothing);
    });

    testWidgets('Web mode: clicking backdrop barrier outside dialog dismisses it',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        buildTestWidget(isWebOverride: true),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(Strings.termosPoliticaRodapeTelaLogin));
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsOneWidget);

      // Tap on the backdrop outside the dialog (top-left margin)
      await tester.tapAt(const Offset(40, 40));
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsNothing);
    });

    testWidgets('Web mode: pressing Escape key dismisses dialog',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        buildTestWidget(isWebOverride: true),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text(Strings.termosPoliticaRodapeTelaLogin));
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsOneWidget);

      // Send Escape key
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsNothing);
    });

    testWidgets(
        'Web mode: ultra compact window height (320px) does not overflow and scrolls cleanly',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1024, 320);
      tester.view.devicePixelRatio = 1.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        buildTestWidget(isWebOverride: true),
      );
      await tester.pumpAndSettle();

      final termsFinder = find.text(Strings.termosPoliticaRodapeTelaLogin);
      await tester.ensureVisible(termsFinder);
      await tester.pumpAndSettle();
      await tester.tap(termsFinder);
      await tester.pumpAndSettle();

      expect(find.byType(Dialog), findsOneWidget);
      expect(tester.takeException(), isNull);

      final buttonFinder = find.widgetWithText(ElevatedButton, 'Entendido');
      expect(buttonFinder, findsOneWidget);
      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsNothing);
    });

    testWidgets('Web mode: footer terms link has click cursor',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        buildTestWidget(isWebOverride: true),
      );
      await tester.pumpAndSettle();

      final mouseRegionFinder = find.ancestor(
        of: find.text(Strings.termosPoliticaRodapeTelaLogin),
        matching: find.byType(MouseRegion),
      );
      expect(mouseRegionFinder, findsOneWidget);
      final mouseRegion = tester.widget<MouseRegion>(mouseRegionFinder);
      expect(mouseRegion.cursor, SystemMouseCursors.click);
    });

    testWidgets(
        'Mobile mode: short screen (640x360 landscape) does not overflow bottom sheet',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(640, 360);
      tester.view.devicePixelRatio = 1.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        buildTestWidget(isWebOverride: false),
      );
      await tester.pumpAndSettle();

      final termsFinder = find.text(Strings.termosPoliticaRodapeTelaLogin);
      await tester.ensureVisible(termsFinder);
      await tester.pumpAndSettle();
      await tester.tap(termsFinder);
      await tester.pumpAndSettle();

      expect(find.byType(BottomSheet), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.tap(find.text('Entendido'));
      await tester.pumpAndSettle();
      expect(find.byType(BottomSheet), findsNothing);
    });
  });
}
