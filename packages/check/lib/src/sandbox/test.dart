import 'dart:math';

import 'package:meta/meta.dart';
import 'package:ribs_check/src/sandbox/gen2.dart';
import 'package:ribs_check/src/sandbox/prop2.dart';
import 'package:ribs_check/src/sandbox/seed.dart';
import 'package:ribs_check/src/sandbox/shrink.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

final class Test {
  static TestResult check(String name, TestParameters params, Prop2 p) {
    final iterations = params.minSuccessfulTests;
    final sizeStep = (params.maxSize - params.minSize) / iterations;
    final maxSpinsBetween = max(params.maxRNGSpins, 1);

    var stop = false;

    TestResult workerFun() {
      var n = 0; // passed tests
      var d = 0; // discarded tests

      TestResult? res;
      var fm = FreqMap.empty<ISet<dynamic>>();

      bool isExhausted() =>
          d > params.minSuccessfulTests * params.maxDiscardRatio;

      var seed = params.initialSeed.getOrElse(Seed.random);

      final Function0<void> spinner;

      if (maxSpinsBetween > 1) {
        spinner = () {
          var slides = 1 + ((n + d) % maxSpinsBetween);

          while (slides > 0) {
            seed = seed.slide();
            slides -= 1;
          }
        };
      } else {
        spinner = () {
          seed = seed.slide();
        };
      }

      while (!stop && res == null && n < iterations) {
        final count = n + d;
        final size = params.minSize.toDouble() + (sizeStep * count);

        final genPrms =
            GenParameters.create().withInitialSeed(seed).withsize(size.round());

        spinner();

        final propRes = p.apply(genPrms);

        if (propRes.collected.nonEmpty) {
          fm = fm.add(propRes.collected);
        }

        if (propRes.status is Undecided) {
          d += 1;
          params.testCallback.onPropEval(name, 0, n, d);
          if (isExhausted()) {
            res = TestResult(Exhausted(), n, d, none(), fm, Duration.zero);
          }
        } else if (propRes.status is True) {
          n += 1;
          params.testCallback.onPropEval(name, 0, n, d);
        } else if (propRes.status is Proved) {
          n += 1;
          res =
              TestResult(Proved(propRes.args), n, d, none(), fm, Duration.zero);
          stop = true;
        } else if (propRes.status is False) {
          res = TestResult(Failed(propRes.args, propRes.labels), n, d,
              propRes.failingSeed, fm, Duration.zero);
          stop = true;
        } else if (propRes.status is Exceptional) {
          final e = (propRes.status as Exceptional).e;
          res = TestResult(PropException(propRes.args, e, propRes.labels), n, d,
              propRes.failingSeed, fm, Duration.zero);
          stop = true;
        }
      }

      if (res == null) {
        if (isExhausted()) {
          return TestResult(Exhausted(), n, d, none(), fm, Duration.zero);
        } else {
          return TestResult(Passed(), n, d, none(), fm, Duration.zero);
        }
      } else {
        return res;
      }
    }

    final t0 = DateTime.now();
    final r = workerFun();
    final elapsed = DateTime.now().difference(t0);
    final timedRes = r.copy(time: elapsed);

    params.testCallback.onTestResult(name, timedRes, none());

    return timedRes;
  }
}

sealed class TestStatus {
  U fold<U>({
    required Function0<U> onPassed,
    required Function0<U> onProved,
    required Function2<IList<Arg<dynamic>>, ISet<String>, U> onFailed,
    required Function0<U> onExhausted,
    required Function3<IList<Arg<dynamic>>, Exception, ISet<String>, U>
        onPropException,
  });
}

final class Passed extends TestStatus {
  @override
  U fold<U>({
    required Function0<U> onPassed,
    required Function0<U> onProved,
    required Function2<IList<Arg<dynamic>>, ISet<String>, U> onFailed,
    required Function0<U> onExhausted,
    required Function3<IList<Arg<dynamic>>, Exception, ISet<String>, U>
        onPropException,
  }) =>
      onPassed();
}

