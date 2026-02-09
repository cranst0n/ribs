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

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/collection/hashing.dart';
import 'package:ribs_core/src/collection/immutable/set/champ_common.dart';
import 'package:ribs_core/src/collection/immutable/set/set_node.dart';

final class IHashSet<A> with RIterableOnce<A>, RIterable<A>, RSet<A>, ISet<A> {
  final BitmapIndexedSetNode<A> _rootNode;

  IHashSet._(this._rootNode);

  static IHashSetBuilder<A> builder<A>() => IHashSetBuilder();

  static IHashSet<A> empty<A>() => IHashSet._(SetNode.empty());

  static IHashSet<A> from<A>(RIterableOnce<A> xs) => switch (xs) {
    final IHashSet<A> hs => hs,
    _ when xs.knownSize == 0 => IHashSet.empty(),
    _ => builder<A>().addAll(xs).result(),
  };

  @override
  IHashSet<A> operator +(A a) => incl(a);

  @override
  IHashSet<A> operator -(A a) => excl(a);

  @override
  IHashSet<A> concat(RIterableOnce<A> that) {
    if (that is IHashSet<A>) {
      if (isEmpty) {
        return that;
      } else {
        final newNode = _rootNode.concat(that._rootNode, 0);
        if (newNode == that._rootNode) {
          return that;
        } else {
          return _newHashSetOrThis(newNode);
        }
      }
    } else {
      final iter = that.iterator;
      var current = _rootNode;

      while (iter.hasNext) {
        final element = iter.next();
        final originalHash = element.hashCode;
        final improved = Hashing.improve(originalHash);
        current = current.updated(element, originalHash, improved, 0);

        if (current != _rootNode) {
          // Note: We could have started with shallowlyMutableNodeMap = 0, however this way, in the case that
          // the first changed key ended up in a subnode beneath root, we mark that root right away as being
          // shallowly mutable.
          //
          // since `element` has just been inserted, and certainly caused a new root node to be created, we can say with
          // certainty that it either caused a new subnode to be created underneath `current`, in which case we should
          // carry on mutating that subnode, or it ended up as a child data pair of the root, in which case, no harm is
          // done by including its bit position in the shallowlyMutableNodeMap anyways.
          var shallowlyMutableNodeMap = Node.bitposFrom(Node.maskFrom(improved, 0));

          while (iter.hasNext) {
            final element = iter.next();
            final originalHash = element.hashCode;
            final improved = Hashing.improve(originalHash);
            shallowlyMutableNodeMap = current.updateWithShallowMutations(
              element,
              originalHash,
              improved,
              0,
              shallowlyMutableNodeMap,
            );
          }

          return IHashSet._(current);
        }
      }
      return this;
    }
  }

  @override
  bool contains(A elem) {
    final elementUnimprovedHash = elem.hashCode;
    final elementHash = Hashing.improve(elementUnimprovedHash);
    return _rootNode.contains(elem, elementUnimprovedHash, elementHash, 0);
  }

  @override
  IHashSet<A> diff(ISet<A> that) {
    if (isEmpty) {
      return this;
    } else {
      if (that is IHashSet<A>) {
        if (that.isEmpty) {
          return this;
        } else {
          final newRootNode = _rootNode.diff(that._rootNode, 0);
          if (newRootNode.size == 0) {
            return IHashSet.empty();
          } else {
            return _newHashSetOrThis(_rootNode.diff(that._rootNode, 0));
          }
        }
      } else {
        final thatKnownSize = that.knownSize;

        if (thatKnownSize == 0) {
          return this;
        } else if (thatKnownSize <= size) {
          /* this branch intentionally includes the case of thatKnownSize == -1. We know that HashSets are quite fast at look-up, so
            we're likely to be the faster of the two at that. */
          return _removedAllWithShallowMutations(that);
        } else {
          // TODO: Develop more sophisticated heuristic for which branch to take
          return filterNot(that.contains);
        }
      }
    }
  }

  @override
  IHashSet<A> excl(A elem) {
    final elementUnimprovedHash = elem.hashCode;
    final elementHash = Hashing.improve(elementUnimprovedHash);
    final newRootNode = _rootNode.removed(elem, elementUnimprovedHash, elementHash, 0);
    return _newHashSetOrThis(newRootNode);
  }

  @override
  IHashSet<A> filter(Function1<A, bool> p) => _filterImpl(p, false);

  @override
  IHashSet<A> filterNot(Function1<A, bool> p) => _filterImpl(p, true);

  IHashSet<A> _filterImpl(Function1<A, bool> p, bool isFlipped) {
    final newRootNode = _rootNode.filterImpl(p, isFlipped);

    if (newRootNode == _rootNode) {
      return this;
    } else if (newRootNode.size == 0) {
      return IHashSet.empty();
    } else {
      return IHashSet._(newRootNode);
    }
  }

  @override
  void foreach<U>(Function1<A, U> f) => _rootNode.foreach(f);

  @override
  A get head => iterator.next();

