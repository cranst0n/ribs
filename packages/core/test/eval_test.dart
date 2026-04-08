import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

void main() {
  group('Eval.now', () {
    test('returns the value immediately', () {
      expect(Eval.now(42).value, 42);
    });

    test('memoize returns itself', () {
      final e = Eval.now('hello');
      expect(identical(e.memoize(), e), isTrue);
    });
  });

  group('Eval.later', () {
    test('evaluates lazily on first access', () {
      var called = 0;
      final e = Eval.later(() => ++called);
      expect(called, 0);
      expect(e.value, 1);
      expect(called, 1);
    });

    test('memoizes: function called at most once', () {
      var called = 0;
      final e = Eval.later(() => ++called);
      e.value;
      e.value;
      e.value;
      expect(called, 1);
    });

    test('memoize returns itself', () {
      final e = Eval.later(() => 1);
      expect(identical(e.memoize(), e), isTrue);
    });
  });

  group('Eval.always', () {
    test('recomputes value on every access', () {
      var called = 0;
      final e = Eval.always(() => ++called);
      expect(e.value, 1);
      expect(e.value, 2);
      expect(e.value, 3);
    });

    test('memoize wraps in a later', () {
      var called = 0;
      final memoized = Eval.always(() => ++called).memoize();
      expect(memoized.value, 1);
      expect(memoized.value, 1);
      expect(called, 1);
    });
  });

  group('Eval.defer', () {
    test('defers evaluation of another Eval', () {
      var called = 0;
      final e = Eval.defer(() {
        called++;
        return Eval.now(42);
      });
      expect(called, 0);
      expect(e.value, 42);
      expect(called, 1);
    });

    test('supports recursive definitions without stack overflow', () {
      Eval<int> sum(int n, int acc) =>
          n <= 0 ? Eval.now(acc) : Eval.defer(() => sum(n - 1, acc + n));

      expect(sum(100000, 0).value, 5000050000);
    });
  });

  group('Eval.pure', () {
    test('is an alias for now', () {
      expect(Eval.pure(7).value, 7);
    });
  });

  group('Eval.unit', () {
    test('evaluates to Unit', () {
      expect(Eval.unit.value, Unit.instance);
    });
  });

  group('map', () {
    test('transforms the value', () {
      expect(Eval.now(3).map((n) => n * 2).value, 6);
    });

    test('chains multiple maps', () {
      expect(
        Eval.now(1).map((n) => n + 1).map((n) => n * 10).value,
        20,
      );
    });
  });

  group('flatMap', () {
    test('chains evaluations', () {
      final result = Eval.now(3).flatMap((n) => Eval.now(n * 2));
      expect(result.value, 6);
    });

    test('is stack-safe for deeply nested chains', () {
      var e = Eval.now(0);
      for (var i = 0; i < 100000; i++) {
        e = e.flatMap((n) => Eval.now(n + 1));
      }
      expect(e.value, 100000);
    });

    test('interleaves now, later, and always', () {
      var sideEffect = 0;
      final result = Eval.now(1)
          .flatMap((a) => Eval.later(() => a + 1))
          .flatMap(
            (b) => Eval.always(() {
              sideEffect++;
              return b + 1;
            }),
          )
          .flatMap((c) => Eval.now(c * 10));
      expect(result.value, 30);
      expect(sideEffect, 1);
    });
  });

  group('memoize', () {
    test('always.memoize evaluates once', () {
      var called = 0;
      final m = Eval.always(() => ++called).memoize();
      m.value;
      m.value;
      expect(called, 1);
    });

    test('flatMap chain .memoize evaluates once', () {
      var called = 0;
      final m =
          Eval.now(1)
              .flatMap(
                (n) => Eval.always(() {
                  called++;
                  return n + 1;
                }),
              )
              .memoize();
      m.value;
      m.value;
      expect(called, 1);
    });
  });

  group('flatten', () {
    test('flattens nested Eval', () {
      final nested = Eval.now(Eval.now(42));
      expect(nested.flatten().value, 42);
    });
  });

  group('EvalOps', () {
    test('productL discards right result', () {
      expect(Eval.now(1).productL(Eval.now(2)).value, 1);
    });

    test('productR discards left result', () {
      expect(Eval.now(1).productR(Eval.now(2)).value, 2);
    });
  });
}
