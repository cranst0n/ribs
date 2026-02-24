// ignore_for_file: avoid_print

import 'package:ribs_bench/rill/basic.dart';
import 'package:ribs_bench/rill/collatz.dart';
import 'package:ribs_bench/rill/primes.dart';

void main(List<String> args) async {
  void printTitle(String title) => print('\n${'=' * 20} $title ${'=' * 20}');

  printTitle('basic (x$basicN)');
  await StreamBasicBenchmark().report();
  await RillBasicBenchmark().report();

  printTitle('primes (x$primesN)');
  await StreamPrimesBenchmark().report();
  await RillPrimesBenchmark().report();

  printTitle('collatz (x$collatzStartNum, x$collatzStepThreshold, x$collatzTakeLimit)');
  await StreamCollatzBenchmark().report();
  await RillCollatzBenchmark().report();
}
