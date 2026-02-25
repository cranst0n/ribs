import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:built_collection/built_collection.dart' as built_list;
import 'package:dartz/dartz.dart' as dartz;
import 'package:fast_immutable_collections/fast_immutable_collections.dart' as fic;
import 'package:kt_dart/collection.dart' as kt;
import 'package:ribs_bench/collection/utils.dart';
import 'package:ribs_core/ribs_core.dart' as ribs;

class DartListMapBenchmark extends BenchmarkBase {
  final int n;
  late List<int> l;

  DartListMapBenchmark(this.n) : super('dart-list-map-$n');

  @override
  void setup() => l = genDartList(n);

  @override
  void run() => l.map((e) => e + 1).toList();
}

class BuiltListMapBenchmark extends BenchmarkBase {
  final int n;
  late built_list.BuiltList<int> l;

  BuiltListMapBenchmark(this.n) : super('built-list-map-$n');

  @override
  void setup() => l = genBuiltList(n);

  @override
  void run() => l.rebuild((p0) => p0.map((x) => x + 1));
}

class DartzIListMapBenchmark extends BenchmarkBase {
  final int n;
  late dartz.IList<int> l;

  DartzIListMapBenchmark(this.n) : super('dartz-ilist-map-$n');

  @override
  void setup() => l = genDartzList(n);

  @override
  void run() => l.map((x) => x + 1);
}

class FICIListMapBenchmark extends BenchmarkBase {
  final int n;
  late fic.IList<int> l;

  FICIListMapBenchmark(this.n) : super('fic-ilist-map-$n');

  @override
  void setup() => l = genFicList(n);

  @override
  void run() => fic.IList(l.map((x) => x + 1));
}

class KtListMapBenchmark extends BenchmarkBase {
  final int n;
  late kt.KtList<int> l;

  KtListMapBenchmark(this.n) : super('kt-list-map-$n');

  @override
  void setup() => l = genKtList(n);

  @override
  void run() => l.map((x) => x + 1);
}

class RibsIChainMapBenchmark extends BenchmarkBase {
  final int n;
  late ribs.IChain<int> l;

  RibsIChainMapBenchmark(this.n) : super('ribs-ichain-map-$n');

  @override
  void setup() => l = genRibsIChain(n);

  @override
  void run() => l.map((x) => x + 1);
}

class RibsIListMapBenchmark extends BenchmarkBase {
  final int n;
  late ribs.IList<int> l;

  RibsIListMapBenchmark(this.n) : super('ribs-ilist-map-$n');

  @override
  void setup() => l = genRibsIList(n);

  @override
  void run() => l.map((x) => x + 1);
}

class RibsIVectorMapBenchmark extends BenchmarkBase {
  final int n;
  late ribs.IVector<int> l;

  RibsIVectorMapBenchmark(this.n) : super('ribs-ivector-map-$n');

  @override
  void setup() => l = genRibsIVector(n);

  @override
  void run() => l.map((x) => x + 1);
}

class RibsListBufferMapBenchmark extends BenchmarkBase {
  final int n;
  late ribs.ListBuffer<int> l;

  RibsListBufferMapBenchmark(this.n) : super('ribs-listbuffer-map-$n');

  @override
  void setup() => l = genRibsListBuffer(n);

  @override
  void run() => l.mapInPlace((x) => x + 1);
}
