part of '../riterator.dart';

final class _MapIterator<A, B> extends RIterator<B> {
  final RIterator<A> self;
  final Function1<A, B> f;

  const _MapIterator(this.self, this.f);

  @override
  bool get hasNext => self.hasNext;

  @override
  B next() => f(self.next());
}
