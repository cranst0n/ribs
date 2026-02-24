import 'dart:math';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

const piEstimationTotal = 100000000;
const piEstimationChunks = 10000;

final _random = Random();

final class FuturePiEstimationBenchmark extends AsyncBenchmarkBase {
  FuturePiEstimationBenchmark() : super('pi-estimation-future');

  @override
  Future<void> run() => estimatePi(piEstimationTotal, piEstimationChunks);

  Future<double> estimatePi(int totalIterations, int numChunks) async {
    final iterationsPerChunk = totalIterations ~/ numChunks;
    final tasks = <Future<int>>[];

    for (int i = 0; i < numChunks; i++) {
      tasks.add(Future(() => calculatePiChunk(iterationsPerChunk)));
    }

    final results = await Future.wait(tasks);
    final totalInside = results.fold(0, (sum, count) => sum + count);

    return 4.0 * (totalInside / totalIterations);
  }
}

class RibsPiEstimationBenchmark extends AsyncBenchmarkBase {
  RibsPiEstimationBenchmark() : super('pi-estimation-ribs');

  @override
  Future<void> run() => estimatePi(piEstimationTotal, piEstimationChunks).unsafeRunFuture();

  IO<double> estimatePi(int totalIterations, int numChunks) {
    final iterationsPerChunk = totalIterations ~/ numChunks;
    final tasks = IList.tabulate(
      numChunks,
      (_) => IO.delay(() => calculatePiChunk(iterationsPerChunk)),
    );

    // .parSequence() does worse than .sequence() here
    return tasks
        .sequence()
        .map((l) => l.sum())
        .map((totalInside) => 4.0 * (totalInside / totalIterations));
  }
}

int calculatePiChunk(int iterations) {
  int insideCircle = 0;

  for (int i = 0; i < iterations; i++) {
    final x = _random.nextDouble();
    final y = _random.nextDouble();

    if ((x * x) + (y * y) <= 1.0) insideCircle++;
  }

  return insideCircle;
}
