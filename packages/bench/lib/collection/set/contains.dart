import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:fast_immutable_collections/fast_immutable_collections.dart' as fic;
import 'package:ribs_bench/benchmark_emitter.dart';
import 'package:ribs_bench/collection/utils.dart';
import 'package:ribs_core/ribs_core.dart' as ribs;

class DartSetContainsBenchmark extends BenchmarkBase {
  final int n;
  late Set<int> s;

  DartSetContainsBenchmark(this.n) : super('dart-set-contains-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => s = genDartSet(n);

  @override
  void run() => s.contains(n ~/ 2);
}

class DartzISetContainsBenchmark extends BenchmarkBase {
  final int n;
  late dartz.ISet<int> s;

  DartzISetContainsBenchmark(this.n)
    : super('dartz-iset-contains-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => s = genDartzSet(n);

  @override
  void run() => s.contains(n ~/ 2);
}

class FICISetContainsBenchmark extends BenchmarkBase {
  final int n;
  late fic.ISet<int> s;

  FICISetContainsBenchmark(this.n) : super('fic-iset-contains-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => s = genFicISet(n);

  @override
  void run() => s.contains(n ~/ 2);
}

class RibsISetContainsBenchmark extends BenchmarkBase {
  final int n;
  late ribs.ISet<int> s;

  RibsISetContainsBenchmark(this.n)
    : super('ribs-iset-contains-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => s = genRibsISet(n);

  @override
  void run() => s.contains(n ~/ 2);
}

class RibsMSetContainsBenchmark extends BenchmarkBase {
  final int n;
  late ribs.MSet<int> s;

  RibsMSetContainsBenchmark(this.n)
    : super('ribs-mset-contains-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => s = genRibsMSet(n);

  @override
  void run() => s.contains(n ~/ 2);
}
