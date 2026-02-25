import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:built_collection/built_collection.dart' as built_list;
import 'package:dartz/dartz.dart' as dartz;
import 'package:fast_immutable_collections/fast_immutable_collections.dart' as fic;
import 'package:kt_dart/collection.dart' as kt;
import 'package:ribs_bench/benchmark_emitter.dart';
import 'package:ribs_bench/collection/utils.dart';
import 'package:ribs_core/ribs_core.dart' as ribs;

class DartListTailBenchmark extends BenchmarkBase {
  final int n;
  late List<int> l;

  DartListTailBenchmark(this.n) : super('dart-list-tail-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => l = genDartList(n);

  @override
  void run() => l.skip(1).toList();
}

class BuiltListTailBenchmark extends BenchmarkBase {
  final int n;
  late built_list.BuiltList<int> l;

  BuiltListTailBenchmark(this.n) : super('built-list-tail-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => l = genBuiltList(n);

  @override
  void run() => l.rebuild((p0) => p0.skip(1));
}

class DartzIListTailBenchmark extends BenchmarkBase {
  final int n;
  late dartz.IList<int> l;

  DartzIListTailBenchmark(this.n) : super('dartz-ilist-tail-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => l = genDartzList(n);

  @override
  void run() => l.tailOption.getOrElse(() => throw '');
}

class FICIListTailBenchmark extends BenchmarkBase {
  final int n;
  late fic.IList<int> l;

  FICIListTailBenchmark(this.n) : super('fic-ilist-tail-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => l = genFicList(n);

  @override
  void run() => fic.IList(l.tail);
}

class KtListTailBenchmark extends BenchmarkBase {
  final int n;
  late kt.KtList<int> l;

  KtListTailBenchmark(this.n) : super('kt-list-tail-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => l = genKtList(n);

  @override
  void run() => l.drop(1);
}

class RibsIChainTailBenchmark extends BenchmarkBase {
  final int n;
  late ribs.IChain<int> l;

  RibsIChainTailBenchmark(this.n) : super('ribs-ichain-tail-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => l = genRibsIChain(n);

  @override
  void run() => l.tail;
}

class RibsIListTailBenchmark extends BenchmarkBase {
  final int n;
  late ribs.IList<int> l;

  RibsIListTailBenchmark(this.n) : super('ribs-ilist-tail-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => l = genRibsIList(n);

  @override
  void run() => l.tail;
}

class RibsIVectorTailBenchmark extends BenchmarkBase {
  final int n;
  late ribs.IVector<int> l;

  RibsIVectorTailBenchmark(this.n) : super('ribs-ivector-tail-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => l = genRibsIVector(n);

  @override
  void run() => l.tail;
}
