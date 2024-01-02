part of '../iterator.dart';

final class _MapIterator<A, B> extends RibsIterator<B> {
  final RibsIterator<A> self;
  final Function1<A, B> f;

  const _MapIterator(this.self, this.f);

  @override
  bool get hasNext => self.hasNext;

  @override
  B next() => f(self.next());
}
