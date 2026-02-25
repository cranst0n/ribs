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

void main(List<String> args) async {
  await FutureMapBenchmark().report();
  await RibsMapBenchmark().report();
  print('-' * 80);
  await FutureFlatmapBenchmark().report();
  await RibsFlatmapBenchmark().report();
  print('-' * 80);
  await FutureAttemptHappyBenchmark().report();
  await RibsAttemptHappyBenchmark().report();
  print('-' * 80);
  await FutureAttemptSadBenchmark().report();
  await RibsAttemptSadBenchmark().report();
  print('-' * 80);
  await FuturePingPongBenchmark().report();
  await RibsPingPongBenchmark().report();
  print('-' * 80);
  await FibonacciFutureBenchmark().report();
  await FibonacciIOBenchmark().report();
  print('-' * 80);
  await FuturePrimesBenchmark().report();
  await RibsPrimesBenchmark().report();
  print('-' * 80);
  await FuturePiEstimationBenchmark().report();
  await RibsPiEstimationBenchmark().report();
  print('-' * 80);
  await MergeSortFutureBenchmark().report();
  await MergeSortIOBenchmark().report();
}
