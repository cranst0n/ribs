import 'dart:math';

import 'package:ribs_core/ribs_collection.dart';
import 'package:ribs_core/src/collection/seq_views.dart' as seqviews;

abstract class AbstractIndexedSeqView<A>
    with
        IterableOnce<A>,
        RibsIterable<A>,
        Seq<A>,
        View<A>,
        SeqView<A>,
        IndexedSeq<A>,
        IndexedSeqView<A> {
  const AbstractIndexedSeqView();
}

class Appended<A> extends seqviews.Appended<A>
    with IndexedSeq<A>, IndexedSeqView<A> {
  const Appended(IndexedSeq<A> super.seq, super.elem);
}

class Concat<A> extends seqviews.Concat<A>
    with IndexedSeq<A>, IndexedSeqView<A> {
  const Concat(IndexedSeq<A> super.prefix, IndexedSeq<A> super.suffix);
}

class Drop<A> extends seqviews.Drop<A> with IndexedSeq<A>, IndexedSeqView<A> {
  const Drop(IndexedSeq<A> super.seq, super.n);
}

class DropRight<A> extends seqviews.DropRight<A>
    with IndexedSeq<A>, IndexedSeqView<A> {
  const DropRight(IndexedSeq<A> super.seq, super.n);
}

class Id<A> extends seqviews.Id<A> with IndexedSeq<A>, IndexedSeqView<A> {
  const Id(IndexedSeq<A> super.seq);
}

class Map<A, B> extends seqviews.Map<A, B>
    with IndexedSeq<B>, IndexedSeqView<B> {
  const Map(IndexedSeq<A> super.seq, super.f);
}

class Prepended<A> extends seqviews.Prepended<A>
    with IndexedSeq<A>, IndexedSeqView<A> {
  const Prepended(super.elem, IndexedSeq<A> super.seq);
}

class Reverse<A> extends seqviews.Reverse<A>
    with IndexedSeq<A>, IndexedSeqView<A> {
  const Reverse(IndexedSeq<A> super.underlying);

  @override
  IndexedSeqView<A> reverse() => switch (underlying) {
        final IndexedSeqView<A> x => x,
        _ => super.reverse(),
      };
}

class Slice<A> extends AbstractIndexedSeqView<A> {
  final Seq<A> underlying;
  final int from;
  final int until;

  final int lo;
  final int hi;
  late final int len = max(hi - lo, 0);

  Slice(
    this.underlying,
    this.from,
    this.until,
  )   : lo = max(from, 0),
        hi = min(max(until, 0), underlying.length);

  @override
  A operator [](int idx) => underlying[lo + idx];

  @override
  int get length => len;
}

class Take<A> extends seqviews.Take<A> with IndexedSeq<A>, IndexedSeqView<A> {
  const Take(IndexedSeq<A> super.seq, super.n);
}

class TakeRight<A> extends seqviews.TakeRight<A>
    with IndexedSeq<A>, IndexedSeqView<A> {
  const TakeRight(IndexedSeq<A> super.seq, super.n);
}

final class IndexedSeqViewIterator<A> extends RibsIterator<A> {
  final IndexedSeqView<A> self;

  int _current = 0;
  int _remainder;

  IndexedSeqViewIterator(this.self) : _remainder = self.length;

  @override
  bool get hasNext => _remainder > 0;

  @override
  int get knownSize => _remainder;

  @override
  A next() {
    if (hasNext) {
      final r = self[_current];
      _current += 1;
      _remainder -= 1;
      return r;
    } else {
      noSuchElement();
    }
  }

  @override
  RibsIterator<A> drop(int n) {
    if (n > 0) {
      _current += n;
      _remainder = max(0, _remainder - n);
    }
    return this;
  }

  @override
  RibsIterator<A> sliceIterator(int from, int until) {
    int formatRange(int value) {
      if (value < 0) {
        return 0;
      } else if (value > _remainder) {
        return _remainder;
      } else {
        return value;
      }
    }

    final formatFrom = formatRange(from);
    final formatUntil = formatRange(until);
    _remainder = max(0, formatUntil - formatFrom);
    _current = _current + formatFrom;

    return this;
  }
}

final class IndexedSeqViewReverseIterator<A> extends RibsIterator<A> {
  final IndexedSeqView<A> self;

  int _remainder;
  int _pos;

  IndexedSeqViewReverseIterator(this.self)
      : _remainder = self.length,
        _pos = self.length - 1;

  @override
  bool get hasNext => _remainder > 0;

  @override
  A next() {
    if (hasNext) {
      final r = self[_pos];
      _pos -= 1;
      _remainder -= 1;
      return r;
    } else {
      noSuchElement();
    }
  }

  @override
  RibsIterator<A> sliceIterator(int from, int until) {
    if (hasNext) {
      if (_remainder <= from) {
        _remainder = 0; // exhausted by big skip
      } else if (from <= 0) {
        // no skip, pos is same
        if (until >= 0 && until < _remainder) {
          _remainder = until; // ...limited by until
        }
      } else {
        _pos -= from; // skip ahead
        if (until >= 0 && until < _remainder) {
          // ...limited by until
          if (until <= from) {
            _remainder = 0; // ...exhausted if limit is smaller than skip
          } else {
            _remainder = until - from; // ...limited by until, less the skip
          }
        } else {
          _remainder -= from; // ...otherwise just less the skip
        }
      }
    }
    return this;
  }
}
