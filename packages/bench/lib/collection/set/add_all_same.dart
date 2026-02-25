import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:fast_immutable_collections/fast_immutable_collections.dart' as fic;
import 'package:ribs_bench/collection/utils.dart';
import 'package:ribs_core/ribs_core.dart' as ribs;

class DartSetAddAllSameBenchmark extends BenchmarkBase {
  final int n;
  late Set<int> s;

  DartSetAddAllSameBenchmark(this.n) : super('dart-set-add-all-same-$n');

  @override
  void setup() => s = genDartSet(n);

  @override
  void run() => s.addAll(s);
}

class DartzISetAddAllSameBenchmark extends BenchmarkBase {
  final int n;
  late dartz.ISet<int> s;

  DartzISetAddAllSameBenchmark(this.n) : super('dartz-iset-add-all-same-$n');

  @override
  void setup() => s = genDartzSet(n);

  @override
  void run() => s.union(s);
}

class FICISetAddAllSameBenchmark extends BenchmarkBase {
  final int n;
  late fic.ISet<int> s;

  FICISetAddAllSameBenchmark(this.n) : super('fic-iset-add-all-same-$n');

  @override
  void setup() => s = genFicISet(n);

  @override
  void run() => s.addAll(s);
}

class RibsISetAddAllSameBenchmark extends BenchmarkBase {
  final int n;
  late ribs.ISet<int> s;

  RibsISetAddAllSameBenchmark(this.n) : super('ribs-iset-add-all-same-$n');

  @override
  void setup() => s = genRibsISet(n);

  @override
  void run() => s.concat(s);
}

class RibsMSetAddAllSameBenchmark extends BenchmarkBase {
  final int n;
  late ribs.MSet<int> s;

  RibsMSetAddAllSameBenchmark(this.n) : super('ribs-mset-add-all-same-$n');

  @override
  void setup() => s = genRibsMSet(n);

  @override
  void run() => s.concat(s);
}
