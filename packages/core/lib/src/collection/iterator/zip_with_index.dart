part of '../iterator.dart';

final class _ZipWithIndexIterator<A> extends RibsIterator<(A, int)> {
  final RibsIterator<A> self;
  int _i = 0;

  _ZipWithIndexIterator(this.self);

  @override
  bool get hasNext => self.hasNext;

  @override
  int get knownSize => self.knownSize;

  @override
  (A, int) next() {
    final res = (self.next(), _i);
    _i += 1;
    return res;
  }
}
