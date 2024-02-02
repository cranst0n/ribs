import 'dart:collection';

import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/collection/hashing.dart';
import 'package:ribs_core/src/collection/immutable/set/champ_common.dart';

@internal
sealed class MapNode<K, V> extends Node<MapNode<K, V>> {
  static const TupleLength = 2;

  static BitmapIndexedMapNode<K, V> empty<K, V>() =>
      BitmapIndexedMapNode(0, 0, Array.empty(), Array.empty(), 0, 0);

  V apply(K key, int originalHash, int hash, int shift);

  Option<V> get(K key, int originalHash, int hash, int shift);

  V getOrElse(K key, int originalHash, int hash, int shift, Function0<V> f);

  bool containsKey(K key, int originalHash, int hash, int shift);

  MapNode<K, V> updated(
      K key, V value, int originalHash, int hash, int shift, bool replaceValue);

  MapNode<K, V> removed(K key, int originalHash, int hash, int shift);

  @override
  int get nodeArity;

  @override
  MapNode<K, V> getNode(int index);

  @override
  bool get hasPayload;

  @override
  int get payloadArity;

  K getKey(int index);

  V getValue(int index);

  @override
  (K, V) getPayload(int index);

  int get size;

  void foreach<U>(Function1<(K, V), U> f);

  void foreachEntry<U>(Function2<K, V, U> f);

  void foreachWithHash(Function3<K, V, int, void> f);

  MapNode<K, W> transform<W>(Function2<K, V, W> f);

  MapNode<K, V> copy();

  MapNode<K, V> concat(MapNode<K, V> that, int shift);

  MapNode<K, V> filterImpl(Function1<(K, V), bool> p, bool isFlipped);

  void mergeInto(MapNode<K, V> that, IHashMapBuilder<K, V> builder, int shift,
      Function2<(K, V), (K, V), (K, V)> mergef);

  (K, V) getTuple(K key, int originalHash, int hash, int shift);

  void buildTo(IHashMapBuilder<K, V> builder);
}

@internal
final class BitmapIndexedMapNode<K, V> extends MapNode<K, V> {
  int dataMap;
  int nodeMap;
  Array<dynamic> content;
  Array<int> originalHashes;
  @override
  int size;
  @override
  int cachedDartKeySetHashCode;

  static const int TupleLength = MapNode.TupleLength;

  BitmapIndexedMapNode(
    this.dataMap,
    this.nodeMap,
    this.content,
    this.originalHashes,
    this.size,
    this.cachedDartKeySetHashCode,
  );

  @override
  V apply(K key, int originalHash, int keyHash, int shift) {
    final mask = Node.maskFrom(keyHash, shift);
    final bitpos = Node.bitposFrom(mask);

    if ((dataMap & bitpos) != 0) {
      final index = Node.indexFromMask(dataMap, mask, bitpos);

      if (key == getKey(index)) {
        return getValue(index);
      } else {
        noSuchKey(key);
      }
    } else if ((nodeMap & bitpos) != 0) {
      return getNode(Node.indexFromMask(nodeMap, mask, bitpos))
          .apply(key, originalHash, keyHash, shift + Node.BitPartitionSize);
    } else {
      noSuchKey(key);
    }
  }

  @override
  void buildTo(IHashMapBuilder<K, V> builder) {
    var i = 0;
    final iN = payloadArity;
    final jN = nodeArity;

    while (i < iN) {
      builder.addOneWithHash((getKey(i), getValue(i)), getHash(i));
      i += 1;
    }

    var j = 0;
    while (j < jN) {
      getNode(j).buildTo(builder);
      j += 1;
    }
  }

