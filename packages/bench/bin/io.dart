// ignore_for_file: avoid_print

import 'package:ribs_bench/io/attempt_happy.dart';
import 'package:ribs_bench/io/attempt_sad.dart';
import 'package:ribs_bench/io/fibonacci.dart';
import 'package:ribs_bench/io/flat_map.dart';
import 'package:ribs_bench/io/map.dart';
import 'package:ribs_bench/io/merge_sort.dart';
import 'package:ribs_bench/io/pi_estimation.dart';
import 'package:ribs_bench/io/ping_pong.dart';
import 'package:ribs_bench/io/primes.dart';
import 'package:ribs_bench/ribs_benchmark.dart';

void main(List<String> args) async {
  await RibsBenchmark.runAndReportAsync([
    FutureMapBenchmark(),
    RibsMapBenchmark(),
    FpdartMapBenchmark(),
  ]);

  await RibsBenchmark.runAndReportAsync([
    FutureFlatmapBenchmark(),
    RibsFlatmapBenchmark(),
    FpdartFlatmapBenchmark(),
  ]);

  await RibsBenchmark.runAndReportAsync([
    FutureAttemptHappyBenchmark(),
    RibsAttemptHappyBenchmark(),
    FpdartAttemptHappyBenchmark(),
  ]);

  await RibsBenchmark.runAndReportAsync([
    FutureAttemptSadBenchmark(),
    RibsAttemptSadBenchmark(),
    FpdartAttemptSadBenchmark(),
  ]);

  await RibsBenchmark.runAndReportAsync([
    FuturePingPongBenchmark(),
    RibsPingPongBenchmark(),
    FpdartPingPongBenchmark(),
  ]);

  await RibsBenchmark.runAndReportAsync([
    FibonacciFutureBenchmark(),
    FibonacciIOBenchmark(),
    FibonacciFpdartBenchmark(),
  ]);

  await RibsBenchmark.runAndReportAsync([
    FuturePrimesBenchmark(),
    RibsPrimesBenchmark(),
  ]);

  await RibsBenchmark.runAndReportAsync([
    FuturePiEstimationBenchmark(),
    RibsPiEstimationBenchmark(),
  ]);

  await RibsBenchmark.runAndReportAsync([
    MergeSortFutureBenchmark(),
    MergeSortIOBenchmark(),
  ]);
}
