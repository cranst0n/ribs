import 'dart:async';
import 'dart:io' show Platform;

import 'package:ribs_check/src/gen.dart';
import 'package:ribs_check/src/stateful_random.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

/// A test body that accepts a single generated value and may throw a
/// [TestFailure] to signal that the property does not hold.
typedef TestBody<T> = Function1<T, FutureOr<void>>;

/// A property-based test that pairs a [Gen] with a [TestBody].
///
/// On failure the framework automatically shrinks the counter-example to a
/// minimal value before reporting it.  Use [run] to register the property as
/// a `package:test` test case, or [check] to execute the property directly
/// and inspect the result.
final class Prop<T> {
  /// Human-readable description used as the test name.
  final String description;

  /// Generator used to produce random samples.
  final Gen<T> gen;

  /// The predicate under test.
  final TestBody<T> testBody;

  /// Creates a [Prop] with the given [description], [gen], and [testBody].
  Prop(this.description, this.gen, this.testBody);

  /// Registers this property as a `package:test` test case.
  ///
  /// [numTests] controls how many random samples are drawn (default 100).
  /// [seed] pins the random source so failures are reproducible; when omitted
  /// the value is read from the `RIBS_CHECK_SEED` environment variable, then
  /// falls back to the current wall-clock time.
  ///
  /// All remaining parameters are forwarded verbatim to `package:test`'s
  /// `test()`.
  void run({
    int? numTests,
    int? seed,
    String? testOn,
    Timeout? timeout,
    dynamic skip,
    dynamic tags,
    Map<String, dynamic>? onPlatform,
    int? retry,
  }) {
    test(
      description,
      () async {
        final envSeed = _kIsWeb ? null : Platform.environment['RIBS_CHECK_SEED'];
        final seedNN = seed ?? int.tryParse(envSeed ?? '') ?? DateTime.now().millisecondsSinceEpoch;

        final shrunkenFailure = await check(numTests: numTests, seed: seedNN);

        shrunkenFailure.foreach((a) {
          throw TestFailure(
            '${a.underlying.message}\n'
            'Failed after ${a.count} iterations using value <${a.value}> and initial seed of [$seedNN].\n\n'
            'To reproduce this failure, use seed: $seedNN in your forAllN/Prop call, or run:\n'
            'RIBS_CHECK_SEED=$seedNN dart test --plain-name "$description"\n',
          );
        });
      },
      testOn: testOn,
      timeout: timeout,
      skip: skip,
      tags: tags,
      onPlatform: onPlatform,
      retry: retry,
    );
  }

  /// Runs the property check and returns the shrunken failure, if any.
  ///
  /// Draws up to [numTests] (default 100) samples from [gen].  Returns
  /// [None] when every sample passes, or a [Some] wrapping the minimised
  /// [PropFailure] when a counter-example is found.
  Future<Option<PropFailure<T>>> check({int? numTests, int? seed}) async {
    final seedNN = seed ?? DateTime.now().millisecondsSinceEpoch;

    var count = 0;
    Option<PropFailure<T>> firstFailure = none();

    final iterator = gen.stream(StatefulRandom(seedNN)).take(numTests ?? 100).iterator;

    while (iterator.hasNext) {
      final value = iterator.next();
      count++;

      final result = await _runProp(value, testBody);

      if (result.isDefined) {
        firstFailure = result.map((f) => f.copy(count: count));
        break;
      }
    }

    return firstFailure.fold(
      () => Future.value(firstFailure),
      (a) => _shrink(a, testBody),
    );
  }

  FutureOr<Option<PropFailure<T>>> _runProp(T value, TestBody<T> testBody) async {
    try {
      await testBody(value);
      return none<PropFailure<T>>();
    } on TestFailure catch (tf) {
      return Some(PropFailure(value, tf));
    }
  }

  Future<Option<PropFailure<T>>> _shrink(
    PropFailure<T> original,
    TestBody<T> testBody, {
    int count = 50,
  }) async {
    if (count <= 0) return Some(original);

    final iterator = gen.shrink(original.value).iterator;
    while (iterator.hasNext) {
      final value = iterator.next();
      final result = await _runProp(value, testBody);

      if (result.isDefined) {
        return _shrink(
          result.get,
          testBody,
          count: count - 1,
        );
      }
    }

    return Some(original);
  }
}

/// Describes a failing sample produced by [Prop.check].
class PropFailure<T> {
  /// The counter-example value that caused the failure.
  final T value;

  /// The [TestFailure] thrown by the test body.
  final TestFailure underlying;

  /// The 1-based iteration number at which the failure was first observed.
  final int count;

  /// Creates a [PropFailure] for [value] with the given [underlying] failure.
  const PropFailure(this.value, this.underlying, {this.count = 0});

  /// Returns a copy of this failure with optionally overridden fields.
  PropFailure<T> copy({T? value, TestFailure? underlying, int? count}) => PropFailure(
    value ?? this.value,
    underlying ?? this.underlying,
    count: count ?? this.count,
  );
}

const bool _kIsWeb = bool.fromEnvironment('dart.library.js_util');
