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

abstract class AbstractView<A> with RIterableOnce<A>, RIterable<A>, View<A> {
  const AbstractView();
}

class Id<A> extends AbstractView<A> {
  final RIterableOnce<A> underlying;

  const Id(this.underlying);

  @override
  RIterator<A> get iterator => underlying.iterator;

  @override
  int get knownSize => underlying.knownSize;

  @override
  bool get isEmpty => underlying.isEmpty;
}

class Appended<A> extends AbstractView<A> {
  final RIterableOnce<A> underlying;
  final A elem;

  const Appended(this.underlying, this.elem);

  @override
  RIterator<A> get iterator => Concat(underlying, Single(elem)).iterator;

  @override
  int get knownSize {
    final size = underlying.knownSize;
    return size >= 0 ? size + 1 : -1;
  }

  @override
  bool get isEmpty => false;
}

class Collect<A, B> extends AbstractView<B> {
  final RIterableOnce<A> underlying;
  final Function1<A, Option<B>> f;

  const Collect(this.underlying, this.f);

  @override
  RIterator<B> get iterator => underlying.iterator.collect(f);
}

class Concat<A> extends AbstractView<A> {
  final RIterableOnce<A> prefix;
  final RIterableOnce<A> suffix;

  const Concat(this.prefix, this.suffix);

  @override
  RIterator<A> get iterator => prefix.iterator.concat(suffix.iterator);

  @override
  int get knownSize {
    final prefixSize = prefix.knownSize;
    if (prefixSize >= 0) {
      final suffixSize = suffix.knownSize;
      if (suffixSize >= 0) {
        return prefixSize + suffixSize;
      } else {
        return -1;
      }
    } else {
      return -1;
    }
  }

  @override
  bool get isEmpty => prefix.isEmpty && suffix.isEmpty;
}

class DistinctBy<A, B> extends AbstractView<A> {
  final RIterableOnce<A> underlying;
  final Function1<A, B> f;

  const DistinctBy(this.underlying, this.f);

  @override
  RIterator<A> get iterator => underlying.iterator.distinctBy(f);

  @override
  int get knownSize => underlying.knownSize == 0 ? 0 : super.knownSize;

  @override
  bool get isEmpty => underlying.isEmpty;
}

class Drop<A> extends AbstractView<A> {
  final RIterableOnce<A> underlying;
  final int n;

  const Drop(this.underlying, this.n);

  @override
  RIterator<A> get iterator => underlying.iterator.drop(n);

  @override
  int get knownSize {
    final size = underlying.knownSize;
    return size >= 0 ? max(size - normN, 0) : -1;
  }

  @override
  bool get isEmpty => iterator.isEmpty;

  int get normN => max(n, 0);
}

class DropRight<A> extends AbstractView<A> {
  final RIterableOnce<A> underlying;
  final int n;

  const DropRight(this.underlying, this.n);

  @override
  RIterator<A> get iterator => _dropRightIterator(underlying.iterator, n);

  @override
  int get knownSize {
    final size = underlying.knownSize;
    return size >= 0 ? size - max(n, 0) : -1;
  }

  @override
  bool get isEmpty {
    if (knownSize >= 0) {
      return knownSize == 0;
    } else {
      return iterator.isEmpty;
    }
  }
}

class DropWhile<A> extends AbstractView<A> {
  final RIterableOnce<A> underlying;
  final Function1<A, bool> p;

  const DropWhile(this.underlying, this.p);

  @override
  RIterator<A> get iterator => underlying.iterator.dropWhile(p);

  @override
  int get knownSize => underlying.knownSize == 0 ? 0 : super.knownSize;

  @override
  bool get isEmpty => iterator.isEmpty;
}

class Fill<A> extends AbstractView<A> {
  final int n;
  final A elem;

  const Fill(this.n, this.elem);

  @override
  RIterator<A> get iterator => RIterator.fill(n, elem);
}

class Filter<A> extends AbstractView<A> {
  final RIterableOnce<A> underlying;
  final Function1<A, bool> p;
  final bool isFlipped;

