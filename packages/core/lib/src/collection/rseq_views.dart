// This file is derived in part from the Scala collection library.
// https://github.com/scala/scala/blob/v2.13.x/src/library/scala/collection/
//
// Scala (https://www.scala-lang.org)
//
// Copyright EPFL and Lightbend, Inc.
//
// Licensed under Apache License 2.0
// (http://www.apache.org/licenses/LICENSE-2.0).
//
// See the NOTICE file distributed with this work for
// additional information regarding copyright ownership.

import 'dart:math';

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/collection/views.dart' as views;

abstract class AbstractSeqView<A>
    with RIterableOnce<A>, RIterable<A>, View<A>, RSeq<A>, SeqView<A> {
  const AbstractSeqView();
}

class Appended<A> extends views.Appended<A> with RSeq<A>, SeqView<A> {
  final RSeq<A> seq;

  const Appended(this.seq, A elem) : super(seq, elem);

  @override
  A operator [](int idx) => idx == seq.length ? elem : seq[idx];

  @override
  int get length => seq.length + 1;
}

class Concat<A> extends views.Concat<A> with RSeq<A>, SeqView<A> {
  final RSeq<A> prefixSeq;
  final RSeq<A> suffixSeq;

  const Concat(this.prefixSeq, this.suffixSeq) : super(prefixSeq, suffixSeq);

  @override
  A operator [](int idx) {
    final l = prefixSeq.length;
    return idx < l ? prefixSeq[idx] : suffixSeq[idx - l];
  }

  @override
  int get length => prefixSeq.length + suffixSeq.length;
}

class Drop<A> extends views.Drop<A> with RSeq<A>, SeqView<A> {
  final RSeq<A> seq;

  const Drop(this.seq, int n) : super(seq, n);

  @override
  A operator [](int idx) => seq[idx + normN];

  @override
  int get length => max(underlying.size - normN, 0);

  @override
  RSeq<A> drop(int n) => Drop(seq, this.n + n);
}

class DropRight<A> extends views.DropRight<A> with RSeq<A>, SeqView<A> {
  final RSeq<A> seq;

  const DropRight(this.seq, int n) : super(seq, n);

  @override
  A operator [](int idx) => seq[idx];

  @override
  int get length => max(seq.size - max(n, 0), 0);
}

class Id<A> extends AbstractSeqView<A> {
  final RSeq<A> underlying;

  const Id(this.underlying);

  @override
  A operator [](int idx) => underlying[idx];

  @override
  bool get isEmpty => underlying.isEmpty;

  @override
  RIterator<A> get iterator => underlying.iterator;

  @override
  int get knownSize => underlying.knownSize;

  @override
  int get length => underlying.length;
}

class Map<A, B> extends views.Map<A, B> with RSeq<B>, SeqView<B> {
  final RSeq<A> seq;

  const Map(this.seq, Function1<A, B> f) : super(seq, f);

  @override
  B operator [](int idx) => f(seq[idx]);

  @override
  int get length => seq.length;
}

class Prepended<A> extends views.Prepended<A> with RSeq<A>, SeqView<A> {
  final RSeq<A> seq;

  const Prepended(A elem, this.seq) : super(elem, seq);

  @override
  A operator [](int idx) => idx == 0 ? elem : seq[idx - 1];

  @override
  int get length => seq.length + 1;
}

class Reverse<A> extends AbstractSeqView<A> {
  final RSeq<A> underlying;

  const Reverse(this.underlying);

  @override
  A operator [](int idx) => underlying[size - 1 - idx];

  @override
  bool get isEmpty => underlying.isEmpty;

  @override
  RIterator<A> get iterator => underlying.reverseIterator();

  @override
  int get knownSize => underlying.knownSize;

  @override
  int get length => underlying.length;
}

class Sorted<A> extends AbstractSeqView<A> {
  RSeq<A>? seq;
  final int len;
  final Order<A> order;

  RSeq<A>? _sortedImpl;

  Sorted(this.seq, this.order, [this.len = 0]);

  @override
  A operator [](int idx) => _sorted[idx];

  @override
  bool get isEmpty => len == 0;

  @override
  RIterator<A> get iterator => _sorted.iterator; // todo: lazy?

  @override
  int get knownSize => len;

  @override
  int get length => len;

  @override
  RSeq<A> reverse() => _ReverseSorted(this);

  @override
  RSeq<A> sorted(Order<A> order) {
    if (order == this.order) {
      return this;
    } else if (order.isReverseOf(this.order)) {
      return reverse();
    } else {
      return Sorted(elems, order, len);
    }
  }

  RSeq<A> get _sorted {
    if (_sortedImpl == null) {
      final List<A> res;

      if (len == 0) {
        res = [];
      } else if (len == 1) {
        res = [seq![0]];
      } else {
        res = seq!.toList()..sort(order.compare);
      }

      seq = null;

      _sortedImpl = RSeq.from(RIterator.fromDart(res.iterator));
    }

    return _sortedImpl!;
  }

  RSeq<A> get elems => seq ?? _sorted;
}

class Take<A> extends views.Take<A> with RSeq<A>, SeqView<A> {
  final RSeq<A> seq;

  const Take(this.seq, int n) : super(seq, n);

  @override
  A operator [](int idx) {
    if (idx < n) {
      return seq[idx];
    } else {
      throw RangeError.index(idx, seq);
    }
  }

  @override
  int get length => min(seq.length, normN);
}

class TakeRight<A> extends views.TakeRight<A> with RSeq<A>, SeqView<A> {
  final RSeq<A> seq;

  const TakeRight(this.seq, int n) : super(seq, n);

  @override
  A operator [](int idx) => seq[idx + _delta];

  @override
  int get length => seq.size - _delta;

  int get _delta => max(seq.size - normN, 0);
}

class _ReverseSorted<A> extends AbstractSeqView<A> {
  final Sorted<A> outer;
  final Reverse<A> _reversed;

  _ReverseSorted(this.outer) : _reversed = Reverse(outer._sorted);

  @override
  A operator [](int idx) => outer._sorted[idx];

  @override
  bool get isEmpty => outer.len == 0;

  @override
  RIterator<A> get iterator => _reversed.iterator;

  @override
  int get knownSize => outer.len;

  @override
  int get length => outer.len;

  @override
  RSeq<A> reverse() => outer;

  @override
  RSeq<A> sorted(Order<A> order) {
    if (order == outer.order) {
      return outer;
    } else if (order.isReverseOf(outer.order)) {
      return this;
    } else {
      return Sorted(outer.elems, order, outer.len);
    }
  }
}
