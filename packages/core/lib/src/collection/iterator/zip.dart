part of '../iterator.dart';

final class _ZipIterator<A, B> extends RibsIterator<(A, B)> {
  final RibsIterator<A> self;
  final IterableOnce<B> that;

  final RibsIterator<B> thatIterator;

  _ZipIterator(this.self, this.that) : thatIterator = that.iterator;

  @override
  bool get hasNext => self.hasNext && thatIterator.hasNext;

  @override
  int get knownSize => min(self.knownSize, that.knownSize);

  @override
  (A, B) next() => (self.next(), thatIterator.next());
}
