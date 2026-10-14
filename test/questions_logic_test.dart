import 'package:flutter_test/flutter_test.dart';
import 'package:inteligencias_multiplas/utils/etapas.dart';
import 'package:inteligencias_multiplas/utils/perguntas.dart';
import 'package:inteligencias_multiplas/utils/strings.dart';

void main() {
  group('Question illustration mapping per intelligence', () {
    test('ilustracoesPerguntas has exactly 9 assets matching the results style', () {
      expect(Strings.ilustracoesPerguntas.length, 9);
      expect(Strings.ilustracoesPerguntas[0], Strings.cinestesicaAsset);
      expect(Strings.ilustracoesPerguntas[1], Strings.espacialAsset);
      expect(Strings.ilustracoesPerguntas[2], Strings.interpessoalAsset);
      expect(Strings.ilustracoesPerguntas[3], Strings.intrapessoalAsset);
      expect(Strings.ilustracoesPerguntas[4], Strings.linguisticoAsset);
      expect(Strings.ilustracoesPerguntas[5], Strings.logicoAsset);
      expect(Strings.ilustracoesPerguntas[6], Strings.musicalAsset);
      expect(Strings.ilustracoesPerguntas[7], Strings.naturalistaAsset);
      expect(Strings.ilustracoesPerguntas[8], Strings.existencialAsset);
    });

    test('all illustration assets point to assets/resultado/ pattern', () {
      for (final asset in Strings.ilustracoesPerguntas) {
        expect(asset.startsWith('assets/resultado/'), isTrue);
        expect(asset.endsWith('.png'), isTrue);
      }
    });
  });

  group('Etapas and Perguntas list structure and bounds', () {
    test('etapas and perguntas have 10 steps', () {
      expect(etapas.length, 10);
      expect(perguntas.length, 10);
    });

    test('step title (etapas) differs from individual question text (perguntas)', () {
      for (int step = 0; step < 10; step++) {
        final stepTitle = etapas[step] as String;
        expect(stepTitle.isNotEmpty, isTrue);
        for (int q = 0; q < 9; q++) {
          final question = perguntas[step][q] as String;
          expect(stepTitle, isNot(equals(question)),
              reason:
                  'Stage $step title "$stepTitle" must not be identical to question "$question"');
        }
      }
    });

    test('Etapa 4 has distinct title and questions', () {
      expect(etapas[3], 'O tipo de pergunta que mais faço é?');
      expect(perguntas[3][0], 'Onde?');
      expect(perguntas[3][1], 'Como?');
      expect(perguntas[3][7], 'Qual tipo?');
      expect(perguntas[3][8], 'Qual o sentido?');
    });

    test('each step in perguntas has exactly 9 questions', () {
      for (int step = 0; step < perguntas.length; step++) {
        final stepQuestions = perguntas[step] as List;
        expect(stepQuestions.length, 9,
            reason: 'Step $step must contain exactly 9 questions');
      }
    });

    test(
        'clamped safe index access never throws RangeError for out-of-bounds indices',
        () {
      // Test negative, boundary, and out-of-range indices (like 9, 10, -1)
      for (int testStep in [-1, 0, 5, 9, 10, 99]) {
        for (int testQuestion in [-1, 0, 8, 9, 10, 99]) {
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
      for (int i = 0; i < 9; i++) {
        int next = (currentQuestion + i) % 9;
        if (respostasEtapa[next] == 0) {
          return next;
        }
      }
      return 9;
    }

    test('finds next unanswered question sequentially', () {
      List<int> stepAnswers = [1, 2, 0, 0, 0, 0, 0, 0, 0];
      int next = obterProximaPergunta(stepAnswers, 1);
      expect(next, 2);
    });

    test('finds earlier unanswered question when current question was edited',
        () {
      // Question 1 was edited and cleared to 0, current question is 7
      List<int> stepAnswers = [1, 0, 3, 4, 5, 6, 7, 8, 0];
      int next = obterProximaPergunta(stepAnswers, 7);
      // Next after 7 is question 8 (which is 0)
      expect(next, 8);

      // Now question 8 is also answered, current question is 8
      stepAnswers[8] = 9;
      next = obterProximaPergunta(stepAnswers, 8);
      // It wraps around and finds question 1 (which is 0)!
      expect(next, 1);
    });

    test('returns 9 when all questions are answered', () {
      List<int> stepAnswers = [1, 2, 3, 4, 5, 6, 7, 8, 9];
      int next = obterProximaPergunta(stepAnswers, 8);
      expect(next, 9);
    });

    test('freeing star in listaJaRespondida uses previous star minus 1', () {
      var listaJaRespondida = List.filled(9, true);
      int previousStar = 5; // answered with 5 stars

      // When editing:
      if (previousStar >= 1 && previousStar <= 9) {
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
      expect(listaJaRespondida[7], isTrue);
      expect(listaJaRespondida[8], isTrue);
    });
  });
}
