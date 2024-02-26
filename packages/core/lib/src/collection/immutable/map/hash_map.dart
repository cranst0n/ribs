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

part of '../imap.dart';

final class IHashMap<K, V>
    with RIterableOnce<(K, V)>, RIterable<(K, V)>, RMap<K, V>, IMap<K, V> {
  final BitmapIndexedMapNode<K, V> _rootNode;

  IHashMap._(this._rootNode);

  static IHashMap<K, V> empty<K, V>() => IHashMap._(MapNode.empty());

  @override
  Option<V> get(K key) {
    final keyUnimprovedHash = key.hashCode;
    final keyHash = Hashing.improve(keyUnimprovedHash);
    return _rootNode.get(key, keyUnimprovedHash, keyHash, 0);
  }

  @override
  bool get isEmpty => _rootNode.size == 0;

  @override
  RIterator<(K, V)> get iterator => _MapKeyValueTupleIterator(_rootNode);

  @override
  ISet<K> get keys => _MapKeyIterator(_rootNode).toISet();

  @override
  int get knownSize => _rootNode.size;

  @override
  IMap<K, V> removed(K key) {
    final keyUnimprovedHash = key.hashCode;
    return _newHashMapOrThis(_rootNode.removed(
      key,
      keyUnimprovedHash,
      Hashing.improve(keyUnimprovedHash),
      0,
    ));
  }

  @override
  int get size => _rootNode.size;

  @override
  IMap<K, V> updated(K key, V value) {
    final keyUnimprovedHash = key.hashCode;
    return _newHashMapOrThis(_rootNode.updated(
      key,
      value,
      keyUnimprovedHash,
      Hashing.improve(keyUnimprovedHash),
      0,
      true,
    ));
  }

  @override
  RIterator<V> get valuesIterator => _MapValueIterator(_rootNode);

  IHashMap<K, V> _newHashMapOrThis(BitmapIndexedMapNode<K, V> newRootNode) =>
      newRootNode == _rootNode ? this : IHashMap._(newRootNode);
}

class IHashMapBuilder<K, V> {
  IHashMap<K, V>? _aliased;
  BitmapIndexedMapNode<K, V> _rootNode;

  IHashMapBuilder() : _rootNode = _newEmptyRootNode();

  IHashMapBuilder<K, V> addAll(RIterableOnce<(K, V)> elems) {
    // TODO: Optimize
    final it = elems.iterator;
    while (it.hasNext) {
      addOne(it.next());
    }

    return this;
  }

  IHashMapBuilder<K, V> addOne((K, V) elem) {
    _ensureUnaliased();
    final h = elem.$1.hashCode;
    final im = Hashing.improve(h);
    _update(_rootNode, elem.$1, elem.$2, h, im, 0);
    return this;
  }

  IHashMapBuilder<K, V> addOneWithHash((K, V) elem, int originalHash) {
    _ensureUnaliased();
    _update(_rootNode, elem.$1, elem.$2, originalHash,
        Hashing.improve(originalHash), 0);
    return this;
  }

  IHashMapBuilder<K, V> addOneWithHashes(
    (K, V) elem,
    int originalHash,
    int hash,
  ) {
    _ensureUnaliased();
    _update(_rootNode, elem.$1, elem.$2, originalHash, hash, 0);
    return this;
  }

  void clear() {
    _aliased = null;
    if (_rootNode.size > 0) _rootNode = _newEmptyRootNode();
  }

  IMap<K, V> result() {
    if (_rootNode.size == 0) {
      return IHashMap.empty();
    } else {
      return _aliased ??= IHashMap._(_rootNode);
    }
  }

  Array<int> _insertElement(Array<int> as, int ix, int elem) {
    if (ix < 0) throw RangeError('IHashMapBuilder.insert: $ix');
    if (ix > as.length) throw RangeError('IHashMapBuilder.insert: $ix');

    final result = Array.ofDim<int>(as.length + 1);
    Array.arraycopy(as, 0, result, 0, ix);
    result[ix] = elem;
    Array.arraycopy(as, ix, result, ix + 1, as.length - ix);
    return result;
  }

