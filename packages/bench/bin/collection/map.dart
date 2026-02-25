// ignore_for_file: avoid_print

import 'package:ribs_bench/collection/map/get.dart';
import 'package:ribs_bench/collection/map/put.dart';
import 'package:ribs_bench/collection/map/remove_absent.dart';
import 'package:ribs_bench/collection/map/remove_present.dart';

void main(List<String> args) {
  const ns = [10, 1000, 100000];

  for (final n in ns) {
    DartMapPutBenchmark(n).report();
    FICIMapPutBenchmark(n).report();
    RibsIMapPutBenchmark(n).report();
    RibsMMapPutBenchmark(n).report();
    DartzIMapPutBenchmark(n).report();
    BuiltMapPutBenchmark(n).report();
    KtMapPutBenchmark(n).report();
    print('-' * 80);
    DartMapGetBenchmark(n).report();
    FICIMapGetBenchmark(n).report();
    RibsIMapGetBenchmark(n).report();
    RibsMMapGetBenchmark(n).report();
    DartzIMapGetBenchmark(n).report();
    BuiltMapGetBenchmark(n).report();
    KtMapGetBenchmark(n).report();
    print('-' * 80);
    DartMapRemovePresentBenchmark(n).report();
    FICIMapRemovePresentBenchmark(n).report();
    RibsIMapRemovePresentBenchmark(n).report();
    RibsMMapRemovePresentBenchmark(n).report();
    DartzIMapRemovePresentBenchmark(n).report();
    BuiltMapRemovePresentBenchmark(n).report();
    KtMapRemovePresentBenchmark(n).report();
    print('-' * 80);
    DartMapRemoveAbsentBenchmark(n).report();
    FICIMapRemoveAbsentBenchmark(n).report();
    RibsIMapRemoveAbsentBenchmark(n).report();
    RibsMMapRemoveAbsentBenchmark(n).report();
    DartzIMapRemoveAbsentBenchmark(n).report();
    BuiltMapRemoveAbsentBenchmark(n).report();
    KtMapRemoveAbsentBenchmark(n).report();
    print('-' * 80);
  }
}
