import 'dart:math';

class AppRandom {
  AppRandom([int? seed]) : _random = Random(seed);

  final Random _random;

  int nextInt(int max) => _random.nextInt(max);

  double nextDouble() => _random.nextDouble();

  bool nextBool() => _random.nextBool();

  T pick<T>(List<T> items) => items[_random.nextInt(items.length)];

  void shuffle<T>(List<T> list) => list.shuffle(_random);
}
