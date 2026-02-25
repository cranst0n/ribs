import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:built_collection/built_collection.dart' as built_list;
import 'package:fast_immutable_collections/fast_immutable_collections.dart' as fic;
import 'package:kt_dart/collection.dart' as kt;
import 'package:ribs_bench/benchmark_emitter.dart';
import 'package:ribs_bench/collection/utils.dart';
import 'package:ribs_core/ribs_core.dart' as ribs;

class DartListHeadBenchmark extends BenchmarkBase {
  final int n;
  late List<int> l;

  DartListHeadBenchmark(this.n) : super('dart-list-head-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => l = genDartList(n);

  @override
  void run() => l.first;
}

class BuiltListHeadBenchmark extends BenchmarkBase {
  final int n;
  late built_list.BuiltList<int> l;

  BuiltListHeadBenchmark(this.n) : super('built-list-head-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => l = genBuiltList(n);

  @override
  void run() => l.first;
}

class FICIListHeadBenchmark extends BenchmarkBase {
  final int n;
  late fic.IList<int> l;

  FICIListHeadBenchmark(this.n) : super('fic-ilist-head-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => l = genFicList(n);

  @override
  void run() => l.first;
}

class KtListHeadBenchmark extends BenchmarkBase {
  final int n;
  late kt.KtList<int> l;

  KtListHeadBenchmark(this.n) : super('kt-list-head-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => l = genKtList(n);
}

class RibsIChainHeadBenchmark extends BenchmarkBase {
  final int n;
  late ribs.IChain<int> l;

  RibsIChainHeadBenchmark(this.n) : super('ribs-ichain-head-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => l = genRibsIChain(n);

  @override
  void run() => l.head;
}

class RibsIListHeadBenchmark extends BenchmarkBase {
  final int n;
  late ribs.IList<int> l;

  RibsIListHeadBenchmark(this.n) : super('ribs-ilist-head-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => l = genRibsIList(n);

  @override
  void run() => l.head;
}

class RibsIVectorHeadBenchmark extends BenchmarkBase {
  final int n;
  late ribs.IVector<int> l;

  RibsIVectorHeadBenchmark(this.n) : super('ribs-ivector-head-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => l = genRibsIVector(n);

  @override
  void run() => l.head;
}

class RibsListBufferHeadBenchmark extends BenchmarkBase {
  final int n;
  late ribs.ListBuffer<int> l;

  RibsListBufferHeadBenchmark(this.n)
    : super('ribs-listbuffer-head-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => l = genRibsListBuffer(n);

  @override
  void run() => l.head;
}
