import 'package:flutter_test/flutter_test.dart';

import 'package:math_speed_test_brain_challenge/features/game/models.dart';
import 'package:math_speed_test_brain_challenge/features/game/question_generator.dart';

void main() {
  group('QuestionGenerator', () {
    test('options contain unique values and include answer', () {
      final generator = QuestionGenerator(seed: 42);
      final question = generator.nextQuestion(Difficulty.medium);
      expect(question.options.toSet().length, question.options.length);
      expect(question.options, contains(question.answer));
    });

    test('hard difficulty division questions produce integer results', () {
      final generator = QuestionGenerator(seed: 88);
      for (var i = 0; i < 20; i++) {
        final question = generator.nextQuestion(Difficulty.hard);
        if (question.operator == '÷') {
          expect(question.a % question.b, equals(0));
        }
      }
    });

    test('easy subtraction never negative', () {
      final generator = QuestionGenerator(seed: 7);
      for (var i = 0; i < 20; i++) {
        final question = generator.nextQuestion(Difficulty.easy);
        if (question.operator == '-') {
          expect(question.a - question.b >= 0, isTrue);
        }
      }
    });
  });
}
