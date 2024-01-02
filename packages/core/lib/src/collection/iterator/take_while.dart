part of '../iterator.dart';

final class _TakeWhileIterator<A> extends RibsIterator<A> {
  final RibsIterator<A> self;
  final Function1<A, bool> p;

  late A hd;
  bool hdDefined = false;
  late RibsIterator<A> tailIt = self;

  _TakeWhileIterator(this.self, this.p);

  @override
  bool get hasNext {
    hd = tailIt.next();

    if (p(hd)) {
      hdDefined = true;
    } else {
      tailIt = RibsIterator.empty();
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
