import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/ribs_effect_test.dart';
import 'package:ribs_effect/src/std/random.dart';
import 'package:test/test.dart';

void main() {
  group('Random', () {
    final rand = Random(42);

    group('constructors', () {
      test('Random() creates a working instance', () {
        expect(Random().nextInt(), succeeds(isA<int>()));
      });

      test('Random(seed) creates a seeded instance', () {
        expect(Random(123).nextInt(), succeeds(isA<int>()));
      });

      test('Random.secure() creates a secure instance', () {
        expect(Random.secure().nextBoolean(), succeeds(isA<bool>()));
      });
    });

    group('nextBoolean', () {
      test('returns a bool', () {
        expect(rand.nextBoolean(), succeeds(isA<bool>()));
      });
    });

    group('nextDouble', () {
      test('returns value in [0.0, 1.0)', () {
        final test = rand.nextDouble().flatMap((d) {
          return expectIO(d, allOf(greaterThanOrEqualTo(0.0), lessThan(1.0)));
        });
        expect(test, succeeds());
      });
    });

    group('nextGaussian', () {
      test('returns a double', () {
        expect(rand.nextGaussian(), succeeds(isA<double>()));
      });

      test('multiple samples are not all identical', () {
        final test = rand.nextGaussian().flatMap((a) {
          return rand.nextGaussian().flatMap((b) {
            return expectIO(a == b, isFalse);
          });
        });
        expect(test, succeeds());
      });
    });

    group('nextInt', () {
      test('returns non-negative int less than 2147483647', () {
        final test = rand.nextInt().flatMap((n) {
          return expectIO(n, allOf(greaterThanOrEqualTo(0), lessThan(2147483647)));
        });
        expect(test, succeeds());
      });
    });

    group('nextIntBounded', () {
      test('returns value in [0, n)', () {
        const bound = 100;
        final test = rand.nextIntBounded(bound).flatMap((n) {
          return expectIO(n, allOf(greaterThanOrEqualTo(0), lessThan(bound)));
        });
        expect(test, succeeds());
      });

      test('always returns 0 when bound is 1', () {
        expect(rand.nextIntBounded(1), succeeds(0));
      });

      test('multiple calls stay within bound', () {
        const bound = 10;
        final test = rand.nextIntBounded(bound).replicate(20).flatMap((results) {
          return results.foldLeft<IO<Unit>>(IO.unit, (acc, n) {
            return acc.flatMap((_) {
              return expectIO(n, allOf(greaterThanOrEqualTo(0), lessThan(bound)));
            });
          });
        });
        expect(test, succeeds());
      });
    });

    group('betweenInt', () {
      test('returns value in [min, max)', () {
        const min = 10;
        const max = 20;
        final test = rand.betweenInt(min, max).flatMap((n) {
          return expectIO(n, allOf(greaterThanOrEqualTo(min), lessThan(max)));
        });
        expect(test, succeeds());
      });

      test('handles negative range', () {
        const min = -100;
        const max = -50;
        final test = rand.betweenInt(min, max).flatMap((n) {
          return expectIO(n, allOf(greaterThanOrEqualTo(min), lessThan(max)));
        });
        expect(test, succeeds());
      });

      test('handles range spanning zero', () {
        const min = -5;
        const max = 5;
        final test = rand.betweenInt(min, max).flatMap((n) {
          return expectIO(n, allOf(greaterThanOrEqualTo(min), lessThan(max)));
        });
        expect(test, succeeds());
      });

      test('throws ArgumentError when min equals max', () {
        expect(() => rand.betweenInt(5, 5), throwsA(isA<ArgumentError>()));
      });

      test('throws ArgumentError when min exceeds max', () {
        expect(() => rand.betweenInt(10, 5), throwsA(isA<ArgumentError>()));
      });
    });

    group('betweenDouble', () {
      test('returns value in [min, max)', () {
        const min = 1.5;
        const max = 3.5;
        final test = rand.betweenDouble(min, max).flatMap((d) {
          return expectIO(d, allOf(greaterThanOrEqualTo(min), lessThan(max)));
        });
        expect(test, succeeds());
      });

      test('handles negative range', () {
        const min = -5.0;
        const max = -1.0;
        final test = rand.betweenDouble(min, max).flatMap((d) {
          return expectIO(d, allOf(greaterThanOrEqualTo(min), lessThan(max)));
        });
        expect(test, succeeds());
      });

      test('handles range spanning zero', () {
        const min = -1.0;
        const max = 1.0;
        final test = rand.betweenDouble(min, max).flatMap((d) {
          return expectIO(d, allOf(greaterThanOrEqualTo(min), lessThan(max)));
        });
        expect(test, succeeds());
      });

      test('throws ArgumentError when min equals max', () {
        expect(() => rand.betweenDouble(1.0, 1.0), throwsA(isA<ArgumentError>()));
      });

      test('throws ArgumentError when min exceeds max', () {
        expect(() => rand.betweenDouble(3.0, 1.0), throwsA(isA<ArgumentError>()));
      });
    });

    group('oneOf', () {
      test('returns a when xs is empty', () {
        expect(rand.oneOf(42, nil<int>()), succeeds(42));
      });

      test('returns one of the provided values', () {
        const all = [1, 2, 3, 4];
        final test = rand.oneOf(all[0], ilist(all.sublist(1))).flatMap((n) {
          return expectIO(all.contains(n), isTrue);
        });
        expect(test, succeeds());
      });

      test('can return any element including the head', () {
        const all = ['a', 'b', 'c'];
        final test = rand.oneOf(all[0], ilist(all.sublist(1))).flatMap((s) {
          return expectIO(all.contains(s), isTrue);
        });
        expect(test, succeeds());
      });
    });
  });

  group('nextAfter', () {
    test('returns NaN when start is NaN', () {
      expect(nextAfter(double.nan, 1.0).isNaN, isTrue);
    });

    test('returns NaN when direction is NaN', () {
      expect(nextAfter(1.0, double.nan).isNaN, isTrue);
    });

    test('returns direction when start equals direction', () {
      expect(nextAfter(1.0, 1.0), equals(1.0));
    });

    test('returns direction for positive zero == negative zero', () {
      expect(nextAfter(0.0, -0.0), equals(-0.0));
    });

    test('steps away from zero towards positive infinity', () {
      expect(nextAfter(0.0, 1.0), equals(5e-324));
    });

    test('steps away from zero towards negative infinity', () {
      expect(nextAfter(0.0, -1.0), equals(-5e-324));
    });

    test('returns the next representable double towards positive infinity', () {
      expect(nextAfter(1.0, double.infinity), greaterThan(1.0));
    });

    test('returns the next representable double towards negative infinity', () {
      expect(nextAfter(1.0, double.negativeInfinity), lessThan(1.0));
    });

    test('returns the next representable double for a negative value towards zero', () {
      expect(nextAfter(-1.0, 0.0), greaterThan(-1.0));
    });

    test('returns the next representable double for a negative value away from zero', () {
      expect(nextAfter(-1.0, double.negativeInfinity), lessThan(-1.0));
    });

    test('result is distinct from start', () {
      expect(nextAfter(2.0, double.infinity), isNot(equals(2.0)));
    });
  });
}
