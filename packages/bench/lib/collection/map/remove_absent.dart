import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:built_collection/built_collection.dart' as built_list;
import 'package:dartz/dartz.dart' as dartz;
import 'package:fast_immutable_collections/fast_immutable_collections.dart' as fic;
import 'package:kt_dart/collection.dart' as kt;
import 'package:ribs_bench/collection/utils.dart';
import 'package:ribs_core/ribs_core.dart' as ribs;

class DartMapRemoveAbsentBenchmark extends BenchmarkBase {
  final int n;
  late Map<int, String> m;

  DartMapRemoveAbsentBenchmark(this.n) : super('dart-map-remove-absent-$n');

  @override
  void setup() => m = genDartMap(n);

  @override
  void run() => m.remove(n);
}

class FICIMapRemoveAbsentBenchmark extends BenchmarkBase {
  final int n;
  late fic.IMap<int, String> m;

  FICIMapRemoveAbsentBenchmark(this.n) : super('fic-imap-remove-absent-$n');

  @override
  void setup() => m = genFicIMap(n);

  @override
  void run() => m.remove(n);
}

class RibsIMapRemoveAbsentBenchmark extends BenchmarkBase {
  final int n;
  late ribs.IMap<int, String> m;

  RibsIMapRemoveAbsentBenchmark(this.n) : super('ribs-imap-remove-absent-$n');

  @override
  void setup() => m = genRibsIMap(n);

  @override
  void run() => m.removed(n);
}

class RibsMMapRemoveAbsentBenchmark extends BenchmarkBase {
  final int n;
  late ribs.MMap<int, String> m;

  RibsMMapRemoveAbsentBenchmark(this.n) : super('ribs-mmap-remove-absent-$n');

  @override
  void setup() => m = genRibsMMap(n);

  @override
  void run() => m.remove(n);
}

class DartzIMapRemoveAbsentBenchmark extends BenchmarkBase {
  final int n;
  late dartz.IMap<int, String> m;

  DartzIMapRemoveAbsentBenchmark(this.n) : super('dartz-imap-remove-absent-$n');

  @override
  void setup() => m = genDartzIMap(n);

  @override
  void run() => m.remove(n);
}

class BuiltMapRemoveAbsentBenchmark extends BenchmarkBase {
  final int n;
  late built_list.BuiltMap<int, String> m;

  BuiltMapRemoveAbsentBenchmark(this.n) : super('built-map-remove-absent-$n');

  @override
  void setup() => m = genBuiltMap(n);

  @override
  void run() => m.rebuild((p0) => p0.remove(n));
}

class KtMapRemoveAbsentBenchmark extends BenchmarkBase {
  final int n;
  late kt.KtMap<int, String> m;

  KtMapRemoveAbsentBenchmark(this.n) : super('kt-map-remove-absent-$n');

  @override
  void setup() => m = genKtMap(n);

  @override
  void run() => m.minus(n);
}