  const Filter(this.underlying, this.p, this.isFlipped);

  @override
  RIterator<A> get iterator => !isFlipped
      ? underlying.iterator.filter(p)
      : underlying.iterator.filterNot(p);

  @override
  int get knownSize => underlying.knownSize == 0 ? 0 : super.knownSize;

  @override
  bool get isEmpty => iterator.isEmpty;
}

class FlatMap<A, B> extends AbstractView<B> {
  final RIterableOnce<A> underlying;
  final Function1<A, RIterableOnce<B>> f;

  const FlatMap(this.underlying, this.f);

  @override
  RIterator<B> get iterator => underlying.iterator.flatMap(f);

  @override
  int get knownSize => underlying.knownSize == 0 ? 0 : super.knownSize;

  @override
  bool get isEmpty => iterator.isEmpty;
}

class Iterate<A> extends AbstractView<A> {
  final A start;
  final int len;
  final Function1<A, A> f;

  const Iterate(this.start, this.len, this.f);

  @override
  RIterator<A> get iterator => RIterator.iterate(start, f).take(len);

  @override
  int get knownSize => max(0, len);

  @override
  bool get isEmpty => len <= 0;
}

class Map<A, B> extends AbstractView<B> {
  final RIterableOnce<A> underlying;
  final Function1<A, B> f;

  const Map(this.underlying, this.f);

  @override
  RIterator<B> get iterator => underlying.iterator.map(f);

  @override
  int get knownSize => underlying.knownSize;

  @override
  bool get isEmpty => underlying.isEmpty;
}

class PadTo<A> extends AbstractView<A> {
  final RIterableOnce<A> underlying;
  final int len;
  final A elem;

  const PadTo(this.underlying, this.len, this.elem);

  @override
  RIterator<A> get iterator => underlying.iterator.padTo(len, elem);

  @override
  int get knownSize {
    final size = underlying.knownSize;
    if (size >= 0) {
      return max(size, len);
    } else {
      return -1;
    }
  }

  @override
  bool get isEmpty => underlying.isEmpty && len <= 0;
}

class Patched<A> extends AbstractView<A> {
  final RIterableOnce<A> underlying;
  final int from;
  final RIterableOnce<A> other;
  final int replaced;

  const Patched(this.underlying, this.from, this.other, this.replaced);

  @override
  RIterator<A> get iterator =>
      underlying.iterator.patch(from, other.iterator, replaced);

  @override
  int get knownSize {
    if (underlying.knownSize == 0 && other.knownSize == 0) {
      return 0;
    } else {
      return super.knownSize;
    }
  }

  @override
  bool get isEmpty => knownSize == 0 || iterator.isEmpty;
}

class Prepended<A> extends AbstractView<A> {
  final RIterableOnce<A> underlying;
  final A elem;

  const Prepended(this.elem, this.underlying);

  @override
  RIterator<A> get iterator => Concat(Single(elem), underlying).iterator;

  @override
  int get knownSize {
    final size = underlying.knownSize;
    return size >= 0 ? size + 1 : -1;
  }

  @override
  bool get isEmpty => false;
}

class ScanLeft<A, B> extends AbstractView<B> {
  final RIterableOnce<A> underlying;
  final B z;
  final Function2<B, A, B> op;

  const ScanLeft(this.underlying, this.z, this.op);

  @override
  RIterator<B> get iterator => underlying.iterator.scanLeft(z, op);

  @override
  int get knownSize {
    final size = underlying.knownSize;
    return size >= 0 ? size + 1 : -1;
  }

  @override
  bool get isEmpty => iterator.isEmpty;
}

class Single<A> extends AbstractView<A> {
  final A a;

  const Single(this.a);

  @override
  RIterator<A> get iterator => RIterator.single(a);

  @override
  int get knownSize => 1;

  @override
  bool get isEmpty => false;
}

class Tabulate<A> extends AbstractView<A> {
  final int n;
  final Function1<int, A> f;

