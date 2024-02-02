part of '../riterator.dart';

final class _ZipIterator<A, B> extends RIterator<(A, B)> {
  final RIterator<A> self;
  final RIterableOnce<B> that;

  final RIterator<B> thatIterator;

  _ZipIterator(this.self, this.that) : thatIterator = that.iterator;

  @override
  bool get hasNext => self.hasNext && thatIterator.hasNext;

  @override
  int get knownSize => min(self.knownSize, that.knownSize);

  @override
  (A, B) next() => (self.next(), thatIterator.next());
}
