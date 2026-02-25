import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:fast_immutable_collections/fast_immutable_collections.dart' as fic;
import 'package:ribs_bench/benchmark_emitter.dart';
import 'package:ribs_bench/collection/utils.dart';
import 'package:ribs_core/ribs_core.dart' as ribs;

class DartSetAddAllDiffBenchmark extends BenchmarkBase {
  final int n;
  late Set<int> s1;
  late Set<int> s2;

  DartSetAddAllDiffBenchmark(this.n)
    : super('dart-set-add-all-diff-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() {
    s1 = genDartSet(n);
    s2 = genDartSet2(n);
  }

  @override
  void run() => s1.addAll(s2);
}

class DartzISetAddAllDiffBenchmark extends BenchmarkBase {
  final int n;
  late dartz.ISet<int> s1;
  late dartz.ISet<int> s2;

  DartzISetAddAllDiffBenchmark(this.n)
    : super('dartz-iset-add-all-diff-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() {
    s1 = genDartzSet(n);
    s2 = genDartzSet2(n);
  }

  @override
  void run() => s1.union(s2);
}

class FICISetAddAllDiffBenchmark extends BenchmarkBase {
  final int n;
  late fic.ISet<int> s1;
  late fic.ISet<int> s2;

  FICISetAddAllDiffBenchmark(this.n)
    : super('fic-iset-add-all-diff-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() {
    s1 = genFicISet(n);
    s2 = genFicISet2(n);
  }

  @override
  void run() => s1.addAll(s2);
}

class RibsISetAddAllDiffBenchmark extends BenchmarkBase {
  final int n;
  late ribs.ISet<int> s1;
  late ribs.ISet<int> s2;

  RibsISetAddAllDiffBenchmark(this.n)
    : super('ribs-iset-add-all-diff-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() {
    s1 = genRibsISet(n);
    s2 = genRibsISet2(n);
  }

  @override
  void run() => s1.concat(s2);
}

class RibsMSetAddAllDiffBenchmark extends BenchmarkBase {
  final int n;
  late ribs.MSet<int> s1;
  late ribs.MSet<int> s2;

  RibsMSetAddAllDiffBenchmark(this.n)
    : super('ribs-mset-add-all-diff-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() {
    s1 = genRibsMSet(n);
    s2 = genRibsMSet2(n);
  }

  @override
  void run() => s1.concat(s2);
}
