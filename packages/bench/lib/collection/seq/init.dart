import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:built_collection/built_collection.dart' as built_list;
import 'package:fast_immutable_collections/fast_immutable_collections.dart' as fic;
import 'package:kt_dart/collection.dart' as kt;
import 'package:ribs_bench/benchmark_emitter.dart';
import 'package:ribs_bench/collection/utils.dart';
import 'package:ribs_core/ribs_core.dart' as ribs;

class DartListInitBenchmark extends BenchmarkBase {
  final int n;
  late List<int> l;

  DartListInitBenchmark(this.n) : super('dart-list-init-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => l = genDartList(n);

  @override
  void run() => l.getRange(0, n - 1).toList();
}

class BuiltListInitBenchmark extends BenchmarkBase {
  final int n;
  late built_list.BuiltList<int> l;

  BuiltListInitBenchmark(this.n) : super('built-list-init-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => l = genBuiltList(n);

  @override
  void run() => l.rebuild((p0) => p0.take(n - 1));
}

class FICIListInitBenchmark extends BenchmarkBase {
  final int n;
  late fic.IList<int> l;

  FICIListInitBenchmark(this.n) : super('fic-ilist-init-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => l = genFicList(n);

  @override
  void run() => fic.IList(l.init);
}

class KtListInitBenchmark extends BenchmarkBase {
  final int n;
  late kt.KtList<int> l;

  KtListInitBenchmark(this.n) : super('kt-list-init-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => l = genKtList(n);

  @override
  void run() => l.dropLast(1);
}

class RibsIChainInitBenchmark extends BenchmarkBase {
  final int n;
  late ribs.IChain<int> l;

  RibsIChainInitBenchmark(this.n) : super('ribs-ichain-init-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => l = genRibsIChain(n);

  @override
  void run() => l.init;
}

class RibsIListInitBenchmark extends BenchmarkBase {
  final int n;
  late ribs.IList<int> l;

  RibsIListInitBenchmark(this.n) : super('ribs-ilist-init-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => l = genRibsIList(n);

  @override
  void run() => l.init;
}

class RibsIVectorInitBenchmark extends BenchmarkBase {
  final int n;
  late ribs.IVector<int> l;

  RibsIVectorInitBenchmark(this.n) : super('ribs-ivector-init-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => l = genRibsIVector(n);

  @override
  void run() => l.init;
}
