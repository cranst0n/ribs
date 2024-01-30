import 'dart:math';

import 'package:ribs_core/ribs_collection.dart';
import 'package:ribs_core/src/collection/mutable/mutation_tracker.dart';
import 'package:ribs_core/src/option.dart';

class ListBuffer<A> with IterableOnce<A>, RibsIterable<A>, Seq<A>, Buffer<A> {
  IList<A> _first = Nil<A>();
  Cons<A>? _last0;

  var _aliased = false;
  var _len = 0;
  var _mutationCount = 0;

  @override
  A operator [](int idx) => _first[idx];

  @override
  ListBuffer<A> addAll(IterableOnce<A> elems) {
    final it = elems.iterator;
    if (it.hasNext) {
      final fresh = ListBuffer<A>()._freshFrom(it);
      _ensureUnaliased();

      if (_len == 0) {
        _first = fresh._first;
      } else {
        _last0!.next = fresh._first;
      }

      _last0 = fresh._last0;
      _len += fresh.length;
    }
    return this;
  }

  @override
  ListBuffer<A> addOne(A elem) {
    _ensureUnaliased();
    final last1 = Cons(elem, Nil<A>());

    if (_len == 0) {
      _first = last1;
    } else {
      _last0!.next = last1;
    }

    _last0 = last1;
    _len += 1;
    return this;
  }

  @override
  ListBuffer<A> appended(A elem) {
    final b = ListBuffer<A>();
    b.addAll(this);
    b.addOne(elem);

    return b;
  }

  @override
  void clear() {
    _mutationCount += 1;
    _first = Nil<A>();
    _len = 0;
    _last0 = null;
    _aliased = false;
  }

  @override
  void insert(int idx, A elem) {
    _ensureUnaliased();

    if (idx < 0 || idx > _len) {
      throw RangeError('$idx is out of bounds (min 0, max ${_len - 1})');
    }

    if (idx == _len) {
      addOne(elem);
    } else {
      final p = _locate(idx);
      final nx = Cons(elem, _getNext(p));
      if (p == null) {
        _first = nx;
      } else {
        p.next = nx;
      }
      _len += 1;
    }
  }

  @override
  void insertAll(int idx, IterableOnce<A> elems) {
    if (idx < 0 || idx > _len) {
      throw RangeError('$idx is out of bounds (min 0, max ${_len - 1})');
    }

    final it = elems.iterator;
    if (it.hasNext) {
      if (idx == _len) {
        addAll(it);
      } else {
        final fresh = ListBuffer<A>()._freshFrom(it);
        _ensureUnaliased();
        _insertAfter(_locate(idx), fresh);
      }
    }
  }

  @override
  bool get isEmpty => _len == 0;

  @override
  RibsIterator<A> get iterator => MutationTrackerIterator(
        _first.iterator,
        _mutationCount,
        () => _mutationCount,
      );

  @override
  int get knownSize => _len;

  @override
  A get last {
    if (_last0 == null) {
      throw StateError('last of empty ListBuffer');
    } else {
      return _last0!.head;
    }
  }

  @override
  Option<A> get lastOption =>
      Option.when(() => _last0 != null, () => _last0!.head);

  @override
  int get length => _len;

  @override
  ListBuffer<A> patchInPlace(int from, IterableOnce<A> patch, int replaced) {
    final len_ = _len;
    final from_ = max(from, 0); // normalized
    final replaced_ = max(replaced, 0); // normalized
    final it = patch.iterator;

    final nonEmptyPatch = it.hasNext;
    final nonEmptyReplace = (from_ < len_) && (replaced_ > 0);

    // don't want to add a mutation or check aliasing (potentially expensive)
    // if there's no patching to do
    if (nonEmptyPatch || nonEmptyReplace) {
      final fresh = ListBuffer<A>()._freshFrom(it);
      _ensureUnaliased();
      final i = min(from_, len_);
      final n = min(replaced_, len_);
      final p = _locate(i);
      _removeAfter(p, min(n, len_ - i));
      _insertAfter(p, fresh);
    }

    return this;
  }

  @override
  ListBuffer<A> prepend(A elem) {
    insert(0, elem);
    return this;
  }