final class Proved extends TestStatus {
  final IList<Arg<dynamic>> args;

  Proved(this.args);

  @override
  U fold<U>({
    required Function0<U> onPassed,
    required Function0<U> onProved,
    required Function2<IList<Arg<dynamic>>, ISet<String>, U> onFailed,
    required Function0<U> onExhausted,
    required Function3<IList<Arg<dynamic>>, Exception, ISet<String>, U>
        onPropException,
  }) =>
      onProved();
}

final class Failed extends TestStatus {
  final IList<Arg<dynamic>> args;
  final ISet<String> labels;

  Failed(this.args, this.labels);

  @override
  U fold<U>({
    required Function0<U> onPassed,
    required Function0<U> onProved,
    required Function2<IList<Arg<dynamic>>, ISet<String>, U> onFailed,
    required Function0<U> onExhausted,
    required Function3<IList<Arg<dynamic>>, Exception, ISet<String>, U>
        onPropException,
  }) =>
      onFailed(args, labels);
}

final class Exhausted extends TestStatus {
  @override
  U fold<U>({
    required Function0<U> onPassed,
    required Function0<U> onProved,
    required Function2<IList<Arg<dynamic>>, ISet<String>, U> onFailed,
    required Function0<U> onExhausted,
    required Function3<IList<Arg<dynamic>>, Exception, ISet<String>, U>
        onPropException,
  }) =>
      onExhausted();
}

final class PropException extends TestStatus {
  final IList<Arg<dynamic>> args;
  final Exception e;
  final ISet<String> labels;

  PropException(this.args, this.e, this.labels);

  @override
  U fold<U>({
    required Function0<U> onPassed,
    required Function0<U> onProved,
    required Function2<IList<Arg<dynamic>>, ISet<String>, U> onFailed,
    required Function0<U> onExhausted,
    required Function3<IList<Arg<dynamic>>, Exception, ISet<String>, U>
        onPropException,
  }) =>
      onPropException(args, e, labels);

  @override
  String toString() => 'Prop Exception: $args / $labels / $e';
}

final class TestResult {
  final TestStatus status;
  final int succeeded;
  final int discarded;
  final Option<Seed> failingSeed;
  final FreqMap<ISet<dynamic>> freqMap;
  final Duration time;

  const TestResult(
    this.status,
    this.succeeded,
    this.discarded,
    this.failingSeed,
    this.freqMap,
    this.time,
  );

  bool get passed => switch (status) {
        Passed() => true,
        Proved(args: _) => true,
        _ => false,
      };

  TestResult copy({
    TestStatus? status,
    int? succeeded,
    int? discarded,
    Seed? failingSeed,
    FreqMap<ISet<dynamic>>? freqMap,
    Duration? time,
  }) =>
      TestResult(
        status ?? this.status,
        succeeded ?? this.succeeded,
        discarded ?? this.discarded,
        Option(failingSeed ?? this.failingSeed.toNullable()),
        freqMap ?? this.freqMap,
        time ?? this.time,
      );

  @override
  String toString() => 'TestResult($status, $succeeded, $discarded, $time)';
}

class TestParameters {
  final int minSuccessfulTests;
  final int minSize;
  final int maxSize;
  final double maxDiscardRatio;
  final TestCallback testCallback;
  final Option<Seed> initialSeed;
  final int maxRNGSpins;

  TestParameters({
    this.minSuccessfulTests = 100,
    this.minSize = 0,
    this.maxSize = 100,
    this.testCallback = const TestCallback(),
    this.maxDiscardRatio = 5,
    this.initialSeed = const None(),
    this.maxRNGSpins = 1,
  });

  TestParameters copy({
    int? minSuccessfulTests,
    int? minSize,
    int? maxSize,
    double? maxDiscardRatio,
    TestCallback? testCallback,
    Option<Seed>? initialSeed,
    int? maxRNGSpins,
  }) =>
      TestParameters(
        minSuccessfulTests: minSuccessfulTests ?? this.minSuccessfulTests,
        minSize: minSize ?? this.minSize,
        maxSize: maxSize ?? this.maxSize,
        maxDiscardRatio: maxDiscardRatio ?? this.maxDiscardRatio,
        testCallback: testCallback ?? this.testCallback,
        initialSeed: initialSeed ?? this.initialSeed,
        maxRNGSpins: maxRNGSpins ?? this.maxRNGSpins,
      );

