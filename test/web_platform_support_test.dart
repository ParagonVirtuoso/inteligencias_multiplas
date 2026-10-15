import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inteligencias_multiplas/controller/resultController/result_controller.dart';
import 'package:inteligencias_multiplas/firebase_options.dart';
import 'package:inteligencias_multiplas/main.dart';
import 'package:inteligencias_multiplas/screens/aboutPage/about_page.dart';
import 'package:inteligencias_multiplas/screens/developersPage/developers_page.dart';
import 'package:inteligencias_multiplas/screens/finishTestPage/finish_test_page.dart';
import 'package:inteligencias_multiplas/screens/homePage/componentes/dialog_sair.dart';
import 'package:inteligencias_multiplas/screens/homePage/componentes/drawer_custom.dart';
import 'package:inteligencias_multiplas/screens/homePage/home_page.dart';
import 'package:inteligencias_multiplas/screens/loginPage/login_page.dart';
import 'package:inteligencias_multiplas/screens/questionsPage/componentes/numeric_chips.dart';
import 'package:inteligencias_multiplas/screens/questionsPage/componentes/smart_swap_modal.dart';
import 'package:inteligencias_multiplas/screens/questionsPage/question_page.dart';
import 'package:inteligencias_multiplas/screens/resultPage/result_page.dart';
import 'package:inteligencias_multiplas/screens/termsPage/terms_page.dart';
import 'package:inteligencias_multiplas/utils/strings.dart';
import 'package:share_plus/share_plus.dart';

class _FakeSharePlus implements SharePlus {
  ShareParams? lastParams;

  @override
  Future<ShareResult> share(ShareParams params) async {
    lastParams = params;
    return const ShareResult('', ShareResultStatus.success);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
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

  group('Web Platform Support & PDF Sharing Tests', () {
    testWidgets('ResultController.compartilharResultadoPdf passes XFile with fileNameOverrides to sharePlatform',
        (WidgetTester tester) async {
      final fakeShare = _FakeSharePlus();
      final controller = ResultController();

      late BuildContext capturedContext;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                capturedContext = context;
                return const SizedBox(width: 100, height: 100);
              },
            ),
          ),
        ),
      );

      final sortedEntries = [
        const MapEntry('Musical', 46),
        const MapEntry('Logico', 44),
        const MapEntry('Linguistica', 42),
        const MapEntry('Intrapessoal', 40),
        const MapEntry('Interpessoal', 38),
        const MapEntry('Espacial', 36),
        const MapEntry('Cinestesica', 34),
        const MapEntry('Naturalista', 32),
        const MapEntry('Existencial', 30),
      ];

      final infoMap = {
        for (final entry in sortedEntries)
          entry.key: {
            'descricao': 'Descrição da inteligência ${entry.key}',
            'habilidades': 'Habilidades da inteligência ${entry.key}',
          }
      };

      await controller.compartilharResultadoPdf(
        context: capturedContext,
        itensOrdenados: sortedEntries,
        infoInteligencias: infoMap,
        nomeUsuario: 'Teste Web',
        emailUsuario: 'teste@web.com',
        sharePlus: fakeShare,
      );

