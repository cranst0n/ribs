import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:built_collection/built_collection.dart' as built_list;
import 'package:dartz/dartz.dart' as dartz;
import 'package:fast_immutable_collections/fast_immutable_collections.dart' as fic;
import 'package:kt_dart/collection.dart' as kt;
import 'package:ribs_bench/benchmark_emitter.dart';
import 'package:ribs_bench/collection/utils.dart';
import 'package:ribs_core/ribs_core.dart' as ribs;

class DartListFilterBenchmark extends BenchmarkBase {
  final int n;
  late List<int> l;

  DartListFilterBenchmark(this.n) : super('dart-list-filter-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => l = genDartList(n);

  @override
  void run() => l.where((e) => e.isOdd).toList();
}

class BuiltListFilterBenchmark extends BenchmarkBase {
  final int n;
  late built_list.BuiltList<int> l;

  BuiltListFilterBenchmark(this.n) : super('built-list-filter-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => l = genBuiltList(n);

  @override
  void run() => l.rebuild((p0) => p0.where((x) => x.isOdd));
}

class DartzIListFilterBenchmark extends BenchmarkBase {
  final int n;
  late dartz.IList<int> l;

  DartzIListFilterBenchmark(this.n)
    : super('dartz-ilist-filter-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => l = genDartzList(n);

  @override
  void run() => l.filter((x) => x.isOdd);
}

class FICIListFilterBenchmark extends BenchmarkBase {
  final int n;
  late fic.IList<int> l;

  FICIListFilterBenchmark(this.n) : super('fic-ilist-filter-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => l = genFicList(n);

  @override
  void run() => fic.IList(l.where((x) => x.isOdd));
}

class KtListFilterBenchmark extends BenchmarkBase {
  final int n;
  late kt.KtList<int> l;

  KtListFilterBenchmark(this.n) : super('kt-list-filter-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => l = genKtList(n);

  @override
  void run() => l.filter((x) => x.isOdd);
}

class RibsIChainFilterBenchmark extends BenchmarkBase {
  final int n;
  late ribs.IChain<int> l;

  RibsIChainFilterBenchmark(this.n)
    : super('ribs-ichain-filter-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => l = genRibsIChain(n);

  @override
  void run() => l.filter((x) => x.isOdd);
}

class RibsIListFilterBenchmark extends BenchmarkBase {
  final int n;
  late ribs.IList<int> l;

  RibsIListFilterBenchmark(this.n) : super('ribs-ilist-filter-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => l = genRibsIList(n);

  @override
  void run() => l.filter((x) => x.isOdd);
}

class RibsIVectorFilterBenchmark extends BenchmarkBase {
  final int n;
  late ribs.IVector<int> l;

  RibsIVectorFilterBenchmark(this.n)
    : super('ribs-ivector-filter-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => l = genRibsIVector(n);

  @override
  void run() => l.filter((x) => x.isOdd);
}

class RibsListBufferFilterBenchmark extends BenchmarkBase {
  final int n;
  late ribs.ListBuffer<int> l;

  RibsListBufferFilterBenchmark(this.n)
    : super('ribs-listbuffer-filter-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => l = genRibsListBuffer(n);

  @override
  void run() => l.filterInPlace((x) => x.isOdd);
}
