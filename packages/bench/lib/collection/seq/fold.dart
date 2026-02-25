import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:built_collection/built_collection.dart' as built_list;
import 'package:dartz/dartz.dart' as dartz;
import 'package:fast_immutable_collections/fast_immutable_collections.dart' as fic;
import 'package:kt_dart/collection.dart' as kt;
import 'package:ribs_bench/collection/utils.dart';
import 'package:ribs_core/ribs_core.dart' as ribs;

class DartListFoldBenchmark extends BenchmarkBase {
  final int n;
  late List<int> l;

  DartListFoldBenchmark(this.n) : super('dart-list-fold-$n');

  @override
  void setup() => l = genDartList(n);

  @override
  void run() => l.fold<int>(0, (a, b) => a + b);
}

class BuiltListFoldBenchmark extends BenchmarkBase {
  final int n;
  late built_list.BuiltList<int> l;

  BuiltListFoldBenchmark(this.n) : super('built-list-fold-$n');

  @override
  void setup() => l = genBuiltList(n);

  @override
  void run() => l.fold<int>(0, (a, b) => a + b);
}

class DartzIListFoldBenchmark extends BenchmarkBase {
  final int n;
  late dartz.IList<int> l;

  DartzIListFoldBenchmark(this.n) : super('dartz-ilist-fold-$n');

  @override
  void setup() => l = genDartzList(n);

  @override
  void run() => l.foldLeft<int>(0, (a, b) => a + b);
}

class FICIListFoldBenchmark extends BenchmarkBase {
  final int n;
  late fic.IList<int> l;

  FICIListFoldBenchmark(this.n) : super('fic-ilist-fold-$n');

  @override
  void setup() => l = genFicList(n);

  @override
  void run() => l.fold<int>(0, (a, b) => a + b);
}

class KtListFoldBenchmark extends BenchmarkBase {
  final int n;
  late kt.KtList<int> l;

  KtListFoldBenchmark(this.n) : super('kt-list-fold-$n');

  @override
  void setup() => l = genKtList(n);

  @override
  void run() => l.fold<int>(0, (a, b) => a + b);
}

class RibsIChainFoldBenchmark extends BenchmarkBase {
  final int n;
  late ribs.IChain<int> l;

  RibsIChainFoldBenchmark(this.n) : super('ribs-ichain-fold-$n');

  @override
  void setup() => l = genRibsIChain(n);

  @override
  void run() => l.fold(0, (a, b) => a + b);
}

class RibsIListFoldBenchmark extends BenchmarkBase {
  final int n;
  late ribs.IList<int> l;

  RibsIListFoldBenchmark(this.n) : super('ribs-ilist-fold-$n');

  @override
  void setup() => l = genRibsIList(n);

  @override
  void run() => l.foldLeft<int>(0, (a, b) => a + b);
}

class RibsIVectorFoldBenchmark extends BenchmarkBase {
  final int n;
  late ribs.IVector<int> l;

  RibsIVectorFoldBenchmark(this.n) : super('ribs-ivector-fold-$n');

  @override
  void setup() => l = genRibsIVector(n);

  @override
  void run() => l.foldLeft<int>(0, (a, b) => a + b);
}