      expect(fakeShare.lastParams, isNotNull);
      final params = fakeShare.lastParams!;
      expect(params.files, isNotNull);
      expect(params.files!.length, 1);
      expect(params.files!.first.mimeType, 'application/pdf');
      expect(params.fileNameOverrides, ['resultado_inteligencias_multiplas.pdf']);
      expect(params.subject, Strings.pdfShareSubject);
      expect(params.text, Strings.pdfShareText);
    });

    test('DefaultFirebaseOptions provides valid web configuration and platform resolution', () {
      expect(DefaultFirebaseOptions.web.projectId, isNotEmpty);
      expect(DefaultFirebaseOptions.web.messagingSenderId, isNotEmpty);
      expect(DefaultFirebaseOptions.web.apiKey, isNotEmpty);
      expect(DefaultFirebaseOptions.web.appId, isNotEmpty);
      expect(DefaultFirebaseOptions.currentPlatform, isNotNull);
      expect(DefaultFirebaseOptions.facebookAppId, isNotEmpty);
    });

    testWidgets(
        'MyApp with isWebOverride: true on desktop width fills 100% screen width without sidebars or font explosion',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const MyApp(isWebOverride: true),
      );
      await tester.pump();

      // Verify no outer ColoredBox sidebar exists
      final sidebarFinder = find.byWidgetPredicate(
        (w) => w is ColoredBox && w.color == const Color(0xFFF8FAFC),
      );
      expect(sidebarFinder, findsNothing);

      // Verify no outer Container capping the app width exists
      final outerCappedContainerFinder = find.byWidgetPredicate(
        (w) =>
            w is Container &&
            w.constraints?.maxWidth == MyApp.kMaxWebWidth &&
            w.decoration is BoxDecoration,
      );
      expect(outerCappedContainerFinder, findsNothing);

      // Verify MediaQuery inside MaterialApp sees 100% full width (1920)
      final buildContext = tester.element(find.byType(Navigator));
      final mq = MediaQuery.of(buildContext);
      expect(mq.size.width, 1920.0);

      // Verify font sizes do not explode on desktop width
      final scaledFontSize = ScreenUtil().setSp(70);
      expect(scaledFontSize, lessThanOrEqualTo(35.0));
      expect(scaledFontSize, greaterThanOrEqualTo(25.0));
    });

    testWidgets(
        'MyApp with isWebOverride: true on tablet width (800px) is fluid up to 100% available width',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 1000);
      tester.view.devicePixelRatio = 1.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const MyApp(isWebOverride: true),
      );
      await tester.pump();

      // Verify MediaQuery inside MaterialApp sees 100% full width (800)
      final buildContext = tester.element(find.byType(Navigator));
      final mq = MediaQuery.of(buildContext);
      expect(mq.size.width, 800.0);
    });

    testWidgets(
        'MyApp with isWebOverride: true on mobile web width (360px) works without font explosion or error',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const MyApp(isWebOverride: true),
      );
      await tester.pump();

      final buildContext = tester.element(find.byType(Navigator));
      final mq = MediaQuery.of(buildContext);
      expect(mq.size.width, 360.0);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'MyApp with isWebOverride: false uses normal mobile responsive layout',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.75;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const MyApp(isWebOverride: false),
      );
      await tester.pump();

      final buildContext = tester.element(find.byType(Navigator));
      final mq = MediaQuery.of(buildContext);
      // Mobile logical width is 1080 / 2.75 ~= 392.7
      expect(mq.size.width, closeTo(392.7, 1.0));
    });

    testWidgets(
        'Desktop web layout renders all screens (Login, Home, Questions, Finish, Result, About, Devs, Terms) full-width without error',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      Widget buildWebScreen(Widget screen, {Object? routeArguments}) {
        return ScreenUtilInit(
          designSize: const Size(1080, 1920),
          fontSizeResolver: (fontSize, instance) {
            final factor = (1920 / 1080 * 0.42).clamp(0.36, 0.44);
            return fontSize * factor;
          },
          builder: (context, child) => MaterialApp(
            key: ValueKey(screen.runtimeType),
            onGenerateRoute: (settings) => MaterialPageRoute(
              settings: RouteSettings(name: '/', arguments: routeArguments),
              builder: (_) => screen,
            ),
          ),
        );
      }

      // 1. Verify LoginPage on desktop web (full width)
      await tester.pumpWidget(buildWebScreen(const LoginPage()));
      await tester.pumpAndSettle();
      expect(find.byType(LoginPage), findsOneWidget);
      expect(find.text(Strings.continuarComGoogleTelaLogin), findsOneWidget);
      expect(find.text(Strings.continuarComFacebookTelaLogin), findsOneWidget);
      expect(find.text(Strings.continuarComoVisitanteTelaLogin), findsOneWidget);

      final dotFinders = find.byWidgetPredicate(
        (w) =>
            w is Container &&
            w.decoration is BoxDecoration &&
            (w.decoration as BoxDecoration).shape == BoxShape.circle,
      );
      for (final element in dotFinders.evaluate()) {
        final container = element.widget as Container;
        if (container.constraints?.hasTightWidth ?? false) {
          expect(container.constraints!.maxWidth, lessThanOrEqualTo(14.0));
        }
      }
      expect(tester.takeException(), isNull);

      // 2. Verify HomePage on desktop web (full width)
      await tester.pumpWidget(buildWebScreen(const HomePage()));
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
      expect(tester.takeException(), isNull);

      // 3. Verify QuestionsPage on desktop web (full width)
      await tester.pumpWidget(buildWebScreen(const QuestionsPage()));
      await tester.pumpAndSettle();
      expect(find.byType(QuestionsPage), findsOneWidget);
      expect(find.byKey(const Key('unified_question_statement')), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(NumericChips),
          matching: find.byType(SingleChildScrollView),
        ),
        findsNothing,
      );
      for (int i = 1; i <= 9; i++) {
        final chipBox = tester.renderObject<RenderBox>(find.byKey(Key('numeric_chip_$i')));
        expect(chipBox.size.height, greaterThanOrEqualTo(48.0));
      }
      expect(tester.takeException(), isNull);

      // 4. Verify FinishTest on desktop web (full width)
      await tester.pumpWidget(
        buildWebScreen(
          const FinishTest(),
          routeArguments: List.generate(10, (_) => List.filled(9, 3)),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(FinishTest), findsOneWidget);
      expect(tester.takeException(), isNull);

      // 5. Verify ResultPage on desktop web (full width)
      await tester.pumpWidget(
        buildWebScreen(
          const ResultPage(),
          routeArguments: {
            'total': {
              'Linguistica': 25,
              'Logico': 30,
              'Musical': 18,
            },
          },
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ResultPage), findsOneWidget);
      expect(tester.takeException(), isNull);

      // 6. Verify AboutPage on desktop web (full width)
      await tester.pumpWidget(buildWebScreen(const AboutPage()));
      await tester.pumpAndSettle();
      expect(find.byType(AboutPage), findsOneWidget);
      expect(tester.takeException(), isNull);

      // 7. Verify DevelopersPage on desktop web (full width)
      await tester.pumpWidget(buildWebScreen(const DevelopersPage()));
      await tester.pumpAndSettle();
      expect(find.byType(DevelopersPage), findsOneWidget);
      expect(tester.takeException(), isNull);

      // 8. Verify TermsPage on desktop web (full width)
      await tester.pumpWidget(buildWebScreen(const TermsPage()));
      await tester.pumpAndSettle();
      expect(find.byType(TermsPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'HomePage drawer opens cleanly on desktop web without overflow',
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
          builder: (context, child) => const MaterialApp(
            home: HomePage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Open drawer using the leading menu icon
      final scaffoldState = tester.state<ScaffoldState>(find.byType(Scaffold));
      scaffoldState.openDrawer();
      await tester.pumpAndSettle();

      expect(find.byType(Drawer), findsOneWidget);
      expect(find.byType(DrawerCustom), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'DialogSair and SmartSwapModal render with constrained maxWidth on desktop web',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      Widget buildDesktopModal(Widget modalWidget) {
        return ScreenUtilInit(
          designSize: const Size(1080, 1920),
          fontSizeResolver: (fontSize, instance) {
            final factor = (1920 / 1080 * 0.42).clamp(0.36, 0.44);
            return fontSize * factor;
          },
          builder: (context, child) => MaterialApp(
            home: Scaffold(
              body: Center(
                child: modalWidget,
              ),
            ),
          ),
        );
      }

      // Verify DialogSair maxWidth is 440
      await tester.pumpWidget(
        buildDesktopModal(
          DialogSair(
            onConfirm: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DialogSair), findsOneWidget);
      final dialogConstrainedBox = find.byWidgetPredicate(
        (w) => w is ConstrainedBox && w.constraints.maxWidth == 440,
      );
      expect(dialogConstrainedBox, findsOneWidget);
      expect(tester.takeException(), isNull);

      // Verify SmartSwapModal maxWidth is 640
      await tester.pumpWidget(
        buildDesktopModal(
          SmartSwapModal(
            targetValue: 7,
            currentQuestionIndex: 0,
            currentQuestionText: 'Pergunta atual para teste',
            currentAnswer: 4,
            otherQuestionIndex: 2,
            otherQuestionText: 'Outra pergunta para teste de troca',
            onConfirm: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SmartSwapModal), findsOneWidget);
      final swapConstrainedBox = find.byWidgetPredicate(
        (w) => w is Container && w.constraints?.maxWidth == 640,
      );
      expect(swapConstrainedBox, findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'MyApp with dynamic window resize transitions smoothly between desktop, tablet, and mobile',
        (WidgetTester tester) async {
      // 1. Start at desktop width (1920px)
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const MyApp(isWebOverride: true),
      );
      await tester.pump();

      final buildContext1 = tester.element(find.byType(Navigator));
      expect(MediaQuery.of(buildContext1).size.width, 1920.0);

      // 2. Resize to tablet width (768px)
      tester.view.physicalSize = const Size(768, 1024);
      await tester.pump();

      final buildContext2 = tester.element(find.byType(Navigator));
      expect(MediaQuery.of(buildContext2).size.width, 768.0);

      // 3. Resize to mobile width (400px)
      tester.view.physicalSize = const Size(400, 800);
      await tester.pump();

      final buildContext3 = tester.element(find.byType(Navigator));
      expect(MediaQuery.of(buildContext3).size.width, 400.0);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'QuestionsPage on mobile web (360px) fits all 9 numeric chips in single line without scroll and with >=48dp vertical touch target',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(1080, 1920),
          fontSizeResolver: (fontSize, instance) => fontSize * (360 / 1080),
          builder: (context, child) => const MaterialApp(
            home: QuestionsPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(QuestionsPage), findsOneWidget);
      expect(find.byKey(const Key('unified_question_statement')), findsOneWidget);

      // Verify no horizontal scroll view inside NumericChips
      expect(
        find.descendant(
          of: find.byType(NumericChips),
          matching: find.byType(SingleChildScrollView),
        ),
        findsNothing,
      );

      // Verify all 9 chips exist and have >=48dp vertical touch target
      for (int i = 1; i <= 9; i++) {
        final chipFinder = find.byKey(Key('numeric_chip_$i'));
        expect(chipFinder, findsOneWidget);
        final chipBox = tester.renderObject<RenderBox>(chipFinder);
        expect(chipBox.size.height, greaterThanOrEqualTo(48.0));
        expect(chipBox.size.width, greaterThanOrEqualTo(30.0));
      }

      expect(tester.takeException(), isNull);
    });
  });
}

