import 'dart:math';

import '../../core/utils/rng.dart';
import 'models.dart';

class QuestionGenerator {
  QuestionGenerator({Difficulty? difficulty, int? seed})
      : _difficulty = difficulty,
        _random = AppRandom(seed);

  final Difficulty? _difficulty;
  final AppRandom _random;

  Question nextQuestion(Difficulty difficulty) {
    final level = _difficulty ?? difficulty;
    switch (level) {
      case Difficulty.easy:
        return _generateEasy();
      case Difficulty.medium:
        return _generateMedium();
      case Difficulty.hard:
        return _generateHard();
    }
  }

  Question _generateEasy() {
    final operations = ['+', '-'];
    final op = _random.pick(operations);
    int a = _random.nextInt(21);
    int b = _random.nextInt(21);
    if (op == '-') {
      if (b > a) {
        final temp = a;
        a = b;
        b = temp;
      }
    }
    final answer = _compute(a, b, op);
    final options = _generateOptions(answer, Difficulty.easy);
    return Question(a: a, b: b, operator: op, answer: answer, options: options);
  }

  Question _generateMedium() {
    final operations = ['+', '-', '×'];
    final op = _random.pick(operations);
    int max = 51;
    int a = _random.nextInt(max);
    int b = _random.nextInt(max);
    if (op == '-') {
      if (b > a) {
        final temp = a;
        a = b;
        b = temp;
      }
    } else if (op == '×') {
      a = _random.nextInt(13);
      b = _random.nextInt(13);
    }
    final answer = _compute(a, b, op);
    final options = _generateOptions(answer, Difficulty.medium);
    return Question(a: a, b: b, operator: op, answer: answer, options: options);
  }

  Question _generateHard() {
    final operations = ['+', '-', '×', '÷'];
    final op = _random.pick(operations);
    int a;
    int b;
    if (op == '÷') {
      b = max(1, _random.nextInt(12) + 1);
      final answer = _random.nextInt(13);
      a = answer * b;
      final options = _generateOptions(answer, Difficulty.hard);
      return Question(a: a, b: b, operator: op, answer: answer, options: options);
    }
    a = _random.nextInt(100);
    b = _random.nextInt(100);
    if (op == '-') {
      if (b > a) {
        final temp = a;
        a = b;
        b = temp;
      }
    } else if (op == '×') {
      a = _random.nextInt(15);
      b = _random.nextInt(15);
    }
    final answer = _compute(a, b, op);
    final options = _generateOptions(answer, Difficulty.hard);
    return Question(a: a, b: b, operator: op, answer: answer, options: options);
  }

  int _compute(int a, int b, String op) {
    switch (op) {
      case '+':
        return a + b;
      case '-':
        return a - b;
      case '×':
        return a * b;
      case '÷':
        return b == 0 ? 0 : a ~/ b;
      default:
        return 0;
    }
  }

  List<int> _generateOptions(int correct, Difficulty difficulty) {
    final options = <int>{correct};
    final deltaBase = switch (difficulty) {
      Difficulty.easy => 2,
      Difficulty.medium => 5,
      Difficulty.hard => 8,
    };
    while (options.length < 4) {
      final sign = _random.nextBool() ? 1 : -1;
      final delta = deltaBase + _random.nextInt(deltaBase + 5);
      final candidate = max(0, correct + sign * delta);
      options.add(candidate);
    }
    final list = options.toList();
    _random.shuffle(list);
    return list;
  }
}
