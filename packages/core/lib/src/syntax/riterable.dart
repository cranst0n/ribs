import 'package:ribs_core/ribs_core.dart';

extension RIterableIntOps on RIterableOnce<int> {
  /// Returns the sum of all elements in this list
  int sum() {
    var s = 0;
    final it = iterator;

    while (it.hasNext) {
      s += it.next();
    }

    return s;
  }

  /// Returns the product of all elements in this list
  int product() {
    var p = 1;
    final it = iterator;

    while (it.hasNext) {
      p *= it.next();
    }

    return p;
  }
}

extension RIterableDoubleOps on RIterableOnce<double> {
  /// Returns the sum of all elements in this list
  double sum() {
    var s = 0.0;
    final it = iterator;

    while (it.hasNext) {
      s += it.next();
    }

    return s;
  }

  /// Returns the product of all elements in this list
  double product() {
    var p = 1.0;
    final it = iterator;

    while (it.hasNext) {
      p *= it.next();
    }

    return p;
  }
}

extension RIterableTuple2Ops<A, B> on RIterable<(A, B)> {
  /// Creates a new [IMap] where element tuple element of this list is used to
  /// create a key and value respectively.
  IMap<A, B> toIMap() => IMap.from(this);
}

extension RIterableNested2Ops<A> on RIterable<RIterable<A>> {
  RIterable<A> flatten() {
    final it = iterator;
    final b = IList.builder<A>();

    while (it.hasNext) {
      b.addAll(it.next());
    }

    return b.toIList();
  }
}
