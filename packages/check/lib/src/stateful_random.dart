import 'dart:math';

import 'package:ribs_core/ribs_core.dart';

final class StatefulRandom {
  final int? _seed;

  const StatefulRandom([this._seed]);

  int? get currentSeed => _seed;

  (StatefulRandom, bool) nextBool() => _next((rnd) => rnd.nextBool());

  (StatefulRandom, double) nextDouble() => _next((rnd) => rnd.nextDouble());

  (StatefulRandom, int) nextInt(int maximum) {
    final maxExclusive = max(maximum, 1);

    // Use signed 32-bit max (2^31 - 1) as safe limit for web
    // This avoids potentially ambiguous unsigned 32-bit behavior in some environments
    const safeWebLimit = 2147483647;

    if (maxExclusive <= safeWebLimit) {
      return _next((rnd) => rnd.nextInt(maxExclusive));
    } else {
      // big numbers
      final nBits = (log(maxExclusive) / ln2 + 1).floor();
      final bitsA = nBits ~/ 2;
      final bitsB = nBits - bitsA;

      return _next((rnd) {
        int result;
        do {
          final a = rnd.nextInt(pow(2, bitsA).toInt());
          final b = rnd.nextInt(pow(2, bitsB).toInt());

          if (kIsWeb) {
            result = (a * pow(2, bitsB).toInt()) + b;
          } else {
            result = (a << bitsB) | b;
          }
        } while (result < 0 || result >= maxExclusive);

        return result;
      });
    }
  }

  (StatefulRandom, T) _next<T>(Function1<Random, T> f) => (StatefulRandom(_nextSeed()), f(_random));

  // Use signed 32-bit max for seed generation to be strict safe
  int _nextSeed() => _random.nextInt(2147483647);

  Random get _random => Random(_seed);
}

const bool kIsWeb = bool.fromEnvironment('dart.library.js_util');
