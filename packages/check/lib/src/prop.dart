import 'dart:async';
import 'dart:io';

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
}) => Prop(description, gen, testBody).run(
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
    test(
      description,
      () async {
        final envSeed = Platform.environment['RIBS_CHECK_SEED'];
        final seedNN = seed ?? int.tryParse(envSeed ?? '') ?? DateTime.now().millisecondsSinceEpoch;

        final shrunkenFailure = await check(numTests: numTests, seed: seedNN);

        shrunkenFailure.foreach((a) {
          throw TestFailure(
            '${a.underlying.message}\n'
            'Failed after ${a.count} iterations using value <${a.value}> and initial seed of [$seedNN].\n\n'
            'To reproduce this failure, use seed: $seedNN in your forAll/Prop call, or run:\n'
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
        firstFailure = result.map((f) => f.copyWith(count: count));
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
          result.getOrElse(() => throw Exception('unreachable')),
          testBody,
          count: count - 1,
        );
      }
    }

    return Some(original);
  }
}

class PropFailure<T> {
  final T value;
  final TestFailure underlying;
  final int count;

  const PropFailure(this.value, this.underlying, {this.count = 0});

  PropFailure<T> copyWith({T? value, TestFailure? underlying, int? count}) => PropFailure(
    value ?? this.value,
    underlying ?? this.underlying,
    count: count ?? this.count,
  );
}
