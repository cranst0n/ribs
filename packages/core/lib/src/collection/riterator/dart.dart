part of '../riterator.dart';

final class _DartIterator<A> extends RIterator<A> {
  final Iterator<A> self;

  bool _hasNext = false;
  dynamic _nextElem;

  _DartIterator(this.self) {
    _hasNext = self.moveNext();
    _nextElem = hasNext ? self.current : null;
  }

  @override
  bool get hasNext => _hasNext;

  @override
  A next() {
    if (!hasNext) noSuchElement();

    final result = _nextElem;

    _hasNext = self.moveNext();
    if (_hasNext) _nextElem = self.current;

    return result as A;
  }
}