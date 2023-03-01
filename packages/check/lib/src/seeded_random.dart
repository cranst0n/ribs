import 'dart:math';

import 'package:ribs_core/ribs_core.dart';

class StatefulRandom {
  final int? _seed;

  const StatefulRandom([this._seed]);

  Tuple2<StatefulRandom, bool> get nextBool => _next((rnd) => rnd.nextBool());

  Tuple2<StatefulRandom, double> get nextDouble =>
      _next((rnd) => rnd.nextDouble());

  Tuple2<StatefulRandom, int> nextInt(int max) =>
      _next((rnd) => rnd.nextInt(max));

  Tuple2<StatefulRandom, T> _next<T>(Function1<Random, T> f) =>
      Tuple2(StatefulRandom(_nextSeed), f(_random));

  int get _nextSeed => _random.nextInt(pow(2, 32).toInt());

  Random get _random => Random(_seed);
}