  @override
  MapNode<K, V> concat(MapNode<K, V> that, int shift) {
    if (that is BitmapIndexedMapNode<K, V>) {
      final bm = that;

      if (size == 0) {
        return bm;
      } else if (bm.size == 0 || (bm == this)) {
        return this;
      } else if (bm.size == 1) {
        final originalHash = bm.getHash(0);
        return this.updated(bm.getKey(0), bm.getValue(0), originalHash,
            Hashing.improve(originalHash), shift, true);
      }

      // if we go through the merge and the result does not differ from `bm`, we can just return `bm`, to improve sharing
      // So, `anyChangesMadeSoFar` will be set to `true` as soon as we encounter a difference between the
      // currently-being-computed result, and `bm`
      var anyChangesMadeSoFar = false;

      final allMap = dataMap | bm.dataMap | nodeMap | bm.nodeMap;

      // minimumIndex is inclusive -- it is the first index for which there is data or nodes
      final minimumBitPos =
          Node.bitposFrom(Integer.numberOfTrailingZeros(allMap));
      // maximumIndex is inclusive -- it is the last index for which there is data or nodes
      // it could not be exclusive, because then upper bound in worst case (Node.BranchingFactor) would be out-of-bound
      // of int bitposition representation
      final maximumBitPos = Node.bitposFrom(
          Node.BranchingFactor - Integer.numberOfLeadingZeros(allMap) - 1);

      var leftNodeRightNode = 0;
      var leftDataRightNode = 0;
      var leftNodeRightData = 0;
      var leftDataOnly = 0;
      var rightDataOnly = 0;
      var leftNodeOnly = 0;
      var rightNodeOnly = 0;
      var leftDataRightDataMigrateToNode = 0;
      var leftDataRightDataRightOverwrites = 0;

      var dataToNodeMigrationTargets = 0;

      {
        var bitpos = minimumBitPos;
        var leftIdx = 0;
        var rightIdx = 0;
        var finished = false;

        while (!finished) {
          if ((bitpos & dataMap) != 0) {
            if ((bitpos & bm.dataMap) != 0) {
              final leftOriginalHash = getHash(leftIdx);
              if (leftOriginalHash == bm.getHash(rightIdx) &&
                  getKey(leftIdx) == bm.getKey(rightIdx)) {
                leftDataRightDataRightOverwrites |= bitpos;
              } else {
                leftDataRightDataMigrateToNode |= bitpos;
                dataToNodeMigrationTargets |= Node.bitposFrom(
                    Node.maskFrom(Hashing.improve(leftOriginalHash), shift));
              }
              rightIdx += 1;
            } else if ((bitpos & bm.nodeMap) != 0) {
              leftDataRightNode |= bitpos;
            } else {
              leftDataOnly |= bitpos;
            }
            leftIdx += 1;
          } else if ((bitpos & nodeMap) != 0) {
            if ((bitpos & bm.dataMap) != 0) {
              leftNodeRightData |= bitpos;
              rightIdx += 1;
            } else if ((bitpos & bm.nodeMap) != 0) {
              leftNodeRightNode |= bitpos;
            } else {
              leftNodeOnly |= bitpos;
            }
          } else if ((bitpos & bm.dataMap) != 0) {
            rightDataOnly |= bitpos;
            rightIdx += 1;
          } else if ((bitpos & bm.nodeMap) != 0) {
            rightNodeOnly |= bitpos;
          }

          if (bitpos == maximumBitPos) {
            finished = true;
          } else {
            bitpos = bitpos << 1;
          }
        }
      }

      final newDataMap =
          leftDataOnly | rightDataOnly | leftDataRightDataRightOverwrites;

      final newNodeMap = leftNodeRightNode |
          leftDataRightNode |
          leftNodeRightData |
          leftNodeOnly |
          rightNodeOnly |
          dataToNodeMigrationTargets;

      if ((newDataMap == (rightDataOnly | leftDataRightDataRightOverwrites)) &&
          (newNodeMap == rightNodeOnly)) {
        // nothing from `this` will make it into the result -- return early
        return bm;
      }

      final newDataSize = Integer.bitCount(newDataMap);
      final newContentSize =
          (MapNode.TupleLength * newDataSize) + Integer.bitCount(newNodeMap);

      final newContent = Array.ofDim<dynamic>(newContentSize);
      final newOriginalHashes = Array.ofDim<int>(newDataSize);
      var newSize = 0;
      var newCachedHashCode = 0;

      {
        var leftDataIdx = 0;
        var rightDataIdx = 0;
        var leftNodeIdx = 0;
        var rightNodeIdx = 0;

        final nextShift = shift + Node.BitPartitionSize;

        var compressedDataIdx = 0;
        var compressedNodeIdx = 0;

        var bitpos = minimumBitPos;
        var finished = false;

        while (!finished) {
          if ((bitpos & leftNodeRightNode) != 0) {
            final rightNode = bm.getNode(rightNodeIdx);
            final newNode = getNode(leftNodeIdx).concat(rightNode, nextShift);

            if (rightNode != newNode) {
              anyChangesMadeSoFar = true;
            }

            newContent[newContentSize - compressedNodeIdx - 1] = newNode;
            compressedNodeIdx += 1;
            rightNodeIdx += 1;
            leftNodeIdx += 1;
            newSize += newNode.size;
            newCachedHashCode += newNode.cachedDartKeySetHashCode;
          } else if ((bitpos & leftDataRightNode) != 0) {
            //       val newNode = {
            final n = bm.getNode(rightNodeIdx);
            final leftKey = getKey(leftDataIdx);
            final leftValue = getValue(leftDataIdx);
            final leftOriginalHash = getHash(leftDataIdx);
            final leftImproved = Hashing.improve(leftOriginalHash);

            final updated = n.updated(leftKey, leftValue, leftOriginalHash,
                leftImproved, nextShift, false);

            if (updated != n) {
              anyChangesMadeSoFar = true;
            }

            final newNode = updated;

            newContent[newContentSize - compressedNodeIdx - 1] = newNode;
            compressedNodeIdx += 1;
            rightNodeIdx += 1;
            leftDataIdx += 1;
            newSize += newNode.size;
            newCachedHashCode += newNode.cachedDartKeySetHashCode;
          } else if ((bitpos & leftNodeRightData) != 0) {
            anyChangesMadeSoFar = true;
            final rightOriginalHash = bm.getHash(rightDataIdx);
            final newNode = getNode(leftNodeIdx).updated(
              bm.getKey(rightDataIdx),
              bm.getValue(rightDataIdx),
              bm.getHash(rightDataIdx),
              Hashing.improve(rightOriginalHash),
              nextShift,
              true,
            );

            newContent[newContentSize - compressedNodeIdx - 1] = newNode;
            compressedNodeIdx += 1;
            leftNodeIdx += 1;
            rightDataIdx += 1;
            newSize += newNode.size;
            newCachedHashCode += newNode.cachedDartKeySetHashCode;
          } else if ((bitpos & leftDataOnly) != 0) {
            anyChangesMadeSoFar = true;
            final originalHash = originalHashes[leftDataIdx];
            newContent[TupleLength * compressedDataIdx] = getKey(leftDataIdx);
            newContent[TupleLength * compressedDataIdx + 1] =
                getValue(leftDataIdx);
            newOriginalHashes[compressedDataIdx] = originalHash;

            compressedDataIdx += 1;
            leftDataIdx += 1;
            newSize += 1;
            newCachedHashCode += Hashing.improve(originalHash!);
          } else if ((bitpos & rightDataOnly) != 0) {
            final originalHash = bm.originalHashes[rightDataIdx];
            newContent[TupleLength * compressedDataIdx] =
                bm.getKey(rightDataIdx);
            newContent[TupleLength * compressedDataIdx + 1] =
                bm.getValue(rightDataIdx);
            newOriginalHashes[compressedDataIdx] = originalHash;

            compressedDataIdx += 1;
            rightDataIdx += 1;
            newSize += 1;
            newCachedHashCode += Hashing.improve(originalHash!);
          } else if ((bitpos & leftNodeOnly) != 0) {
            anyChangesMadeSoFar = true;
            final newNode = getNode(leftNodeIdx);
            newContent[newContentSize - compressedNodeIdx - 1] = newNode;
            compressedNodeIdx += 1;
            leftNodeIdx += 1;
            newSize += newNode.size;
            newCachedHashCode += newNode.cachedDartKeySetHashCode;
          } else if ((bitpos & rightNodeOnly) != 0) {
            final newNode = bm.getNode(rightNodeIdx);
            newContent[newContentSize - compressedNodeIdx - 1] = newNode;
            compressedNodeIdx += 1;
            rightNodeIdx += 1;
            newSize += newNode.size;
            newCachedHashCode += newNode.cachedDartKeySetHashCode;
          } else if ((bitpos & leftDataRightDataMigrateToNode) != 0) {
            anyChangesMadeSoFar = true;

            final leftOriginalHash = getHash(leftDataIdx);
            final rightOriginalHash = bm.getHash(rightDataIdx);

            final newNode = bm.mergeTwoKeyValPairs(
              getKey(leftDataIdx),
              getValue(leftDataIdx),
              leftOriginalHash,
              Hashing.improve(leftOriginalHash),
              bm.getKey(rightDataIdx),
              bm.getValue(rightDataIdx),
              rightOriginalHash,
              Hashing.improve(rightOriginalHash),
              nextShift,
            );

            newContent[newContentSize - compressedNodeIdx - 1] = newNode;
            compressedNodeIdx += 1;
            leftDataIdx += 1;
            rightDataIdx += 1;
            newSize += newNode.size;
            newCachedHashCode += newNode.cachedDartKeySetHashCode;
          } else if ((bitpos & leftDataRightDataRightOverwrites) != 0) {
            final originalHash = bm.originalHashes[rightDataIdx];
            newContent[TupleLength * compressedDataIdx] =
                bm.getKey(rightDataIdx);
            newContent[TupleLength * compressedDataIdx + 1] =
                bm.getValue(rightDataIdx);
            newOriginalHashes[compressedDataIdx] = originalHash;

            compressedDataIdx += 1;
            rightDataIdx += 1;
            newSize += 1;
            newCachedHashCode += Hashing.improve(originalHash!);
            leftDataIdx += 1;
          }

          if (bitpos == maximumBitPos) {
            finished = true;
          } else {
            bitpos = bitpos << 1;
          }
        }
      }

      if (anyChangesMadeSoFar) {
        return BitmapIndexedMapNode(newDataMap, newNodeMap, newContent,
            newOriginalHashes, newSize, newCachedHashCode);
      } else {
        return bm;
      }
    } else {
      throw UnsupportedError(
          'Cannot concatenate a HashCollisionMapNode with a BitmapIndexedSetNode');
    }
  }

