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

final class MHashSet<A> with RIterableOnce<A>, RIterable<A>, RSet<A>, MSet<A> {
  static const DefaultInitialCapacity = 16;
  static const DefaultLoadFactor = 0.75;

  final int initialCapacity;
  final double loadFactor;

  Array<_Node<A>> _table;
  int _threshold;
  int _contentSize = 0;

  MHashSet({
    this.initialCapacity = DefaultInitialCapacity,
    this.loadFactor = DefaultLoadFactor,
  }) : _table = Array.ofDim(_tableSizeFor(initialCapacity)),
       _threshold = _newThreshold(_tableSizeFor(initialCapacity), loadFactor);

  static MHashSet<A> empty<A>() => MHashSet();

  static MHashSet<A> from<A>(RIterableOnce<A> xs) {
    final k = xs.knownSize;
    final cap = k > 0 ? ((k + 1).toDouble() ~/ DefaultLoadFactor) : DefaultInitialCapacity;

    return MHashSet<A>(initialCapacity: cap).concat(xs);
  }

  @override
  bool add(A elem) {
    if (_contentSize + 1 >= _threshold) _growTable(_table.length * 2);
    return _addElem(elem, _computeHash(elem));
  }

  @override
  MHashSet<A> concat(RIterableOnce<A> suffix) {
    if (suffix is MHashSet<A>) {
      final iter = suffix._nodeIterator;

      while (iter.hasNext) {
        final next = iter.next();
        _addElem(next.key as A, next.hash);
      }
    } else {
      suffix.iterator.foreach(add);
    }

    return this;
  }

  @override
  bool contains(A elem) => _findNode(elem) != null;

  @override
  bool get isEmpty => size == 0;

  @override
  RIterator<A> get iterator => _HashSetIterator(_table, (node) => node.key);

  @override
  bool remove(A elem) => _remove(elem, _computeHash(elem));

  @override
  int get size => _contentSize;

  // ///////////////////////////////////////////////////////////////////////////

  bool _addElem(A elem, int hash) {
    final idx = _index(hash);
    final old = _table[idx];

    if (old == null) {
      _table[idx] = _Node(elem, hash, null);
    } else {
      _Node<A>? prev;
      _Node<A>? n = old;

      while ((n != null) && n.hash <= hash) {
        if (n.hash == hash && elem == n.key) return false;
        prev = n;
        n = n.next;
      }
      if (prev == null) {
        _table[idx] = _Node(elem, hash, old);
      } else {
        prev.next = _Node(elem, hash, prev.next);
      }
    }

    _contentSize += 1;
    return true;
  }

  int _computeHash(A a) => _improveHash(a.hashCode);

  _Node<A>? _findNode(A elem) {
    final hash = _computeHash(elem);
    return _table[_index(hash)]?.findNode(elem, hash);
  }

  void _growTable(int newlen) {
    var oldlen = _table.length;
    _threshold = _newThreshold(newlen, loadFactor);

    if (size == 0) {
      _table = Array.ofDim(newlen);
    } else {
      _table = Array.copyOf(_table, newlen);
      final preLow = _Node<A>(null, 0, null);
      final preHigh = _Node<A>(null, 0, null);
      // Split buckets until the new length has been reached. This could be done more
      // efficiently when growing an already filled table to more than double the size.
      while (oldlen < newlen) {
        var i = 0;
        while (i < oldlen) {
          final old = _table[i];
          if (old != null) {
            preLow.next = null;
            preHigh.next = null;
            var lastLow = preLow;
            var lastHigh = preHigh;
            _Node<A>? n = old;

            while (n != null) {
              final next = n.next;
              if ((n.hash & oldlen) == 0) {
                // keep low
                lastLow.next = n;
                lastLow = n;
              } else {
                // move to high
                lastHigh.next = n;
                lastHigh = n;
              }
              n = next;
            }
            lastLow.next = null;
            if (old != preLow.next) _table[i] = preLow.next;
            if (preHigh.next != null) {
              _table[i + oldlen] = preHigh.next;
              lastHigh.next = null;
            }
          }
          i += 1;
        }
        oldlen *= 2;
      }
    }
  }

  int _improveHash(int originalHash) => originalHash ^ (originalHash >>> 16);

  int _index(int hash) => hash & (_table.length - 1);

  RIterator<_Node<A>> get _nodeIterator => _HashSetIterator(_table, (n) => n);

  bool _remove(A elem, int hash) {
    final idx = _index(hash);
    final nd = _table[idx];

    if (nd == null) {
      return false;
    } else if (nd.hash == hash && nd.key == elem) {
      // first element matches
      _table[idx] = nd.next;
      _contentSize -= 1;
      return true;
    } else {
      // find an element that matches
      var prev = nd;
      var next = nd.next;
      while ((next != null) && next.hash <= hash) {
        if (next.hash == hash && next.key == elem) {
          prev.next = next.next;
          _contentSize -= 1;
          return true;
        }
        prev = next;
        next = next.next;
      }
      return false;
    }
  }

  static int _newThreshold(int size, double loadFactor) => (size.toDouble() * loadFactor).toInt();

  static int _tableSizeFor(int capacity) =>
      min(Integer.highestOneBit(max(capacity - 1, 4)) * 2, 1 << 30);
}

final class _Node<K> {
  final K? _key;
  final int _hash;
  _Node<K>? next;

  _Node(this._key, this._hash, this.next);

  K? get key => _key;
  int get hash => _hash;

  _Node<K>? findNode(K k, int h) {
    var curr = this;

    while (true) {
      if (h == curr._hash && k == curr._key) {
        return this;
      } else if (curr.next == null || curr._hash > h) {
        return null;
      } else {
        curr = next!;
      }
    }
  }

  void foreach<U>(Function1<K, U> f) {
    var currKey = _key;

    while (currKey != null) {
      f(currKey);
      currKey = next?._key;
    }
  }

  @override
  String toString() => 'Node($key, $hash) -> $next';
}

final class _HashSetIterator<A, B> extends RIterator<B> {
  final Array<_Node<A>> _table;
  final int len;
  final Function1<_Node<A>, B?> extract;

  int _i = 0;
  _Node<A>? _node;

  _HashSetIterator(this._table, this.extract) : len = _table.length;

  @override
  bool get hasNext {
    if (_node != null) {
      return true;
    } else {
      while (_i < len) {
        final n = _table[_i];
        _i += 1;
        if (n != null) {
          _node = n;
          return true;
        }
      }
      return false;
    }
  }

  @override
  B next() {
    if (!hasNext) {
      noSuchElement();
    } else {
      final r = extract(_node!);
      _node = _node!.next;
      return r!;
    }
  }
}
