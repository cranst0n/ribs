import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:built_collection/built_collection.dart' as built_list;
import 'package:dartz/dartz.dart' as dartz;
import 'package:fast_immutable_collections/fast_immutable_collections.dart' as fic;
import 'package:kt_dart/collection.dart' as kt;
import 'package:ribs_bench/collection/utils.dart';
import 'package:ribs_core/ribs_core.dart' as ribs;

class DartMapGetBenchmark extends BenchmarkBase {
  final int n;
  late Map<int, String> m;

  DartMapGetBenchmark(this.n) : super('dart-map-get-$n');

  @override
  void setup() => m = genDartMap(n);

  @override
  void run() => m[n ~/ 2];
}

class FICIMapGetBenchmark extends BenchmarkBase {
  final int n;
  late fic.IMap<int, String> m;

  FICIMapGetBenchmark(this.n) : super('fic-imap-get-$n');

  @override
  void setup() => m = genFicIMap(n);

  @override
  void run() => m[n ~/ 2];
}

class RibsIMapGetBenchmark extends BenchmarkBase {
  final int n;
  late ribs.IMap<int, String> m;

  RibsIMapGetBenchmark(this.n) : super('ribs-imap-get-$n');

  @override
  void setup() => m = genRibsIMap(n);

  @override
  void run() => m[n ~/ 2];
}

class RibsMMapGetBenchmark extends BenchmarkBase {
  final int n;
  late ribs.MMap<int, String> m;

  RibsMMapGetBenchmark(this.n) : super('ribs-mmap-get-$n');

  @override
  void setup() => m = genRibsMMap(n);

  @override
  void run() => m[n ~/ 2];
}

class DartzIMapGetBenchmark extends BenchmarkBase {
  final int n;
  late dartz.IMap<int, String> m;

  DartzIMapGetBenchmark(this.n) : super('dartz-imap-get-$n');

  @override
  void setup() => m = genDartzIMap(n);

  @override
  void run() => m.get(n ~/ 2);
}

class BuiltMapGetBenchmark extends BenchmarkBase {
  final int n;
  late built_list.BuiltMap<int, String> m;

  BuiltMapGetBenchmark(this.n) : super('built-map-get-$n');

  @override
  void setup() => m = genBuiltMap(n);

  @override
  void run() => m[n ~/ 2];
}

class KtMapGetBenchmark extends BenchmarkBase {
  final int n;
  late kt.KtMap<int, String> m;

  KtMapGetBenchmark(this.n) : super('kt-map-get-$n');

  @override
  void setup() => m = genKtMap(n);

  @override
  void run() => m[n ~/ 2];
}
