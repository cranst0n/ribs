// ignore_for_file: avoid_print

import 'package:ribs_bench/io/pi_estimation/common.dart';

void main(List<String> args) async {
  final estimate = await estimatePiFuture(total, chunks);
  print('[future] pi estimated: ${estimate.toStringAsFixed(5)}');
}

Future<double> estimatePiFuture(int totalIterations, int numChunks) async {
  final iterationsPerChunk = totalIterations ~/ numChunks;
  final tasks = <Future<int>>[];

  for (int i = 0; i < numChunks; i++) {
    tasks.add(Future(() => calculatePiChunk(iterationsPerChunk)));
  }

  final results = await Future.wait(tasks);
  final totalInside = results.fold(0, (sum, count) => sum + count);

  return 4.0 * (totalInside / totalIterations);
}
