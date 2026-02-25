import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:built_collection/built_collection.dart' as built_list;
import 'package:dartz/dartz.dart' as dartz;
import 'package:fast_immutable_collections/fast_immutable_collections.dart' as fic;
import 'package:kt_dart/collection.dart' as kt;
import 'package:ribs_bench/collection/utils.dart';
import 'package:ribs_core/ribs_core.dart' as ribs;

class DartListReverseBenchmark extends BenchmarkBase {
  final int n;
  late List<int> l;

  DartListReverseBenchmark(this.n) : super('dart-list-reverse-$n');

  @override
  void setup() => l = genDartList(n);

  @override
  void run() => l.reversed.toList();
}

class BuiltListReverseBenchmark extends BenchmarkBase {
  final int n;
  late built_list.BuiltList<int> l;

  BuiltListReverseBenchmark(this.n) : super('built-list-reverse-$n');

  @override
  void setup() => l = genBuiltList(n);

  @override
  void run() => l.rebuild((p0) => p0.reverse());
}

class DartzIListReverseBenchmark extends BenchmarkBase {
  final int n;
  late dartz.IList<int> l;

  DartzIListReverseBenchmark(this.n) : super('dartz-ilist-reverse-$n');

  @override
  void setup() => l = genDartzList(n);

  @override
  void run() => l.reverse();
}

class FICIListReverseBenchmark extends BenchmarkBase {
  final int n;
  late fic.IList<int> l;

  FICIListReverseBenchmark(this.n) : super('fic-ilist-reverse-$n');

  @override
  void setup() => l = genFicList(n);

  @override
  void run() => l.reversed;
}

class KtListReverseBenchmark extends BenchmarkBase {
  final int n;
  late kt.KtList<int> l;

  KtListReverseBenchmark(this.n) : super('kt-list-reverse-$n');

  @override
  void setup() => l = genKtList(n);

  @override
  void run() => l.reversed();
}

class RibsIChainReverseBenchmark extends BenchmarkBase {
  final int n;
  late ribs.IChain<int> l;

  RibsIChainReverseBenchmark(this.n) : super('ribs-ichain-reverse-$n');

  @override
  void setup() => l = genRibsIChain(n);

  @override
  void run() => l.reverse();
}

class RibsIListReverseBenchmark extends BenchmarkBase {
  final int n;
  late ribs.IList<int> l;

  RibsIListReverseBenchmark(this.n) : super('ribs-ilist-reverse-$n');

  @override
  void setup() => l = genRibsIList(n);

  @override
  void run() => l.reverse();
}

class RibsIVectorReverseBenchmark extends BenchmarkBase {
  final int n;
  late ribs.IVector<int> l;

  RibsIVectorReverseBenchmark(this.n) : super('ribs-ivector-reverse-$n');

  @override
  void setup() => l = genRibsIVector(n);

  @override
  void run() => l.reverse();
}