  IList<A> prependToList(IList<A> xs) {
    if (isEmpty) {
      return xs;
    } else {
      _ensureUnaliased();
      _last0!.next = xs;
      return toIList();
    }
  }

  @override
  A remove(int idx) {
    _ensureUnaliased();

    if (idx < 0 || idx >= _len) {
      throw RangeError("$idx is out of bounds (min 0, max ${_len - 1})");
    }

    final p = _locate(idx);
    final nx = _getNext(p);

    if (p == null) {
      _first = nx.tail();
      if (_first.isEmpty) _last0 = null;
    } else {
      if (_last0 == nx) _last0 = p;
      p.next = nx.tail();
    }

    _len -= 1;

    return nx.head;
  }

  @override
  void removeN(int idx, int count) {
    if (count > 0) {
      _ensureUnaliased();

      if (idx < 0 || idx + count > _len) {
        throw RangeError(
            '$idx to ${idx + count} is out of bounds (min 0, max ${_len - 1})');
      }

      _removeAfter(_locate(idx), count);
    } else if (count < 0) {
      throw ArgumentError('removing negative number of elements: $count');
    }
  }

  @override
  ListBuffer<A> reverse() => ListBuffer<A>().addAll(_reversed());

  RibsIterable<A> _reversed() {
    var xs = IList.empty<A>();
    final it = iterator;

    while (it.hasNext) {
      xs = xs.prepended(it.next());
    }

    return xs;
  }

  @override
  ListBuffer<A> subtractOne(A elem) {
    _ensureUnaliased();
    if (isEmpty) {
    } else if (_first.head == elem) {
      _first = _first.tail();
      _reduceLengthBy(1);
    } else {
      var cursor = _first;
      while (!cursor.tail().isEmpty && cursor.tail().head != elem) {
        cursor = cursor.tail();
      }
      if (!cursor.tail().isEmpty) {
        final z = cursor as Cons<A>;
        if (z.next == _last0) _last0 = z;
        z.next = cursor.tail().tail();
        _reduceLengthBy(1);
      }
    }
    return this;
  }

  @override
  IList<A> toIList() {
    _aliased = nonEmpty;
    return _first;
  }

  void _copyElems() {
    final buf = ListBuffer<A>()._freshFrom(this);
    _first = buf._first;
    _last0 = buf._last0;
    _aliased = false;
  }

  void _ensureUnaliased() {
    _mutationCount += 1;
    if (_aliased) _copyElems();
  }

  ListBuffer<A> _freshFrom(IterableOnce<A> xs) {
    final it = xs.iterator;

    if (it.hasNext) {
      var len = 1;
      var last0 = Cons(it.next(), Nil<A>());
      _first = last0;

      while (it.hasNext) {
        final last1 = Cons(it.next(), Nil<A>());
        last0.next = last1;
        last0 = last1;
        len += 1;
      }

      // copy local vars into instance
      this._len = len;
      this._last0 = last0;
    }
    return this;
  }

  IList<A> _getNext(Cons<A>? p) => p == null ? _first : p.next;

  void _insertAfter(Cons<A>? prev, ListBuffer<A> fresh) {
    if (!fresh.isEmpty) {
      final follow = _getNext(prev);

      if (prev == null) {
        _first = fresh._first;
      } else {
        prev.next = fresh._first;
      }

      fresh._last0!.next = follow;
      if (follow.isEmpty) _last0 = fresh._last0;
      _len += fresh.length;
    }
  }

  Cons<A>? _locate(int i) {
    if (i == 0) {
      return null;
    } else if (i == _len) {
      return _last0;
    } else {
      var j = i - 1;
      var p = _first;

      while (j > 0) {
        p = p.tail();
        j -= 1;
      }

      return p as Cons<A>;
    }
  }

  void _reduceLengthBy(int n) {
    _len -= n;
    if (_len <= 0) _last0 = null;
  }

  void _removeAfter(Cons<A>? prev, int n) {
    var i = n;
    IList<A> nx = _getNext(prev);

    while (i >= 0) {
      nx = _getNext(nx.tail() as Cons<A>);
      i -= 1;
    }

    if (prev == null) {
      _first = nx;
    } else {
      prev.next = nx;
    }

    if (nx.isEmpty) _last0 = prev;

    _len -= n;
  }
}
