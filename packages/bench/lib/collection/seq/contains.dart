import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:built_collection/built_collection.dart' as built_list;
import 'package:dartz/dartz.dart' as dartz;
import 'package:fast_immutable_collections/fast_immutable_collections.dart' as fic;
import 'package:kt_dart/collection.dart' as kt;
import 'package:ribs_bench/benchmark_emitter.dart';
import 'package:ribs_bench/collection/utils.dart';
import 'package:ribs_core/ribs_core.dart' as ribs;

class DartListContainsBenchmark extends BenchmarkBase {
  final int n;
  late List<int> l;

  DartListContainsBenchmark(this.n)
    : super('dart-list-contains-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => l = genDartList(n);

  @override
  void run() => l.contains(n ~/ 2);
}

class BuiltListContainsBenchmark extends BenchmarkBase {
  final int n;
  late built_list.BuiltList<int> l;

  BuiltListContainsBenchmark(this.n)
    : super('built-list-contains-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => l = genBuiltList(n);

  @override
  void run() => l.contains(n ~/ 2);
}

class DartzIListContainsBenchmark extends BenchmarkBase {
  final int n;
  late dartz.IList<int> l;

  DartzIListContainsBenchmark(this.n)
    : super('dartz-ilist-contains-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => l = genDartzList(n);

  @override
  void run() => l.find((x) => x == n ~/ 2);
}

class FICIListContainsBenchmark extends BenchmarkBase {
  final int n;
  late fic.IList<int> l;

  FICIListContainsBenchmark(this.n)
    : super('fic-ilist-contains-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => l = genFicList(n);

  @override
  void run() => l.contains(n ~/ 2);
}

class KtListContainsBenchmark extends BenchmarkBase {
  final int n;
  late kt.KtList<int> l;

  KtListContainsBenchmark(this.n) : super('kt-list-contains-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => l = genKtList(n);

  @override
  void run() => l.contains(n ~/ 2);
}

class RibsIListContainsBenchmark extends BenchmarkBase {
  final int n;
  late ribs.IList<int> l;

  RibsIListContainsBenchmark(this.n)
    : super('ribs-ilist-contains-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => l = genRibsIList(n);

  @override
  void run() => l.contains(n ~/ 2);
}

class RibsIVectorContainsBenchmark extends BenchmarkBase {
  final int n;
  late ribs.IVector<int> l;

  RibsIVectorContainsBenchmark(this.n)
    : super('ribs-ivector-contains-$n', emitter: RibsBenchmarkEmitter());

  @override
  void setup() => l = genRibsIVector(n);

  @override
  void run() => l.contains(n ~/ 2);
}
