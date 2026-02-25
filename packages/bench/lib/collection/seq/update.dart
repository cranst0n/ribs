import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:built_collection/built_collection.dart' as built_list;
import 'package:fast_immutable_collections/fast_immutable_collections.dart' as fic;
import 'package:ribs_bench/collection/utils.dart';
import 'package:ribs_core/ribs_core.dart' as ribs;

class DartListUpdateBenchmark extends BenchmarkBase {
  final int n;
  late List<int> l;

  DartListUpdateBenchmark(this.n) : super('dart-list-update-$n');

  @override
  void setup() => l = genDartList(n);

  @override
  void run() => l[n ~/ 2] = 0;
}

class BuiltListUpdateBenchmark extends BenchmarkBase {
  final int n;
  late built_list.BuiltList<int> l;

  BuiltListUpdateBenchmark(this.n) : super('built-list-update-$n');

  @override
  void setup() => l = genBuiltList(n);

  @override
  void run() => l.rebuild((p0) => p0[n ~/ 2] = 0);
}

class FICIListUpdateBenchmark extends BenchmarkBase {
  final int n;
  late fic.IList<int> l;

  FICIListUpdateBenchmark(this.n) : super('fic-ilist-update-$n');

  @override
  void setup() => l = genFicList(n);

  @override
  void run() => l.replace(n ~/ 2, 0);
}

class RibsIListUpdateBenchmark extends BenchmarkBase {
  final int n;
  late ribs.IList<int> l;

  RibsIListUpdateBenchmark(this.n) : super('ribs-ilist-update-$n');

  @override
  void setup() => l = genRibsIList(n);

  @override
  void run() => l.updated(n ~/ 2, 0);
}

class RibsIVectorUpdateBenchmark extends BenchmarkBase {
  final int n;
  late ribs.IVector<int> l;

  RibsIVectorUpdateBenchmark(this.n) : super('ribs-ivector-update-$n');

  @override
  void setup() => l = genRibsIVector(n);

  @override
  void run() => l.updated(n ~/ 2, 0);
}

class RibsListBufferUpdateBenchmark extends BenchmarkBase {
  final int n;
  late ribs.ListBuffer<int> l;

  RibsListBufferUpdateBenchmark(this.n) : super('ribs-listbuffer-update-$n');

  @override
  void setup() => l = genRibsListBuffer(n);

  @override
  void run() => l.update(n ~/ 2, 0);
}
