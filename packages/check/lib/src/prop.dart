import 'package:ribs_check/src/gen.dart';
import 'package:ribs_check/src/seeded_random.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

Prop<T> Function(TestBody<T> testBody) forAll<T>(
        String description, Gen<T> gen) =>
    (testBody) => Prop(description, gen, testBody);

typedef TestBody<T> = Function1<T, void>;

final class Prop<T> {
  final String description;
  final Gen<T> gen;
  final TestBody<T> testBody;

  Prop(this.description, this.gen, this.testBody);

  void run({
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

    test(description, () async {
      var count = 0;

      final firstFailure = await gen
          .stream(StatefulRandom(seedNN))
          .map((value) {
        count++;
        return _runProp(value, testBody);
      }).firstWhere((result) => result.isDefined,
              orElse: () => none<PropFailure<T>>());

      final shrunkenFailure = await firstFailure.fold(
          () => Future.value(firstFailure), (a) => _shrink(a, testBody));

      shrunkenFailure.forEach((a) {
        throw TestFailure(
            '${a.underlying.message} Failed after $count iterations using value [${a.value}] and seed [$seedNN].');
      });
    }, testOn: testOn);
  }

  Option<PropFailure<T>> _runProp(T value, TestBody<T> testBody) {
    try {
      testBody(value);
      return none<PropFailure<T>>();
    } on TestFailure catch (tf) {
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
  final TestFailure underlying;

  const PropFailure(this.value, this.underlying);
}
