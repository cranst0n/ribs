import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:built_collection/built_collection.dart' as built_list;
import 'package:fast_immutable_collections/fast_immutable_collections.dart' as fic;
import 'package:kt_dart/collection.dart' as kt;
import 'package:ribs_bench/collection/utils.dart';
import 'package:ribs_core/ribs_core.dart' as ribs;

class DartListApplyBenchmark extends BenchmarkBase {
  final int n;
  late List<int> l;

  DartListApplyBenchmark(this.n) : super('dart-list-apply-$n');

  @override
  void setup() => l = genDartList(n);

  @override
  void run() => l[n ~/ 2];
}

class BuiltListApplyBenchmark extends BenchmarkBase {
  final int n;
  late built_list.BuiltList<int> l;

  BuiltListApplyBenchmark(this.n) : super('built-list-apply-$n');

  @override
  void setup() => l = genBuiltList(n);

  @override
  void run() => l[n ~/ 2];
}

class FICIListApplyBenchmark extends BenchmarkBase {
  final int n;
  late fic.IList<int> l;

  FICIListApplyBenchmark(this.n) : super('fic-ilist-apply-$n');

  @override
  void setup() => l = genFicList(n);

  @override
  void run() => l[n ~/ 2];
}

class KtListApplyBenchmark extends BenchmarkBase {
  final int n;
  late kt.KtList<int> l;

  KtListApplyBenchmark(this.n) : super('kt-list-apply-$n');

  @override
  void setup() => l = genKtList(n);

  @override
  void run() => l[n ~/ 2];
}

class RibsIChainApplyBenchmark extends BenchmarkBase {
  final int n;
  late ribs.IChain<int> l;

  RibsIChainApplyBenchmark(this.n) : super('ribs-ichain-apply-$n');

  @override
  void setup() => l = genRibsIChain(n);

  @override
  void run() => l[n ~/ 2];
}

class RibsIListApplyBenchmark extends BenchmarkBase {
  final int n;
  late ribs.IList<int> l;

  RibsIListApplyBenchmark(this.n) : super('ribs-ilist-apply-$n');

  @override
  void setup() => l = genRibsIList(n);

  @override
  void run() => l[n ~/ 2];
}

class RibsIVectorApplyBenchmark extends BenchmarkBase {
  final int n;
  late ribs.IVector<int> l;

  RibsIVectorApplyBenchmark(this.n) : super('ribs-ivector-apply-$n');

  @override
  void setup() => l = genRibsIVector(n);

  @override
  void run() => l[n ~/ 2];
}

class RibsListBufferApplyBenchmark extends BenchmarkBase {
  final int n;
  late ribs.ListBuffer<int> l;

  RibsListBufferApplyBenchmark(this.n) : super('ribs-listbuffer-apply-$n');

  @override
  void setup() => l = genRibsListBuffer(n);

  @override
  void run() => l[n ~/ 2];
}
