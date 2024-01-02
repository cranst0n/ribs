part of '../iterator.dart';

final class _EmptyIterator<A> extends RibsIterator<A> {
  const _EmptyIterator();

  @override
  bool get hasNext => false;

  @override
  A next() => noSuchElement();

  @override
  RibsIterator<A> sliceIterator(int from, int until) => this;
}
