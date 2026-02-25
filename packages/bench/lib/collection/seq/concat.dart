import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:built_collection/built_collection.dart' as built_list;
import 'package:dartz/dartz.dart' as dartz;
import 'package:fast_immutable_collections/fast_immutable_collections.dart' as fic;
import 'package:kt_dart/collection.dart' as kt;
import 'package:ribs_bench/collection/utils.dart';
import 'package:ribs_core/ribs_core.dart' as ribs;

class DartListConcatBenchmark extends BenchmarkBase {
  final int n;
  late List<int> l;

  DartListConcatBenchmark(this.n) : super('dart-list-concat-$n');

  @override
  void setup() => l = genDartList(n);

  @override
  void run() => l.followedBy(l).toList();
}

class BuiltListConcatBenchmark extends BenchmarkBase {
  final int n;
  late built_list.BuiltList<int> l;

  BuiltListConcatBenchmark(this.n) : super('built-list-concat-$n');

  @override
  void setup() => l = genBuiltList(n);

  @override
  void run() => l.rebuild((p0) => p0.addAll(l));
}

class DartzIListConcatBenchmark extends BenchmarkBase {
  final int n;
  late dartz.IList<int> l;

  DartzIListConcatBenchmark(this.n) : super('dartz-ilist-concat-$n');

  @override
  void setup() => l = genDartzList(n);

  @override
  void run() => l.plus(l);
}

class FICIListConcatBenchmark extends BenchmarkBase {
  final int n;
  late fic.IList<int> l;

  FICIListConcatBenchmark(this.n) : super('fic-ilist-concat-$n');

  @override
  void setup() => l = genFicList(n);

  @override
  void run() => l.addAll(l);
}

class KtListConcatBenchmark extends BenchmarkBase {
  final int n;
  late kt.KtList<int> l;

  KtListConcatBenchmark(this.n) : super('kt-list-concat-$n');

  @override
  void setup() => l = genKtList(n);

  @override
  void run() => l.plus(l);
}

class RibsIChainConcatBenchmark extends BenchmarkBase {
  final int n;
  late ribs.IChain<int> l;

  RibsIChainConcatBenchmark(this.n) : super('ribs-ichain-concat-$n');

  @override
  void setup() => l = genRibsIChain(n);

  @override
  void run() => l.concat(l);
}

class RibsIListConcatBenchmark extends BenchmarkBase {
  final int n;
  late ribs.IList<int> l;

  RibsIListConcatBenchmark(this.n) : super('ribs-ilist-concat-$n');

  @override
  void setup() => l = genRibsIList(n);

  @override
  void run() => l.concat(l);
}

class RibsIVectorConcatBenchmark extends BenchmarkBase {
  final int n;
  late ribs.IVector<int> l;

  RibsIVectorConcatBenchmark(this.n) : super('ribs-ivector-concat-$n');

  @override
  void setup() => l = genRibsIVector(n);

  @override
  void run() => l.concat(l);
}
