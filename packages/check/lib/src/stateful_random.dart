import 'dart:math';

import 'package:ribs_core/ribs_core.dart';

final class StatefulRandom {
  final int? _seed;

  const StatefulRandom([this._seed]);

  int? get currentSeed => _seed;

  (StatefulRandom, bool) nextBool() => _next((rnd) => rnd.nextBool());

  (StatefulRandom, double) nextDouble() => _next((rnd) => rnd.nextDouble());

  (StatefulRandom, int) nextInt(int max) {
    if (kIsWeb || max <= (1 << 32)) {
      return _next((rnd) => rnd.nextInt(max));
    } else {
      // big numbers
      final nBits = (log(max) / log(2) + 1).floor();
      final bitsA = nBits ~/ 2;
      final bitsB = nBits - bitsA;

      return _next((rnd) {
        final a = rnd.nextInt(2 ^ bitsA);
        final b = rnd.nextInt(2 ^ bitsB);
        return a << bitsB | b;
      });
    }
  }

  (StatefulRandom, T) _next<T>(Function1<Random, T> f) =>
      (StatefulRandom(_nextSeed()), f(_random));

  int _nextSeed() => _random.nextInt(pow(2, 32).toInt());

  Random get _random => Random(_seed);
}

const bool kIsWeb = bool.fromEnvironment('dart.library.js_util');
