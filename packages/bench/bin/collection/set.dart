// ignore_for_file: avoid_print

import 'package:ribs_bench/collection/set/add.dart';
import 'package:ribs_bench/collection/set/add_all_diff.dart';
import 'package:ribs_bench/collection/set/add_all_same.dart';
import 'package:ribs_bench/collection/set/contains.dart';
import 'package:ribs_bench/collection/set/remove.dart';
import 'package:ribs_bench/ribs_benchmark.dart';

void main(List<String> args) {
  const ns = [10, 1000, 100000];

  for (final n in ns) {
    RibsBenchmark.runAndReport([
      DartSetAddBenchmark(n),
      DartzISetAddBenchmark(n),
      FICISetAddBenchmark(n),
      RibsISetAddBenchmark(n),
      RibsMSetAddBenchmark(n),
    ]);

    RibsBenchmark.runAndReport([
      DartSetAddAllSameBenchmark(n),
      DartzISetAddAllSameBenchmark(n),
      FICISetAddAllSameBenchmark(n),
      RibsISetAddAllSameBenchmark(n),
      RibsMSetAddAllSameBenchmark(n),
    ]);

    RibsBenchmark.runAndReport([
      DartSetAddAllDiffBenchmark(n),
      DartzISetAddAllDiffBenchmark(n),
      FICISetAddAllDiffBenchmark(n),
      RibsISetAddAllDiffBenchmark(n),
      RibsMSetAddAllDiffBenchmark(n),
    ]);

    RibsBenchmark.runAndReport([
      DartSetRemoveBenchmark(n),
      DartzISetRemoveBenchmark(n),
      FICISetRemoveBenchmark(n),
      RibsISetRemoveBenchmark(n),
      RibsMSetRemoveBenchmark(n),
    ]);

    RibsBenchmark.runAndReport([
      DartSetContainsBenchmark(n),
      DartzISetContainsBenchmark(n),
      FICISetContainsBenchmark(n),
      RibsISetContainsBenchmark(n),
      RibsMSetContainsBenchmark(n),
    ]);
  }
}
