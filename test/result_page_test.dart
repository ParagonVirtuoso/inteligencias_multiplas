import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inteligencias_multiplas/controller/resultController/result_controller.dart';
import 'package:inteligencias_multiplas/screens/resultPage/result_page.dart';
import 'package:inteligencias_multiplas/utils/strings.dart';

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
}
