import 'dart:math' as math;
import 'dart:typed_data';

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

/// A purely functional random number generator.
///
/// All operations are suspended in [IO] to preserve referential transparency.
/// Construct via [Random.new] for a standard (optionally seeded) generator,
/// or [Random.secure] for a cryptographically secure source.
///
/// ```dart
/// final rand = Random(42); // seeded, reproducible
/// final n = await rand.nextIntBounded(100).unsafeRunFuture(); // 0..99
/// ```
abstract class Random {
  /// Creates a random number generator, optionally seeded with [seed].
  ///
  /// When [seed] is provided, the sequence of values produced is
  /// deterministic and reproducible — useful for tests. When omitted, the
  /// generator is seeded from the platform's default entropy source.
  factory Random([int? seed]) => RandomImpl(math.Random(seed));

  /// Creates a cryptographically secure random number generator.
  ///
  /// Suitable for security-sensitive use cases such as token generation.
  /// Backed by [dart:math]'s `Random.secure()`.
  factory Random.secure() => RandomImpl(math.Random.secure());

  Random._();

  /// Returns a random [double] in the range `[minInclusive, maxExclusive)`.
  ///
  /// Throws [ArgumentError] if `maxExclusive <= minInclusive`.
  IO<double> betweenDouble(double minInclusive, double maxExclusive);

  /// Returns a random [int] in the range `[minInclusive, maxExclusive)`.
  ///
  /// Throws [ArgumentError] if `maxExclusive <= minInclusive`.
  /// When the interval size exceeds [int] max value, rejection sampling is
  /// used to guarantee uniform distribution.
  IO<int> betweenInt(int minInclusive, int maxExclusive);

  /// Returns a random [bool].
  IO<bool> nextBoolean();

  /// Returns a random [double] in the range `[0.0, 1.0)`.
  IO<double> nextDouble();

  /// Returns a random [double] sampled from the standard normal distribution
  /// (mean 0, standard deviation 1) using the Box-Muller transform.
  IO<double> nextGaussian();

  /// Returns a random non-negative [int] less than `2147483647`.
  IO<int> nextInt();

  /// Returns a random [int] in the range `[0, n)`.
  IO<int> nextIntBounded(int n);

  /// Returns a randomly selected element from `a` and `xs`.
  ///
  /// When [xs] is empty, [a] is always returned. Otherwise, each element
  /// (including [a]) has an equal probability of being selected.
  IO<A> oneOf<A>(A a, RIterable<A> xs) {
    if (xs.isEmpty) {
      return IO.pure(a);
    } else {
      return nextIntBounded(1 + xs.size).map((idx) => idx == 0 ? a : xs.drop(idx - 1).head);
    }
  }
}

/// Default [Random] implementation backed by [dart:math]'s [math.Random].
class RandomImpl extends Random {
  final math.Random rand;

  RandomImpl(this.rand) : super._();

  @override
  IO<double> betweenDouble(double minInclusive, double maxExclusive) {
    if (maxExclusive <= minInclusive) {
      throw ArgumentError(
        'Random.betweenDouble: min must be < max, was: $minInclusive, $maxExclusive',
      );
    }

    return nextDouble().map((d) {
      final diff = maxExclusive - minInclusive;

      final double next;

      if (diff < double.infinity) {
        next = (d * diff) + minInclusive;
      } else {
        // overflow
        final maxHalf = maxExclusive / 2.0;
        final minHalf = maxExclusive / 2.0;

        next = ((d * (maxHalf - minHalf)) + minHalf) * 2.0;
      }

      if (next < maxExclusive) {
        return next;
      } else {
        return nextAfter(maxExclusive, double.negativeInfinity);
      }
    });
  }

  @override
  IO<int> betweenInt(int minInclusive, int maxExclusive) {
    if (maxExclusive <= minInclusive) {
      throw ArgumentError(
        'Random.betweenInt: min must be < max, was: $minInclusive, $maxExclusive',
      );
    }

    final difference = maxExclusive - minInclusive;

    if (difference >= 0) {
      return nextIntBounded(difference).map((n) => n + minInclusive);
    } else {
      // interval size is greater than Integer.maxValue
      IO<int> loop() => nextInt().flatMap((n) {
        if (n >= minInclusive && n < maxExclusive) {
          return IO.pure(n);
        } else {
          return loop();
        }
      });

      return loop();
    }
  }

  @override
  IO<bool> nextBoolean() => IO.delay(() => rand.nextBool());

  @override
  IO<double> nextDouble() => IO.delay(() => rand.nextDouble());

  @override
  IO<double> nextGaussian() => IO.delay(() {
    final u1 = rand.nextDouble();
    final u2 = rand.nextDouble();

    // Standard normal dist (Box-Muller)
    return math.sqrt(-2.0 * math.log(u1)) * math.sin(2.0 * math.pi * u2);
  });

  @override
  IO<int> nextInt() => IO.delay(() => rand.nextInt(2147483647));

  @override
  IO<int> nextIntBounded(int n) => IO.delay(() => rand.nextInt(n));
}

/// Returns the adjacent floating-point value of [start] in the direction of
/// [direction], using IEEE 754 bit-level manipulation.
///
/// Special cases:
/// - Returns `NaN` if either [start] or [direction] is `NaN`.
/// - Returns [direction] if `start == direction` (handles `+0.0` vs `-0.0`).
/// - Returns the smallest positive/negative subnormal if [start] is `0.0`.
double nextAfter(double start, double direction) {
  if (start.isNaN || direction.isNaN) {
    return double.nan;
  } else if (start == direction) {
    // if equal, or both zero, return direction (handle +0.0 vs -0.0)
    return direction;
  } else if (start == 0.0) {
    // step away from zero in the indicated direction
    return direction > 0 ? 5e-324 : -5e-324;
  } else {
    // Use IEEE 754 bit representation to increment/decrement
    final byteData = ByteData(8);
    byteData.setFloat64(0, start, Endian.little);

    int bits = byteData.getInt64(0, Endian.little);

    // if moving tower direction, increment magnitude, otherwise decrement
    if ((direction > start) == (start > 0)) {
      bits++;
    } else {
      bits--;
    }

    byteData.setInt64(0, bits, Endian.little);

    return byteData.getFloat64(0, Endian.little);
  }
}
