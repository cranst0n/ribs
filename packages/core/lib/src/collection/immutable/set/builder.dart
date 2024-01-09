part of '../iset.dart';

final class ISetBuilder<A> {
  ISet<A> _elems = ISet.empty<A>();
  var _switchedToHashSetBuilder = false;
  late final _hashSetBuilder = HashSetBuilder<A>();

  ISetBuilder<A> addAll(IterableOnce<A> elems) {
    final it = elems.iterator;

    while (it.hasNext) {
      addOne(it.next());
    }

    return this;
  }

  ISetBuilder<A> addOne(A elem) {
    if (_switchedToHashSetBuilder) {
      _hashSetBuilder.addOne(elem);
    } else if (_elems.size < 4) {
      _elems = _elems + elem;
    } else {
      // assert(elems.size == 4)
      if (!_elems.contains(elem)) {
        _switchedToHashSetBuilder = true;
        _hashSetBuilder.addAll(_elems);
        _hashSetBuilder.addOne(elem);
      }
    }

    return this;
  }

  void clear() {
    _elems = ISet.empty();
    _hashSetBuilder.clear();
    _switchedToHashSetBuilder = false;
  }

  ISet<A> result() {
    if (_switchedToHashSetBuilder) {
      return _hashSetBuilder.result();
    } else {
      return _elems;
    }
  }
}

final class HashSetBuilder<A> {
  IHashSet<A>? _aliased;
  BitmapIndexedSetNode<A> _rootNode;

  HashSetBuilder() : _rootNode = _newEmptyRootNode();

  HashSetBuilder<A> addAll(IterableOnce<A> elems) {
    _ensureUnaliased();

    // TODO: ChampBaseIterator if elems is an IHashSet

    final it = elems.iterator;
    while (it.hasNext) {
      addOne(it.next());
    }

    return this;
  }

  HashSetBuilder<A> addOne(A elem) {
    _ensureUnaliased();
    final h = elem.hashCode;
    final im = Hashing.improve(h);
    update(_rootNode, elem, h, im, 0);
    return this;
  }

  void clear() {
    _aliased = null;
    if (_rootNode.size > 0) {
      // if rootNode is empty, we will not have given it away anyways, we instead give out the reused Set.empty
      _rootNode = _newEmptyRootNode();
    }
  }

  IHashSet<A> result() {
    if (_rootNode.size == 0) {
      return IHashSet.empty();
    } else if (_aliased != null) {
      return _aliased!;
    } else {
      return _aliased = IHashSet._(_rootNode);
    }
  }

  int get size => _rootNode.size;

  void update(SetNode<A> setNode, A element, int originalHash, int elementHash,
      int shift) {
    if (setNode is BitmapIndexedSetNode<A>) {
      final bm = setNode;

      final mask = Node.maskFrom(elementHash, shift);
      final bitpos = Node.bitposFrom(mask);

      if ((bm.dataMap & bitpos) != 0) {
        final index = Node.indexFromMask(bm.dataMap, mask, bitpos);
        final element0 = bm.getPayload(index);
        final element0UnimprovedHash = bm.getHash(index);

        if (element0UnimprovedHash == originalHash && element0 == element) {
          _setValue(bm, bitpos, element0);
        } else {
          final element0Hash = Hashing.improve(element0UnimprovedHash);
          final subNodeNew = bm.mergeTwoKeyValPairs(
              element0,
              element0UnimprovedHash,
              element0Hash,
              element,
              originalHash,
              elementHash,
              shift + Node.BitPartitionSize);
          bm.migrateFromInlineToNodeInPlace(bitpos, element0Hash, subNodeNew);
        }
      } else if ((bm.nodeMap & bitpos) != 0) {
        final index = Node.indexFromMask(bm.nodeMap, mask, bitpos);
        final subNode = bm.getNode(index);
        final beforeSize = subNode.size;
        final beforeHashCode = subNode.cachedDartKeySetHashCode;
        update(subNode, element, originalHash, elementHash,
            shift + Node.BitPartitionSize);
        bm.size += subNode.size - beforeSize;
        bm.cachedDartKeySetHashCode +=
            subNode.cachedDartKeySetHashCode - beforeHashCode;
      } else {
        _insertValue(bm, bitpos, element, originalHash, elementHash);
      }
    } else if (setNode is HashCollisionSetNode<A>) {
      final hc = setNode;

      final index = hc.content.indexOf(element);

      index.fold(
        () => hc.content = hc.content.appended(element),
        (index) => hc.content = hc.content.updated(index, element),
      );
    }
  }

  // ///////////////////////////////////////////////////////////////////////////

  void _ensureUnaliased() {
    if (_isAliased) _copyElems();
    _aliased = null;
  }

  void _copyElems() {
    _rootNode = _rootNode.copy();
  }

  Array<int> _insertElement(Array<int> arr, int ix, int elem) {
    if (ix < 0) throw RangeError('HashSetBuilder.insert: $ix');
    if (ix > arr.length) throw RangeError('$ix > ${arr.length}');

    final result = Array.ofDim<int>(arr.length + 1);
    Array.arraycopy(arr, 0, result, 0, ix);
    result[ix] = elem;
    Array.arraycopy(arr, ix, result, ix + 1, arr.length - ix);

    return result;
  }

  void _insertValue(
    BitmapIndexedSetNode<A> bm,
    int bitpos,
    A key,
    int originalHash,
    int keyHash,
  ) {
    final dataIx = bm.dataIndex(bitpos);
    final idx = SetNode.TupleLength * dataIx;

    final src = bm.content;
    final dst = Array.ofDim<dynamic>(src.length + SetNode.TupleLength);

    // copy 'src' and insert 2 element(s) at position 'idx'
    Array.arraycopy(src, 0, dst, 0, idx);
    dst[idx] = key;
    Array.arraycopy(src, idx, dst, idx + SetNode.TupleLength, src.length - idx);

    final dstHashes = _insertElement(bm.originalHashes, dataIx, originalHash);

    bm.dataMap = bm.dataMap | bitpos;
    bm.content = dst;
    bm.originalHashes = dstHashes;
    bm.size += 1;
    bm.cachedDartKeySetHashCode += keyHash;
  }

  bool get _isAliased => _aliased != null;

  void _setValue(BitmapIndexedSetNode<A> bm, int bitpos, A elem) {
    final dataIx = bm.dataIndex(bitpos);
    final idx = SetNode.TupleLength * dataIx;
    bm.content[idx] = elem;
  }

  static BitmapIndexedSetNode<A> _newEmptyRootNode<A>() =>
      BitmapIndexedSetNode(0, 0, Array.empty(), Array.empty(), 0, 0);
}
