part of '../iset.dart';

class _SetNIterator<A> extends RibsIterator<A> {
  final int n;
  final Function1<int, A> apply;

  int _current = 0;
  int _remainder;

  _SetNIterator(this.n, this.apply) : _remainder = n;

  @override
  RibsIterator<A> drop(int n) {
    if (n > 0) {
      _current += n;
      _remainder = max(0, _remainder - n);
    }

    return this;
  }

  @override
  bool get hasNext => _remainder > 0;

  @override
  int get knownSize => _remainder;

  @override
  A next() {
    if (hasNext) {
      final r = apply(_current);
      _current += 1;
      _remainder -= 1;
      return r;
    } else {
      noSuchElement();
    }
  }
}
