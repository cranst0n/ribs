part of '../iterator.dart';

final class _DistinctByIterator<A, B> extends RibsIterator<A> {
  final RibsIterator<A> self;
  final Function1<A, B> f;

  final _traversedValues = HashSet<B>();
  bool _nextElementDefined = false;
  A? _nextElement;

  _DistinctByIterator(this.self, this.f);

  @override
  bool get hasNext {
    if (_nextElementDefined) {
      return true;
    } else {
      while (self.hasNext && !_nextElementDefined) {
        final a = self.next();

        if (_traversedValues.add(f(a))) {
          _nextElement = a;
          _nextElementDefined = true;
          return true;
        }
      }

      return false;
    }
  }

  @override
  A next() {
    if (hasNext) {
      _nextElementDefined = false;
      return _nextElement!;
    } else {
      noSuchElement();
    }
  }
}