  const Tabulate(this.n, this.f);

  @override
  RIterator<A> get iterator => RIterator.tabulate(n, f);

  @override
  int get knownSize => max(n, 0);

  @override
  bool get isEmpty => n <= 0;
}

class Take<A> extends AbstractView<A> {
  final RIterableOnce<A> underlying;
  final int n;

  const Take(this.underlying, this.n);

  @override
  RIterator<A> get iterator => underlying.iterator.take(n);

  @override
  int get knownSize {
    final size = underlying.knownSize;
    return size >= 0 ? min(size, normN) : -1;
  }

  @override
  bool get isEmpty => iterator.isEmpty;

  int get normN => max(n, 0);
}

class TakeRight<A> extends AbstractView<A> {
  final RIterableOnce<A> underlying;
  final int n;

  const TakeRight(this.underlying, this.n);

  @override
  RIterator<A> get iterator => _takeRightIterator(underlying.iterator, n);

  @override
  int get knownSize {
    final size = underlying.knownSize;
    return size >= 0 ? min(size, normN) : -1;
  }

  @override
  bool get isEmpty {
    if (knownSize >= 0) {
      return knownSize == 0;
    } else {
      return iterator.isEmpty;
    }
  }

  int get normN => max(n, 0);
}

class TakeWhile<A> extends AbstractView<A> {
  final RIterableOnce<A> underlying;
  final Function1<A, bool> p;

  const TakeWhile(this.underlying, this.p);

  @override
  RIterator<A> get iterator => underlying.iterator.takeWhile(p);

  @override
  int get knownSize => underlying.knownSize == 0 ? 0 : super.knownSize;

  @override
  bool get isEmpty => iterator.isEmpty;
}

class Unfold<A, S> extends AbstractView<A> {
  final S initial;
  final Function1<S, Option<(A, S)>> f;

  const Unfold(this.initial, this.f);

  @override
  RIterator<A> get iterator => RIterator.unfold(initial, f);
}

class Updated<A> extends AbstractView<A> {
  final RIterableOnce<A> underlying;
  final int index;
  final A elem;

  const Updated(this.underlying, this.index, this.elem);

  @override
  RIterator<A> get iterator =>
      _UpdatedIterator(underlying, underlying.iterator, index, elem);

  @override
  int get knownSize => underlying.knownSize;

  @override
  bool get isEmpty => underlying.isEmpty;
}

class Zip<A, B> extends AbstractView<(A, B)> {
  final RIterableOnce<A> underlying;
  final RIterableOnce<B> other;

  const Zip(this.underlying, this.other);

  @override
  RIterator<(A, B)> get iterator => underlying.iterator.zip(other);

  @override
  int get knownSize {
    final s1 = underlying.knownSize;
    if (s1 == 0) {
      return 0;
    } else {
      final s2 = other.knownSize;
      if (s2 == 0) {
        return 0;
      } else {
        return min(s1, s2);
      }
    }
  }

  @override
  bool get isEmpty => underlying.isEmpty || other.isEmpty;
}

class ZipAll<A, B> extends AbstractView<(A, B)> {
  final RIterableOnce<A> underlying;
  final RIterableOnce<B> other;
  final A thisElem;
  final B thatElem;

  const ZipAll(this.underlying, this.other, this.thisElem, this.thatElem);

  @override
  RIterator<(A, B)> get iterator =>
      underlying.iterator.zipAll(other, thisElem, thatElem);

  @override
  int get knownSize {
    final s1 = underlying.knownSize;
    if (s1 == -1) {
      return -1;
    } else {
      final s2 = other.knownSize;
      if (s2 == -1) {
        return -1;
      } else {
        return max(s1, s2);
      }
    }
  }

  @override
  bool get isEmpty => underlying.isEmpty && other.isEmpty;
}

class ZipWithIndex<A> extends AbstractView<(A, int)> {
  final RIterableOnce<A> underlying;

  const ZipWithIndex(this.underlying);

