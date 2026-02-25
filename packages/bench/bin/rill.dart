// ignore_for_file: avoid_print

import 'package:ribs_bench/ribs_benchmark.dart';
import 'package:ribs_bench/rill/basic.dart';
import 'package:ribs_bench/rill/collatz.dart';
import 'package:ribs_bench/rill/primes.dart';

void main(List<String> args) async {
  await RibsBenchmark.runAndReportAsync([
    StreamBasicBenchmark(),
    RillBasicBenchmark(),
  ]);

  await RibsBenchmark.runAndReportAsync([
    StreamPrimesBenchmark(),
    RillPrimesBenchmark(),
  ]);

  await RibsBenchmark.runAndReportAsync([
    StreamCollatzBenchmark(),
    RillCollatzBenchmark(),
  ]);
}
