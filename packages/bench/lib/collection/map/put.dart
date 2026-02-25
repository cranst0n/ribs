import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:built_collection/built_collection.dart' as built_list;
import 'package:dartz/dartz.dart' as dartz;
import 'package:fast_immutable_collections/fast_immutable_collections.dart' as fic;
import 'package:kt_dart/collection.dart' as kt;
import 'package:kt_dart/kt.dart';
import 'package:ribs_bench/collection/utils.dart';
import 'package:ribs_core/ribs_core.dart' as ribs;

class DartMapPutBenchmark extends BenchmarkBase {
  final int n;
  late Map<int, String> m;

  DartMapPutBenchmark(this.n) : super('dart-map-put-$n');

  @override
  void setup() => m = genDartMap(n);

  @override
  void run() => m.putIfAbsent(n, () => n.toString());
}

class FICIMapPutBenchmark extends BenchmarkBase {
  final int n;
  late fic.IMap<int, String> m;

  FICIMapPutBenchmark(this.n) : super('fic-imap-put-$n');

  @override
  void setup() => m = genFicIMap(n);

  @override
  void run() => m.putIfAbsent(n, () => n.toString());
}

class RibsIMapPutBenchmark extends BenchmarkBase {
  final int n;
  late ribs.IMap<int, String> m;

  RibsIMapPutBenchmark(this.n) : super('ribs-imap-put-$n');

  @override
  void setup() => m = genRibsIMap(n);

  @override
  void run() => m.updated(n, n.toString());
}

class RibsMMapPutBenchmark extends BenchmarkBase {
  final int n;
  late ribs.MMap<int, String> m;

  RibsMMapPutBenchmark(this.n) : super('ribs-mmap-put-$n');

  @override
  void setup() => m = genRibsMMap(n);

  @override
  void run() => m.update(n, n.toString());
}

class DartzIMapPutBenchmark extends BenchmarkBase {
  final int n;
  late dartz.IMap<int, String> m;

  DartzIMapPutBenchmark(this.n) : super('dartz-imap-put-$n');

  @override
  void setup() => m = genDartzIMap(n);

  @override
  void run() => m.put(n, n.toString());
}

class BuiltMapPutBenchmark extends BenchmarkBase {
  final int n;
  late built_list.BuiltMap<int, String> m;

  BuiltMapPutBenchmark(this.n) : super('built-map-put-$n');

  @override
  void setup() => m = genBuiltMap(n);

  @override
  void run() => m.rebuild((p0) => p0.putIfAbsent(n, () => n.toString()));
}

class KtMapPutBenchmark extends BenchmarkBase {
  final int n;
  late kt.KtMap<int, String> m;

  KtMapPutBenchmark(this.n) : super('kt-map-put-$n');

  @override
  void setup() => m = genKtMap(n);

  @override
  void run() => m.plus(KtHashMap.from({n: n.toString()}));
}
