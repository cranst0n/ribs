import 'dart:math';

import 'package:ribs_core/ribs_core.dart';

final class MHashMap<K, V>
    with RIterableOnce<(K, V)>, RIterable<(K, V)>, RMap<K, V>, MMap<K, V> {
  static const DefaultInitialCapacity = 16;
  static const DefaultLoadFactor = 0.75;

  final int initialCapacity;
  final double loadFactor;

  Array<_Node<K, V>> _table;
  int _threshold;
  int _contentSize = 0;

  MHashMap({
    this.initialCapacity = DefaultInitialCapacity,
    this.loadFactor = DefaultLoadFactor,
  })  : _table = Array.ofDim(_tableSizeFor(initialCapacity)),
        _threshold = _newThreshold(_tableSizeFor(initialCapacity), loadFactor);

  static MHashMap<K, V> empty<K, V>() => MHashMap();

  @override
  void clear() {
    _table.filled(null);
    _contentSize = 0;
  }

  @override
  MHashMap<K, V> concat(covariant RIterableOnce<(K, V)> suffix) {
    suffix.foreach((elem) => put(elem.$1, elem.$2));
    return this;
  }

  @override
  bool contains(K key) => _findNode(key) != null;

  @override
  Option<V> get(K key) => Option(_findNode(key)).map((n) => n.value!);

  @override
  V getOrElseUpdate(K key, Function0<V> defaultValue) => get(key).fold(
        () {
          final d = defaultValue();
          this[key] = d;
          return d;
        },
        identity,
      );

  @override
  bool get isEmpty => size == 0;

  @override
  RIterator<(K, V)> get iterator {
    if (size == 0) {
      return RIterator.empty();
    } else {
      return _HashMapIterator(_table, (n) => (n.key as K, n.value as V));
    }
  }

  @override
  ISet<K> get keys => _HashMapIterator(_table, (n) => n.key as K).toISet();

  @override
  int get knownSize => size;

  @override
  Option<V> put(K key, V value) => _put0b(key, value, true) ?? none();

  @override
  Option<V> remove(K key) {
    final r = get(key);
    if (r.isDefined) _remove0(key, _computeHash(key));
    return r;
  }

  @override
  int get size => _contentSize;

  @override
  RIterator<V> get valuesIterator => _HashMapIterator(_table, (n) => n.value);

  // ///////////////////////////////////////////////////////////////////////////

  int _computeHash(K a) => _improveHash(a.hashCode);

  _Node<K, V>? _findNode(K key) {
    final hash = _computeHash(key);
    return _table[_index(hash)]?.findNode(key, hash);
  }

  void _growTable(int newlen) {
    if (newlen < 0) {
      throw Exception('new HashMap table size $newlen exceeds maximum');
    }

    var oldlen = _table.length;
    _threshold = _newThreshold(newlen, loadFactor);

    if (size == 0) {
      _table = Array.ofDim(newlen);
    } else {
      _table = Array.copyOf(_table, newlen);
      final _Node<K, V> preLow = _Node(null, 0, null, null);
      final _Node<K, V> preHigh = _Node(null, 0, null, null);

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
            _Node<K, V>? n = old;

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

  static int _newThreshold(int size, double loadFactor) =>
      (size.toDouble() * loadFactor).toInt();

  Some<V>? _put0b(
    K key,
    V value,
    bool getOld,
  ) {
    if (_contentSize + 1 >= _threshold) _growTable(_table.length * 2);
    final hash = _computeHash(key);
    final idx = _index(hash);
    return _put0c(key, value, getOld, hash, idx);
  }

  Some<V>? _put0c(
    K key,
    V value,
    bool getOld,
    int hash,
    int idx,
  ) {
    final old = _table[idx];

    if (old == null) {
      _table[idx] = _Node(key, hash, value, null);
    } else {
      _Node<K, V>? prev;
      _Node<K, V>? n = old;

      while ((n != null) && n.hash <= hash) {
        if (n.hash == hash && key == n.key) {
          final old = n.value;
          n._value = value;
          return getOld ? Some(old as V) : null;
        }
        prev = n;
        n = n.next;
      }
      if (prev == null) {
        _table[idx] = _Node(key, hash, value, old);
      } else {
        prev.next = _Node(key, hash, value, prev.next);
      }
    }

    _contentSize += 1;
    return null;
  }

  _Node<K, V>? _remove0(K elem, int hash) {
    final idx = _index(hash);
    final nd = _table[idx];

    if (nd == null) {
      return null;
    } else if (nd.hash == hash && nd.key == elem) {
      // first element matches
      _table[idx] = nd.next;
      _contentSize -= 1;
      return nd;
    } else {
      // find an element that matches
      var prev = nd;
      var next = nd.next;
      while ((next != null) && next.hash <= hash) {
        if (next.hash == hash && next.key == elem) {
          prev.next = next.next;
          _contentSize -= 1;
          return next;
        }
        prev = next;
        next = next.next;
      }
      return null;
    }
  }

  static int _tableSizeFor(int capacity) =>
      min(Integer.highestOneBit(max(capacity - 1, 4)) * 2, 1 << 30);
}

final class _Node<K, V> {
  final K? _key;
  V? _value;
  final int _hash;
  _Node<K, V>? next;

  _Node(this._key, this._hash, this._value, this.next);

  K? get key => _key;
  V? get value => _value;
  int get hash => _hash;

// TODO: tailrec
  _Node<K, V>? findNode(K k, int h) {
    if (h == _hash && k == _key) {
      return this;
    } else if (next == null || _hash > h) {
      return null;
    } else {
      return next!.findNode(k, h);
    }
  }

  // TODO: tailrec
  void foreach<U>(Function1<(K, V), U> f) {
    if (_key != null && _value != null) f((_key, _value!));
    next?.foreach(f);
  }

// TODO: tailrec
  void foreachEntry<U>(Function2<K, V, U> f) {
    if (_key != null && _value != null) f(_key, _value as V);
    next?.foreachEntry(f);
  }

  @override
  String toString() => 'Node($key, $value, $hash) -> $next';
}

final class _HashMapIterator<K, V, B> extends RIterator<B> {
  final Array<_Node<K, V>> _table;
  final int len;
  final Function1<_Node<K, V>, B?> extract;

  int _i = 0;
  _Node<K, V>? _node;

  _HashMapIterator(this._table, this.extract) : len = _table.length;

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
