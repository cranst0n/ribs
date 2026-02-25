import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:built_collection/built_collection.dart' as built_list;
import 'package:fast_immutable_collections/fast_immutable_collections.dart' as fic;
import 'package:kt_dart/collection.dart' as kt;
import 'package:ribs_bench/collection/utils.dart';
import 'package:ribs_core/ribs_core.dart' as ribs;

class DartListTakeBenchmark extends BenchmarkBase {
  final int n;
  late List<int> l;

  DartListTakeBenchmark(this.n) : super('dart-list-take-$n');

  @override
  void setup() => l = genDartList(n);

  @override
  void run() => l.take(n ~/ 2).toList();
}

class BuiltListTakeBenchmark extends BenchmarkBase {
  final int n;
  late built_list.BuiltList<int> l;

  BuiltListTakeBenchmark(this.n) : super('built-list-take-$n');

  @override
  void setup() => l = genBuiltList(n);

  @override
  void run() => l.rebuild((p0) => p0.take(n ~/ 2));
}

class FICIListTakeBenchmark extends BenchmarkBase {
  final int n;
  late fic.IList<int> l;

  FICIListTakeBenchmark(this.n) : super('fic-ilist-take-$n');

  @override
  void setup() => l = genFicList(n);

  @override
  void run() => fic.IList(l.take(n ~/ 2));
}

class KtListTakeBenchmark extends BenchmarkBase {
  final int n;
  late kt.KtList<int> l;

  KtListTakeBenchmark(this.n) : super('kt-list-take-$n');

  @override
  void setup() => l = genKtList(n);

  @override
  void run() => l.take(n ~/ 2);
}

class RibsIListTakeBenchmark extends BenchmarkBase {
  final int n;
  late ribs.IList<int> l;

  RibsIListTakeBenchmark(this.n) : super('ribs-ilist-take-$n');

  @override
  void setup() => l = genRibsIList(n);

  @override
  void run() => l.take(n ~/ 2);
}

class RibsIVectorTakeBenchmark extends BenchmarkBase {
  final int n;
  late ribs.IVector<int> l;

  RibsIVectorTakeBenchmark(this.n) : super('ribs-ivector-take-$n');

  @override
  void setup() => l = genRibsIVector(n);

  @override
  void run() => l.take(n ~/ 2);
}