  TestParameters withInitialSeed(Seed seed) => copy(initialSeed: Some(seed));

  TestParameters withoutInitialSeed() => copy(initialSeed: const None());

  TestParameters withMinSucessfulTests(int n) => copy(minSuccessfulTests: n);

  TestParameters withTestCallback(TestCallback testCallback) =>
      copy(testCallback: testCallback);
}

class TestCallback {
  const TestCallback();

  void onPropEval(String name, int threadIdx, int succeeded, int discarded) {}
  void onTestResult(String name, TestResult result, Option<Seed> failingSeed) {}

  TestCallback chain(TestCallback testCallback) {
    return _TestCallbackImpl(
      onPropEvalF: (name, threadIdx, succeeded, discarded) {
        onPropEval(name, threadIdx, succeeded, discarded);
        testCallback.onPropEval(name, threadIdx, succeeded, discarded);
      },
      onTestResultF: (name, result, seed) {
        onTestResult(name, result, seed);
        testCallback.onTestResult(name, result, seed);
      },
    );
  }
}

final class _TestCallbackImpl extends TestCallback {
  final Function4<String, int, int, int, void> onPropEvalF;
  final Function3<String, TestResult, Option<Seed>, void> onTestResultF;

  const _TestCallbackImpl({
    required this.onPropEvalF,
    required this.onTestResultF,
  });

  @override
  void onPropEval(String name, int threadIdx, int succeeded, int discarded) =>
      onPropEvalF(name, threadIdx, succeeded, discarded);

  @override
  void onTestResult(String name, TestResult result, Option<Seed> failingSeed) =>
      onTestResultF(name, result, failingSeed);
}

final class ConsoleReporter extends TestCallback {
  final int verbosity;
  final int columnWidth;

  const ConsoleReporter(this.verbosity, this.columnWidth);

  @override
  void onTestResult(String name, TestResult result, Option<Seed> failingSeed) {
    if (verbosity > 0) {
      result.status.fold(
        onPassed: () => print('✓ $name: OK, passed ${result.succeeded} tests.'),
        onProved: () =>
            print('✓ $name: PROVEN, passed ${result.succeeded} tests.'),
        onFailed: (args, labels) =>
            fail('✖ $name FAILED: Passed: ${result.succeeded} tests.\n$args'),
        onExhausted: () => fail('✖ $name: EXHAUSTED'),
        onPropException: (args, ex, labels) {
          fail(
              '✖ $name FAILED: Passed: ${result.succeeded} tests.\nFailing seed: ${result.failingSeed.map((s) => s.toString()).getOrElse(() => '???')}\n$ex');
        },
      );
    }
  }
}

final class FreqMap<T> {
  final IMap<T, int> _underlying;
  final int total;

  FreqMap._(this._underlying, this.total);

  static FreqMap<T> empty<T>() => FreqMap._(IMap.empty(), 0);

  FreqMap<T> add(T t) {
    final n = _underlying.get(t).fold(() => 1, (n) => n + 1);
    return FreqMap._(_underlying + (t, n), total + 1);
  }
}

typedef PropBody<T> = Function1<Gen2<T>, void>;

@isTest
void forAll<T>(
  String name,
  Gen2<T> gen,
  Function1<T, void> propBody, {
  TestParameters? testParams,
  Shrink<T>? shrink,
}) {
  test(name, () {
    final shrinker = shrink?.shrink ?? (_) => ILazyList.empty();

    final prop = Prop2.forAll(
      name,
      gen,
      shrinker,
      (t) => Prop2.simple(() => propBody(t)),
      (t) => t.toString(),
    );

    final tp = testParams ??
        TestParameters().withTestCallback(const ConsoleReporter(0, 80));

    Test.check(name, tp, prop);
  });
}
