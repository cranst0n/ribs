import 'dart:async';

import 'package:meta/meta.dart';
import 'package:ribs_check/src/gen.dart';
import 'package:ribs_check/src/stateful_random.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

@isTest
void forAll<T>(
  String description,
  Gen<T> gen,
  TestBody<T> testBody, {
  int? numTests,
  int? seed,
  String? testOn,
  Timeout? timeout,
  dynamic skip,
  dynamic tags,
  Map<String, dynamic>? onPlatform,
  int? retry,
}) =>
    Prop(description, gen, testBody).run(
      numTests: numTests,
      seed: seed,
      testOn: testOn,
      timeout: timeout,
      skip: skip,
      tags: tags,
      onPlatform: onPlatform,
      retry: retry,
    );

typedef TestBody<T> = Function1<T, FutureOr<void>>;

final class Prop<T> {
  final String description;
  final Gen<T> gen;
  final TestBody<T> testBody;

  Prop(this.description, this.gen, this.testBody);

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
    final seedNN = seed ?? DateTime.now().millisecondsSinceEpoch;

    test(
      description,
      () async {
        var count = 0;

        final firstFailure = await gen
            .stream(StatefulRandom(seedNN))
            .take(numTests ?? 100)
            .asyncMap((value) {
          count++;
          return _runProp(value, testBody);
        }).firstWhere((result) => result.isDefined,
                orElse: () => none<PropFailure<T>>());

        final shrunkenFailure = await firstFailure.fold(
            () => Future.value(firstFailure), (a) => _shrink(a, testBody));

        shrunkenFailure.foreach((a) {
          throw TestFailure(
              '${a.underlying.message} Failed after $count iterations using value <${a.value}> and initial seed of [$seedNN].');
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

  FutureOr<Option<PropFailure<T>>> _runProp(
      T value, TestBody<T> testBody) async {
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
  }) {
    return count <= 0
        ? Future.value(Some(original))
        : gen
            .shrink(original.value)
            .asyncMap((value) async => (await _runProp(value, testBody)).fold(
                  () => Future.value(Some(original)),
                  (fail) => _shrink(fail, testBody, count: count - 1),
                ))
            .firstWhere((result) => result.isDefined,
                orElse: () => Some(original));
  }
}

class PropFailure<T> {
  final T value;
  final TestFailure underlying;

  const PropFailure(this.value, this.underlying);
}
