import 'dart:math';

import 'package:ribs_core/ribs_core.dart';

final class StatefulRandom {
  final int? _seed;

  const StatefulRandom([this._seed]);

  (StatefulRandom, bool) nextBool() => _next((rnd) => rnd.nextBool());

  (StatefulRandom, double) nextDouble() => _next((rnd) => rnd.nextDouble());

  (StatefulRandom, int) nextInt(int max) => _next((rnd) => rnd.nextInt(max));

  (StatefulRandom, T) _next<T>(Function1<Random, T> f) =>
      (StatefulRandom(_nextSeed()), f(_random));

  int _nextSeed() => _random.nextInt(pow(2, 32).toInt());

  Random get _random => Random(_seed);
}
