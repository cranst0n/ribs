part of '../iterator.dart';

final class _IterateIterator<A> extends RibsIterator<A> {
  final A start;
  final Function1<A, A> f;

  bool _first = true;
  A _acc;

  _IterateIterator(this.start, this.f) : _acc = start;

  @override
  bool get hasNext => true;

  @override
  A next() {
    if (_first) {
      _first = false;
    } else {
      _acc = f(_acc);
    }

    return _acc;
  }
}
