import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inteligencias_multiplas/controller/resultController/result_controller.dart';
import 'package:inteligencias_multiplas/screens/resultPage/result_page.dart';
import 'package:inteligencias_multiplas/utils/strings.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  final mockResults = {
    'Linguistica': 25,
    'Logico': 35,
    'Musical': 15,
    'Cinestesica': 42,
    'Interpessoal': 30,
    'Intrapessoal': 28,
    'Espacial': 20,
  };

  testWidgets('ResultPage renders without RenderFlex overflow on narrow screen',
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
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => const ResultPage(),
              settings: RouteSettings(name: '/result', arguments: mockResults),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);

    expect(find.text('42 Pontos'), findsOneWidget);
    expect(find.text('35 Pontos'), findsOneWidget);
  });

  testWidgets(
      'ResultPage renders without RenderFlex overflow on very small screen (320px)',
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
        builder: (context, child) => MaterialApp(
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => const ResultPage(),
              settings: RouteSettings(name: '/result', arguments: mockResults),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('42 Pontos'), findsOneWidget);
  });

  testWidgets('ResultPage handles null or empty arguments gracefully',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(1080, 1920),
        builder: (context, child) => const MaterialApp(
          home: ResultPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('ResultPage renders share action button in AppBar',
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
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => const ResultPage(),
              settings: RouteSettings(name: '/result', arguments: mockResults),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.share), findsOneWidget);
    expect(find.byTooltip(Strings.compartilharResultadoPdf), findsOneWidget);
  });

  test('ResultController.gerarRelatorioPdf generates valid PDF bytes with 7 items', () async {
    final controller = ResultController();
    final sortedEntries = [
      const MapEntry('Musical', 46),
      const MapEntry('Logico', 44),
      const MapEntry('Linguistica', 42),
      const MapEntry('Intrapessoal', 40),
      const MapEntry('Interpessoal', 38),
      const MapEntry('Espacial', 36),
      const MapEntry('Cinestesica', 34),
    ];

    final infoMap = {
      'Musical': {
        'key': 'Musical',
        'descricao': 'A inteligência musical está relacionada com a capacidade de compreender, criar e reproduzir sons, ritmos e melodias.\nMúsicos, compositores, cantores e maestros são exemplos de profissionais que possuem alta inteligência musical.',
      },
      'Logico': {
        'key': 'Lógico',
        'descricao': 'A inteligência lógico-matemática é a capacidade de resolver problemas matemáticos e lógicos, além de identificar padrões e relações entre objetos e ideias.\nEngenheiros, matemáticos, cientistas e programadores são exemplos de profissionais que possuem alta inteligência lógico-matemática.',
      },
      'Linguistica': {
        'key': 'Linguística',
        'descricao': 'A inteligência linguística está relacionada com a capacidade de se comunicar, aprender novas línguas e utilizar a linguagem de forma excepcional, seja na forma escrita ou oral.\nEscritores, jornalistas, linguistas, além de pessoas que têm facilidade para falar idiomas diferentes – os poliglotas – apresentam altos níveis de inteligência linguística.',
      },
      'Intrapessoal': {
        'key': 'Intrapessoal',
        'descricao': 'A inteligência intrapessoal está relacionada com a capacidade de compreender e se relacionar consigo mesmo, além de perceber e interpretar emoções e sentimentos.\nFilósofos, psicólogos, terapeutas e líderes espirituais são exemplos de profissionais que possuem alta inteligência intrapessoal.',
      },
      'Interpessoal': {
        'key': 'Interpessoal',
        'descricao': 'A inteligência interpessoal está relacionada com a capacidade de compreender e se relacionar com outras pessoas, além de perceber e interpretar emoções e sentimentos.\nPsicólogos, terapeutas, professores e líderes são exemplos de profissionais que possuem alta inteligência interpessoal.',
      },
      'Espacial': {
        'key': 'Espacial',
        'descricao': 'A inteligência espacial está relacionada com a capacidade de perceber e interpretar imagens, formas e cores, além de compreender o espaço tridimensional.\nArquitetos, designers, artistas plásticos e pilotos são exemplos de profissionais que possuem alta inteligência espacial.',
      },
      'Cinestesica': {
        'key': 'Cinestésica',
        'descricao': 'A inteligência cinestésica está relacionada com a capacidade de controlar os movimentos do corpo, além de perceber e interpretar sensações táteis.\nAtletas, dançarinos, cirurgiões e artistas plásticos são exemplos de profissionais que possuem alta inteligência cinestésica.',
      },
    };

    final pdfBytes = await controller.gerarRelatorioPdf(
      itensOrdenados: sortedEntries,
      infoInteligencias: infoMap,
      nomeUsuario: 'Denys Fernandes',
      emailUsuario: 'd.fernandes@icasei.com.br',
      dataRealizacao: DateTime(2026, 10, 13, 18, 29),
    );

    expect(pdfBytes, isNotNull);
    expect(pdfBytes.isNotEmpty, isTrue);

    // PDF files start with the ASCII header "%PDF"
    final headerString = String.fromCharCodes(pdfBytes.take(4));
    expect(headerString, equals('%PDF'));

    // Count pages in generated PDF: each page dictionary contains "/Type /Page"
    final pdfContent = String.fromCharCodes(pdfBytes);
    final pageMatches = RegExp(r'/Type\s*/Page\b').allMatches(pdfContent);
    expect(pageMatches.length, equals(1),
        reason: 'Relatório sem respostas detalhadas cabe em 1 página');
  });

  test('ResultController.gerarRelatorioPdf generates 2 pages when respostas is provided', () async {
    final controller = ResultController();
    final sortedEntries = [
      const MapEntry('Musical', 46),
      const MapEntry('Logico', 44),
      const MapEntry('Linguistica', 42),
      const MapEntry('Intrapessoal', 40),
      const MapEntry('Interpessoal', 38),
      const MapEntry('Espacial', 36),
      const MapEntry('Cinestesica', 34),
    ];

    final infoMap = {
      'Musical': {
        'key': 'Musical',
        'descricao': 'A inteligência musical...',
      },
      'Logico': {
        'key': 'Lógico',
        'descricao': 'A inteligência lógico-matemática...',
      },
      'Linguistica': {
        'key': 'Linguística',
        'descricao': 'A inteligência linguística...',
      },
      'Intrapessoal': {
        'key': 'Intrapessoal',
        'descricao': 'A inteligência intrapessoal...',
      },
      'Interpessoal': {
        'key': 'Interpessoal',
        'descricao': 'A inteligência interpessoal...',
      },
      'Espacial': {
        'key': 'Espacial',
        'descricao': 'A inteligência espacial...',
      },
      'Cinestesica': {
        'key': 'Cinestésica',
        'descricao': 'A inteligência cinestésica...',
      },
    };

    // 10 etapas, each with 7 notes summing to 28 points
    final mockRespostas = List.generate(10, (i) => [1, 2, 3, 4, 5, 6, 7]);

    final pdfBytes = await controller.gerarRelatorioPdf(
      itensOrdenados: sortedEntries,
      infoInteligencias: infoMap,
      respostas: mockRespostas,
      nomeUsuario: 'Denys Fernandes',
      emailUsuario: 'd.fernandes@icasei.com.br',
      dataRealizacao: DateTime(2026, 10, 13, 18, 29),
    );

    expect(pdfBytes, isNotNull);
    expect(pdfBytes.isNotEmpty, isTrue);

    final pdfContent = String.fromCharCodes(pdfBytes);
    final pageMatches = RegExp(r'/Type\s*/Page\b').allMatches(pdfContent);
    expect(pageMatches.length, equals(2),
        reason: 'Relatório com questionário deve ter exatamente 2 páginas');

    // Ensure the generated PDF is substantial and contains both pages
    expect(pdfBytes.length, greaterThan(15000));
  });

  test(
      'ResultController.gerarRelatorioPdf generates exactly 2 pages with 9 intelligences and 10x9 answers',
      () async {
    final controller = ResultController();
    final sortedEntries = [
      const MapEntry('Existencial', 72),
      const MapEntry('Musical', 65),
      const MapEntry('Naturalista', 60),
      const MapEntry('Logico', 55),
      const MapEntry('Linguistica', 50),
      const MapEntry('Intrapessoal', 45),
      const MapEntry('Interpessoal', 40),
      const MapEntry('Espacial', 35),
      const MapEntry('Cinestesica', 30),
    ];

    final infoMap = {
      'Existencial': {
        'key': 'Existencial',
        'descricao': Strings.existencialDescricao,
      },
      'Musical': {
        'key': 'Musical',
        'descricao': 'A inteligência musical...',
      },
      'Naturalista': {
        'key': 'Naturalista',
        'descricao': Strings.naturalistaDescricao,
      },
      'Logico': {
        'key': 'Lógico',
        'descricao': 'A inteligência lógico-matemática...',
      },
      'Linguistica': {
        'key': 'Linguística',
        'descricao': 'A inteligência linguística...',
      },
      'Intrapessoal': {
        'key': 'Intrapessoal',
        'descricao': 'A inteligência intrapessoal...',
      },
      'Interpessoal': {
        'key': 'Interpessoal',
        'descricao': 'A inteligência interpessoal...',
      },
      'Espacial': {
        'key': 'Espacial',
        'descricao': 'A inteligência espacial...',
      },
      'Cinestesica': {
        'key': 'Cinestésica',
        'descricao': 'A inteligência cinestésica...',
      },
    };

    // 10 etapas, each with 9 notes from 1 to 9
    final mockRespostas =
        List.generate(10, (i) => [1, 2, 3, 4, 5, 6, 7, 8, 9]);

    final pdfBytes = await controller.gerarRelatorioPdf(
      itensOrdenados: sortedEntries,
      infoInteligencias: infoMap,
      respostas: mockRespostas,
      nomeUsuario: 'Denys Fernandes',
      emailUsuario: 'd.fernandes@icasei.com.br',
      dataRealizacao: DateTime(2026, 10, 13, 18, 29),
    );

    expect(pdfBytes, isNotNull);
    expect(pdfBytes.isNotEmpty, isTrue);

    final pdfContent = String.fromCharCodes(pdfBytes);
    final pageMatches = RegExp(r'/Type\s*/Page\b').allMatches(pdfContent);
    expect(pageMatches.length, equals(2),
        reason:
            'Relatório completo com 9 inteligências deve ter estritamente 2 páginas (sem quebrar cards)');

    expect(pdfBytes.length, greaterThan(18000));
  });

  testWidgets(
      'ResultPage renders without overflow with all 9 intelligences',
      (WidgetTester tester) async {
    final mock9Results = {
      'Linguistica': 45,
      'Logico': 55,
      'Musical': 35,
      'Cinestesica': 50,
      'Interpessoal': 60,
      'Intrapessoal': 40,
      'Espacial': 30,
      'Naturalista': 65,
      'Existencial': 70,
    };

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
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => const ResultPage(),
              settings: RouteSettings(name: '/result', arguments: mock9Results),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('70 Pontos'), findsOneWidget);
    expect(find.text('65 Pontos'), findsOneWidget);
  });

  test(
      'ResultController.baixarResultadoPdf generates valid PDF and invokes onSaveFile',
      () async {
    final controller = ResultController();
    final sortedEntries = [
      const MapEntry('Musical', 46),
      const MapEntry('Logico', 44),
      const MapEntry('Linguistica', 42),
    ];
    final infoMap = {
      'Musical': {'key': 'Musical', 'descricao': 'Desc 1'},
      'Logico': {'key': 'Logico', 'descricao': 'Desc 2'},
      'Linguistica': {'key': 'Linguistica', 'descricao': 'Desc 3'},
    };

    XFile? savedFile;
    await controller.baixarResultadoPdf(
      itensOrdenados: sortedEntries,
      infoInteligencias: infoMap,
      nomeUsuario: 'Usuário Web',
      emailUsuario: 'web@teste.com',
      onSaveFile: (file) async {
        savedFile = file;
      },
    );

    expect(savedFile, isNotNull);
    expect(savedFile!.name, 'resultado_inteligencias_multiplas.pdf');
    expect(savedFile!.mimeType, 'application/pdf');
    final bytes = await savedFile!.readAsBytes();
    expect(bytes.length, greaterThan(10000));
  });

  testWidgets(
      'ResultPage renders download button on Web and share button on Mobile',
      (WidgetTester tester) async {
    // 1. Mobile (isWebOverride: false)
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
          key: const ValueKey('mobile_app'),
          onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (context) => const ResultPage(isWebOverride: false),
            settings: RouteSettings(name: '/result', arguments: mockResults),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.share), findsOneWidget);
    expect(find.byTooltip(Strings.compartilharResultadoPdf), findsOneWidget);
    expect(find.byIcon(Icons.download), findsNothing);

    // 2. Web (isWebOverride: true)
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(1080, 1920),
        fontSizeResolver: (fontSize, instance) {
          final factor = (1920 / 1080 * 0.42).clamp(0.36, 0.44);
          return fontSize * factor;
        },
        builder: (context, child) => MaterialApp(
          key: const ValueKey('web_app'),
          onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (context) => const ResultPage(isWebOverride: true),
            settings: RouteSettings(name: '/result', arguments: mockResults),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.download), findsOneWidget);
    expect(find.byTooltip(Strings.baixarResultadoPdf), findsOneWidget);
    expect(find.byIcon(Icons.share), findsNothing);
  });

  testWidgets(
      'ResultPage CircularProgressIndicator in AppBar is never giant on desktop web (1920x1080)',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final completer = Completer<void>();
    final mockController = _MockWebResultController(completer);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(1080, 1920),
        fontSizeResolver: (fontSize, instance) {
          final factor = (1920 / 1080 * 0.42).clamp(0.36, 0.44);
          return fontSize * factor;
        },
        builder: (context, child) => MaterialApp(
          key: const ValueKey('web_progress_app'),
          onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (context) => ResultPage(
              isWebOverride: true,
              resultControllerOverride: mockController,
            ),
            settings: RouteSettings(name: '/result', arguments: mockResults),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final downloadButton = find.byIcon(Icons.download);
    expect(downloadButton, findsOneWidget);

    // Tap download to trigger loading state
    await tester.tap(downloadButton);
    await tester.pump(); // Start async execution, _compartilhandoPdf = true

    final progressFinder = find.byType(CircularProgressIndicator);
    expect(progressFinder, findsOneWidget);

    // Measure CircularProgressIndicator rendered size - must NOT be giant (previously was 78px)
    final progressBox = tester.renderObject<RenderBox>(progressFinder);
    expect(progressBox.size.width, lessThanOrEqualTo(24.0));
    expect(progressBox.size.height, lessThanOrEqualTo(24.0));

    // Measure parent action container size in AppBar - exactly standard action slot (48x48)
    final parentSizedBoxFinder = find.ancestor(
      of: progressFinder,
      matching: find.byType(SizedBox),
    ).first;
    final parentBox = tester.renderObject<RenderBox>(parentSizedBoxFinder);
    expect(parentBox.size.width, lessThanOrEqualTo(48.0));
    expect(parentBox.size.height, lessThanOrEqualTo(48.0));

    // Complete the download
    completer.complete();
    await tester.pumpAndSettle();

    // Verify progress indicator is gone and download icon is back
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byIcon(Icons.download), findsOneWidget);
  });

  testWidgets(
      'ResultPage shows error snackbar on web when PDF download fails',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final mockController = _MockErrorResultController();

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(1080, 1920),
        fontSizeResolver: (fontSize, instance) {
          final factor = (1920 / 1080 * 0.42).clamp(0.36, 0.44);
          return fontSize * factor;
        },
        builder: (context, child) => MaterialApp(
          key: const ValueKey('web_error_app'),
          onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (context) => ResultPage(
              isWebOverride: true,
              resultControllerOverride: mockController,
            ),
            settings: RouteSettings(name: '/result', arguments: mockResults),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.download));
    await tester.pumpAndSettle();

    expect(find.text(Strings.erroBaixarPdf), findsOneWidget);
    expect(find.byIcon(Icons.download), findsOneWidget);
  });

  testWidgets(
      'Strings.deslizeResultados is inside ListView and scrolls with the list',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 2.0;

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(1080, 1920),
        builder: (context, child) => MaterialApp(
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (context) => const ResultPage(),
              settings: RouteSettings(name: '/result', arguments: mockResults),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    final textFinder = find.text(Strings.deslizeResultados);
    expect(textFinder, findsOneWidget);

    expect(
      find.descendant(of: find.byType(ListView), matching: textFinder),
      findsOneWidget,
    );

    final initialOffset = tester.getTopLeft(textFinder);

    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();

    final scrolledOffset = tester.getTopLeft(textFinder);
    expect(scrolledOffset.dy, lessThan(initialOffset.dy));
  });

  testWidgets(
      'ResultPage Ver mais opens centered Dialog on Web and BottomSheet on Mobile',
      (WidgetTester tester) async {
    // 1. Web mode (1920x1080)
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
          key: const ValueKey('web_detail_modal_app'),
          onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (context) => const ResultPage(isWebOverride: true),
            settings: RouteSettings(name: '/result', arguments: mockResults),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Tap first "Ver mais" button (Cinestésica - 42 Pontos)
    await tester.tap(find.text(Strings.verMais).first);
    await tester.pumpAndSettle();

    expect(find.byType(Dialog), findsOneWidget);
    expect(find.byType(BottomSheet), findsNothing);
    expect(find.byKey(const Key('detail_modal_drag_handle')), findsNothing);
    expect(find.text(Strings.cinestesicaDescricao), findsOneWidget);
    expect(find.text(Strings.entendido), findsOneWidget);

    await tester.tap(find.text(Strings.entendido));
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsNothing);

    // 2. Mobile mode (1080x2400 @ 2.75x)
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(1080, 1920),
        builder: (context, child) => MaterialApp(
          key: const ValueKey('mobile_detail_modal_app'),
          onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (context) => const ResultPage(isWebOverride: false),
            settings: RouteSettings(name: '/result', arguments: mockResults),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text(Strings.verMais).first);
    await tester.pumpAndSettle();

    expect(find.byType(BottomSheet), findsOneWidget);
    expect(find.byType(Dialog), findsNothing);
    expect(find.byKey(const Key('detail_modal_drag_handle')), findsOneWidget);
    expect(find.text(Strings.cinestesicaDescricao), findsOneWidget);
  });
}

class _MockWebResultController extends ResultController {
  final Completer<void> completer;
  _MockWebResultController(this.completer);

  @override
  Future<void> baixarResultadoPdf({
    required List<MapEntry<String, int>> itensOrdenados,
    required Map<String, Map<String, String>> infoInteligencias,
    List<List<int>>? respostas,
    String? nomeUsuario,
    String? emailUsuario,
    DateTime? dataRealizacao,
    Future<void> Function(XFile file)? onSaveFile,
  }) async {
    await completer.future;
  }
}

class _MockErrorResultController extends ResultController {
  @override
  Future<void> baixarResultadoPdf({
    required List<MapEntry<String, int>> itensOrdenados,
    required Map<String, Map<String, String>> infoInteligencias,
    List<List<int>>? respostas,
    String? nomeUsuario,
    String? emailUsuario,
    DateTime? dataRealizacao,
    Future<void> Function(XFile file)? onSaveFile,
  }) async {
    throw Exception('Simulated download failure');
  }
}
