import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:fast_immutable_collections/fast_immutable_collections.dart' as fic;
import 'package:ribs_bench/collection/utils.dart';
import 'package:ribs_core/ribs_core.dart' as ribs;

class DartSetRemoveBenchmark extends BenchmarkBase {
  final int n;
  late Set<int> s;

  DartSetRemoveBenchmark(this.n) : super('dart-set-remove-$n');

  @override
  void setup() => s = genDartSet(n);

  @override
  void run() => s.remove(n ~/ 2);
}

class DartzISetRemoveBenchmark extends BenchmarkBase {
  final int n;
  late dartz.ISet<int> s;

  DartzISetRemoveBenchmark(this.n) : super('dartz-iset-remove-$n');

  @override
  void setup() => s = genDartzSet(n);

  @override
  void run() => s.remove(n ~/ 2);
}

class FICISetRemoveBenchmark extends BenchmarkBase {
  final int n;
  late fic.ISet<int> s;

  FICISetRemoveBenchmark(this.n) : super('fic-iset-remove-$n');

  @override
  void setup() => s = genFicISet(n);

  @override
  void run() => s.remove(n ~/ 2);
}

class RibsISetRemoveBenchmark extends BenchmarkBase {
  final int n;
  late ribs.ISet<int> s;

  RibsISetRemoveBenchmark(this.n) : super('ribs-iset-remove-$n');

  @override
  void setup() => s = genRibsISet(n);

  @override
  void run() => s.excl(n ~/ 2);
}

class RibsMSetRemoveBenchmark extends BenchmarkBase {
  final int n;
  late ribs.MSet<int> s;

  RibsMSetRemoveBenchmark(this.n) : super('ribs-mset-remove-$n');

  @override
  void setup() => s = genRibsMSet(n);

  @override
  void run() => s.remove(n ~/ 2);
}
