import 'package:flutter_test/flutter_test.dart';
import 'package:inteligencias_multiplas/utils/perguntas.dart';

void main() {
  group('Perguntas list structure and bounds', () {
    test('perguntas has 10 steps', () {
      expect(perguntas.length, 10);
    });

    test('each step in perguntas has exactly 7 questions', () {
      for (int step = 0; step < perguntas.length; step++) {
        final stepQuestions = perguntas[step] as List;
        expect(stepQuestions.length, 7,
            reason: 'Step $step must contain exactly 7 questions');
      }
    });

    test(
        'clamped safe index access never throws RangeError for out-of-bounds indices',
        () {
      // Test negative, boundary, and out-of-range indices (like 7, 10, -1)
      for (int testStep in [-1, 0, 5, 9, 10, 99]) {
        for (int testQuestion in [-1, 0, 6, 7, 10, 99]) {
          final int safeStep = testStep.clamp(0, perguntas.length - 1);
          final int safeQuestion =
              testQuestion.clamp(0, (perguntas[safeStep] as List).length - 1);

          expect(() => perguntas[safeStep][safeQuestion], returnsNormally);
          expect(perguntas[safeStep][safeQuestion], isA<String>());
        }
      }
    });
  });

  group('Question navigation next-question algorithm', () {
    int obterProximaPergunta(List<int> respostasEtapa, int currentQuestion) {
      for (int i = 0; i < 7; i++) {
        int next = (currentQuestion + i) % 7;
        if (respostasEtapa[next] == 0) {
          return next;
        }
      }
      return 7;
    }

    test('finds next unanswered question sequentially', () {
      List<int> stepAnswers = [1, 2, 0, 0, 0, 0, 0];
      int next = obterProximaPergunta(stepAnswers, 1);
      expect(next, 2);
    });

    test('finds earlier unanswered question when current question was edited',
        () {
      // Question 1 was edited and cleared to 0, current question is 5
      List<int> stepAnswers = [1, 0, 3, 4, 5, 6, 0];
      int next = obterProximaPergunta(stepAnswers, 5);
      // Next after 5 is question 6 (which is 0)
      expect(next, 6);

      // Now question 6 is also answered, current question is 6
      stepAnswers[6] = 7;
      next = obterProximaPergunta(stepAnswers, 6);
      // It wraps around and finds question 1 (which is 0)!
      expect(next, 1);
    });

    test('returns 7 when all questions are answered', () {
      List<int> stepAnswers = [1, 2, 3, 4, 5, 6, 7];
      int next = obterProximaPergunta(stepAnswers, 6);
      expect(next, 7);
    });

    test('freeing star in listaJaRespondida uses previous star minus 1', () {
      var listaJaRespondida = [true, true, true, true, true, true, true];
      int previousStar = 5; // answered with 5 stars

      // When editing:
      if (previousStar >= 1 && previousStar <= 7) {
        listaJaRespondida[previousStar - 1] = false;
      }

      // Star 5 (index 4) is now available (false), others remain true
      expect(listaJaRespondida[4], isFalse);
      expect(listaJaRespondida[0], isTrue);
      expect(listaJaRespondida[1], isTrue);
      expect(listaJaRespondida[2], isTrue);
      expect(listaJaRespondida[3], isTrue);
      expect(listaJaRespondida[5], isTrue);
      expect(listaJaRespondida[6], isTrue);
    });
  });
}
