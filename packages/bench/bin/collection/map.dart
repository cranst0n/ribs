// ignore_for_file: avoid_print

import 'package:ribs_bench/collection/map/get.dart';
import 'package:ribs_bench/collection/map/put.dart';
import 'package:ribs_bench/collection/map/remove_absent.dart';
import 'package:ribs_bench/collection/map/remove_present.dart';
import 'package:ribs_bench/ribs_benchmark.dart';

void main(List<String> args) {
  const ns = [10, 1000, 100000];

  for (final n in ns) {
    RibsBenchmark.runAndReport([
      DartMapPutBenchmark(n),
      FICIMapPutBenchmark(n),
      RibsIMapPutBenchmark(n),
      RibsMMapPutBenchmark(n),
      DartzIMapPutBenchmark(n),
      BuiltMapPutBenchmark(n),
      KtMapPutBenchmark(n),
    ]);

    RibsBenchmark.runAndReport([
      DartMapGetBenchmark(n),
      FICIMapGetBenchmark(n),
      RibsIMapGetBenchmark(n),
      RibsMMapGetBenchmark(n),
      DartzIMapGetBenchmark(n),
      BuiltMapGetBenchmark(n),
      KtMapGetBenchmark(n),
    ]);

    RibsBenchmark.runAndReport([
      DartMapRemovePresentBenchmark(n),
      FICIMapRemovePresentBenchmark(n),
      RibsIMapRemovePresentBenchmark(n),
      RibsMMapRemovePresentBenchmark(n),
      DartzIMapRemovePresentBenchmark(n),
      BuiltMapRemovePresentBenchmark(n),
      KtMapRemovePresentBenchmark(n),
    ]);

    RibsBenchmark.runAndReport([
      DartMapRemoveAbsentBenchmark(n),
      FICIMapRemoveAbsentBenchmark(n),
      RibsIMapRemoveAbsentBenchmark(n),
      RibsMMapRemoveAbsentBenchmark(n),
      DartzIMapRemoveAbsentBenchmark(n),
      BuiltMapRemoveAbsentBenchmark(n),
      KtMapRemoveAbsentBenchmark(n),
    ]);
  }
}
