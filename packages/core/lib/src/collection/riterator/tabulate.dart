part of '../riterator.dart';

final class _TabulateIterator<A> extends RIterator<A> {
  final int len;
  final Function1<int, A> f;
  var _i = 0;

  _TabulateIterator(this.len, this.f);

  @override
  bool get hasNext => _i < len;

  @override
  int get knownSize => max(len - _i, 0);

  @override
  A next() {
    if (_i < len) {
      final elem = f(_i);
      _i += 1;
      return elem;
    } else {
      noSuchElement();
    }
  }
}
