// ignore_for_file: unreachable_from_main

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    as fic;
import 'package:fpdart/fpdart.dart';
import 'package:ribs_core/ribs_collection.dart';

const n = 1000;
const idxs = [0, n ~/ 4, n ~/ 2, n ~/ 2 + n ~/ 4, n - 1];
int mapF(int i) => i + 1;

void main(List<String> args) {
  VectorFillBenchmark('Ribs: fill').report();
  FICFillBenchmark('FICL: fill').report();

  VectorTabulateBenchmark('Ribs: tabulate').report();
  FICTabulateBenchmark('FICL: tabulate').report();

  VectorUpdatedBenchmark('Ribs: updated').report();
  FICUpdatedBenchmark('FICL: updated').report();

  VectorTailBenchmark('Ribs: tail').report();
  FICTailBenchmark('FICL: tail').report();

  VectorInitBenchmark('Ribs: init').report();
  FICInitBenchmark('FICL: init').report();

  VectorAppendedBenchmark('Ribs: appended').report();
  FICAppendedBenchmark('FICL: appended').report();

  VectorPrependedBenchmark('Ribs: prepended').report();
  FICPrependedBenchmark('FICL: prepended').report();

  VectorMapBenchmark('Ribs: map').report();
  FICMapBenchmark('FICL: map').report();

  VectorTakeBenchmark('Ribs: take').report();
  FICTakeBenchmark('FICL: take').report();

  // VectorComplexBenchmark('Ribs: complex', 10).report();
  // VectorViewComplexBenchmark('Ribs: complex (view)', 1).report();
  // FICComplexBenchmark('FICL: complex', 1).report();
}

class FICFillBenchmark extends BenchmarkBase {
  FICFillBenchmark(super.name);

  @override
  void run() {
    fic.IList.tabulate(n, (_) => 0).toIList();
  }
}

class VectorFillBenchmark extends BenchmarkBase {
  VectorFillBenchmark(super.name);

  @override
  void run() {
    IVector.fill(n, 0);
  }
}

class FICTabulateBenchmark extends BenchmarkBase {
  FICTabulateBenchmark(super.name);

  @override
  void run() {
    fic.IList.tabulate(n, (x) => x).toIList();
  }
}

class VectorTabulateBenchmark extends BenchmarkBase {
  VectorTabulateBenchmark(super.name);

  @override
  void run() {
    IVector.tabulate(n, (x) => x);
  }
}

class FICUpdatedBenchmark extends BenchmarkBase {
  late fic.IList<int> col;

  FICUpdatedBenchmark(super.name);

  @override
  void setup() {
    col = fic.IList.tabulate(n, (_) => 0).toIList();
  }

  @override
  void run() {
    var x = col;

    for (final idx in idxs) {
      x = x.replace(idx, -1);
    }

    for (final idx in idxs) {
      assert(x[idx] == -1);
    }
  }
}

class VectorUpdatedBenchmark extends BenchmarkBase {
  late IVector<int> col;

  VectorUpdatedBenchmark(super.name);

  @override
  void setup() {
    col = IVector.fill(n, 0);
  }

  @override
  void run() {
    var x = col;

    for (final idx in idxs) {
      x = x.updated(idx, -1);
    }

    for (final idx in idxs) {
      assert(x[idx] == -1);
    }
  }
}

class FICTailBenchmark extends BenchmarkBase {
  late fic.IList<int> col;

  FICTailBenchmark(super.name);

  @override
  void setup() {
    col = fic.IList.tabulate(n, (_) => 0).toIList();
  }

  @override
  void run() {
    final _ = col.tail.toIList();
  }
}

class VectorTailBenchmark extends BenchmarkBase {
  late IVector<int> col;

  VectorTailBenchmark(super.name);

  @override
  void setup() {
    col = IVector.fill(n, 0);
  }

  @override
  void run() {
    col.tail();
  }
}

class FICInitBenchmark extends BenchmarkBase {
  late fic.IList<int> col;

  FICInitBenchmark(super.name);

  @override
  void setup() {
    col = fic.IList.tabulate(n, (_) => 0).toIList();
  }

