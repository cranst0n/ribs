import 'dart:math';

import 'package:ribs_core/ribs_core.dart';

/// A pseudo-random number generator that threads its state immutably.
///
/// Each `next*` method returns a pair of the updated [StatefulRandom] and the
/// generated value, leaving the original instance unchanged.  Passing the same
/// seed to [StatefulRandom] always reproduces the exact same sequence of
/// values, making test failures easy to reproduce.
final class StatefulRandom {
  final int? _seed;

  /// Creates a [StatefulRandom] with an optional [seed].
  ///
  /// If [seed] is omitted the generator is unseeded and non-reproducible.
  const StatefulRandom([this._seed]);

  /// The seed currently held by this instance, or `null` if unseeded.
  int? get currentSeed => _seed;

  /// Returns the next boolean value together with the updated generator.
  (StatefulRandom, bool) nextBool() => _next((rnd) => rnd.nextBool());

  /// Returns the next double in `[0.0, 1.0)` together with the updated
  /// generator.
  (StatefulRandom, double) nextDouble() => _next((rnd) => rnd.nextDouble());

  /// Returns the next non-negative integer below [maximum] together with the
  /// updated generator.
  ///
  /// Values beyond the signed 32-bit limit are handled by splitting the draw
  /// into two smaller requests and combining their bits, keeping the
  /// distribution uniform.
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

          if (_kIsWeb) {
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

const bool _kIsWeb = bool.fromEnvironment('dart.library.js_util');
