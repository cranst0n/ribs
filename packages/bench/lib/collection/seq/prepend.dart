import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:built_collection/built_collection.dart' as built_list;
import 'package:dartz/dartz.dart' as dartz;
import 'package:fast_immutable_collections/fast_immutable_collections.dart' as fic;
import 'package:ribs_bench/collection/utils.dart';
import 'package:ribs_core/ribs_core.dart' as ribs;

class DartListPrependBenchmark extends BenchmarkBase {
  final int n;
  late List<int> l;

  DartListPrependBenchmark(this.n) : super('dart-list-prepend-$n');

  @override
  void setup() => l = genDartList(n);

  @override
  void run() => l.insert(0, 0);
}

class BuiltListPrependBenchmark extends BenchmarkBase {
  final int n;
  late built_list.BuiltList<int> l;

  BuiltListPrependBenchmark(this.n) : super('built-list-prepend-$n');

  @override
  void setup() => l = genBuiltList(n);

  @override
  void run() => l.rebuild((p0) => p0.insert(0, 0));
}

class DartzIListPrependBenchmark extends BenchmarkBase {
  final int n;
  late dartz.IList<int> l;

  DartzIListPrependBenchmark(this.n) : super('dartz-ilist-prepend-$n');

  @override
  void setup() => l = genDartzList(n);

  @override
  void run() => l.prependElement(0);
}

class FICIListPrependBenchmark extends BenchmarkBase {
  final int n;
  late fic.IList<int> l;

  FICIListPrependBenchmark(this.n) : super('fic-ilist-prepend-$n');

  @override
  void setup() => l = genFicList(n);

  @override
  void run() => l.insert(0, 0);
}

class RibsIChainPrependBenchmark extends BenchmarkBase {
  final int n;
  late ribs.IChain<int> l;

  RibsIChainPrependBenchmark(this.n) : super('ribs-ichain-prepend-$n');

  @override
  void setup() => l = genRibsIChain(n);

  @override
  void run() => l.prepended(0);
}

class RibsIListPrependBenchmark extends BenchmarkBase {
  final int n;
  late ribs.IList<int> l;

  RibsIListPrependBenchmark(this.n) : super('ribs-ilist-prepend-$n');

  @override
  void setup() => l = genRibsIList(n);

  @override
  void run() => l.prepended(0);
}

class RibsIVectorPrependBenchmark extends BenchmarkBase {
  final int n;
  late ribs.IVector<int> l;

  RibsIVectorPrependBenchmark(this.n) : super('ribs-ivector-prepend-$n');

  @override
  void setup() => l = genRibsIVector(n);

  @override
  void run() => l.prepended(0);
}

class RibsListBufferPrependBenchmark extends BenchmarkBase {
  final int n;
  late ribs.ListBuffer<int> l;

  RibsListBufferPrependBenchmark(this.n) : super('ribs-listbuffer-prepend-$n');

  @override
  void setup() => l = genRibsListBuffer(n);

  @override
  void run() => l.prepend(0);
}