  @override
  void run() {
    final _ = col.init.toIList();
  }
}

class VectorInitBenchmark extends BenchmarkBase {
  late IVector<int> col;

  VectorInitBenchmark(super.name);

  @override
  void setup() {
    col = IVector.fill(n, 0);
  }

  @override
  void run() {
    col.init();
  }
}

class FICAppendedBenchmark extends BenchmarkBase {
  late fic.IList<int> col;

  FICAppendedBenchmark(super.name);

  @override
  void setup() {
    col = fic.IList.tabulate(n, (_) => 0).toIList();
  }

  @override
  void run() {
    final _ = col.add(0).toIList();
  }
}

class VectorAppendedBenchmark extends BenchmarkBase {
  late IVector<int> col;

  VectorAppendedBenchmark(super.name);

  @override
  void setup() {
    col = IVector.fill(n, 0);
  }

  @override
  void run() {
    col.appended(0);
  }
}

class FICPrependedBenchmark extends BenchmarkBase {
  late fic.IList<int> col;

  FICPrependedBenchmark(super.name);

  @override
  void setup() {
    col = fic.IList.tabulate(n, (_) => 0).toIList();
  }

  @override
  void run() {
    final _ = col.prepend(0).toIList();
  }
}

class VectorPrependedBenchmark extends BenchmarkBase {
  late IVector<int> col;

  VectorPrependedBenchmark(super.name);

  @override
  void setup() {
    col = IVector.fill(n, 0);
  }

  @override
  void run() {
    col.prepended(0);
  }
}

class FICMapBenchmark extends BenchmarkBase {
  late fic.IList<int> col;

  FICMapBenchmark(super.name);

  @override
  void setup() {
    col = fic.IList.tabulate(n, (_) => 0).toIList();
  }

  @override
  void run() {
    final _ = col.map(mapF).toIList();
  }
}

class VectorMapBenchmark extends BenchmarkBase {
  late IVector<int> col;

  VectorMapBenchmark(super.name);

  @override
  void setup() {
    col = IVector.fill(n, 0);
  }

  @override
  void run() {
    col.map(mapF);
  }
}

class FICTakeBenchmark extends BenchmarkBase {
  late fic.IList<int> col;

  FICTakeBenchmark(super.name);

  @override
  void setup() {
    col = fic.IList.tabulate(n, (_) => 0).toIList();
  }

  @override
  void run() {
    final _ = col.take(n ~/ 2).toIList();
  }
}

class VectorTakeBenchmark extends BenchmarkBase {
  late IVector<int> col;

  VectorTakeBenchmark(super.name);

  @override
  void setup() {
    col = IVector.fill(n, 0);
  }

  @override
  void run() {
    col.take(n ~/ 2);
  }
}

class FICComplexBenchmark extends BenchmarkBase {
  late fic.IList<int> col;
  final int nMaps;

  FICComplexBenchmark(super.name, this.nMaps);

  @override
  void setup() {
    col = fic.IList.tabulate(n, (_) => 0).toIList();
  }

  @override
  void run() {
    var i = col.map(mapF);
    Iterable<int>.generate(nMaps - 1).forEach((_) => i = i.map(mapF));
    // .take(n ~/ 2).drop(n ~/ 3).dropRight(n ~/ 10)
    i.toIList();
  }
}

class VectorComplexBenchmark extends BenchmarkBase {
  late IVector<int> col;
  final int nMaps;

  VectorComplexBenchmark(super.name, this.nMaps);

  @override
  void setup() => col = IVector.fill(n, 0);

  @override
  void run() {
    Iterable<int>.generate(nMaps).forEach((_) => col = col.map(mapF));
    col = col.take(n ~/ 2);
  }
}

class VectorViewComplexBenchmark extends BenchmarkBase {
  late IVector<int> col;
  final int nMaps;

  VectorViewComplexBenchmark(super.name, this.nMaps);

  @override
  void setup() {
    col = IVector.fill(n, 0);
  }

  @override
  void run() {
    var v = col.view();

    Iterable<int>.generate(nMaps).forEach((_) => v = v.map(mapF));

    v = v.take(n ~/ 2);

    col = v.toIVector();
  }
}
