import 'package:ribs_check/src/gen.dart';
import 'package:ribs_check/src/seeded_random.dart';
import 'package:ribs_core/ribs_core.dart';

import 'package:test/test.dart' as dart_test;
// ignore: deprecated_member_use
import 'package:test_api/test_api.dart';

Prop<T> Function(TestBody<T> testBody) forAll<T>(Gen<T> gen) =>
    (testBody) => Prop(gen, testBody);

typedef TestBody<T> = Function1<T, void>;

final class Prop<T> {
  final Gen<T> gen;
  final TestBody<T> testBody;

  Prop(this.gen, this.testBody);

  void run({
    required String description,
    int numTests = 100,
    int? seed,
    String? testOn,
    Timeout? timeout,
    dynamic skip,
    dynamic tags,
    Map<String, dynamic>? onPlatform,
    int? retry,
  }) {
    final seedNN = seed ?? DateTime.now().millisecondsSinceEpoch;

    dart_test.test(description, () async {
      var count = 0;

      final firstFailure = await gen
          .stream(StatefulRandom(seedNN))
          .take(numTests)
          .map((value) {
        count++;
        return _runProp(value, testBody);
      }).firstWhere((result) => result.isDefined,
              orElse: () => none<PropFailure<T>>());

      final shrunkenFailure = await firstFailure.fold(
          () => Future.value(firstFailure), (a) => _shrink(a, testBody));

      shrunkenFailure.forEach((a) {
        throw dart_test.TestFailure(
            '${a.underlying.message} Failed after $count iterations using value [${a.value}] and seed [$seedNN].');
      });
    }, testOn: testOn);
  }

  Option<PropFailure<T>> _runProp(T value, TestBody<T> testBody) {
    try {
      testBody(value);
      return none<PropFailure<T>>();
    } on dart_test.TestFailure catch (tf) {
      return Some(PropFailure(value, tf));
    }
  }

  Future<Option<PropFailure<T>>> _shrink(
    PropFailure<T> original,
    TestBody<T> testBody, {
    int count = 50,
  }) {
    return count <= 0
        ? Future.value(Some(original))
        : gen
            .shrink(original.value)
            .asyncMap((value) => _runProp(value, testBody).fold(
                () => Future.value(Some(original)),
                (fail) => _shrink(fail, testBody, count: count - 1)))
            .firstWhere((result) => result.isDefined,
                orElse: () => Some(original));
  }
}

class PropFailure<T> {
  final T value;
  final dart_test.TestFailure underlying;

  const PropFailure(this.value, this.underlying);
}
