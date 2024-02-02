part of '../riterator.dart';

final class _EmptyIterator<A> extends RIterator<A> {
  const _EmptyIterator();

  @override
  bool get hasNext => false;

  @override
  A next() => noSuchElement();

  @override
  RIterator<A> sliceIterator(int from, int until) => this;
}
