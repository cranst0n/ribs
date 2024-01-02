part of '../iterator.dart';

final class _SingleIterator<A> extends RibsIterator<A> {
  final A a;
  bool _consumed = false;

  _SingleIterator(this.a);

  @override
  bool get hasNext => !_consumed;

  @override
  A next() {
    if (_consumed) {
      noSuchElement();
    } else {
      _consumed = true;
      return a;
    }
  }

  @override
  RibsIterator<A> sliceIterator(int from, int until) {
    if (_consumed || from > 0 || until == 0) {
      return RibsIterator.empty();
    } else {
      return this;
    }
  }
}