  @override
  bool containsKey(K key, int originalHash, int keyHash, int shift) {
    final mask = Node.maskFrom(keyHash, shift);
    final bitpos = Node.bitposFrom(mask);

    if ((dataMap & bitpos) != 0) {
      final index = Node.indexFromMask(dataMap, mask, bitpos);
      return (originalHashes[index] == originalHash) && key == getKey(index);
    } else if ((nodeMap & bitpos) != 0) {
      return getNode(Node.indexFromMask(nodeMap, mask, bitpos)).containsKey(
          key, originalHash, keyHash, shift + Node.BitPartitionSize);
    } else {
      return false;
    }
  }

  @override
  BitmapIndexedMapNode<K, V> copy() {
    final contentClone = content.clone();
    final contentLength = contentClone.length;
    var i = Integer.bitCount(dataMap) * TupleLength;

    while (i < contentLength) {
      contentClone[i] = (contentClone[i] as MapNode<K, V>).copy();
      i += 1;
    }

    return BitmapIndexedMapNode<K, V>(dataMap, nodeMap, contentClone,
        originalHashes.clone(), size, cachedDartKeySetHashCode);
  }

  @override
  MapNode<K, V> filterImpl(Function1<(K, V), bool> pred, bool flipped) {
    if (size == 0) {
      return this;
    } else if (size == 1) {
      if (pred(getPayload(0)) != flipped) {
        return this;
      } else {
        return MapNode.empty();
      }
    } else if (nodeMap == 0) {
      // Performance optimization for nodes of depth 1:
      //
      // this node has no "node" children, all children are inlined data elems, therefor logic is significantly simpler
      // approach:
      //   * traverse the content array, accumulating in `newDataMap: Int` any bit positions of keys which pass the filter
      //   * (bitCount(newDataMap) * TupleLength) tells us the new content array and originalHashes array size, so now perform allocations
      //   * traverse the content array once more, placing each passing element (according to `newDatamap`) in the new content and originalHashes arrays
      //
      // note:
      //   * this optimization significantly improves performance of not only small trees, but also larger trees, since
      //     even non-root nodes are affected by this improvement, and large trees will consist of many nodes as
      //     descendants
      //
      final int minimumIndex = Integer.numberOfTrailingZeros(dataMap);
      final int maximumIndex =
          Node.BranchingFactor - Integer.numberOfLeadingZeros(dataMap);

      var newDataMap = 0;
      var newCachedHashCode = 0;
      var dataIndex = 0;

      var i = minimumIndex;

      while (i < maximumIndex) {
        final bitpos = Node.bitposFrom(i);

        if ((bitpos & dataMap) != 0) {
          final payload = getPayload(dataIndex);
          final passed = pred(payload) != flipped;

          if (passed) {
            newDataMap |= bitpos;
            newCachedHashCode += Hashing.improve(getHash(dataIndex));
          }

          dataIndex += 1;
        }

        i += 1;
      }

      if (newDataMap == 0) {
        return MapNode.empty();
      } else if (newDataMap == dataMap) {
        return this;
      } else {
        final newSize = Integer.bitCount(newDataMap);
        final newContent = Array.ofDim<dynamic>(newSize * TupleLength);
        final newOriginalHashCodes = Array.ofDim<int>(newSize);
        final newMaximumIndex =
            Node.BranchingFactor - Integer.numberOfLeadingZeros(newDataMap);

        var j = Integer.numberOfTrailingZeros(newDataMap);

        var newDataIndex = 0;

        while (j < newMaximumIndex) {
          final bitpos = Node.bitposFrom(j);
          if ((bitpos & newDataMap) != 0) {
            final oldIndex = Node.indexFrom(dataMap, bitpos);
            newContent[newDataIndex * TupleLength] =
                content[oldIndex * TupleLength];
            newContent[newDataIndex * TupleLength + 1] =
                content[oldIndex * TupleLength + 1];
            newOriginalHashCodes[newDataIndex] = originalHashes[oldIndex];
            newDataIndex += 1;
          }
          j += 1;
        }

        return BitmapIndexedMapNode(newDataMap, 0, newContent,
            newOriginalHashCodes, newSize, newCachedHashCode);
      }
    } else {
      final allMap = dataMap | nodeMap;
      final minimumIndex = Integer.numberOfTrailingZeros(allMap);
      final maximumIndex =
          Node.BranchingFactor - Integer.numberOfLeadingZeros(allMap);

      var oldDataPassThrough = 0;

      // bitmap of nodes which, when filtered, returned a single-element node. These must be migrated to data
      var nodeMigrateToDataTargetMap = 0;
      // the queue of single-element, post-filter nodes
      Queue<MapNode<K, V>>? nodesToMigrateToData;

      // bitmap of all nodes which, when filtered, returned themselves. They are passed forward to the returned node
      var nodesToPassThroughMap = 0;

      // bitmap of any nodes which, after being filtered, returned a node that is not empty, but also not `eq` itself
      // These are stored for later inclusion into the final `content` array
      // not named `newNodesMap` (plural) to avoid confusion with `newNodeMap` (singular)
      var mapOfNewNodes = 0;
      // each bit in `mapOfNewNodes` corresponds to one element in this queue
      Queue<MapNode<K, V>>? newNodes;

      var newDataMap = 0;
      var newNodeMap = 0;
      var newSize = 0;
      var newCachedHashCode = 0;

      var dataIndex = 0;
      var nodeIndex = 0;

      var i = minimumIndex;

      while (i < maximumIndex) {
        final bitpos = Node.bitposFrom(i);

        if ((bitpos & dataMap) != 0) {
          final payload = getPayload(dataIndex);
          final passed = pred(payload) != flipped;

          if (passed) {
            newDataMap |= bitpos;
            oldDataPassThrough |= bitpos;
            newSize += 1;
            newCachedHashCode += Hashing.improve(getHash(dataIndex));
          }

          dataIndex += 1;
        } else if ((bitpos & nodeMap) != 0) {
          final oldSubNode = getNode(nodeIndex);
          final newSubNode = oldSubNode.filterImpl(pred, flipped);

          newSize += newSubNode.size;
          newCachedHashCode += newSubNode.cachedDartKeySetHashCode;

          // if (newSubNode.size == 0) do nothing (drop it)
          if (newSubNode.size > 1) {
            newNodeMap |= bitpos;
            if (oldSubNode == newSubNode) {
              nodesToPassThroughMap |= bitpos;
            } else {
              mapOfNewNodes |= bitpos;
              newNodes ??= Queue();
              newNodes.add(newSubNode);
            }
          } else if (newSubNode.size == 1) {
            newDataMap |= bitpos;
            nodeMigrateToDataTargetMap |= bitpos;
            nodesToMigrateToData ??= Queue();
            nodesToMigrateToData.add(newSubNode);
          }

          nodeIndex += 1;
        }

        i += 1;
      }

      if (newSize == 0) {
        return MapNode.empty();
      } else if (newSize == size) {
        return this;
      } else {
        final newDataSize = Integer.bitCount(newDataMap);
        final newContentSize =
            (MapNode.TupleLength * newDataSize) + Integer.bitCount(newNodeMap);
        final newContent = Array.ofDim<dynamic>(newContentSize);
        final newOriginalHashes = Array.ofDim<int>(newDataSize);

        final newAllMap = newDataMap | newNodeMap;
        final maxIndex =
            Node.BranchingFactor - Integer.numberOfLeadingZeros(newAllMap);

        // note: We MUST start from the minimum index in the old (`this`) node, otherwise `old{Node,Data}Index` will
        // not be incremented properly. Otherwise we could have started at Integer.numberOfTrailingZeroes(newAllMap)
        var i = minimumIndex;

        var oldDataIndex = 0;
        var oldNodeIndex = 0;

        var newDataIndex = 0;
        var newNodeIndex = 0;

        while (i < maxIndex) {
          final bitpos = Node.bitposFrom(i);

          if ((bitpos & oldDataPassThrough) != 0) {
            newContent[newDataIndex * TupleLength] = getKey(oldDataIndex);
            newContent[newDataIndex * TupleLength + 1] = getValue(oldDataIndex);
            newOriginalHashes[newDataIndex] = getHash(oldDataIndex);
            newDataIndex += 1;
            oldDataIndex += 1;
          } else if ((bitpos & nodesToPassThroughMap) != 0) {
            newContent[newContentSize - newNodeIndex - 1] =
                getNode(oldNodeIndex);
            newNodeIndex += 1;
            oldNodeIndex += 1;
          } else if ((bitpos & nodeMigrateToDataTargetMap) != 0) {
            // we need not check for null here. If nodeMigrateToDataTargetMap != 0, then nodesMigrateToData must not be null
            final node = nodesToMigrateToData!.dequeue();
            newContent[TupleLength * newDataIndex] = node.getKey(0);
            newContent[TupleLength * newDataIndex + 1] = node.getValue(0);
            newOriginalHashes[newDataIndex] = node.getHash(0);
            newDataIndex += 1;
            oldNodeIndex += 1;
          } else if ((bitpos & mapOfNewNodes) != 0) {
            newContent[newContentSize - newNodeIndex - 1] = newNodes!.dequeue();
            newNodeIndex += 1;
            oldNodeIndex += 1;
          } else if ((bitpos & dataMap) != 0) {
            oldDataIndex += 1;
          } else if ((bitpos & nodeMap) != 0) {
            oldNodeIndex += 1;
          }

          i += 1;
        }

        return BitmapIndexedMapNode<K, V>(newDataMap, newNodeMap, newContent,
            newOriginalHashes, newSize, newCachedHashCode);
      }
    }
  }

