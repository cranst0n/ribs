import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:built_collection/built_collection.dart' as built_list;
import 'package:dartz/dartz.dart' as dartz;
import 'package:fast_immutable_collections/fast_immutable_collections.dart' as fic;
import 'package:kt_dart/collection.dart' as kt;
import 'package:ribs_bench/benchmark_emitter.dart';
import 'package:ribs_bench/collection/utils.dart';
import 'package:ribs_core/ribs_core.dart' as ribs;

class DartMapRemovePresentBenchmark extends BenchmarkBase {
  final int n;
  late Map<int, String> m;

  DartMapRemovePresentBenchmark(this.n)
    : super('dart-map-remove-present-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => m = genDartMap(n);

  @override
  void run() => m.remove(n ~/ 2);
}

class FICIMapRemovePresentBenchmark extends BenchmarkBase {
  final int n;
  late fic.IMap<int, String> m;

  FICIMapRemovePresentBenchmark(this.n)
    : super('fic-imap-remove-present-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => m = genFicIMap(n);

  @override
  void run() => m.remove(n ~/ 2);
}

class RibsIMapRemovePresentBenchmark extends BenchmarkBase {
  final int n;
  late ribs.IMap<int, String> m;

  RibsIMapRemovePresentBenchmark(this.n)
    : super('ribs-imap-remove-present-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => m = genRibsIMap(n);

  @override
  void run() => m.removed(n ~/ 2);
}

class RibsMMapRemovePresentBenchmark extends BenchmarkBase {
  final int n;
  late ribs.MMap<int, String> m;

  RibsMMapRemovePresentBenchmark(this.n)
    : super('ribs-mmap-remove-present-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => m = genRibsMMap(n);

  @override
  void run() => m.remove(n ~/ 2);
}

class DartzIMapRemovePresentBenchmark extends BenchmarkBase {
  final int n;
  late dartz.IMap<int, String> m;

  DartzIMapRemovePresentBenchmark(this.n)
    : super('dartz-imap-remove-present-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => m = genDartzIMap(n);

  @override
  void run() => m.remove(n ~/ 2);
}

class BuiltMapRemovePresentBenchmark extends BenchmarkBase {
  final int n;
  late built_list.BuiltMap<int, String> m;

  BuiltMapRemovePresentBenchmark(this.n)
    : super('built-map-remove-present-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => m = genBuiltMap(n);

  @override
  void run() => m.rebuild((p0) => p0.remove(n ~/ 2));
}

class KtMapRemovePresentBenchmark extends BenchmarkBase {
  final int n;
  late kt.KtMap<int, String> m;

  KtMapRemovePresentBenchmark(this.n)
    : super('kt-map-remove-present-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => m = genKtMap(n);

  @override
  void run() => m.minus(n ~/ 2);
}
