import 'package:ribs_core/ribs_core.dart';

extension RIterableIntOps on RIterable<int> {
  /// Returns the sum of all elements in this list
  int sum() => foldLeft(0, (a, b) => a + b);

  /// Returns the product of all elements in this list
  int product() => foldLeft(1, (a, b) => a * b);
}

extension RIterableDoubleOps on RIterable<double> {
  /// Returns the sum of all elements in this list
  double sum() => foldLeft(0, (a, b) => a + b);

  /// Returns the product of all elements in this list
  double product() => foldLeft(1, (a, b) => a * b);
}

extension RIterableTuple2Ops<A, B> on RIterable<(A, B)> {
  /// Creates a new [IMap] where element tuple element of this list is used to
  /// create a key and value respectively.
  IMap<A, B> toIMap() => IMap.from(this);
}

extension RIterableNested2Ops<A> on RIterable<RIterable<A>> {
  RIterable<A> flatten() => fold(nil(), (acc, elem) => acc.concat(elem));
}