  @override
  void foreach<U>(Function1<(K, V), U> f) {
    final iN = payloadArity; // arity doesn't change during this operation
    var i = 0;

    while (i < iN) {
      f(getPayload(i));
      i += 1;
    }

    final jN = nodeArity; // arity doesn't change during this operation
    var j = 0;
    while (j < jN) {
      getNode(j).foreach(f);
      j += 1;
    }
  }

  @override
  void foreachEntry<U>(Function2<K, V, U> f) {
    final iN = payloadArity; // arity doesn't change during this operation
    var i = 0;

    while (i < iN) {
      f(getKey(i), getValue(i));
      i += 1;
    }

    final jN = nodeArity; // arity doesn't change during this operation
    var j = 0;

    while (j < jN) {
      getNode(j).foreachEntry(f);
      j += 1;
    }
  }

  @override
  void foreachWithHash(Function3<K, V, int, void> f) {
    final iN = payloadArity; // arity doesn't change during this operation
    var i = 0;

    while (i < iN) {
      f(getKey(i), getValue(i), getHash(i));
      i += 1;
    }

    final jN = nodeArity; // arity doesn't change during this operation
    var j = 0;

    while (j < jN) {
      getNode(j).foreachWithHash(f);
      j += 1;
    }
  }

  @override
  Option<V> get(K key, int originalHash, int keyHash, int shift) {
    final mask = Node.maskFrom(keyHash, shift);
    final bitpos = Node.bitposFrom(mask);

    if ((dataMap & bitpos) != 0) {
      final index = Node.indexFromMask(dataMap, mask, bitpos);
      final key0 = getKey(index);
      if (key == key0) {
        return Some(getValue(index));
      } else {
        return none();
      }
    } else if ((nodeMap & bitpos) != 0) {
      final index = Node.indexFromMask(nodeMap, mask, bitpos);
      return getNode(index)
          .get(key, originalHash, keyHash, shift + Node.BitPartitionSize);
    } else {
      return none();
    }
  }

  @override
  int getHash(int index) => originalHashes[index]!;

  @override
  K getKey(int index) => content[MapNode.TupleLength * index] as K;

  @override
  MapNode<K, V> getNode(int index) =>
      content[content.length - 1 - index] as MapNode<K, V>;

  @override
  V getOrElse(K key, int originalHash, int keyHash, int shift, Function0<V> f) {
    final mask = Node.maskFrom(keyHash, shift);
    final bitpos = Node.bitposFrom(mask);

    if ((dataMap & bitpos) != 0) {
      final index = Node.indexFromMask(dataMap, mask, bitpos);
      final key0 = getKey(index);
      if (key == key0) {
        return getValue(index);
      } else {
        return f();
      }
    } else if ((nodeMap & bitpos) != 0) {
      final index = Node.indexFromMask(nodeMap, mask, bitpos);
      return getNode(index).getOrElse(
          key, originalHash, keyHash, shift + Node.BitPartitionSize, f);
    } else {
      return f();
    }
  }

  @override
  (K, V) getPayload(int index) => (
        content[TupleLength * index] as K,
        content[TupleLength * index + 1] as V,
      );

  @override
  (K, V) getTuple(K key, int originalHash, int hash, int shift) {
    final mask = Node.maskFrom(hash, shift);
    final bitpos = Node.bitposFrom(mask);

    if ((dataMap & bitpos) != 0) {
      final index = Node.indexFromMask(dataMap, mask, bitpos);
      final payload = getPayload(index);
      if (key == payload.$1) {
        return payload;
      } else {
        noSuchKey(key);
      }
    } else if ((nodeMap & bitpos) != 0) {
      final index = Node.indexFromMask(nodeMap, mask, bitpos);
      return getNode(index)
          .getTuple(key, originalHash, hash, shift + Node.BitPartitionSize);
    } else {
      noSuchKey(key);
    }
  }

  @override
  V getValue(int index) => content[TupleLength * index + 1] as V;

  @override
  bool get hasNodes => nodeMap != 0;

  @override
  bool get hasPayload => dataMap != 0;