  void _insertValue(BitmapIndexedMapNode<K, V> bm, int bitpos, K key,
      int originalHash, int keyHash, V value) {
    final dataIx = bm.dataIndex(bitpos);
    final idx = MapNode.TupleLength * dataIx;

    final src = bm.content;
    final dst = Array.ofDim<dynamic>(src.length + MapNode.TupleLength);

    // copy 'src' and insert 2 element(s) at position 'idx'
    Array.arraycopy(src, 0, dst, 0, idx);
    dst[idx] = key;
    dst[idx + 1] = value;
    Array.arraycopy(src, idx, dst, idx + MapNode.TupleLength, src.length - idx);

    final dstHashes = _insertElement(bm.originalHashes, dataIx, originalHash);

    bm.dataMap |= bitpos;
    bm.content = dst;
    bm.originalHashes = dstHashes;
    bm.size += 1;
    bm.cachedDartKeySetHashCode += keyHash;
  }

  void _update(
    MapNode<K, V> mapNode,
    K key,
    V value,
    int originalHash,
    int keyHash,
    int shift,
  ) {
    if (mapNode is BitmapIndexedMapNode<K, V>) {
      final bm = mapNode;

      final mask = Node.maskFrom(keyHash, shift);
      final bitpos = Node.bitposFrom(mask);

      if ((bm.dataMap & bitpos) != 0) {
        final index = Node.indexFromMask(bm.dataMap, mask, bitpos);
        final key0 = bm.getKey(index);
        final key0UnimprovedHash = bm.getHash(index);

        if (key0UnimprovedHash == originalHash && key0 == key) {
          bm.content[MapNode.TupleLength * index + 1] = value;
        } else {
          final value0 = bm.getValue(index);
          final key0Hash = Hashing.improve(key0UnimprovedHash);

          final subNodeNew = bm.mergeTwoKeyValPairs(
              key0,
              value0,
              key0UnimprovedHash,
              key0Hash,
              key,
              value,
              originalHash,
              keyHash,
              shift + Node.BitPartitionSize);

          bm.migrateFromInlineToNodeInPlace(bitpos, key0Hash, subNodeNew);
        }
      } else if ((bm.nodeMap & bitpos) != 0) {
        final index = Node.indexFromMask(bm.nodeMap, mask, bitpos);
        final subNode = bm.getNode(index);
        final beforeSize = subNode.size;
        final beforeHash = subNode.cachedDartKeySetHashCode;

        _update(subNode, key, value, originalHash, keyHash,
            shift + Node.BitPartitionSize);
        bm.size += subNode.size - beforeSize;
        bm.cachedDartKeySetHashCode +=
            subNode.cachedDartKeySetHashCode - beforeHash;
      } else {
        _insertValue(bm, bitpos, key, originalHash, keyHash, value);
      }
    } else if (mapNode is HashCollisionMapNode<K, V>) {
      final hc = mapNode;

      final index = hc.indexOf(key);

      if (index < 0) {
        hc.content = hc.content.appended((key, value));
      } else {
        hc.content = hc.content.updated(index, (key, value));
      }
    } else {
      throw UnsupportedError('IHashMapBuilder._update: $mapNode');
    }
  }

  void _ensureUnaliased() {
    if (isAliased) _copyElems();
    _aliased = null;
  }

  bool get isAliased => _aliased != null;

  void _copyElems() {
    _rootNode = _rootNode.copy();
  }

  int get size => _rootNode.size;

  static BitmapIndexedMapNode<K, V> _newEmptyRootNode<K, V>() =>
      BitmapIndexedMapNode(0, 0, Array.empty(), Array.empty(), 0, 0);
}

final class _MapKeyValueTupleIterator<K, V>
    extends ChampBaseIterator<(K, V), MapNode<K, V>> {
  _MapKeyValueTupleIterator(super.rootNode);

  @override
  (K, V) next() {
    if (!hasNext) noSuchElement();

    final payload = currentValueNode!.getPayload(currentValueCursor);
    currentValueCursor += 1;

    return payload;
  }
}

final class _MapKeyIterator<K, V> extends ChampBaseIterator<K, MapNode<K, V>> {
  _MapKeyIterator(super.rootNode);

  @override
  K next() {
    if (!hasNext) noSuchElement();

    final key = currentValueNode!.getKey(currentValueCursor);
    currentValueCursor += 1;

    return key;
  }
}

final class _MapValueIterator<K, V>
    extends ChampBaseIterator<V, MapNode<K, V>> {
  _MapValueIterator(super.rootNode);

  @override
  V next() {
    if (!hasNext) noSuchElement();

    final value = currentValueNode!.getValue(currentValueCursor);
    currentValueCursor += 1;

    return value;
  }
}
