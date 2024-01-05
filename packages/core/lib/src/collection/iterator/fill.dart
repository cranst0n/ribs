part of '../iterator.dart';

final class _FillIterator<A> extends RibsIterator<A> {
  final int len;
  final A elem;
  var _i = 0;

  _FillIterator(this.len, this.elem);

  @override
  bool get hasNext => _i < len;

  @override
  int get knownSize => max(len, 0);

  @override
  A next() {
    if (_i < len) {
      _i += 1;
      return elem;
    } else {
      noSuchElement();
    }
  }
}