  @override
  void mergeInto(MapNode<K, V> that, IHashMapBuilder<K, V> builder, int shift,
      Function2<(K, V), (K, V), (K, V)> mergef) {
    if (that is BitmapIndexedMapNode<K, V>) {
      final bm = that;

      if (size == 0) {
        that.buildTo(builder);
        return;
      } else if (bm.size == 0) {
        buildTo(builder);
        return;
      }

      final allMap = dataMap | bm.dataMap | nodeMap | bm.nodeMap;

      final minIndex = Integer.numberOfTrailingZeros(allMap);
      final maxIndex =
          Node.BranchingFactor - Integer.numberOfLeadingZeros(allMap);

      {
        var index = minIndex;
        var leftIdx = 0;
        var rightIdx = 0;

        while (index < maxIndex) {
          final bitpos = Node.bitposFrom(index);

          if ((bitpos & dataMap) != 0) {
            final leftKey = getKey(leftIdx);
            final leftValue = getValue(leftIdx);
            final leftOriginalHash = getHash(leftIdx);

            if ((bitpos & bm.dataMap) != 0) {
              // left data and right data
              final rightKey = bm.getKey(rightIdx);
              final rightValue = bm.getValue(rightIdx);
              final rightOriginalHash = bm.getHash(rightIdx);

              if (leftOriginalHash == rightOriginalHash &&
                  leftKey == rightKey) {
                builder.addOne(
                    mergef((leftKey, leftValue), (rightKey, rightValue)));
              } else {
                builder.addOneWithHash((leftKey, leftValue), leftOriginalHash);
                builder
                    .addOneWithHash((rightKey, rightValue), rightOriginalHash);
              }
              rightIdx += 1;
            } else if ((bitpos & bm.nodeMap) != 0) {
              // left data and right node
              final subNode = bm.getNode(bm.nodeIndex(bitpos));
              final leftImprovedHash = Hashing.improve(leftOriginalHash);
              final removed = subNode.removed(leftKey, leftOriginalHash,
                  leftImprovedHash, shift + Node.BitPartitionSize);

              if (removed == subNode) {
                // no overlap in leftData and rightNode, just build both children to builder
                subNode.buildTo(builder);
                builder.addOneWithHashes(
                    (leftKey, leftValue), leftOriginalHash, leftImprovedHash);
              } else {
                // there is collision, so special treatment for that key
                removed.buildTo(builder);
                builder.addOne(mergef(
                    (leftKey, leftValue),
                    subNode.getTuple(leftKey, leftOriginalHash,
                        leftImprovedHash, shift + Node.BitPartitionSize)));
              }
            } else {
              // left data and nothing on right
              builder.addOneWithHash((leftKey, leftValue), leftOriginalHash);
            }
            leftIdx += 1;
          } else if ((bitpos & nodeMap) != 0) {
            if ((bitpos & bm.dataMap) != 0) {
              // left node and right data
              final rightKey = bm.getKey(rightIdx);
              final rightValue = bm.getValue(rightIdx);
              final rightOriginalHash = bm.getHash(rightIdx);
              final rightImprovedHash = Hashing.improve(rightOriginalHash);

              final subNode = getNode(nodeIndex(bitpos));
              final removed = subNode.removed(rightKey, rightOriginalHash,
                  rightImprovedHash, shift + Node.BitPartitionSize);
              if (removed == subNode) {
                // no overlap in leftNode and rightData, just build both children to builder
                subNode.buildTo(builder);
                builder.addOneWithHashes((rightKey, rightValue),
                    rightOriginalHash, rightImprovedHash);
              } else {
                // there is collision, so special treatment for that key
                removed.buildTo(builder);
                builder.addOne(mergef(
                    subNode.getTuple(rightKey, rightOriginalHash,
                        rightImprovedHash, shift + Node.BitPartitionSize),
                    (rightKey, rightValue)));
              }
              rightIdx += 1;
            } else if ((bitpos & bm.nodeMap) != 0) {
              // left node and right node
              getNode(nodeIndex(bitpos)).mergeInto(
                  bm.getNode(bm.nodeIndex(bitpos)),
                  builder,
                  shift + Node.BitPartitionSize,
                  mergef);
            } else {
              // left node and nothing on right
              getNode(nodeIndex(bitpos)).buildTo(builder);
            }
          } else if ((bitpos & bm.dataMap) != 0) {
            // nothing on left, right data
            final dataIndex = bm.dataIndex(bitpos);
            builder.addOneWithHash(
              (bm.getKey(dataIndex), bm.getValue(dataIndex)),
              bm.getHash(dataIndex),
            );
            rightIdx += 1;
          } else if ((bitpos & bm.nodeMap) != 0) {
            // nothing on left, right node
            bm.getNode(bm.nodeIndex(bitpos)).buildTo(builder);
          }

          index += 1;
        }
      }
    } else {
      throw UnsupportedError(
          'Cannot merge BitmapIndexedMapNode with HashCollisionMapNode');
    }
  }

  @override
  int get nodeArity => Integer.bitCount(nodeMap);

  @override
  int get payloadArity => Integer.bitCount(dataMap);

  @override
  BitmapIndexedMapNode<K, V> removed(
      K key, int originalHash, int keyHash, int shift) {
    final mask = Node.maskFrom(keyHash, shift);
    final bitpos = Node.bitposFrom(mask);

    if ((dataMap & bitpos) != 0) {
      final index = Node.indexFromMask(dataMap, mask, bitpos);
      final key0 = this.getKey(index);

      if (key0 == key) {
        if (this.payloadArity == 2 && this.nodeArity == 0) {
          // Create new node with remaining pair. The new node will a) either become the new root
          // returned, or b) unwrapped and inlined during returning.
          final newDataMap = shift == 0
              ? (dataMap ^ bitpos)
              : Node.bitposFrom(Node.maskFrom(keyHash, 0));

          if (index == 0) {
            return BitmapIndexedMapNode<K, V>(
              newDataMap,
              0,
              arr([getKey(1), getValue(1)]),
              arr([originalHashes[1]]),
              1,
              Hashing.improve(getHash(1)),
            );
          } else {
            return BitmapIndexedMapNode<K, V>(
              newDataMap,
              0,
              arr([getKey(0), getValue(0)]),
              arr([originalHashes[0]]),
              1,
              Hashing.improve(getHash(0)),
            );
          }
        } else {
          return copyAndRemoveValue(bitpos, keyHash);
        }
      } else {
        return this;
      }
    } else if ((nodeMap & bitpos) != 0) {
      final index = Node.indexFromMask(nodeMap, mask, bitpos);
      final subNode = this.getNode(index);

      final subNodeNew = subNode.removed(
          key, originalHash, keyHash, shift + Node.BitPartitionSize);
      //   // assert(subNodeNew.size != 0, "Sub-node must have at least one element.")

      if (subNodeNew == subNode) return this;

      // cache just in case subNodeNew is a hashCollision node, in which in which case a little arithmetic is avoided
      // in Vector#length
      final subNodeNewSize = subNodeNew.size;

      if (subNodeNewSize == 1) {
        if (this.size == subNode.size) {
          // subNode is the only child (no other data or node children of `this` exist)
          // escalate (singleton or empty) result
          return subNodeNew as BitmapIndexedMapNode<K, V>;
        } else {
          // inline value (move to front)
          return copyAndMigrateFromNodeToInline(bitpos, subNode, subNodeNew);
        }
      } else if (subNodeNewSize > 1) {
        // modify current node (set replacement node)
        return copyAndSetNode(bitpos, subNode, subNodeNew);
      } else {
        return this;
      }
    } else {
      return this;
    }
  }

