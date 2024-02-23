part of '../riterator.dart';

final class _FlatMapIterator<A, B> extends RIterator<B> {
  final RIterator<A> self;
  final Function1<A, RIterableOnce<B>> f;

  RIterator<B> cur = RIterator.empty();
  int _hasNext = -1;

  _FlatMapIterator(this.self, this.f);

  @override
  bool get hasNext {
    if (_hasNext == -1) {
      while (!cur.hasNext) {
        if (!self.hasNext) {
          _hasNext = 0;
          // since we know we are exhausted, we can release cur for gc, and as well replace with
          // static Iterator.empty which will support efficient subsequent `hasNext`/`next` calls
          cur = RIterator.empty();
          return false;
        }
        nextCur();
      }
      _hasNext = 1;
      return true;
    } else {
      return _hasNext == 1;
    }
  }

  @override
  B next() {
    if (hasNext) {
      _hasNext = -1;
    }

    return cur.next();
  }

  void nextCur() {
    cur = RIterator.empty();
    cur = f(self.next()).iterator;
    _hasNext = -1;
  }
}
