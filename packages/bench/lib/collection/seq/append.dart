import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:built_collection/built_collection.dart' as built_list;
import 'package:dartz/dartz.dart' as dartz;
import 'package:fast_immutable_collections/fast_immutable_collections.dart' as fic;
import 'package:kt_dart/collection.dart' as kt;
import 'package:ribs_bench/collection/utils.dart';
import 'package:ribs_core/ribs_core.dart' as ribs;

class DartListAppendBenchmark extends BenchmarkBase {
  final int n;
  late List<int> l;

  DartListAppendBenchmark(this.n) : super('dart-list-append-$n');

  @override
  void setup() => l = genDartList(n);

  @override
  void run() => l.add(0);
}

class BuiltListAppendBenchmark extends BenchmarkBase {
  final int n;
  late built_list.BuiltList<int> l;

  BuiltListAppendBenchmark(this.n) : super('built-list-append-$n');

  @override
  void setup() => l = genBuiltList(n);

  @override
  void run() => l.rebuild((p0) => p0.add(0));
}

class DartzIListAppendBenchmark extends BenchmarkBase {
  final int n;
  late dartz.IList<int> l;

  DartzIListAppendBenchmark(this.n) : super('dartz-ilist-append-$n');

  @override
  void setup() => l = genDartzList(n);

  @override
  void run() => l.appendElement(0);
}

class FICIListAppendBenchmark extends BenchmarkBase {
  final int n;
  late fic.IList<int> l;

  FICIListAppendBenchmark(this.n) : super('fic-ilist-append-$n');

  @override
  void setup() => l = genFicList(n);

  @override
  void run() => l.add(0);
}

class KtListAppendBenchmark extends BenchmarkBase {
  final int n;
  late kt.KtList<int> l;

  KtListAppendBenchmark(this.n) : super('kt-list-append-$n');

  @override
  void setup() => l = genKtList(n);

  @override
  void run() => l.plusElement(0);
}

class RibsIChainAppendBenchmark extends BenchmarkBase {
  final int n;
  late ribs.IChain<int> l;

  RibsIChainAppendBenchmark(this.n) : super('ribs-ichain-append-$n');

  @override
  void setup() => l = genRibsIChain(n);

  @override
  void run() => l.appended(0);
}

class RibsIListAppendBenchmark extends BenchmarkBase {
  final int n;
  late ribs.IList<int> l;

  RibsIListAppendBenchmark(this.n) : super('ribs-ilist-append-$n');

  @override
  void setup() => l = genRibsIList(n);

  @override
  void run() => l.appended(0);
}

class RibsIVectorAppendBenchmark extends BenchmarkBase {
  final int n;
  late ribs.IVector<int> l;

  RibsIVectorAppendBenchmark(this.n) : super('ribs-ivector-append-$n');

  @override
  void setup() => l = genRibsIVector(n);

  @override
  void run() => l.appended(0);
}

class RibsListBufferAppendBenchmark extends BenchmarkBase {
  final int n;
  late ribs.ListBuffer<int> l;

  RibsListBufferAppendBenchmark(this.n) : super('ribs-listbuffer-append-$n');

  @override
  void setup() => l = genRibsListBuffer(n);

  @override
  void run() => l.append(0);
}