  @override
  MapNode<K, W> transform<W>(Function2<K, V, W> f) {
    Array<dynamic>? newContent;
    final iN = payloadArity; // arity doesn't change during this operation
    final jN = nodeArity; // arity doesn't change during this operation
    final newContentLength = content.length;
    var i = 0;

    while (i < iN) {
      final key = getKey(i);
      final value = getValue(i);
      final newValue = f(key, value);
      if (newContent == null) {
        if (newValue != value) {
          newContent = content.clone();
          newContent[TupleLength * i + 1] = newValue;
        }
      } else {
        newContent[TupleLength * i + 1] = newValue;
      }
      i += 1;
    }

    var j = 0;
    while (j < jN) {
      final node = getNode(j);
      final newNode = node.transform(f);

      if (newContent == null) {
        if (newNode != node) {
          newContent = content.clone();
          newContent[newContentLength - j - 1] = newNode;
        }
      } else {
        newContent[newContentLength - j - 1] = newNode;
      }
      j += 1;
    }

    if (newContent == null) {
      return this as BitmapIndexedMapNode<K, W>;
    } else {
      return BitmapIndexedMapNode<K, W>(dataMap, nodeMap, newContent,
          originalHashes, size, cachedDartKeySetHashCode);
    }
  }

  @override
  BitmapIndexedMapNode<K, V> updated(K key, V value, int originalHash,
      int keyHash, int shift, bool replaceValue) {
    final mask = Node.maskFrom(keyHash, shift);
    final bitpos = Node.bitposFrom(mask);

    if ((dataMap & bitpos) != 0) {
      final index = Node.indexFromMask(dataMap, mask, bitpos);
      final key0 = getKey(index);
      final key0UnimprovedHash = getHash(index);

      if (key0UnimprovedHash == originalHash && key0 == key) {
        if (replaceValue) {
          final value0 = this.getValue(index);
          if ((key0 == key) && (value0 == value)) {
            return this;
          } else {
            return copyAndSetValue(bitpos, key, value);
          }
        } else {
          return this;
        }
      } else {
        final value0 = this.getValue(index);
        final key0Hash = Hashing.improve(key0UnimprovedHash);
        final subNodeNew = mergeTwoKeyValPairs(
            key0,
            value0,
            key0UnimprovedHash,
            key0Hash,
            key,
            value,
            originalHash,
            keyHash,
            shift + Node.BitPartitionSize);

        return copyAndMigrateFromInlineToNode(bitpos, key0Hash, subNodeNew);
      }
    } else if ((nodeMap & bitpos) != 0) {
      final index = Node.indexFromMask(nodeMap, mask, bitpos);
      final subNode = getNode(index);
      final subNodeNew = subNode.updated(key, value, originalHash, keyHash,
          shift + Node.BitPartitionSize, replaceValue);

      if (subNodeNew == subNode) {
        return this;
      } else {
        return copyAndSetNode(bitpos, subNode, subNodeNew);
      }
    } else {
      return copyAndInsertValue(bitpos, key, originalHash, keyHash, value);
    }
  }

  @override
  bool operator ==(Object that) => switch (that) {
        final BitmapIndexedMapNode<K, V> node => identical(this, node) ||
            ((this.cachedDartKeySetHashCode == node.cachedDartKeySetHashCode) &&
                (this.nodeMap == node.nodeMap) &&
                (this.dataMap == node.dataMap) &&
                (this.size == node.size) &&
                Array.equals(this.originalHashes, node.originalHashes) &&
                _deepContentEquality(
                    this.content, node.content, content.length)),
        _ => false,
      };

  bool _deepContentEquality(Array<dynamic> a1, Array<dynamic> a2, int length) {
    if (identical(a1, a2)) {
      return true;
    } else {
      var isEqual = true;
      var i = 0;

      while (isEqual && i < length) {
        isEqual = a1[i] == a2[i];
        i += 1;
      }

      return isEqual;
    }
  }

  @override
  int get hashCode =>
      throw UnimplementedError('Trie nodes do not support hashing');

  int dataIndex(int bitpos) => Integer.bitCount(dataMap & (bitpos - 1));

  int nodeIndex(int bitpos) => Integer.bitCount(nodeMap & (bitpos - 1));

  Never noSuchKey(K key) => throw UnsupportedError('Key not found: $key');

  // ///////////////////////////////////////////////////////////////////////////

  BitmapIndexedMapNode<K, V> copyAndSetValue(int bitpos, K newKey, V newValue) {
    final dataIx = dataIndex(bitpos);
    final idx = TupleLength * dataIx;

    final src = content;
    final dst = Array.ofDim<dynamic>(src.length);

    // copy 'src' and set 1 element(s) at position 'idx'
    Array.arraycopy(src, 0, dst, 0, src.length);
    dst[idx + 1] = newValue;
    return BitmapIndexedMapNode<K, V>(
        dataMap, nodeMap, dst, originalHashes, size, cachedDartKeySetHashCode);
  }

  BitmapIndexedMapNode<K, V> copyAndSetNode(
      int bitpos, MapNode<K, V> oldNode, MapNode<K, V> newNode) {
    final idx = content.length - 1 - nodeIndex(bitpos);

    final src = content;
    final dst = Array.ofDim<dynamic>(src.length);

    // copy 'src' and set 1 element(s) at position 'idx'
    Array.arraycopy(src, 0, dst, 0, src.length);
    dst[idx] = newNode;

    return BitmapIndexedMapNode<K, V>(
        dataMap,
        nodeMap,
        dst,
        originalHashes,
        size - oldNode.size + newNode.size,
        cachedDartKeySetHashCode -
            oldNode.cachedDartKeySetHashCode +
            newNode.cachedDartKeySetHashCode);
  }

  BitmapIndexedMapNode<K, V> copyAndInsertValue(
      int bitpos, K key, int originalHash, int keyHash, V value) {
    final dataIx = dataIndex(bitpos);
    final idx = TupleLength * dataIx;

    final src = content;
    final dst = Array.ofDim<dynamic>(src.length + TupleLength);

    // copy 'src' and insert 2 element(s) at position 'idx'
    Array.arraycopy(src, 0, dst, 0, idx);
    dst[idx] = key;
    dst[idx + 1] = value;
    Array.arraycopy(src, idx, dst, idx + TupleLength, src.length - idx);

    final dstHashes = insertElement(originalHashes, dataIx, originalHash);

    return BitmapIndexedMapNode<K, V>(dataMap | bitpos, nodeMap, dst, dstHashes,
        size + 1, cachedDartKeySetHashCode + keyHash);
  }

  BitmapIndexedMapNode<K, V> copyAndRemoveValue(int bitpos, int keyHash) {
    final dataIx = dataIndex(bitpos);
    final idx = TupleLength * dataIx;

    final src = content;
    final dst = Array.ofDim<dynamic>(src.length - TupleLength);

    // copy 'src' and remove 2 element(s) at position 'idx'
    Array.arraycopy(src, 0, dst, 0, idx);
    Array.arraycopy(
        src, idx + TupleLength, dst, idx, src.length - idx - TupleLength);

    final dstHashes = removeElement(originalHashes, dataIx);

    return BitmapIndexedMapNode<K, V>(dataMap ^ bitpos, nodeMap, dst, dstHashes,
        size - 1, cachedDartKeySetHashCode - keyHash);
  }

