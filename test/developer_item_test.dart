import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inteligencias_multiplas/screens/developersPage/componentes/developer_item.dart';
import 'package:inteligencias_multiplas/screens/developersPage/developers_page.dart';
import 'package:inteligencias_multiplas/utils/strings.dart';

class _TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _MockHttpClient();
  }
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
    0x89,
    0x50,
    0x4E,
    0x47,
    0x0D,
    0x0A,
    0x1A,
    0x0A,
    0x00,
    0x00,
    0x00,
    0x0D,
    0x49,
    0x48,
    0x44,
    0x52,
    0x00,
    0x00,
    0x00,
    0x01,
    0x00,
    0x00,
    0x00,
    0x01,
    0x08,
    0x06,
    0x00,
    0x00,
    0x00,
    0x1F,
    0x15,
    0xC4,
    0x89,
    0x00,
    0x00,
    0x00,
    0x0A,
    0x49,
    0x44,
    0x41,
    0x54,
    0x78,
    0x9C,
    0x63,
    0x00,
    0x01,
    0x00,
    0x00,
    0x05,
    0x00,
    0x01,
    0x0D,
    0x0A,
    0x2D,
    0xB4,
    0x00,
    0x00,
    0x00,
    0x00,
    0x49,
    0x45,
    0x4E,
    0x44,
    0xAE,
    0x42,
    0x60,
    0x82,
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

  group('DeveloperItem layout overflow tests', () {
    testWidgets(
        'DeveloperItem renders without RenderFlex overflow on device from error log',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.907;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(1080, 1920),
          builder: (context, child) => const MaterialApp(
            home: Scaffold(
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: DeveloperItem(
                  name: 'Denys Fernandes',
                  email: 'denysfernandes21@gmail.com',
                  githubUrl: 'https://github.com/ParagonVirtuoso',
                  linkedinUrl:
                      'https://www.linkedin.com/in/denys-fernandes-a1916198/',
                  instagramUrl: 'https://www.instagram.com/denysfh/',
                  imageUrl: 'https://example.com/avatar.png',
                  cargo: 'Desenvolvedor',
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Denys Fernandes'), findsOneWidget);
      expect(find.text('denysfernandes21@gmail.com'), findsOneWidget);
      expect(find.text('Desenvolvedor'), findsOneWidget);
    });

    testWidgets(
        'DeveloperItem renders without overflow on small screen (320px width)',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(640, 1136);
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
              body: DeveloperItem(
                name: 'Elias Ribeiro',
                email: 'Elliasribeiro99@gmail.com',
                githubUrl: 'https://github.com/sailleribeiro',
                linkedinUrl:
                    'https://www.linkedin.com/in/elias-ribeiro-b74649174/',
                instagramUrl: 'https://www.instagram.com/elliasribeiro_',
                imageUrl: 'https://example.com/avatar2.png',
                cargo: 'UI / UX Designer',
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Elias Ribeiro'), findsOneWidget);
      expect(find.text('UI / UX Designer'), findsOneWidget);
    });

    testWidgets(
        'DeveloperItem renders without overflow under large accessibility text scale',
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
          builder: (context, child) => MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(1.5)),
            child: const MaterialApp(
              home: Scaffold(
                body: DeveloperItem(
                  name: 'Denys Fernandes',
                  email: 'denysfernandes21@gmail.com',
                  githubUrl: 'https://github.com/ParagonVirtuoso',
                  linkedinUrl:
                      'https://www.linkedin.com/in/denys-fernandes-a1916198/',
                  instagramUrl: 'https://www.instagram.com/denysfh/',
                  imageUrl: 'https://example.com/avatar.png',
                  cargo: 'Desenvolvedor',
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Denys Fernandes'), findsOneWidget);
    });

    testWidgets(
        'DeveloperItem renders safely with empty imageUrl and long texts',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(1080, 1920),
          builder: (context, child) => const MaterialApp(
            home: Scaffold(
              body: DeveloperItem(
                name: 'Denys Fernandes de Souza da Silva Sauro Virtuoso',
                email:
                    'verylongdeveloperemailaddress@domainwithexceptionallength.com',
                githubUrl: 'https://github.com',
                linkedinUrl: 'https://linkedin.com',
                instagramUrl: 'https://instagram.com',
                imageUrl: '',
                cargo: 'Desenvolvedor Full Stack Sênior Mobile & Web Architect',
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets(
        'DevelopersPage renders completely without overflow on small screen',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(640, 1136);
      tester.view.devicePixelRatio = 2.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(1080, 1920),
          builder: (context, child) => const MaterialApp(
            home: DevelopersPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Desenvolvedores'), findsOneWidget);
      expect(find.text('Denys Fernandes'), findsOneWidget);
      expect(find.text('Elias Ribeiro'), findsOneWidget);
    });

    group('DeveloperItem image provider resolution tests', () {
      testWidgets('DeveloperItem resolves imageAsset to AssetImage',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          ScreenUtilInit(
            designSize: const Size(1080, 1920),
            builder: (context, child) => const MaterialApp(
              home: Scaffold(
                body: DeveloperItem(
                  name: 'Denys Fernandes',
                  email: 'denys@example.com',
                  githubUrl: 'https://github.com',
                  linkedinUrl: 'https://linkedin.com',
                  instagramUrl: 'https://instagram.com',
                  imageAsset: Strings.devDenysAsset,
                  cargo: 'Desenvolvedor',
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final containerFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              widget.decoration is BoxDecoration &&
              (widget.decoration as BoxDecoration).image != null,
        );
        expect(containerFinder, findsOneWidget);
        final container = tester.widget<Container>(containerFinder);
        final decoration = container.decoration as BoxDecoration;
        expect(decoration.image?.image, isA<AssetImage>());
        expect((decoration.image?.image as AssetImage).assetName,
            equals(Strings.devDenysAsset));
      });

      testWidgets(
          'DeveloperItem resolves local asset path passed via imageUrl to AssetImage',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          ScreenUtilInit(
            designSize: const Size(1080, 1920),
            builder: (context, child) => const MaterialApp(
              home: Scaffold(
                body: DeveloperItem(
                  name: 'Elias Ribeiro',
                  email: 'elias@example.com',
                  githubUrl: 'https://github.com',
                  linkedinUrl: 'https://linkedin.com',
                  instagramUrl: 'https://instagram.com',
                  imageUrl: Strings.devEliasAsset,
                  cargo: 'UI / UX Designer',
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final containerFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              widget.decoration is BoxDecoration &&
              (widget.decoration as BoxDecoration).image != null,
        );
        expect(containerFinder, findsOneWidget);
        final container = tester.widget<Container>(containerFinder);
        final decoration = container.decoration as BoxDecoration;
        expect(decoration.image?.image, isA<AssetImage>());
        expect((decoration.image?.image as AssetImage).assetName,
            equals(Strings.devEliasAsset));
      });

      testWidgets(
          'DeveloperItem resolves network url passed via imageUrl to NetworkImage',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          ScreenUtilInit(
            designSize: const Size(1080, 1920),
            builder: (context, child) => const MaterialApp(
              home: Scaffold(
                body: DeveloperItem(
                  name: 'Test Dev',
                  email: 'test@example.com',
                  githubUrl: 'https://github.com',
                  linkedinUrl: 'https://linkedin.com',
                  instagramUrl: 'https://instagram.com',
                  imageUrl: 'https://example.com/test.png',
                  cargo: 'Tester',
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final containerFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              widget.decoration is BoxDecoration &&
              (widget.decoration as BoxDecoration).image != null,
        );
        expect(containerFinder, findsOneWidget);
        final container = tester.widget<Container>(containerFinder);
        final decoration = container.decoration as BoxDecoration;
        expect(decoration.image?.image, isA<NetworkImage>());
        expect((decoration.image?.image as NetworkImage).url,
            equals('https://example.com/test.png'));
      });

      testWidgets('dev assets exist in bundle and load bytes correctly',
          (WidgetTester tester) async {
        final dData =
            await tester.runAsync(() => rootBundle.load(Strings.devDenysAsset));
        expect(dData, isNotNull);
        expect(dData!.lengthInBytes, greaterThan(0));
        final eData =
            await tester.runAsync(() => rootBundle.load(Strings.devEliasAsset));
        expect(eData, isNotNull);
        expect(eData!.lengthInBytes, greaterThan(0));

        final ghData = await tester
            .runAsync(() => rootBundle.load(Strings.githubIconAsset));
        expect(ghData, isNotNull);
        final liData = await tester
            .runAsync(() => rootBundle.load(Strings.linkedinIconAsset));
        expect(liData, isNotNull);
        final igData = await tester
            .runAsync(() => rootBundle.load(Strings.instagramIconAsset));
        expect(igData, isNotNull);
      });

      testWidgets(
          'DeveloperItem resolves http url passed via imageAsset to NetworkImage',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          ScreenUtilInit(
            designSize: const Size(1080, 1920),
            builder: (context, child) => const MaterialApp(
              home: Scaffold(
                body: DeveloperItem(
                  name: 'Test Dev',
                  email: 'test@example.com',
                  githubUrl: 'https://github.com',
                  linkedinUrl: 'https://linkedin.com',
                  instagramUrl: 'https://instagram.com',
                  imageAsset: 'https://example.com/network_asset.png',
                  cargo: 'Tester',
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final containerFinder = find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              widget.decoration is BoxDecoration &&
              (widget.decoration as BoxDecoration).image != null,
        );
        expect(containerFinder, findsOneWidget);
        final container = tester.widget<Container>(containerFinder);
        final decoration = container.decoration as BoxDecoration;
        expect(decoration.image?.image, isA<NetworkImage>());
        expect((decoration.image?.image as NetworkImage).url,
            equals('https://example.com/network_asset.png'));
      });

      testWidgets(
          'DeveloperItem displays Icons.person when imageAsset and imageUrl are null or empty',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          ScreenUtilInit(
            designSize: const Size(1080, 1920),
            builder: (context, child) => const MaterialApp(
              home: Scaffold(
                body: DeveloperItem(
                  name: 'No Photo Dev',
                  email: 'nophoto@example.com',
                  githubUrl: 'https://github.com',
                  linkedinUrl: 'https://linkedin.com',
                  instagramUrl: 'https://instagram.com',
                  cargo: 'Tester',
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.person), findsOneWidget);
      });

      testWidgets(
          'DevelopersPage resolves both developer images to AssetImage with correct paths',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          ScreenUtilInit(
            designSize: const Size(1080, 1920),
            builder: (context, child) => const MaterialApp(
              home: DevelopersPage(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final containersWithImages = find.byWidgetPredicate(
          (widget) =>
              widget is Container &&
              widget.decoration is BoxDecoration &&
              (widget.decoration as BoxDecoration).image != null,
        );
        expect(containersWithImages, findsNWidgets(2));

        final widgets = tester
            .widgetList<Container>(containersWithImages)
            .toList();
        final dec1 = widgets[0].decoration as BoxDecoration;
        final dec2 = widgets[1].decoration as BoxDecoration;

        expect(dec1.image?.image, isA<AssetImage>());
        expect((dec1.image?.image as AssetImage).assetName,
            equals(Strings.devDenysAsset));

        expect(dec2.image?.image, isA<AssetImage>());
        expect((dec2.image?.image as AssetImage).assetName,
            equals(Strings.devEliasAsset));
      });
    });

    group('DeveloperItem email lowercase and clipboard tests', () {
      testWidgets(
          'displays email in lowercase even if input has uppercase characters',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          ScreenUtilInit(
            designSize: const Size(1080, 1920),
            builder: (context, child) => const MaterialApp(
              home: Scaffold(
                body: DeveloperItem(
                  name: 'Elias Ribeiro',
                  email: 'ElliasRibeiro99@GMAIL.COM',
                  githubUrl: 'https://github.com',
                  linkedinUrl: 'https://linkedin.com',
                  instagramUrl: 'https://instagram.com',
                  cargo: 'Designer',
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('elliasribeiro99@gmail.com'), findsOneWidget);
        expect(find.text('ElliasRibeiro99@GMAIL.COM'), findsNothing);
      });

      testWidgets(
          'tapping on email copies lowercase email to clipboard and shows SnackBar',
          (WidgetTester tester) async {
        String? clipboardText;
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          (MethodCall methodCall) async {
            if (methodCall.method == 'Clipboard.setData') {
              clipboardText = (methodCall.arguments as Map)['text'];
              return null;
            } else if (methodCall.method == 'Clipboard.getData') {
              return <String, dynamic>{'text': clipboardText};
            }
            return null;
          },
        );

        addTearDown(() {
          tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
            SystemChannels.platform,
            null,
          );
        });

        await tester.pumpWidget(
          ScreenUtilInit(
            designSize: const Size(1080, 1920),
            builder: (context, child) => const MaterialApp(
              home: Scaffold(
                body: DeveloperItem(
                  name: 'Denys Fernandes',
                  email: 'DenysFernandes21@Gmail.Com',
                  githubUrl: 'https://github.com',
                  linkedinUrl: 'https://linkedin.com',
                  instagramUrl: 'https://instagram.com',
                  cargo: 'Desenvolvedor',
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final emailFinder = find.text('denysfernandes21@gmail.com');
        expect(emailFinder, findsOneWidget);

        await tester.tap(emailFinder);
        await tester.pump();

        expect(clipboardText, equals('denysfernandes21@gmail.com'));
        expect(find.text(Strings.emailCopiado), findsOneWidget);
        expect(find.byType(SnackBar), findsOneWidget);
      });
    });
  });
}
