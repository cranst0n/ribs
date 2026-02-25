import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:fast_immutable_collections/fast_immutable_collections.dart' as fic;
import 'package:ribs_bench/benchmark_emitter.dart';
import 'package:ribs_bench/collection/utils.dart';
import 'package:ribs_core/ribs_core.dart' as ribs;

class DartSetAddBenchmark extends BenchmarkBase {
  final int n;
  late Set<int> s;

  DartSetAddBenchmark(this.n) : super('dart-set-add-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => s = genDartSet(n);

  @override
  void run() => s.add(n);
}

class DartzISetAddBenchmark extends BenchmarkBase {
  final int n;
  late dartz.ISet<int> s;

  DartzISetAddBenchmark(this.n) : super('dartz-iset-add-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => s = genDartzSet(n);

  @override
  void run() => s.insert(n);
}

class FICISetAddBenchmark extends BenchmarkBase {
  final int n;
  late fic.ISet<int> s;

  FICISetAddBenchmark(this.n) : super('fic-iset-add-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => s = genFicISet(n);

  @override
  void run() => s.add(n);
}

class RibsISetAddBenchmark extends BenchmarkBase {
  final int n;
  late ribs.ISet<int> s;

  RibsISetAddBenchmark(this.n) : super('ribs-iset-add-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => s = genRibsISet(n);

  @override
  void run() => s.incl(n);
}

class RibsMSetAddBenchmark extends BenchmarkBase {
  final int n;
  late ribs.MSet<int> s;

  RibsMSetAddBenchmark(this.n) : super('ribs-mset-add-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => s = genRibsMSet(n);

  @override
  void run() => s.add(n);
}