  @override
  RIterator<(A, int)> get iterator => underlying.iterator.zipWithIndex();

  @override
  int get knownSize => underlying.knownSize;

  @override
  bool get isEmpty => underlying.isEmpty;
}

RIterator<A> _dropRightIterator<A>(RIterator<A> it, int n) {
  if (n <= 0) {
    return it;
  } else {
    final k = it.knownSize;
    if (k >= 0) {
      return it.take(k - n);
    } else {
      return _DropRightIterator(it, n);
    }
  }
}

RIterator<A> _takeRightIterator<A>(RIterator<A> it, int n) {
  final k = it.knownSize;

  if (k == 0 || n <= 0) {
    return RIterator.empty<A>();
  } else if (n == Integer.MaxValue) {
    return it;
  } else if (k > 0) {
    return it.drop(max(k - n, 0));
  } else {
    return _TakeRightIterator<A>(it, n);
  }
}

final class _DropRightIterator<A> extends RIterator<A> {
  RIterator<A> underlying;
  int maxlen;
  int len = -1;
  int pos = 0;
  List<dynamic>? buf;

  _DropRightIterator(this.underlying, this.maxlen);

  @override
  bool get hasNext {
    _init();
    return len != 0;
  }

  @override
  int get knownSize => len;

  @override
  A next() {
    if (!hasNext) {
      noSuchElement();
    } else {
      final x = buf![pos] as A;

      if (len == -1) {
        buf![pos] = underlying.next();
        if (!underlying.hasNext) len = 0;
      } else {
        len -= 1;
      }

      pos += 1;
      if (pos == maxlen) pos = 0;

      return x;
    }
  }

  void _init() {
    if (buf == null) {
      buf = List.filled(min(maxlen, 256), null);

      while (pos < maxlen && underlying.hasNext) {
        buf!.add(underlying.next());
        pos += 1;
      }

      if (!underlying.hasNext) len = 0;
      pos = 0;
    }
  }
}

final class _TakeRightIterator<A> extends RIterator<A> {
  RIterator<A> underlying;
  int maxlen;

  var _len = -1;
  var _pos = 0;
  List<dynamic>? buf;

  _TakeRightIterator(this.underlying, this.maxlen);

  @override
  RIterator<A> drop(int n) {
    _init();
    if (n > 0) {
      _len = max(_len - n, 0);
      _pos = (_pos + n) % maxlen;
    }

    return this;
  }

  @override
  bool get hasNext {
    _init();
    return _len > 0;
  }

  @override
  int get knownSize => _len;

  @override
  A next() {
    _init();

    if (_len == 0) {
      noSuchElement();
    } else {
      final x = buf![_pos] as A;
      _pos += 1;
      if (_pos == maxlen) _pos = 0;
      _len -= 1;
      return x;
    }
  }

  void _init() {
    buf = List.filled(min(maxlen, 256), null);
    _len = 0;
    while (underlying.hasNext) {
      final n = underlying.next();
      if (_pos >= buf!.length) {
        buf!.add(n);
      } else {
        buf![_pos] = n;
      }
      _pos += 1;
      if (_pos == maxlen) _pos = 0;
      _len += 1;
    }

    if (_len > maxlen) _len = maxlen;
    _pos = _pos - _len;
    if (_pos < 0) _pos += maxlen;
  }
}

final class _UpdatedIterator<A> extends RIterator<A> {
  final RIterableOnce<A> underlying;
  final RIterator<A> it;
  final int index;
  final A elem;

  int i = 0;

  _UpdatedIterator(this.underlying, this.it, this.index, this.elem);

  @override
  bool get hasNext {
    if (it.hasNext) {
      return true;
    } else if (index >= i) {
      throw RangeError.index(index, underlying);
    } else {
      return false;
    }
  }

  @override
  A next() {
    var value = it.next();

    if (i == index) {
      value = elem;
    }

    i += 1;

    return value;
  }

  @override
  bool get isEmpty => underlying.isEmpty;
}
