part of '../iterator.dart';

final class _FilterIterator<A> extends RibsIterator<A> {
  final RibsIterator<A> self;
  final Function1<A, bool> p;
  final bool isFlipped;

  late A hd;
  bool _hdDefined = false;

  _FilterIterator(this.self, this.p, this.isFlipped);

  @override
  bool get hasNext {
    if (_hdDefined) return true;
    if (!self.hasNext) return false;

    hd = self.next();

    while (p(hd) == isFlipped) {
      if (!self.hasNext) return false;
      hd = self.next();
    }

    _hdDefined = true;
    return true;
  }

  @override
  A next() {
    if (hasNext) {
      _hdDefined = false;
      return hd;
    } else {
      noSuchElement();
    }
  }
}
