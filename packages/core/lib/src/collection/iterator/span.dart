part of '../iterator.dart';

(RibsIterator<A>, RibsIterator<A>) spanIterator<A>(
  RibsIterator<A> self,
  Function1<A, bool> p,
) {
  final leading = _SpanLeadingIterator(self, p);
  final trailing = _SpanTrailingIterator(self, leading);

  return (leading, trailing);
}

final class _SpanLeadingIterator<A> extends RibsIterator<A> {
  final RibsIterator<A> self;
  final Function1<A, bool> p;

  Queue<A>? _lookahead;
  late A _hd;

  // Status is kept with magic numbers
  //   1 means next element is in hd and we're still reading into this iterator
  //   0 means we're still reading but haven't found a next element
  //  -1 means we are done reading into the iterator, so we must rely on lookahead
  //  -2 means we are done but have saved hd for the other iterator to use as its first element
  //
  int _status = 0;

  _SpanLeadingIterator(this.self, this.p);

  @override
  bool get hasNext {
    if (_status < 0) {
      return _lookahead != null && _lookahead!.isNotEmpty;
    } else if (_status > 0) {
      return true;
    } else {
      if (self.hasNext) {
        _hd = self.next();
        _status = p(_hd) ? 1 : -2;
      } else {
        _status = -1;
      }

      return _status > 0;
    }
  }

  @override
  A next() {
    if (hasNext) {
      if (_status == 1) {
        _status = 0;
        return _hd;
      } else {
        return _lookahead!.removeLast();
      }
    } else {
      noSuchElement();
    }
  }

  void store(A a) {
    _lookahead ??= Queue();
    _lookahead!.addFirst(a);
  }

  // TODO: tailrec?
  bool finish() {
    switch (_status) {
      case -2:
        _status = -1;
        return true;
      case -1:
        return false;
      case 1:
        store(_hd);
        _status = 0;
        return finish();
      case 0:
        _status = -1;

        while (self.hasNext) {
          final a = self.next();

          if (p(a)) {
            store(a);
          } else {
            _hd = a;
            return true;
          }
        }

        return false;
      default:
        throw StateError('SpanLeadingIterator: $_status');
    }
  }

  A get trailer => _hd!;
}

final class _SpanTrailingIterator<A> extends RibsIterator<A> {
  final RibsIterator<A> self;

  _SpanLeadingIterator<A>? myLeading;

  // Status flag meanings:
  //  -1 not yet accessed
  //   0 single element waiting in leading
  //   1 defer to self
  //   2 self.hasNext already
  //   3 exhausted
  var _status = -1;

  _SpanTrailingIterator(this.self, this.myLeading);

  @override
  bool get hasNext {
    switch (_status) {
      case 3:
        return false;
      case 2:
        return true;
      case 1:
        if (self.hasNext) {
          _status = 2;
          return true;
        } else {
          _status = 3;
          return false;
        }
      case 0:
        return true;
      default:
        throw StateError('SpanTrailingIterator: $_status');
    }
  }

  @override
  A next() {
    if (hasNext) {
      if (_status == 0) {
        _status = 1;
        final res = myLeading!.trailer;
        myLeading = null;
        return res;
      } else {
        _status = 1;
        return self.next();
      }
    } else {
      noSuchElement();
    }
  }
}
