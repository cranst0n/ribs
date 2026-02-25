import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';

const collatzStartNum = 100000;
const collatzStepThreshold = 200;
const collatzTakeLimit = 100;

class StreamCollatzBenchmark extends AsyncBenchmarkBase {
  StreamCollatzBenchmark() : super('stream-collatz');

  @override
  Future<void> run() => computeCollatz(collatzStartNum, collatzStepThreshold, collatzTakeLimit);

  Future<List<int>> computeCollatz(int start, int threshold, int limit) async {
    final source = Iterable.generate(10000000, (i) => i + start);

    final pipeline = Stream.fromIterable(source)
        .asyncMap((n) async {
          final steps = await Future(() => countSteps(n));
          return CollatzResult(n, steps);
        })
        .where((result) => result.steps > threshold);

    final finalResults = await pipeline.take(limit).toList();

    return finalResults.map((r) => r.number).toList();
  }

  Future<int> countSteps(int n) => Future(() {
    int steps = 0;
    var current = n;
    while (current > 1) {
      if (current.isEven) {
        current ~/= 2;
      } else {
        current = 3 * current + 1;
      }
      steps++;
    }
    return steps;
  });
}

class RillCollatzBenchmark extends AsyncBenchmarkBase {
  RillCollatzBenchmark() : super('rill-collatz');

  @override
  Future<void> run() =>
      computeCollatz(collatzStartNum, collatzStepThreshold, collatzTakeLimit).unsafeRunFuture();

  IO<List<int>> computeCollatz(int start, int threshold, int limit) {
    return Rill.range(start, start + 10000000)
        .evalMap((n) => IO.delay(() => countSteps(n)).map((s) => CollatzResult(n, s)))
        .filter((result) => result.steps > threshold)
        .take(limit)
        .compile
        .toList
        .map((results) => results.map((r) => r.number).toList());
  }
}

class CollatzResult {
  final int number;
  final int steps;

  CollatzResult(this.number, this.steps);
}

int countSteps(int n) {
  int steps = 0;
  var current = n;
  while (current > 1) {
    if (current.isEven) {
      current ~/= 2;
    } else {
      current = 3 * current + 1;
    }
    steps++;
  }
  return steps;
}
