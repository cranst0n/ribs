part of '../riterator.dart';

final class _TakeWhileIterator<A> extends RIterator<A> {
  final RIterator<A> self;
  final Function1<A, bool> p;

  late A hd;
  bool hdDefined = false;
  late RIterator<A> tailIt = self;

  _TakeWhileIterator(this.self, this.p);

  @override
  bool get hasNext {
    if (hdDefined) return true;
    if (!tailIt.hasNext) return false;

    hd = tailIt.next();

    if (p(hd)) {
      hdDefined = true;
    } else {
      tailIt = RIterator.empty();
    }

    return hdDefined;
  }

  @override
  A next() {
    if (hasNext) {
      hdDefined = false;
      return hd;
    } else {
      noSuchElement();
    }
  }
}
