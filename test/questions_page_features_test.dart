import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inteligencias_multiplas/screens/homePage/componentes/dialog_sair.dart';
import 'package:inteligencias_multiplas/screens/questionsPage/componentes/mini_navigator.dart';
import 'package:inteligencias_multiplas/screens/questionsPage/componentes/numeric_chips.dart';
import 'package:inteligencias_multiplas/screens/questionsPage/componentes/smart_swap_modal.dart';
import 'package:inteligencias_multiplas/screens/questionsPage/question_page.dart';
import 'package:inteligencias_multiplas/utils/cores.dart';
import 'package:inteligencias_multiplas/utils/strings.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    final fontLoader = FontLoader('Roboto-Regular');
    final fontData = File('assets/fonts/Roboto-Regular.ttf').readAsBytesSync();
    fontLoader.addFont(Future.value(ByteData.view(fontData.buffer)));
    await fontLoader.load();
  });

  void configureViewport(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  }

  Widget wrapWithScreenUtil(Widget child) {
    return ScreenUtilInit(
      designSize: const Size(1080, 1920),
      builder: (context, _) => MaterialApp(
        theme: ThemeData(fontFamily: 'Roboto-Regular'),
        home: Scaffold(body: child),
      ),
    );
  }

  group('NumericChips component tests', () {
    testWidgets('renders all 9 numeric chips with >=48dp touch targets',
        (WidgetTester tester) async {
      configureViewport(tester);

      await tester.pumpWidget(
        wrapWithScreenUtil(
          NumericChips(
            selectedValue: 3,
            stepAnswers: const [1, 2, 3, 0, 0, 0, 0, 0, 0],
            currentQuestionIndex: 2,
            onSelectValue: (_) {},
            onSwapRequested: (_, __) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify no horizontal scroll view exists (single horizontal bar without scroll)
      expect(
        find.descendant(
          of: find.byType(NumericChips),
          matching: find.byType(SingleChildScrollView),
        ),
        findsNothing,
      );

      for (int i = 1; i <= 9; i++) {
        final chipFinder = find.byKey(Key('numeric_chip_$i'));
        expect(chipFinder, findsOneWidget);

        final renderBox = tester.renderObject<RenderBox>(chipFinder);
        // Vertical touch target is at least 48dp for accessibility
        expect(renderBox.size.height, greaterThanOrEqualTo(48.0));
        // Horizontal distribution spans row without overflow
        expect(renderBox.size.width, greaterThanOrEqualTo(32.0));
      }
    });

    testWidgets('renders on compact screen (640x960, 320x480 dp) without overflow',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(640, 960);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        wrapWithScreenUtil(
          NumericChips(
            selectedValue: 1,
            stepAnswers: const [1, 0, 0, 0, 0, 0, 0, 0, 0],
            currentQuestionIndex: 0,
            onSelectValue: (_) {},
            onSwapRequested: (_, __) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'all 9 numeric chips fit in a single horizontal row on 360px mobile width without scroll or overflow',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        wrapWithScreenUtil(
          NumericChips(
            selectedValue: 4,
            stepAnswers: const [1, 2, 3, 4, 5, 6, 7, 8, 9],
            currentQuestionIndex: 3,
            onSelectValue: (_) {},
            onSwapRequested: (_, __) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(
        find.descendant(
          of: find.byType(NumericChips),
          matching: find.byType(SingleChildScrollView),
        ),
        findsNothing,
      );

      for (int i = 1; i <= 9; i++) {
        expect(find.byKey(Key('numeric_chip_$i')), findsOneWidget);
      }
    });

    testWidgets('displays available, selected, and assigned-to-other chips correctly',
        (WidgetTester tester) async {
      configureViewport(tester);

      // Question 0 has note 1, Question 1 has note 5
      // Current question is Question 0, selectedValue is 1
      await tester.pumpWidget(
        wrapWithScreenUtil(
          NumericChips(
            selectedValue: 1,
            stepAnswers: const [1, 5, 0, 0, 0, 0, 0, 0, 0],
            currentQuestionIndex: 0,
            onSelectValue: (_) {},
            onSwapRequested: (_, __) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Chip 1 is selected for current question (displays checkmark)
      expect(find.byIcon(Icons.check), findsOneWidget);

      // Chip 5 is assigned to Question 1 (P2)
      expect(find.text('P2'), findsOneWidget);

      // Redundant "Livre" label is removed to economize horizontal space
      expect(find.text(Strings.disponivel), findsNothing);
    });

    testWidgets('tapping an available chip triggers onSelectValue',
        (WidgetTester tester) async {
      configureViewport(tester);

      int? selected;
      await tester.pumpWidget(
        wrapWithScreenUtil(
          NumericChips(
            selectedValue: 0,
            stepAnswers: const [0, 0, 0, 0, 0, 0, 0, 0, 0],
            currentQuestionIndex: 0,
            onSelectValue: (val) => selected = val,
            onSwapRequested: (_, __) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      final chip7 = find.byKey(const Key('numeric_chip_7'));
      await tester.ensureVisible(chip7);
      await tester.tap(chip7);
      await tester.pump();

      expect(selected, 7);
    });

    testWidgets('tapping an assigned-to-other chip triggers onSwapRequested',
        (WidgetTester tester) async {
      configureViewport(tester);

      int? swappedValue;
      int? otherQuestionIndex;

      await tester.pumpWidget(
        wrapWithScreenUtil(
          NumericChips(
            selectedValue: 0,
            stepAnswers: const [0, 8, 0, 0, 0, 0, 0, 0, 0], // Q1 (P2) has 8
            currentQuestionIndex: 0, // current is Q0 (P1)
            onSelectValue: (_) {},
            onSwapRequested: (val, otherQ) {
              swappedValue = val;
              otherQuestionIndex = otherQ;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      final chip8 = find.byKey(const Key('numeric_chip_8'));
      await tester.ensureVisible(chip8);
      await tester.tap(chip8);
      await tester.pump();

      expect(swappedValue, 8);
      expect(otherQuestionIndex, 1); // assigned to question index 1 (P2)
    });

    testWidgets(
        'all 9 numeric chips adapt gracefully under 2.0x accessibility text scaling without overflow or scroll',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      tester.platformDispatcher.textScaleFactorTestValue = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
        tester.platformDispatcher.clearTextScaleFactorTestValue();
      });

      await tester.pumpWidget(
        wrapWithScreenUtil(
          NumericChips(
            selectedValue: 2,
            stepAnswers: const [1, 2, 3, 4, 5, 6, 7, 8, 9],
            currentQuestionIndex: 1,
            onSelectValue: (_) {},
            onSwapRequested: (_, __) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(
        find.descendant(
          of: find.byType(NumericChips),
          matching: find.byType(SingleChildScrollView),
        ),
        findsNothing,
      );

      for (int i = 1; i <= 9; i++) {
        expect(find.byKey(Key('numeric_chip_$i')), findsOneWidget);
      }
    });

    testWidgets(
        'available chip vertically centers the prominent number without ghost spacer',
        (WidgetTester tester) async {
      configureViewport(tester);

      await tester.pumpWidget(
        wrapWithScreenUtil(
          NumericChips(
            selectedValue: 0,
            stepAnswers: const [0, 0, 0, 0, 0, 0, 0, 0, 0],
            currentQuestionIndex: 0,
            onSelectValue: (_) {},
            onSwapRequested: (_, __) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // For available chip 7, only the number Text is present inside the column (no phantom SizedBox spacer)
      final chip7ColumnFinder = find.descendant(
        of: find.byKey(const Key('numeric_chip_7')),
        matching: find.byType(Column),
      );
      expect(chip7ColumnFinder, findsOneWidget);

      final columnWidget = tester.widget<Column>(chip7ColumnFinder);
      expect(columnWidget.children.length, 1); // exactly the Text('$value')
      expect(find.text('7'), findsOneWidget);
    });

    testWidgets(
        'numeric chips maintain harmonious square proportions avoiding barcode/piano key look',
        (WidgetTester tester) async {
      configureViewport(tester);

      await tester.pumpWidget(
        wrapWithScreenUtil(
          NumericChips(
            selectedValue: 5,
            stepAnswers: const [1, 2, 3, 0, 0, 0, 0, 0, 0],
            currentQuestionIndex: 4,
            onSelectValue: (_) {},
            onSwapRequested: (_, __) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      for (int i = 1; i <= 9; i++) {
        final renderBox = tester.renderObject<RenderBox>(
          find.byKey(Key('numeric_chip_$i')),
        );
        // Vertical touch target is at least 48dp for accessibility
        expect(renderBox.size.height, greaterThanOrEqualTo(48.0));
        // Container height is bounded to prevent tall narrow bar
        expect(renderBox.size.height, lessThanOrEqualTo(55.0));
        // Aspect ratio (height / width) must be harmonious (close to 1:1, <= 1.4, not 2.0+ barcode)
        final aspectRatio = renderBox.size.height / renderBox.size.width;
        expect(aspectRatio, lessThan(1.5));
      }
    });

    testWidgets('supports custom margin or uses compact vertical margins',
        (WidgetTester tester) async {
      configureViewport(tester);

      await tester.pumpWidget(
        wrapWithScreenUtil(
          NumericChips(
            selectedValue: 1,
            stepAnswers: const [1, 0, 0, 0, 0, 0, 0, 0, 0],
            currentQuestionIndex: 0,
            onSelectValue: (_) {},
            onSwapRequested: (_, __) {},
            margin: const EdgeInsets.symmetric(vertical: 2.0),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final containerFinder = find.descendant(
        of: find.byType(NumericChips),
        matching: find.byType(Container),
      ).first;
      final container = tester.widget<Container>(containerFinder);
      expect(container.margin, const EdgeInsets.symmetric(vertical: 2.0));
    });

    testWidgets(
        'default vertical margins provide standard breathing room (8-12dp top, 16-22dp bottom)',
        (WidgetTester tester) async {
      configureViewport(tester);

      await tester.pumpWidget(
        wrapWithScreenUtil(
          NumericChips(
            selectedValue: 1,
            stepAnswers: const [1, 0, 0, 0, 0, 0, 0, 0, 0],
            currentQuestionIndex: 0,
            onSelectValue: (_) {},
            onSwapRequested: (_, __) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      final containerFinder = find.descendant(
        of: find.byType(NumericChips),
        matching: find.byType(Container),
      ).first;
      final container = tester.widget<Container>(containerFinder);
      final margin = container.margin as EdgeInsets;
      expect(margin.top, greaterThanOrEqualTo(8.0));
      expect(margin.top, lessThanOrEqualTo(12.0));
      expect(margin.bottom, greaterThanOrEqualTo(16.0));
      expect(margin.bottom, lessThanOrEqualTo(22.0));
    });

    testWidgets(
        'horizontal spacing between chips provides visible breathing room >=4dp',
        (WidgetTester tester) async {
      configureViewport(tester);

      await tester.pumpWidget(
        wrapWithScreenUtil(
          NumericChips(
            selectedValue: 1,
            stepAnswers: const [1, 0, 0, 0, 0, 0, 0, 0, 0],
            currentQuestionIndex: 0,
            onSelectValue: (_) {},
            onSwapRequested: (_, __) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      final chip1Finder = find.byKey(const Key('numeric_chip_1'));
      final chip2Finder = find.byKey(const Key('numeric_chip_2'));
      final chip1Box = tester.renderObject<RenderBox>(chip1Finder);
      final chip2Box = tester.renderObject<RenderBox>(chip2Finder);

      final chip1Right = chip1Box.localToGlobal(Offset.zero).dx + chip1Box.size.width;
      final chip2Left = chip2Box.localToGlobal(Offset.zero).dx;
      final gap = chip2Left - chip1Right;

      // Adjacent chips have at least 4.0dp and at most 6.0dp separation (2.5dp padding each side = 5dp)
      expect(gap, greaterThanOrEqualTo(4.0));
      expect(gap, lessThanOrEqualTo(6.0));
    });

    testWidgets(
        'NumericChips eliminates lateral padding and aligns concentric 16.r corner radii',
        (WidgetTester tester) async {
      configureViewport(tester);

      await tester.pumpWidget(
        wrapWithScreenUtil(
          NumericChips(
            selectedValue: 1,
            stepAnswers: const [1, 0, 0, 0, 0, 0, 0, 0, 0],
            currentQuestionIndex: 0,
            onSelectValue: (_) {},
            onSwapRequested: (_, __) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      final containerFinder = find.descendant(
        of: find.byType(NumericChips),
        matching: find.byType(Container),
      ).first;
      final container = tester.widget<Container>(containerFinder);
      final padding = container.padding as EdgeInsets;
      // Zeroed horizontal padding on outer container
      expect(padding.left, 0.0);
      expect(padding.right, 0.0);

      // Harmonized border radius matching chips (16.r)
      final boxDecoration = container.decoration as BoxDecoration;
      expect(boxDecoration.borderRadius, BorderRadius.circular(16.r));

      // Chip 1 left is flush with container left; Chip 9 right is flush with container right
      final containerBox = tester.renderObject<RenderBox>(containerFinder);
      final chip1Box = tester.renderObject<RenderBox>(find.byKey(const Key('numeric_chip_1')));
      final chip9Box = tester.renderObject<RenderBox>(find.byKey(const Key('numeric_chip_9')));

      final containerLeft = containerBox.localToGlobal(Offset.zero).dx;
      final containerRight = containerLeft + containerBox.size.width;
      final chip1Left = chip1Box.localToGlobal(Offset.zero).dx;
      final chip9Right = chip9Box.localToGlobal(Offset.zero).dx + chip9Box.size.width;

      final borderWidth = 1.w;
      expect(chip1Left, closeTo(containerLeft + borderWidth, 0.01));
      expect(chip9Right, closeTo(containerRight - borderWidth, 0.01));

      // All 9 chips have equal width across the bar
      final chipWidth = chip1Box.size.width;
      for (int i = 2; i <= 9; i++) {
        final box = tester.renderObject<RenderBox>(find.byKey(Key('numeric_chip_$i')));
        expect(box.size.width, closeTo(chipWidth, 0.01));
      }
    });

    testWidgets('scrubbing gesture previews chip and confirms on release',
        (WidgetTester tester) async {
      configureViewport(tester);

      int? selectedValue;
      await tester.pumpWidget(
        wrapWithScreenUtil(
          StatefulBuilder(
            builder: (context, setState) {
              return NumericChips(
                selectedValue: selectedValue ?? 0,
                stepAnswers: const [0, 0, 0, 0, 0, 0, 0, 0, 0],
                currentQuestionIndex: 0,
                onSelectValue: (val) {
                  setState(() {
                    selectedValue = val;
                  });
                },
                onSwapRequested: (_, __) {},
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      final chip1 = find.byKey(const Key('numeric_chip_1'));
      final chip5 = find.byKey(const Key('numeric_chip_5'));

      // Start drag at chip 1
      final gesture = await tester.startGesture(tester.getCenter(chip1));
      await tester.pump();

      // Chip 1 is previewed (shows check icon), but onSelectValue not yet confirmed
      expect(selectedValue, isNull);
      expect(find.byIcon(Icons.check), findsOneWidget);

      // Slide to chip 3
      final chip3 = find.byKey(const Key('numeric_chip_3'));
      await gesture.moveTo(tester.getCenter(chip3));
      await tester.pump();

      // Still not confirmed
      expect(selectedValue, isNull);

      // Slide to chip 5
      await gesture.moveTo(tester.getCenter(chip5));
      await tester.pump();

      // Still not confirmed while holding down
      expect(selectedValue, isNull);

      // Release finger at chip 5
      await gesture.up();
      await tester.pumpAndSettle();

      // Now confirmed as 5!
      expect(selectedValue, 5);
    });

    testWidgets(
        'scrubbing to assigned chip previews assigned state and triggers swap on release',
        (WidgetTester tester) async {
      configureViewport(tester);

      int? swappedValue;
      int? swappedQuestion;
      await tester.pumpWidget(
        wrapWithScreenUtil(
          NumericChips(
            selectedValue: 0,
            stepAnswers: const [0, 0, 0, 5, 0, 0, 0, 0, 0], // Q3 (P4) has note 5
            currentQuestionIndex: 0,
            onSelectValue: (_) {},
            onSwapRequested: (val, q) {
              swappedValue = val;
              swappedQuestion = q;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      final chip1 = find.byKey(const Key('numeric_chip_1'));
      final chip5 = find.byKey(const Key('numeric_chip_5'));

      final gesture = await tester.startGesture(tester.getCenter(chip1));
      await tester.pump();

      // Move to chip 5 (which is assigned to P4)
      await gesture.moveTo(tester.getCenter(chip5));
      await tester.pump();

      expect(swappedValue, isNull);

      // Release on chip 5
      await gesture.up();
      await tester.pumpAndSettle();

      expect(swappedValue, 5);
      expect(swappedQuestion, 3);
    });

    testWidgets('dragging outside vertically cancels chip preview without selecting',
        (WidgetTester tester) async {
      configureViewport(tester);

      int? selectedValue;
      await tester.pumpWidget(
        wrapWithScreenUtil(
          NumericChips(
            selectedValue: 0,
            stepAnswers: const [0, 0, 0, 0, 0, 0, 0, 0, 0],
            currentQuestionIndex: 0,
            onSelectValue: (val) => selectedValue = val,
            onSwapRequested: (_, __) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      final chip1 = find.byKey(const Key('numeric_chip_1'));
      final gesture = await tester.startGesture(tester.getCenter(chip1));
      await tester.pump();

      // Drag 80 pixels down (outside vertical bounds)
      await gesture.moveBy(const Offset(50, 80));
      await tester.pump();

      // Release outside
      await gesture.up();
      await tester.pumpAndSettle();

      expect(selectedValue, isNull);
    });

    testWidgets('dragging outside horizontally to the left cancels chip preview without selecting',
        (WidgetTester tester) async {
      configureViewport(tester);

      int? selectedValue;
      await tester.pumpWidget(
        wrapWithScreenUtil(
          NumericChips(
            selectedValue: 0,
            stepAnswers: const [0, 0, 0, 0, 0, 0, 0, 0, 0],
            currentQuestionIndex: 0,
            onSelectValue: (val) => selectedValue = val,
            onSwapRequested: (_, __) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      final chip1 = find.byKey(const Key('numeric_chip_1'));
      final gesture = await tester.startGesture(tester.getCenter(chip1));
      await tester.pump();

      // Drag 70 pixels to the left (beyond the -40dp horizontal tolerance)
      await gesture.moveBy(const Offset(-70, 0));
      await tester.pump();

      // Release outside horizontally
      await gesture.up();
      await tester.pumpAndSettle();

      expect(selectedValue, isNull);
    });

    testWidgets('dragging outside horizontally to the right cancels chip preview without selecting',
        (WidgetTester tester) async {
      configureViewport(tester);

      int? selectedValue;
      await tester.pumpWidget(
        wrapWithScreenUtil(
          NumericChips(
            selectedValue: 0,
            stepAnswers: const [0, 0, 0, 0, 0, 0, 0, 0, 0],
            currentQuestionIndex: 0,
            onSelectValue: (val) => selectedValue = val,
            onSwapRequested: (_, __) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      final chip9 = find.byKey(const Key('numeric_chip_9'));
      final gesture = await tester.startGesture(tester.getCenter(chip9));
      await tester.pump();

      // Drag 70 pixels to the right (beyond the totalWidth + 40dp tolerance)
      await gesture.moveBy(const Offset(70, 0));
      await tester.pump();

      // Release outside horizontally
      await gesture.up();
      await tester.pumpAndSettle();

      expect(selectedValue, isNull);
    });

    testWidgets(
        'scrubbing preview with existing selection shows only one active checkmark and no duplicate checkmark on old selection',
        (WidgetTester tester) async {
      configureViewport(tester);

      // Question 0 currently has note 3 selected
      await tester.pumpWidget(
        wrapWithScreenUtil(
          NumericChips(
            selectedValue: 3,
            stepAnswers: const [3, 0, 0, 0, 0, 0, 0, 0, 0],
            currentQuestionIndex: 0,
            onSelectValue: (_) {},
            onSwapRequested: (_, __) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Initially, exactly one checkmark on note 3
      expect(find.byIcon(Icons.check), findsOneWidget);

      final chip1 = find.byKey(const Key('numeric_chip_1'));
      final gesture = await tester.startGesture(tester.getCenter(chip1));
      await tester.pump();

      // While previewing note 1, note 1 has checkmark, note 3 must NOT have checkmark (still exactly 1 checkmark)
      expect(find.byIcon(Icons.check), findsOneWidget);

      // Release at chip 1
      await gesture.up();
      await tester.pumpAndSettle();
    });

    testWidgets(
        'continuous multi-step scrubbing through 1, 2, 3, 4, 5 previews each intermediate value and commits 5 on release',
        (WidgetTester tester) async {
      configureViewport(tester);

      int? committedValue;
      await tester.pumpWidget(
        wrapWithScreenUtil(
          NumericChips(
            selectedValue: 0,
            stepAnswers: const [0, 0, 0, 0, 0, 0, 0, 0, 0],
            currentQuestionIndex: 0,
            onSelectValue: (val) => committedValue = val,
            onSwapRequested: (_, __) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      final chip1 = find.byKey(const Key('numeric_chip_1'));
      final gesture = await tester.startGesture(tester.getCenter(chip1));
      await tester.pump();

      for (int i = 2; i <= 5; i++) {
        final nextChip = find.byKey(Key('numeric_chip_$i'));
        await gesture.moveTo(tester.getCenter(nextChip));
        await tester.pump();
        // None committed during intermediate drag
        expect(committedValue, isNull);
      }

      await gesture.up();
      await tester.pumpAndSettle();

      expect(committedValue, 5);
    });
  });

  group('MiniNavigator component tests', () {
    testWidgets('renders 9 question indicators and highlights current question',
        (WidgetTester tester) async {
      configureViewport(tester);

      int? selectedQuestion;

      await tester.pumpWidget(
        wrapWithScreenUtil(
          MiniNavigator(
            currentQuestion: 3, // P4 is current
            stepAnswers: const [7, 5, 2, 0, 0, 0, 0, 0, 0],
            currentSelection: 4, // currently selecting 4 for P4
            onSelectQuestion: (index) => selectedQuestion = index,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check all 9 indicators exist
      for (int i = 0; i < 9; i++) {
        expect(find.byKey(Key('mini_nav_question_$i')), findsOneWidget);
        expect(
          find.descendant(
            of: find.byKey(Key('mini_nav_question_$i')),
            matching: find.text('P${i + 1}'),
          ),
          findsOneWidget,
        );
      }

      // Check answered indicators display stars
      expect(find.text('★7'), findsOneWidget);
      expect(find.text('★5'), findsOneWidget);
      expect(find.text('★2'), findsOneWidget);
      expect(find.text('★4'), findsOneWidget); // P4 has live selection 4

      // Check pending indicators display '—'
      expect(find.text('—'), findsNWidgets(5));

      // Tap on indicator P2 (index 1)
      await tester.tap(find.byKey(const Key('mini_nav_question_1')));
      await tester.pump();

      expect(selectedQuestion, 1);
    });

    testWidgets('MiniNavigator renders on compact screen (640x960, 320x480 dp) without overflow',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(640, 960);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        wrapWithScreenUtil(
          MiniNavigator(
            currentQuestion: 0,
            stepAnswers: const [1, 2, 3, 4, 5, 6, 7, 8, 9],
            currentSelection: 1,
            onSelectQuestion: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets(
        'MiniNavigator eliminates lateral padding and aligns concentric 12.r corner radii',
        (WidgetTester tester) async {
      configureViewport(tester);

      await tester.pumpWidget(
        wrapWithScreenUtil(
          MiniNavigator(
            currentQuestion: 0,
            stepAnswers: const [1, 2, 3, 4, 5, 6, 7, 8, 9],
            currentSelection: 1,
            onSelectQuestion: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      final containerFinder = find.descendant(
        of: find.byType(MiniNavigator),
        matching: find.byType(Container),
      ).first;
      final container = tester.widget<Container>(containerFinder);
      final padding = container.padding as EdgeInsets;
      // Zeroed horizontal padding on outer container
      expect(padding.left, 0.0);
      expect(padding.right, 0.0);

      // Harmonized border radius matching buttons (12.r)
      final boxDecoration = container.decoration as BoxDecoration;
      expect(boxDecoration.borderRadius, BorderRadius.circular(12.r));

      // Button 1 left is flush with container left; Button 9 right is flush with container right
      final containerBox = tester.renderObject<RenderBox>(containerFinder);
      final button1Box = tester.renderObject<RenderBox>(find.byKey(const Key('mini_nav_question_0')));
      final button9Box = tester.renderObject<RenderBox>(find.byKey(const Key('mini_nav_question_8')));

      final containerLeft = containerBox.localToGlobal(Offset.zero).dx;
      final containerRight = containerLeft + containerBox.size.width;
      final button1Left = button1Box.localToGlobal(Offset.zero).dx;
      final button9Right = button9Box.localToGlobal(Offset.zero).dx + button9Box.size.width;

      final borderWidth = 1.5.w;
      expect(button1Left, closeTo(containerLeft + borderWidth, 0.01));
      expect(button9Right, closeTo(containerRight - borderWidth, 0.01));

      // All 9 buttons have equal width across the bar
      final buttonWidth = button1Box.size.width;
      for (int i = 1; i < 9; i++) {
        final box = tester.renderObject<RenderBox>(find.byKey(Key('mini_nav_question_$i')));
        expect(box.size.width, closeTo(buttonWidth, 0.01));
      }
    });

    testWidgets(
        'non-selected indicators have null border while current indicator has 1.5.w border',
        (WidgetTester tester) async {
      configureViewport(tester);

      await tester.pumpWidget(
        wrapWithScreenUtil(
          MiniNavigator(
            currentQuestion: 2, // P3 is current
            stepAnswers: const [1, 2, 0, 0, 0, 0, 0, 0, 0], // P1 and P2 answered
            currentSelection: 0,
            onSelectQuestion: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Helper to find Container decoration for a question index
      BoxDecoration getDecoration(int index) {
        final containerFinder = find.descendant(
          of: find.byKey(Key('mini_nav_question_$index')),
          matching: find.byType(Container),
        ).first;
        return tester.widget<Container>(containerFinder).decoration as BoxDecoration;
      }

      // P3 (index 2) is current -> must have 1.5.w border
      final currentDecoration = getDecoration(2);
      expect(currentDecoration.border, isNotNull);
      final border = currentDecoration.border as Border;
      expect(border.top.color, Cores.kAzulBotaoItemColor);
      expect(border.top.width, 1.5.w);

      // P1 (index 0, answered) -> border must be null
      expect(getDecoration(0).border, isNull);

      // P2 (index 1, answered) -> border must be null
      expect(getDecoration(1).border, isNull);

      // P4 (index 3, unanswered) -> border must be null
      expect(getDecoration(3).border, isNull);

      // P9 (index 8, unanswered) -> border must be null
      expect(getDecoration(8).border, isNull);
    });

    testWidgets(
        'scrubbing gesture across MiniNavigator updates selected question in real time',
        (WidgetTester tester) async {
      configureViewport(tester);

      final List<int> selectedQuestions = [];
      int currentQ = 0;

      await tester.pumpWidget(
        wrapWithScreenUtil(
          StatefulBuilder(
            builder: (context, setState) {
              return MiniNavigator(
                currentQuestion: currentQ,
                stepAnswers: const [0, 0, 0, 0, 0, 0, 0, 0, 0],
                currentSelection: 0,
                onSelectQuestion: (index) {
                  selectedQuestions.add(index);
                  setState(() {
                    currentQ = index;
                  });
                },
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      final p1 = find.byKey(const Key('mini_nav_question_0'));
      final p7 = find.byKey(const Key('mini_nav_question_6'));

      // Start drag at P1
      final gesture = await tester.startGesture(tester.getCenter(p1));
      await tester.pump();

      // Slide to P7
      await gesture.moveTo(tester.getCenter(p7));
      await tester.pump();

      // Release at P7
      await gesture.up();
      await tester.pumpAndSettle();

      // Questions updated in real time as finger slid across
      expect(selectedQuestions, contains(6)); // Reached P7
      expect(currentQ, 6);
    });

    testWidgets(
        'scrubbing continuously through P1, P2, P3, P4, P5, P6, P7 reports each intermediate question in order',
        (WidgetTester tester) async {
      configureViewport(tester);

      final List<int> selectedQuestions = [];
      int currentQ = 0;

      await tester.pumpWidget(
        wrapWithScreenUtil(
          StatefulBuilder(
            builder: (context, setState) {
              return MiniNavigator(
                currentQuestion: currentQ,
                stepAnswers: const [0, 0, 0, 0, 0, 0, 0, 0, 0],
                currentSelection: 0,
                onSelectQuestion: (index) {
                  selectedQuestions.add(index);
                  setState(() {
                    currentQ = index;
                  });
                },
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      final p1 = find.byKey(const Key('mini_nav_question_0'));
      final gesture = await tester.startGesture(tester.getCenter(p1));
      await tester.pump();

      for (int i = 1; i <= 6; i++) {
        final nextP = find.byKey(Key('mini_nav_question_$i'));
        await gesture.moveTo(tester.getCenter(nextP));
        await tester.pump();
      }

      await gesture.up();
      await tester.pumpAndSettle();

      expect(selectedQuestions, [0, 1, 2, 3, 4, 5, 6]);
      expect(currentQ, 6);
    });

    testWidgets(
        'scrubbing in reverse from P7 down to P1 reports each question in reverse order',
        (WidgetTester tester) async {
      configureViewport(tester);

      final List<int> selectedQuestions = [];
      int currentQ = 6;

      await tester.pumpWidget(
        wrapWithScreenUtil(
          StatefulBuilder(
            builder: (context, setState) {
              return MiniNavigator(
                currentQuestion: currentQ,
                stepAnswers: const [0, 0, 0, 0, 0, 0, 0, 0, 0],
                currentSelection: 0,
                onSelectQuestion: (index) {
                  selectedQuestions.add(index);
                  setState(() {
                    currentQ = index;
                  });
                },
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      final p7 = find.byKey(const Key('mini_nav_question_6'));
      final gesture = await tester.startGesture(tester.getCenter(p7));
      await tester.pump();

      for (int i = 5; i >= 0; i--) {
        final nextP = find.byKey(Key('mini_nav_question_$i'));
        await gesture.moveTo(tester.getCenter(nextP));
        await tester.pump();
      }

      await gesture.up();
      await tester.pumpAndSettle();

      expect(selectedQuestions, [6, 5, 4, 3, 2, 1, 0]);
      expect(currentQ, 0);
    });

    testWidgets(
        'tapping a question item invokes onSelectQuestion exactly once without duplicate calls',
        (WidgetTester tester) async {
      configureViewport(tester);

      int callCount = 0;
      int? selectedIndex;

      await tester.pumpWidget(
        wrapWithScreenUtil(
          MiniNavigator(
            currentQuestion: 0,
            stepAnswers: const [0, 0, 0, 0, 0, 0, 0, 0, 0],
            currentSelection: 0,
            onSelectQuestion: (index) {
              callCount++;
              selectedIndex = index;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('mini_nav_question_2')));
      await tester.pump();

      expect(callCount, 1);
      expect(selectedIndex, 2);
    });

    testWidgets(
        'dragging outside vertically or horizontally beyond tolerance does not switch questions',
        (WidgetTester tester) async {
      configureViewport(tester);

      final List<int> selectedQuestions = [];
      int currentQ = 0;

      await tester.pumpWidget(
        wrapWithScreenUtil(
          StatefulBuilder(
            builder: (context, setState) {
              return MiniNavigator(
                currentQuestion: currentQ,
                stepAnswers: const [0, 0, 0, 0, 0, 0, 0, 0, 0],
                currentSelection: 0,
                onSelectQuestion: (index) {
                  selectedQuestions.add(index);
                  setState(() {
                    currentQ = index;
                  });
                },
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      final p1 = find.byKey(const Key('mini_nav_question_0'));
      final gesture = await tester.startGesture(tester.getCenter(p1));
      await tester.pump();

      // Drag 90dp vertically down (outside tolerance of totalHeight + 40)
      await gesture.moveBy(const Offset(100, 90));
      await tester.pump();

      // Drag further horizontally while outside vertically
      await gesture.moveBy(const Offset(150, 0));
      await tester.pump();

      await gesture.up();
      await tester.pumpAndSettle();

      // Only the initial pointer down on P1 was recorded; the outside movement was ignored
      expect(selectedQuestions, [0]);
      expect(currentQ, 0);
    });
  });

  group('SmartSwapModal component tests', () {
    testWidgets('renders contextual comparison and confirms swap',
        (WidgetTester tester) async {
      configureViewport(tester);

      bool confirmed = false;
      bool cancelled = false;

      await tester.pumpWidget(
        wrapWithScreenUtil(
          SmartSwapModal(
            targetValue: 8,
            currentQuestionIndex: 0,
            currentQuestionText: 'Pergunta de afinidade interpessoal',
            currentAnswer: 4,
            otherQuestionIndex: 5,
            otherQuestionText: 'Pergunta de afinidade lógica',
            onConfirm: () => confirmed = true,
            onCancel: () => cancelled = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('${Strings.trocarNota} 8?'), findsOneWidget);
      expect(find.text('Pergunta 1 (Atual)'), findsOneWidget);
      expect(find.text('Pergunta 6'), findsOneWidget);
      expect(find.text('Pergunta de afinidade interpessoal'), findsOneWidget);
      expect(find.text('Pergunta de afinidade lógica'), findsOneWidget);

      // Tap Confirm
      await tester.tap(find.byKey(const Key('smart_swap_confirm_button')));
      await tester.pump();

      expect(confirmed, isTrue);
      expect(cancelled, isFalse);
    });

    testWidgets('cancels swap when cancel button tapped',
        (WidgetTester tester) async {
      configureViewport(tester);

      bool confirmed = false;
      bool cancelled = false;

      await tester.pumpWidget(
        wrapWithScreenUtil(
          SmartSwapModal(
            targetValue: 6,
            currentQuestionIndex: 1,
            currentQuestionText: 'Questão A',
            currentAnswer: 0,
            otherQuestionIndex: 2,
            otherQuestionText: 'Questão B',
            onConfirm: () => confirmed = true,
            onCancel: () => cancelled = true,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(Strings.semNota), findsOneWidget);
      expect(find.text(Strings.pendente), findsOneWidget);

      await tester.tap(find.byKey(const Key('smart_swap_cancel_button')));
      await tester.pump();

      expect(cancelled, isTrue);
      expect(confirmed, isFalse);
    });
  });

  group('QuestionsPage navigation and interaction tests', () {
    Future<void> preloadImages(WidgetTester tester) async {
      await tester.runAsync(() async {
        final element = tester.element(find.byType(MaterialApp));
        await precacheImage(const AssetImage(Strings.proximoIconAsset), element);
      });
    }

    testWidgets('renders QuestionsPage with MiniNavigator, chips, unified statement, and accessible back button',
        (WidgetTester tester) async {
      configureViewport(tester);

      await tester.pumpWidget(
        wrapWithScreenUtil(
          const QuestionsPage(),
        ),
      );
      await preloadImages(tester);
      await tester.pumpAndSettle();

      expect(find.byType(MiniNavigator), findsOneWidget);
      expect(find.byType(NumericChips), findsOneWidget);
      expect(find.byKey(const Key('unified_question_statement')), findsOneWidget);
      expect(find.byKey(const Key('questions_back_button')), findsOneWidget);
      expect(find.byKey(const Key('questions_next_button')), findsOneWidget);

      // Verify NumericChips inside QuestionsPage does NOT use horizontal scroll
      expect(
        find.descendant(
          of: find.byType(NumericChips),
          matching: find.byType(SingleChildScrollView),
        ),
        findsNothing,
      );

      // Verify back button touch target is >= 48x48
      final backBox = tester.renderObject<RenderBox>(
        find.byKey(const Key('questions_back_button')),
      );
      expect(backBox.size.width, greaterThanOrEqualTo(48.0));
      expect(backBox.size.height, greaterThanOrEqualTo(48.0));
    });

    testWidgets(
        'renders QuestionsPage under 2.0x accessibility font scale without layout overflow',
        (WidgetTester tester) async {
      configureViewport(tester);
      tester.platformDispatcher.textScaleFactorTestValue = 2.0;
      addTearDown(() {
        tester.platformDispatcher.clearTextScaleFactorTestValue();
      });

      await tester.pumpWidget(
        wrapWithScreenUtil(
          const QuestionsPage(),
        ),
      );
      await preloadImages(tester);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(NumericChips), findsOneWidget);
    });

    testWidgets('unifies question prefix and prompt in a cohesive reading block',
        (WidgetTester tester) async {
      configureViewport(tester);

      await tester.pumpWidget(
        wrapWithScreenUtil(
          const QuestionsPage(),
        ),
      );
      await preloadImages(tester);
      await tester.pumpAndSettle();

      final statementFinder = find.byKey(const Key('unified_question_statement'));
      expect(statementFinder, findsOneWidget);

      // Both the step prefix ("Coisas que mais gosto de fazer") and question ("Praticar esportes")
      // are located within the unified statement block
      expect(
        find.descendant(
          of: statementFinder,
          matching: find.text('Coisas que mais gosto de fazer'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: statementFinder,
          matching: find.text('Praticar esportes'),
        ),
        findsOneWidget,
      );

      // Verify question prompt styling: semi-bold & bold, calibrated font sizes, high contrast colors
      final prefixText = tester.widget<Text>(
        find.descendant(
          of: statementFinder,
          matching: find.text('Coisas que mais gosto de fazer'),
        ),
      );
      expect(prefixText.style?.fontWeight, FontWeight.w600);
      expect(prefixText.style?.color, Cores.kTertiaryColor);
      expect(prefixText.style?.fontSize, 42.sp);

      final questionText = tester.widget<Text>(
        find.descendant(
          of: statementFinder,
          matching: find.text('Praticar esportes'),
        ),
      );
      expect(questionText.style?.fontWeight, FontWeight.bold);
      expect(questionText.style?.color, Cores.kQuaternaryColor);
      expect(questionText.style?.fontSize, 50.sp);
    });

    testWidgets(
        'illustration has balanced intermediate height between 170dp and 215dp leaving vertical breathing room for controls',
        (WidgetTester tester) async {
      configureViewport(tester);

      await tester.pumpWidget(
        wrapWithScreenUtil(
          const QuestionsPage(),
        ),
      );
      await preloadImages(tester);
      await tester.pumpAndSettle();

      // Verify SafeArea protects controls from system navigation bar
      expect(find.byType(SafeArea), findsAtLeastNWidgets(1));

      final imageFinder = find.byKey(const ValueKey<String>('0-0'));
      expect(imageFinder, findsOneWidget);

      final imageBox = tester.renderObject<RenderBox>(imageFinder);
      // Illustration has balanced intermediate height calibrated between 170dp and 215dp (not 350dp)
      expect(imageBox.size.height, greaterThanOrEqualTo(170.0));
      expect(imageBox.size.height, lessThanOrEqualTo(215.0));
    });

    testWidgets(
        'bottom section is uncrowded with SafeArea, bottom safety margin and compact card paddings',
        (WidgetTester tester) async {
      configureViewport(tester);

      await tester.pumpWidget(
        wrapWithScreenUtil(
          const QuestionsPage(),
        ),
      );
      await preloadImages(tester);
      await tester.pumpAndSettle();

      // Verify SafeArea wraps body
      expect(find.byType(SafeArea), findsAtLeastNWidgets(1));

      // Verify next button is visible and properly spaced from the bottom
      final nextFinder = find.byKey(const Key('questions_next_button'));
      expect(nextFinder, findsOneWidget);

      final nextBox = tester.renderObject<RenderBox>(nextFinder);
      final nextPosition = nextBox.localToGlobal(Offset.zero);
      // Next button should be well within bounds with at least 16dp safety clearance
      final screenHeight =
          tester.view.physicalSize.height / tester.view.devicePixelRatio;
      final bottomClearance = screenHeight - (nextPosition.dy + nextBox.size.height);
      expect(bottomClearance, greaterThanOrEqualTo(16.0));

      // Verify statement card padding
      final statementFinder = find.byKey(const Key('unified_question_statement'));
      final statementContainer = tester.widget<Container>(statementFinder);
      final padding = statementContainer.padding as EdgeInsets;
      expect(padding.top, lessThanOrEqualTo(10.0));
      expect(padding.bottom, lessThanOrEqualTo(10.0));

      // Verify standard vertical breathing room between lower controls
      final statementBox = tester.renderObject<RenderBox>(statementFinder);
      final statementBottom =
          statementBox.localToGlobal(Offset.zero).dy + statementBox.size.height;

      final instructionFinder = find.text(Strings.avalieComFichas);
      final instructionBox = tester.renderObject<RenderBox>(instructionFinder);
      final instructionTop = instructionBox.localToGlobal(Offset.zero).dy;
      final instructionBottom = instructionTop + instructionBox.size.height;

      final chipsFinder = find.byType(NumericChips);
      final chipsBox = tester.renderObject<RenderBox>(chipsFinder);
      final chipsTop = chipsBox.localToGlobal(Offset.zero).dy;
      final chipsBottom = chipsTop + chipsBox.size.height;

      final nextTop = nextPosition.dy;

      // Spacing between statement card and instruction: 10 to 14dp
      final gapCardToInstruction = instructionTop - statementBottom;
      expect(gapCardToInstruction, greaterThanOrEqualTo(10.0));
      expect(gapCardToInstruction, lessThanOrEqualTo(14.0));

      // Spacing between instruction and NumericChips: 8 to 12dp
      final gapInstructionToChips = chipsTop - instructionBottom;
      expect(gapInstructionToChips, greaterThanOrEqualTo(8.0));
      expect(gapInstructionToChips, lessThanOrEqualTo(12.0));

      // Spacing between NumericChips and Next button: 16 to 22dp
      final gapChipsToNext = nextTop - chipsBottom;
      expect(gapChipsToNext, greaterThanOrEqualTo(16.0));
      expect(gapChipsToNext, lessThanOrEqualTo(22.0));

      // Bottom clearance below Next button: 18 to 24dp (allowing for float rounding)
      expect(bottomClearance, greaterThanOrEqualTo(18.0 - 0.05));
      expect(bottomClearance, lessThanOrEqualTo(24.0 + 0.05));
    });

    testWidgets(
        'renders Etapa 3 from visual feedback with harmonized typography, uncrowded bottom, and balanced illustration',
        (WidgetTester tester) async {
      configureViewport(tester);

      await tester.pumpWidget(
        wrapWithScreenUtil(
          const QuestionsPage(initialStep: 2, initialQuestion: 0),
        ),
      );
      await preloadImages(tester);
      await tester.runAsync(() async {
        final element = tester.element(find.byType(MaterialApp));
        await precacheImage(
          const AssetImage('assets/etapas/etapa-3/pergunta-1.png'),
          element,
        );
      });
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);

      // Verify Etapa 3 text rendered
      expect(find.text('${Strings.etapa} 3'), findsOneWidget);
      expect(find.text('Quando estou no trabalho ou na escola prefiro?'), findsOneWidget);
      expect(find.text('Levantar e andar periodicamente'), findsOneWidget);

      // Verify illustration is scaled in balanced range [170.0, 215.0]
      final imageFinder = find.byKey(const ValueKey<String>('2-0'));
      expect(imageFinder, findsOneWidget);
      final imageBox = tester.renderObject<RenderBox>(imageFinder);
      expect(imageBox.size.height, greaterThanOrEqualTo(170.0));
      expect(imageBox.size.height, lessThanOrEqualTo(215.0));

      // Verify next button bottom clearance >= 16dp
      final nextFinder = find.byKey(const Key('questions_next_button'));
      final nextBox = tester.renderObject<RenderBox>(nextFinder);
      final nextPosition = nextBox.localToGlobal(Offset.zero);
      final screenHeight =
          tester.view.physicalSize.height / tester.view.devicePixelRatio;
      final bottomClearance = screenHeight - (nextPosition.dy + nextBox.size.height);
      expect(bottomClearance, greaterThanOrEqualTo(16.0));
    });

    testWidgets('renders QuestionsPage on small screen (640x1136, 320x568 dp) without overflow',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(640, 1136);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        wrapWithScreenUtil(
          const QuestionsPage(),
        ),
      );
      await preloadImages(tester);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(QuestionsPage), findsOneWidget);
    });

    testWidgets('renders QuestionsPage on ultra compact screen (640x960, 320x480 dp) without overflow',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(640, 960);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        wrapWithScreenUtil(
          const QuestionsPage(),
        ),
      );
      await preloadImages(tester);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(QuestionsPage), findsOneWidget);
    });

    testWidgets('selecting an available chip updates selection and next button',
        (WidgetTester tester) async {
      configureViewport(tester);

      await tester.pumpWidget(
        wrapWithScreenUtil(
          const QuestionsPage(),
        ),
      );
      await preloadImages(tester);
      await tester.pumpAndSettle();

      // Tap chip 5
      final chip5 = find.byKey(const Key('numeric_chip_5'));
      await tester.ensureVisible(chip5);
      await tester.tap(chip5);
      await tester.pumpAndSettle();

      // Chip 5 is now selected
      expect(find.byIcon(Icons.check), findsOneWidget);

      // Next button is tapped to save answer and move to next question
      await tester.tap(find.byKey(const Key('questions_next_button')));
      await tester.pumpAndSettle();

      // P1 in MiniNavigator now shows as answered with 5
      expect(
        find.descendant(
          of: find.byKey(const Key('mini_nav_question_0')),
          matching: find.text('P1'),
        ),
        findsOneWidget,
      );
      expect(find.text('★5'), findsOneWidget);
    });

    testWidgets('tapping back button on question 0 shows exit dialog DialogSair',
        (WidgetTester tester) async {
      configureViewport(tester);

      await tester.pumpWidget(
        wrapWithScreenUtil(
          const QuestionsPage(),
        ),
      );
      await preloadImages(tester);
      await tester.pumpAndSettle();

      // We are on question 0. Tap back button:
      await tester.tap(find.byKey(const Key('questions_back_button')));
      await tester.pumpAndSettle();

      // DialogSair must appear with test exit content
      expect(find.byType(DialogSair), findsOneWidget);
      expect(find.text(Strings.sairDoTeste), findsOneWidget);
      expect(find.text(Strings.desejaSairDoTeste), findsOneWidget);
      expect(find.text(Strings.continuarTeste), findsOneWidget);
      expect(find.text(Strings.confirmarSairDoTeste), findsOneWidget);
      expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
    });

    testWidgets('canceling DialogSair when on question 0 keeps user in QuestionsPage',
        (WidgetTester tester) async {
      configureViewport(tester);

      await tester.pumpWidget(
        wrapWithScreenUtil(
          const QuestionsPage(),
        ),
      );
      await preloadImages(tester);
      await tester.pumpAndSettle();

      // Tap back button on question 0
      await tester.tap(find.byKey(const Key('questions_back_button')));
      await tester.pumpAndSettle();

      expect(find.byType(DialogSair), findsOneWidget);

      // Tap "Continuar teste"
      await tester.tap(find.text(Strings.continuarTeste));
      await tester.pumpAndSettle();

      // Dialog is dismissed, QuestionsPage is still present
      expect(find.byType(DialogSair), findsNothing);
      expect(find.byType(QuestionsPage), findsOneWidget);
    });

    testWidgets('confirming DialogSair when on question 0 successfully exits QuestionsPage',
        (WidgetTester tester) async {
      configureViewport(tester);

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(1080, 1920),
          builder: (context, _) => MaterialApp(
            home: Builder(
              builder: (ctx) => Scaffold(
                body: Center(
                  child: ElevatedButton(
                    key: const Key('open_quiz_button'),
                    onPressed: () => Navigator.push(
                      ctx,
                      MaterialPageRoute(builder: (_) => const QuestionsPage()),
                    ),
                    child: const Text('Start Quiz'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Navigate into QuestionsPage
      await tester.tap(find.byKey(const Key('open_quiz_button')));
      await tester.pump();
      await preloadImages(tester);
      await tester.pumpAndSettle();

      expect(find.byType(QuestionsPage), findsOneWidget);

      // Tap back button
      await tester.tap(find.byKey(const Key('questions_back_button')));
      await tester.pumpAndSettle();

      // DialogSair appears
      expect(find.byType(DialogSair), findsOneWidget);

      // Tap "Sair do teste" to confirm exit
      await tester.tap(find.text(Strings.confirmarSairDoTeste));
      await tester.pumpAndSettle();

      // DialogSair and QuestionsPage should both be popped, leaving Start Quiz
      expect(find.byType(DialogSair), findsNothing);
      expect(find.byType(QuestionsPage), findsNothing);
      expect(find.text('Start Quiz'), findsOneWidget);
    });

    testWidgets('tapping back button on question > 0 shows exit dialog DialogSair',
        (WidgetTester tester) async {
      configureViewport(tester);

      await tester.pumpWidget(
        wrapWithScreenUtil(
          const QuestionsPage(),
        ),
      );
      await preloadImages(tester);
      await tester.pumpAndSettle();

      // Answer question 0 with chip 3 and proceed to question 1
      final chip3 = find.byKey(const Key('numeric_chip_3'));
      await tester.ensureVisible(chip3);
      await tester.tap(chip3);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('questions_next_button')));
      await tester.pumpAndSettle();

      // Now on question 1 (P2). Tap back button:
      await tester.tap(find.byKey(const Key('questions_back_button')));
      await tester.pumpAndSettle();

      // Exit dialog DialogSair.teste appears immediately
      expect(find.byType(DialogSair), findsOneWidget);
      expect(find.text(Strings.sairDoTeste), findsOneWidget);
      expect(find.text(Strings.desejaSairDoTeste), findsOneWidget);

      // Dismiss dialog and verify we remain on question 1
      await tester.tap(find.text(Strings.continuarTeste));
      await tester.pumpAndSettle();
      expect(find.byType(DialogSair), findsNothing);
      expect(find.byType(QuestionsPage), findsOneWidget);
    });

    testWidgets('system back gesture on question > 0 shows exit dialog DialogSair',
        (WidgetTester tester) async {
      configureViewport(tester);

      await tester.pumpWidget(
        wrapWithScreenUtil(
          const QuestionsPage(),
        ),
      );
      await preloadImages(tester);
      await tester.pumpAndSettle();

      // Answer question 0 with chip 3 and proceed to question 1
      final chip3 = find.byKey(const Key('numeric_chip_3'));
      await tester.ensureVisible(chip3);
      await tester.tap(chip3);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('questions_next_button')));
      await tester.pumpAndSettle();

      // Invoke system back gesture on question 1
      final dynamic widgetsAppState = tester.state(find.byType(WidgetsApp));
      await widgetsAppState.didPopRoute();
      await tester.pumpAndSettle();

      // Should directly show DialogSair
      expect(find.byType(DialogSair), findsOneWidget);
      expect(find.text(Strings.sairDoTeste), findsOneWidget);
    });

    testWidgets('mini-navigator allows freely navigating between questions without deadlock',
        (WidgetTester tester) async {
      configureViewport(tester);

      await tester.pumpWidget(
        wrapWithScreenUtil(
          const QuestionsPage(),
        ),
      );
      await preloadImages(tester);
      await tester.pumpAndSettle();

      // Jump to question 4 (P5, index 4) via MiniNavigator
      await tester.tap(find.byKey(const Key('mini_nav_question_4')));
      await tester.pumpAndSettle();

      // Answer question 4 with note 9
      final chip9 = find.byKey(const Key('numeric_chip_9'));
      await tester.ensureVisible(chip9);
      await tester.tap(chip9);
      await tester.pumpAndSettle();

      // Jump to question 1 (P2, index 1)
      await tester.tap(find.byKey(const Key('mini_nav_question_1')));
      await tester.pumpAndSettle();

      // Answer question 1 with note 2
      final chip2 = find.byKey(const Key('numeric_chip_2'));
      await tester.ensureVisible(chip2);
      await tester.tap(chip2);
      await tester.pumpAndSettle();

      // Both question 1 (★2 live) and question 4 (★9 committed) are shown in MiniNavigator!
      expect(find.text('★2'), findsOneWidget);
      expect(find.text('★9'), findsOneWidget);
    });

    testWidgets('smart swap triggered when tapping assigned chip and confirms swap',
        (WidgetTester tester) async {
      configureViewport(tester);

      await tester.pumpWidget(
        wrapWithScreenUtil(
          const QuestionsPage(),
        ),
      );
      await preloadImages(tester);
      await tester.pumpAndSettle();

      // On question 0 (P1), select note 4 and click Próximo
      final chip4 = find.byKey(const Key('numeric_chip_4'));
      await tester.ensureVisible(chip4);
      await tester.tap(chip4);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('questions_next_button')));
      await tester.pumpAndSettle();

      // Now on question 1 (P2). Note 4 is assigned to P1.
      expect(find.text('P1'), findsWidgets);

      // Tap chip 4 (which is assigned to P1)
      await tester.ensureVisible(chip4);
      await tester.tap(chip4);
      await tester.pumpAndSettle();

      // SmartSwapModal opens!
      expect(find.byType(SmartSwapModal), findsOneWidget);
      expect(find.text('${Strings.trocarNota} 4?'), findsOneWidget);

      // Confirm swap
      await tester.tap(find.byKey(const Key('smart_swap_confirm_button')));
      await tester.pumpAndSettle();

      // Modal closed, P2 now has note 4!
      expect(find.byType(SmartSwapModal), findsNothing);
      expect(find.text('Nota 4 trocada com sucesso com a Pergunta 1!'), findsOneWidget);
    });

    testWidgets('smart swap preserves uncommitted selection on current question during swap',
        (WidgetTester tester) async {
      configureViewport(tester);

      await tester.pumpWidget(
        wrapWithScreenUtil(
          const QuestionsPage(),
        ),
      );
      await preloadImages(tester);
      await tester.pumpAndSettle();

      // Answer Question 0 (P1) with note 8
      final chip8 = find.byKey(const Key('numeric_chip_8'));
      await tester.ensureVisible(chip8);
      await tester.tap(chip8);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('questions_next_button')));
      await tester.pumpAndSettle();

      // Now on Question 1 (P2). P1 has note 8.
      // User selects chip 3 on Question 1 (uncommitted, does NOT press next)
      final chip3 = find.byKey(const Key('numeric_chip_3'));
      await tester.ensureVisible(chip3);
      await tester.tap(chip3);
      await tester.pumpAndSettle();

      // User now taps chip 8 (assigned to P1) to initiate smart swap
      await tester.ensureVisible(chip8);
      await tester.tap(chip8);
      await tester.pumpAndSettle();

      // SmartSwapModal opens and shows 3 as old note (not Sem nota!)
      expect(find.byType(SmartSwapModal), findsOneWidget);
      expect(find.text('${Strings.trocarNota} 8?'), findsOneWidget);

      // Confirm swap
      await tester.tap(find.byKey(const Key('smart_swap_confirm_button')));
      await tester.pumpAndSettle();

      // Modal closed. P2 has 8, and P1 has 3!
      expect(find.byType(SmartSwapModal), findsNothing);
      expect(find.text('Nota 8 trocada com sucesso com a Pergunta 1!'), findsOneWidget);

      // Verify in MiniNavigator: P1 has ★3 and P2 has ★8!
      expect(
        find.descendant(
          of: find.byKey(const Key('mini_nav_question_0')),
          matching: find.text('★3'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byKey(const Key('mini_nav_question_1')),
          matching: find.text('★8'),
        ),
        findsOneWidget,
      );
    });

    testWidgets(
        'standard vertical spacings hold consistently on iPhone 15 (393x852) and Android (360x800)',
        (WidgetTester tester) async {
      for (final config in [
        (const Size(1179, 2556), 3.0),
        (const Size(720, 1600), 2.0),
      ]) {
        tester.view.physicalSize = config.$1;
        tester.view.devicePixelRatio = config.$2;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          wrapWithScreenUtil(
            const QuestionsPage(),
          ),
        );
        await preloadImages(tester);
        await tester.pumpAndSettle();

        final headerFinder = find.byKey(const Key('questions_header_row'));
        final headerBox = tester.renderObject<RenderBox>(headerFinder);
        final headerBottom =
            headerBox.localToGlobal(Offset.zero).dy + headerBox.size.height;

        final progressFinder = find.byKey(const Key('questions_progress_row'));
        final progressBox = tester.renderObject<RenderBox>(progressFinder);
        final progressTop = progressBox.localToGlobal(Offset.zero).dy;

        final progressBarFinder = find.byKey(const Key('questions_linear_progress'));
        final progressBarBox = tester.renderObject<RenderBox>(progressBarFinder);
        final progressBarBottom =
            progressBarBox.localToGlobal(Offset.zero).dy + progressBarBox.size.height;

        final miniNavFinder = find.byType(MiniNavigator);
        final miniNavBox = tester.renderObject<RenderBox>(miniNavFinder);
        final miniNavTop = miniNavBox.localToGlobal(Offset.zero).dy;
        final miniNavBottom = miniNavTop + miniNavBox.size.height;

        final illustrationFinder =
            find.byKey(const Key('questions_illustration_container'));
        final illustrationBox = tester.renderObject<RenderBox>(illustrationFinder);
        final illustrationTop = illustrationBox.localToGlobal(Offset.zero).dy;

        final statementFinder = find.byKey(const Key('unified_question_statement'));
        final statementBox = tester.renderObject<RenderBox>(statementFinder);
        final statementBottom =
            statementBox.localToGlobal(Offset.zero).dy + statementBox.size.height;

        final instructionFinder = find.text(Strings.avalieComFichas);
        final instructionBox = tester.renderObject<RenderBox>(instructionFinder);
        final instructionTop = instructionBox.localToGlobal(Offset.zero).dy;
        final instructionBottom = instructionTop + instructionBox.size.height;

        final chipsFinder = find.byType(NumericChips);
        final chipsBox = tester.renderObject<RenderBox>(chipsFinder);
        final chipsTop = chipsBox.localToGlobal(Offset.zero).dy;
        final chipsBottom = chipsTop + chipsBox.size.height;

        final nextFinder = find.byKey(const Key('questions_next_button'));
        final nextBox = tester.renderObject<RenderBox>(nextFinder);
        final nextPosition = nextBox.localToGlobal(Offset.zero);
        final nextTop = nextPosition.dy;

        final screenHeight =
            tester.view.physicalSize.height / tester.view.devicePixelRatio;
        final bottomClearance =
            screenHeight - (nextPosition.dy + nextBox.size.height);

        // Top vertical spacings: 8 to 12dp uniform rhythm
        // 1. Between Header and progress row / percentual:
        expect(progressTop - headerBottom, greaterThanOrEqualTo(8.0));
        expect(progressTop - headerBottom, lessThanOrEqualTo(12.0));

        // 2. Between linear progress bar and MiniNavigator:
        expect(miniNavTop - progressBarBottom, greaterThanOrEqualTo(8.0));
        expect(miniNavTop - progressBarBottom, lessThanOrEqualTo(12.0));

        // 3. Between MiniNavigator and illustration container:
        expect(illustrationTop - miniNavBottom, greaterThanOrEqualTo(8.0));
        expect(illustrationTop - miniNavBottom, lessThanOrEqualTo(12.0));

        // Bottom vertical spacings
        expect(instructionTop - statementBottom, greaterThanOrEqualTo(10.0));
        expect(instructionTop - statementBottom, lessThanOrEqualTo(14.0));

        expect(chipsTop - instructionBottom, greaterThanOrEqualTo(8.0));
        expect(chipsTop - instructionBottom, lessThanOrEqualTo(12.0));

        expect(nextTop - chipsBottom, greaterThanOrEqualTo(16.0));
        expect(nextTop - chipsBottom, lessThanOrEqualTo(22.0));

        expect(bottomClearance, greaterThanOrEqualTo(18.0 - 0.05));
        expect(bottomClearance, lessThanOrEqualTo(24.0 + 0.05));
      }
    });

    testWidgets(
        'top vertical items maintain standardized 8-12dp spacing matching bottom rhythm',
        (WidgetTester tester) async {
      configureViewport(tester);

      await tester.pumpWidget(
        wrapWithScreenUtil(
          const QuestionsPage(),
        ),
      );
      await preloadImages(tester);
      await tester.pumpAndSettle();

      final headerFinder = find.byKey(const Key('questions_header_row'));
      final headerBox = tester.renderObject<RenderBox>(headerFinder);
      final headerBottom =
          headerBox.localToGlobal(Offset.zero).dy + headerBox.size.height;

      final progressFinder = find.byKey(const Key('questions_progress_row'));
      final progressBox = tester.renderObject<RenderBox>(progressFinder);
      final progressTop = progressBox.localToGlobal(Offset.zero).dy;

      final progressBarFinder = find.byKey(const Key('questions_linear_progress'));
      final progressBarBox = tester.renderObject<RenderBox>(progressBarFinder);
      final progressBarBottom =
          progressBarBox.localToGlobal(Offset.zero).dy + progressBarBox.size.height;

      final miniNavFinder = find.byType(MiniNavigator);
      final miniNavBox = tester.renderObject<RenderBox>(miniNavFinder);
      final miniNavTop = miniNavBox.localToGlobal(Offset.zero).dy;
      final miniNavBottom = miniNavTop + miniNavBox.size.height;

      final illustrationFinder =
          find.byKey(const Key('questions_illustration_container'));
      final illustrationBox = tester.renderObject<RenderBox>(illustrationFinder);
      final illustrationTop = illustrationBox.localToGlobal(Offset.zero).dy;

      // 1. Between Header and progress row / percentual: 8-12dp
      final gapHeaderToProgress = progressTop - headerBottom;
      expect(gapHeaderToProgress, greaterThanOrEqualTo(8.0));
      expect(gapHeaderToProgress, lessThanOrEqualTo(12.0));

      // 2. Between LinearProgressIndicator and MiniNavigator: 8-12dp
      final gapProgressToMiniNav = miniNavTop - progressBarBottom;
      expect(gapProgressToMiniNav, greaterThanOrEqualTo(8.0));
      expect(gapProgressToMiniNav, lessThanOrEqualTo(12.0));

      // 3. Between MiniNavigator and illustration container: 8-12dp
      final gapMiniNavToIllustration = illustrationTop - miniNavBottom;
      expect(gapMiniNavToIllustration, greaterThanOrEqualTo(8.0));
      expect(gapMiniNavToIllustration, lessThanOrEqualTo(12.0));
    });
  });
}