  /// Variant of `copyAndMigrateFromInlineToNode` which mutates `this` rather than returning a new node.
  ///
  /// @param bitpos the bit position of the data to migrate to node
  /// @param keyHash the improved hash of the key currently at `bitpos`
  /// @param node the node to place at `bitpos` beneath `this`
  BitmapIndexedMapNode<K, V> migrateFromInlineToNodeInPlace(
      int bitpos, int keyHash, MapNode<K, V> node) {
    final dataIx = dataIndex(bitpos);
    final idxOld = TupleLength * dataIx;
    final idxNew = this.content.length - TupleLength - nodeIndex(bitpos);

    final src = this.content;
    final dst = Array.ofDim<dynamic>(src.length - TupleLength + 1);

    // copy 'src' and remove 2 element(s) at position 'idxOld' and
    // insert 1 element(s) at position 'idxNew'
    // assert(idxOld <= idxNew)
    Array.arraycopy(src, 0, dst, 0, idxOld);
    Array.arraycopy(src, idxOld + TupleLength, dst, idxOld, idxNew - idxOld);
    dst[idxNew] = node;
    Array.arraycopy(src, idxNew + TupleLength, dst, idxNew + 1,
        src.length - idxNew - TupleLength);

    final dstHashes = removeElement(originalHashes, dataIx);

    this.dataMap = dataMap ^ bitpos;
    this.nodeMap = nodeMap | bitpos;
    this.content = dst;
    this.originalHashes = dstHashes;
    this.size = size - 1 + node.size;
    this.cachedDartKeySetHashCode =
        cachedDartKeySetHashCode - keyHash + node.cachedDartKeySetHashCode;

    return this;
  }

  BitmapIndexedMapNode<K, V> copyAndMigrateFromInlineToNode(
      int bitpos, int keyHash, MapNode<K, V> node) {
    final dataIx = dataIndex(bitpos);
    final idxOld = TupleLength * dataIx;
    final idxNew = content.length - TupleLength - nodeIndex(bitpos);

    final src = content;
    final dst = Array.ofDim<dynamic>(src.length - TupleLength + 1);

    // copy 'src' and remove 2 element(s) at position 'idxOld' and
    // insert 1 element(s) at position 'idxNew'
    // assert(idxOld <= idxNew)
    Array.arraycopy(src, 0, dst, 0, idxOld);
    Array.arraycopy(src, idxOld + TupleLength, dst, idxOld, idxNew - idxOld);
    dst[idxNew] = node;
    Array.arraycopy(src, idxNew + TupleLength, dst, idxNew + 1,
        src.length - idxNew - TupleLength);

    final dstHashes = removeElement(originalHashes, dataIx);

    return BitmapIndexedMapNode<K, V>(
        dataMap = dataMap ^ bitpos,
        nodeMap = nodeMap | bitpos,
        content = dst,
        originalHashes = dstHashes,
        size = size - 1 + node.size,
        cachedDartKeySetHashCode =
            cachedDartKeySetHashCode - keyHash + node.cachedDartKeySetHashCode);
  }

  BitmapIndexedMapNode<K, V> copyAndMigrateFromNodeToInline(
      int bitpos, MapNode<K, V> oldNode, MapNode<K, V> node) {
    final idxOld = content.length - 1 - nodeIndex(bitpos);
    final dataIxNew = dataIndex(bitpos);
    final idxNew = TupleLength * dataIxNew;

    final key = node.getKey(0);
    final value = node.getValue(0);
    final src = this.content;
    final dst = Array.ofDim<dynamic>(src.length - 1 + TupleLength);

    // copy 'src' and remove 1 element(s) at position 'idxOld' and
    // insert 2 element(s) at position 'idxNew'
    // assert(idxOld >= idxNew)
    Array.arraycopy(src, 0, dst, 0, idxNew);
    dst[idxNew] = key;
    dst[idxNew + 1] = value;
    Array.arraycopy(src, idxNew, dst, idxNew + TupleLength, idxOld - idxNew);
    Array.arraycopy(
        src, idxOld + 1, dst, idxOld + TupleLength, src.length - idxOld - 1);

    final hash = node.getHash(0);
    final dstHashes = insertElement(originalHashes, dataIxNew, hash);

    return BitmapIndexedMapNode<K, V>(
        dataMap = dataMap | bitpos,
        nodeMap = nodeMap ^ bitpos,
        content = dst,
        originalHashes = dstHashes,
        size = size - oldNode.size + 1,
        cachedDartKeySetHashCode = cachedDartKeySetHashCode -
            oldNode.cachedDartKeySetHashCode +
            node.cachedDartKeySetHashCode);
  }

  MapNode<K, V> mergeTwoKeyValPairs(
      K key0,
      V value0,
      int originalHash0,
      int keyHash0,
      K key1,
      V value1,
      int originalHash1,
      int keyHash1,
      int shift) {
    // assert(key0 != key1)

    if (shift >= Node.HashCodeLength) {
      return HashCollisionMapNode<K, V>(
          originalHash0, keyHash0, ivec([(key0, value0), (key1, value1)]));
    } else {
      final mask0 = Node.maskFrom(keyHash0, shift);
      final mask1 = Node.maskFrom(keyHash1, shift);
      final newCachedHash = keyHash0 + keyHash1;

      if (mask0 != mask1) {
        // unique prefixes, payload fits on same level
        final dataMap = Node.bitposFrom(mask0) | Node.bitposFrom(mask1);

        if (mask0 < mask1) {
          return BitmapIndexedMapNode<K, V>(
              dataMap,
              0,
              arr([key0, value0, key1, value1]),
              arr([originalHash0, originalHash1]),
              2,
              newCachedHash);
        } else {
          return BitmapIndexedMapNode<K, V>(
              dataMap,
              0,
              arr([key1, value1, key0, value0]),
              arr([originalHash1, originalHash0]),
              2,
              newCachedHash);
        }
      } else {
        // identical prefixes, payload must be disambiguated deeper in the trie
        final nodeMap = Node.bitposFrom(mask0);
        final node = mergeTwoKeyValPairs(
            key0,
            value0,
            originalHash0,
            keyHash0,
            key1,
            value1,
            originalHash1,
            keyHash1,
            shift + Node.BitPartitionSize);

        return BitmapIndexedMapNode<K, V>(0, nodeMap, arr([node]),
            Array.empty(), node.size, node.cachedDartKeySetHashCode);
      }
    }
  }
}

final class HashCollisionMapNode<K, V> extends MapNode<K, V> {
  final int originalHash;
  final int hash;
  IVector<(K, V)> content;

  HashCollisionMapNode(this.originalHash, this.hash, this.content);

  @override
  V apply(K key, int originalHash, int hash, int shift) =>
      get(key, originalHash, hash, shift)
          .getOrElse(() => RIterator.empty<V>().next());

  @override
  void buildTo(IHashMapBuilder<K, V> builder) {
    final iter = content.iterator;
    while (iter.hasNext) {
      final (k, v) = iter.next();
      builder.addOneWithHashes((k, v), originalHash, hash);
    }
  }

  @override
  int get cachedDartKeySetHashCode => size * hash;

  @override
  MapNode<K, V> concat(MapNode<K, V> that, int shift) {
    if (that is HashCollisionMapNode<K, V>) {
      final hc = that;

      if (hc == this) {
        return this;
      } else {
        IVectorBuilder<(K, V)>? newContent;
        final iter = content.iterator;

        while (iter.hasNext) {
          final nextPayload = iter.next();

          if (hc.indexOf(nextPayload.$1) < 0) {
            newContent ??= IVectorBuilder();
            newContent.addAll(hc.content);
            newContent.addOne(nextPayload);
          }
        }
        if (newContent == null) {
          return hc;
        } else {
          return HashCollisionMapNode(originalHash, hash, newContent.result());
        }
      }
    } else {
      throw UnsupportedError(
          'Cannot concatenate a HashCollisionMapNode with a BitmapIndexedMapNode');
    }
  }

