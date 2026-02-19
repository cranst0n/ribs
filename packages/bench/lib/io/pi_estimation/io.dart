// ignore_for_file: avoid_print

import 'package:ribs_bench/io/pi_estimation/common.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

void main(List<String> args) async {
  final estimate = await estimatePiIO(total, chunks).unsafeRunFuture();
  print('[future] pi estimated: ${estimate.toStringAsFixed(5)}');
}

IO<double> estimatePiIO(int totalIterations, int numChunks) {
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
