import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:built_collection/built_collection.dart' as built_list;
import 'package:fast_immutable_collections/fast_immutable_collections.dart' as fic;
import 'package:kt_dart/collection.dart' as kt;
import 'package:ribs_bench/benchmark_emitter.dart';
import 'package:ribs_bench/collection/utils.dart';
import 'package:ribs_core/ribs_core.dart' as ribs;

class DartListDropBenchmark extends BenchmarkBase {
  final int n;
  late List<int> l;

  DartListDropBenchmark(this.n) : super('dart-list-drop-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => l = genDartList(n);

  @override
  void run() => l.skip(n ~/ 2).toList();
}

class BuiltListDropBenchmark extends BenchmarkBase {
  final int n;
  late built_list.BuiltList<int> l;

  BuiltListDropBenchmark(this.n) : super('built-list-drop-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => l = genBuiltList(n);

  @override
  void run() => l.rebuild((p0) => p0.skip(n ~/ 2));
}

class FICIListDropBenchmark extends BenchmarkBase {
  final int n;
  late fic.IList<int> l;

  FICIListDropBenchmark(this.n) : super('fic-ilist-drop-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => l = genFicList(n);

  @override
  void run() => fic.IList(l.skip(n ~/ 2));
}

class KtListDropBenchmark extends BenchmarkBase {
  final int n;
  late kt.KtList<int> l;

  KtListDropBenchmark(this.n) : super('kt-list-drop-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => l = genKtList(n);

  @override
  void run() => l.drop(n ~/ 2);
}

class RibsIListDropBenchmark extends BenchmarkBase {
  final int n;
  late ribs.IList<int> l;

  RibsIListDropBenchmark(this.n) : super('ribs-ilist-drop-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => l = genRibsIList(n);

  @override
  void run() => l.drop(n ~/ 2);
}

class RibsIVectorDropBenchmark extends BenchmarkBase {
  final int n;
  late ribs.IVector<int> l;

  RibsIVectorDropBenchmark(this.n) : super('ribs-ivector-drop-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => l = genRibsIVector(n);

  @override
  void run() => l.drop(n ~/ 2);
}
