part of '../iterator.dart';

final class _CollectIterator<A, B> extends RibsIterator<B> {
  final RibsIterator<A> self;
  final Function1<A, Option<B>> f;

  B? _hd;
  int _status = 0; // Seek = 0; Found = 1; Empty = -1

  _CollectIterator(this.self, this.f);

  @override
  bool get hasNext {
    while (_status == 0) {
      if (self.hasNext) {
        final x = self.next();
        final v = f(x);

        v.foreach((v) {
          _hd = v;
          _status = 1;
        });
      } else {
        _status = -1;
      }
    }

    return _status == 1;
  }

  @override
  B next() {
    if (hasNext) {
      _status = 0;
      return _hd!;
    } else {
      noSuchElement();
    }
  }
}
