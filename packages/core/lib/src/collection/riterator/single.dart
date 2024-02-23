part of '../riterator.dart';

final class _SingleIterator<A> extends RIterator<A> {
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
  RIterator<A> sliceIterator(int from, int until) {
    if (_consumed || from > 0 || until == 0) {
      return RIterator.empty();
    } else {
      return this;
    }
  }
}