  @override
  bool containsKey(K key, int originalHash, int hash, int shift) =>
      this.hash == hash && indexOf(key) >= 0;

  @override
  HashCollisionMapNode<K, V> copy() =>
      HashCollisionMapNode(originalHash, hash, content);

  @override
  MapNode<K, V> filterImpl(Function1<(K, V), bool> pred, bool flipped) {
    final newContent = flipped ? content.filterNot(pred) : content.filter(pred);

    final newContentLength = newContent.length;

    if (newContentLength == 0) {
      return MapNode.empty();
    } else if (newContentLength == 1) {
      final (k, v) = newContent.head;
      return BitmapIndexedMapNode<K, V>(Node.bitposFrom(Node.maskFrom(hash, 0)),
          0, arr([k, v]), arr([originalHash]), 1, hash);
    } else if (newContentLength == content.length) {
      return this;
    } else {
      return HashCollisionMapNode(originalHash, hash, newContent);
    }
  }

  @override
  void foreach<U>(Function1<(K, V), U> f) => content.foreach(f);

  @override
  void foreachEntry<U>(Function2<K, V, U> f) =>
      content.foreach((kv) => f(kv.$1, kv.$2));

  @override
  void foreachWithHash(Function3<K, V, int, void> f) {
    final iter = content.iterator;
    while (iter.hasNext) {
      final (k, v) = iter.next();
      f(k, v, originalHash);
    }
  }

  @override
  Option<V> get(K key, int originalHash, int hash, int shift) {
    if (this.hash == hash) {
      final index = indexOf(key);
      if (index >= 0) {
        return Some(content[index].$2);
      } else {
        return none();
      }
    } else {
      return none();
    }
  }

  @override
  int getHash(int index) => originalHash;

  @override
  K getKey(int index) => getPayload(index).$1;

  @override
  MapNode<K, V> getNode(int index) =>
      throw RangeError('No sub-nodes present in hash-collicion leaf node.');

  @override
  V getOrElse(K key, int originalHash, int hash, int shift, Function0<V> f) {
    if (this.hash == hash) {
      return switch (indexOf(key)) {
        final x when x == -1 => f(),
        final other => content[other].$2,
      };
    } else {
      return f();
    }
  }

  @override
  (K, V) getPayload(int index) => content[index];

  @override
  (K, V) getTuple(K key, int originalHash, int hash, int shift) {
    final index = indexOf(key);
    if (index >= 0) {
      return content[index];
    } else {
      return RIterator.empty<(K, V)>().next();
    }
  }

  @override
  V getValue(int index) => getPayload(index).$2;

  @override
  bool get hasNodes => false;

  @override
  bool get hasPayload => true;

  @override
  void mergeInto(
    MapNode<K, V> that,
    IHashMapBuilder<K, V> builder,
    int shift,
    Function2<(K, V), (K, V), (K, V)> mergef,
  ) {
    if (that is HashCollisionMapNode<K, V>) {
      final hc = that;

      final iter = content.iterator;
      final rightArray = Array.from(hc.content); // really Array[(K, V1)]

      int rightIndexOf(K key) {
        var i = 0;
        while (i < rightArray.length) {
          final elem = rightArray[i];
          if ((elem != null) && elem.$1 == key) return i;
          i += 1;
        }
        return -1;
      }

      while (iter.hasNext) {
        final nextPayload = iter.next();
        final index = rightIndexOf(nextPayload.$1);

        if (index == -1) {
          builder.addOne(nextPayload);
        } else {
          final rightPayload = rightArray[index];
          rightArray[index] = null;

          builder.addOne(mergef(nextPayload, rightPayload!));
        }
      }

      var i = 0;
      while (i < rightArray.length) {
        final elem = rightArray[i];
        if (elem != null) builder.addOne(elem);
        i += 1;
      }
    } else {
      throw UnsupportedError(
          'Cannot merge HashCollisionMapNode with BitmapIndexedMapNode');
    }
  }

  @override
  int get nodeArity => 0;

  @override
  int get payloadArity => content.length;

  @override
  MapNode<K, V> removed(K key, int originalHash, int hash, int shift) {
    if (!this.containsKey(key, originalHash, hash, shift)) {
      return this;
    } else {
      final updatedContent =
          content.filterNot((keyValuePair) => keyValuePair.$1 == key);
      // assert(updatedContent.size == content.size - 1)

      if (updatedContent.size == 1) {
        final (k, v) = updatedContent[0];
        return BitmapIndexedMapNode<K, V>(
          Node.bitposFrom(Node.maskFrom(hash, 0)),
          0,
          arr([k, v]),
          arr([originalHash]),
          1,
          hash,
        );
      } else {
        return HashCollisionMapNode<K, V>(originalHash, hash, updatedContent);
      }
    }
  }

  @override
  int get size => content.length;

  @override
  MapNode<K, W> transform<W>(Function2<K, V, W> f) {
    final newContent = IVector.builder<(K, W)>();
    final contentIter = content.iterator;

    // true if any values have been transformed to a different value via `f`
    var anyChanges = false;

    while (contentIter.hasNext) {
      final (k, v) = contentIter.next();
      final newValue = f(k, v);
      newContent.addOne((k, newValue));
      anyChanges |= (v != newValue);
    }

    if (anyChanges) {
      return HashCollisionMapNode(originalHash, hash, newContent.result());
    } else {
      return this as HashCollisionMapNode<K, W>;
    }
  }

  @override
  MapNode<K, V> updated(K key, V value, int originalHash, int hash, int shift,
      bool replaceValue) {
    final index = indexOf(key);

    if (index >= 0) {
      if (replaceValue) {
        if (content[index].$2 == value) {
          return this;
        } else {
          return HashCollisionMapNode<K, V>(
              originalHash, hash, content.updated(index, (key, value)));
        }
      } else {
        return this;
      }
    } else {
      return HashCollisionMapNode<K, V>(
          originalHash, hash, content.appended((key, value)));
    }
  }

  @override
  bool operator ==(Object that) => switch (that) {
        final HashCollisionMapNode<K, V> node => identical(this, node) ||
            (this.hash == node.hash) &&
                (this.content.length == node.content.length) &&
                _contentEqual(node),
        _ => false,
      };

  bool _contentEqual(HashCollisionMapNode<K, V> node) {
    final iter = content.iterator;
    while (iter.hasNext) {
      final (key, value) = iter.next();
      final index = node.indexOf(key);
      if (index < 0 || value != node.content[index].$2) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode =>
      throw UnimplementedError('Trie nodes do not support hashing');

  int indexOf(dynamic key) {
    final iter = content.iterator;
    var i = 0;
    while (iter.hasNext) {
      if (iter.next().$1 == key) return i;
      i += 1;
    }

    return -1;
  }
}

extension<A> on Queue<A> {
  A dequeue() => removeFirst();
}
