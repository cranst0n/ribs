// ignore_for_file: avoid_print

import 'package:ribs_bench/rill/basic.dart';
import 'package:ribs_bench/rill/collatz.dart';
import 'package:ribs_bench/rill/primes.dart';

void main(List<String> args) async {
  await StreamBasicBenchmark().report();
  await RillBasicBenchmark().report();
  print('-' * 80);
  await StreamPrimesBenchmark().report();
  await RillPrimesBenchmark().report();
  print('-' * 80);
  await StreamCollatzBenchmark().report();
  await RillCollatzBenchmark().report();
}
