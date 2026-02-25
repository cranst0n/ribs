// ignore_for_file: avoid_print

import 'package:ribs_bench/collection/set/add.dart';
import 'package:ribs_bench/collection/set/add_all_diff.dart';
import 'package:ribs_bench/collection/set/add_all_same.dart';
import 'package:ribs_bench/collection/set/contains.dart';
import 'package:ribs_bench/collection/set/remove.dart';

void main(List<String> args) {
  const ns = [10, 1000, 100000];

  for (final n in ns) {
    DartSetAddBenchmark(n).report();
    DartzISetAddBenchmark(n).report();
    FICISetAddBenchmark(n).report();
    RibsISetAddBenchmark(n).report();
    RibsMSetAddBenchmark(n).report();
    print('-' * 80);
    DartSetAddAllSameBenchmark(n).report();
    DartzISetAddAllSameBenchmark(n).report();
    FICISetAddAllSameBenchmark(n).report();
    RibsISetAddAllSameBenchmark(n).report();
    RibsMSetAddAllSameBenchmark(n).report();
    print('-' * 80);
    DartSetAddAllDiffBenchmark(n).report();
    DartzISetAddAllDiffBenchmark(n).report();
    FICISetAddAllDiffBenchmark(n).report();
    RibsISetAddAllDiffBenchmark(n).report();
    RibsMSetAddAllDiffBenchmark(n).report();
    print('-' * 80);
    DartSetRemoveBenchmark(n).report();
    DartzISetRemoveBenchmark(n).report();
    FICISetRemoveBenchmark(n).report();
    RibsISetRemoveBenchmark(n).report();
    RibsMSetRemoveBenchmark(n).report();
    print('-' * 80);
    DartSetContainsBenchmark(n).report();
    DartzISetContainsBenchmark(n).report();
    FICISetContainsBenchmark(n).report();
    RibsISetContainsBenchmark(n).report();
    RibsMSetContainsBenchmark(n).report();
    print('-' * 80);
  }
}