  @override
  IHashSet<A> incl(A elem) {
    final elementUnimprovedHash = elem.hashCode;
    final elementHash = Hashing.improve(elementUnimprovedHash);
    final newRootNode = _rootNode.updated(elem, elementUnimprovedHash, elementHash, 0);
    return _newHashSetOrThis(newRootNode);
  }

  @override
  IHashSet<A> get init => this - last;

  @override
  RIterator<IHashSet<A>> get inits => super.inits.map(IHashSet.from);

  @override
  bool get isEmpty => _rootNode.size == 0;

  @override
  RIterator<A> get iterator => isEmpty ? RIterator.empty() : _SetIterator(_rootNode);

  @override
  int get knownSize => _rootNode.size;

  @override
  A get last => reverseIterator.next();

  @override
  IHashSet<A> removedAll(RIterableOnce<A> that) => switch (that) {
    final ISet<A> that => diff(that),
    _ => _removedAllWithShallowMutations(that),
  };

  RIterator<A> get reverseIterator => _SetReverseIterator(_rootNode);

  @override
  int get size => _rootNode.size;

  @override
  IHashSet<A> get tail => this - head;

  @override
  bool operator ==(Object that) => switch (that) {
    final IHashSet<A> that => identical(this, that) || _rootNode == that._rootNode,
    _ => super == that,
  };

  @override
  int get hashCode => MurmurHash3.unorderedHash(_SetHashIterator(_rootNode), MurmurHash3.setSeed);

  IHashSet<A> _newHashSetOrThis(BitmapIndexedSetNode<A> newRootNode) =>
      _rootNode == newRootNode ? this : IHashSet._(newRootNode);

  IHashSet<A> _removedAllWithShallowMutations(RIterableOnce<A> that) {
    final iter = that.iterator;
    var curr = _rootNode;

    while (iter.hasNext) {
      final next = iter.next();
      final originalHash = next.hashCode;
      final improved = Hashing.improve(originalHash);
      curr = curr.removed(next, originalHash, improved, 0);

      if (curr != _rootNode) {
        if (curr.size == 0) return IHashSet.empty();

        while (iter.hasNext) {
          final next = iter.next();
          final originalHash = next.hashCode;
          final improved = Hashing.improve(originalHash);

          curr.removeWithShallowMutations(next, originalHash, improved);

          if (curr.size == 0) return IHashSet.empty();
        }
        return IHashSet._(curr);
      }
    }

    return this;
  }
}

final class _SetIterator<A> extends ChampBaseIterator<A, SetNode<A>> {
  _SetIterator(super.rootNode);

  @override
  A next() {
    if (hasNext) {
      final payload = currentValueNode!.getPayload(currentValueCursor) as A;
      currentValueCursor += 1;

      return payload;
    } else {
      noSuchElement();
    }
  }
}

final class _SetReverseIterator<A> extends ChampBaseReverseIterator<A, SetNode<A>> {
  _SetReverseIterator(super.rootNode);

  @override
  A next() {
    if (hasNext) {
      final payload = currentValueNode!.getPayload(currentValueCursor) as A;
      currentValueCursor -= 1;

      return payload;
    } else {
      noSuchElement();
    }
  }
}

final class _SetHashIterator<A> extends ChampBaseIterator<dynamic, SetNode<A>> {
  var _hash = 0;

  _SetHashIterator(super.rootNode);

  @override
  dynamic next() {
    if (hasNext) {
      _hash = currentValueNode!.getHash(currentValueCursor);
      currentValueCursor += 1;

      return this;
    } else {
      noSuchElement();
    }
  }

  @override
  int get hashCode => _hash;

  @override
  bool operator ==(Object other) => identical(this, other);
}

final class IHashSetBuilder<A> {
  IHashSet<A>? _aliased;
  BitmapIndexedSetNode<A> _rootNode;

  IHashSetBuilder() : _rootNode = _newEmptyRootNode();

  IHashSetBuilder<A> addAll(RIterableOnce<A> elems) {
    _ensureUnaliased();

    // TODO: ChampBaseIterator if elems is an IHashSet

    final it = elems.iterator;
    while (it.hasNext) {
      addOne(it.next());
    }

    return this;
  }

  IHashSetBuilder<A> addOne(A elem) {
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

  void update(SetNode<A> setNode, A element, int originalHash, int elementHash, int shift) {
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
            shift + Node.BitPartitionSize,
          );
          bm.migrateFromInlineToNodeInPlace(bitpos, element0Hash, subNodeNew);
        }
      } else if ((bm.nodeMap & bitpos) != 0) {
        final index = Node.indexFromMask(bm.nodeMap, mask, bitpos);
        final subNode = bm.getNode(index);
        final beforeSize = subNode.size;
        final beforeHashCode = subNode.cachedDartKeySetHashCode;
        update(subNode, element, originalHash, elementHash, shift + Node.BitPartitionSize);
        bm.size += subNode.size - beforeSize;
        bm.cachedDartKeySetHashCode += subNode.cachedDartKeySetHashCode - beforeHashCode;
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
    if (ix < 0) throw RangeError('IHashSetBuilder.insert: $ix');
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
