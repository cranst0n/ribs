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
  void printTitle(String title) => print('\n${'=' * 20} $title ${'=' * 20}');

  printTitle('map (x$mapN)');
  await FutureMapBenchmark().report();
  await RibsMapBenchmark().report();

  printTitle('flatmap (x$flatMapN)');
  await FutureFlatmapBenchmark().report();
  await RibsFlatmapBenchmark().report();

  printTitle('attempt happy (x$attemptHappyN)');
  await FutureAttemptHappyBenchmark().report();
  await RibsAttemptHappyBenchmark().report();

  printTitle('attempt sad (x$attemptSadN)');
  await FutureAttemptSadBenchmark().report();
  await RibsAttemptSadBenchmark().report();

  printTitle('ping pong (x$pingPongN)');
  await FuturePingPongBenchmark().report();
  await RibsPingPongBenchmark().report();

  printTitle('fibonacci ($fibonacciN)');
  await FibonacciFutureBenchmark().report();
  await FibonacciIOBenchmark().report();

  printTitle('primes ($primesSearchLimit / $primesChunkSize)');
  await FuturePrimesBenchmark().report();
  await RibsPrimesBenchmark().report();

  printTitle('pi estimation ($piEstimationTotal / $piEstimationChunks)');
  await FuturePiEstimationBenchmark().report();
  await RibsPiEstimationBenchmark().report();

  printTitle('merge sort ($mergeSortSize / $mergeSortThreshold)');
  await MergeSortFutureBenchmark().report();
  await MergeSortIOBenchmark().report();
}
