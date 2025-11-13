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

import 'dart:collection';

import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/collection/hashing.dart';
import 'package:ribs_core/src/collection/immutable/set/champ_common.dart';

@internal
sealed class SetNode<A> extends Node<SetNode<A>> {
  static const TupleLength = 1;

  static BitmapIndexedSetNode<A> empty<A>() =>
      BitmapIndexedSetNode(0, 0, Array.empty(), Array.empty(), 0, 0);

  SetNode<A> concat(SetNode<A> that, int shift);

  bool contains(A element, int originalHash, int hash, int shift);

  SetNode<A> copy();

  SetNode<A> diff(SetNode<A> that, int shift);

  SetNode<A> filterImpl(Function1<A, bool> pred, bool flipped);

  void foreach<U>(Function1<A, U> f);

  void foreachWithHash(Function2<A, int, void> f);

  bool foreachWithHashWhile(Function2<A, int, bool> f);

  @override
  SetNode<A> getNode(int index);

  SetNode<A> removed(A element, int originalHash, int hash, int shift);

  int get size;

  bool subsetOf(SetNode<A> that, int shift);

  SetNode<A> updated(A element, int originalHash, int hash, int shift);
}

@internal
final class BitmapIndexedSetNode<A> extends SetNode<A> {
  int dataMap;
  int nodeMap;
  Array<dynamic> content;
  Array<int> originalHashes;
  @override
  int size;
  @override
  int cachedDartKeySetHashCode;

  BitmapIndexedSetNode(
    this.dataMap,
    this.nodeMap,
    this.content,
    this.originalHashes,
    this.size,
    this.cachedDartKeySetHashCode,
  );

  @override
  BitmapIndexedSetNode<A> concat(SetNode<A> that, int shift) {
    if (that is BitmapIndexedSetNode<A>) {
      final bm = that;

      if (size == 0) {
        return bm;
      } else if (bm.size == 0 || (bm == this)) {
        return this;
      } else if (bm.size == 1) {
        final originalHash = bm.getHash(0);
        return updated(bm.getPayload(0), originalHash,
            Hashing.improve(originalHash), shift);
      }

      // if we go through the merge and the result does not differ from `this`, we can just return `this`, to improve sharing
      // So, `anyChangesMadeSoFar` will be set to `true` as soon as we encounter a difference between the
      // currently-being-computed result, and `this`
      var anyChangesMadeSoFar = false;

      // bitmap containing `1` in any position that has any descendant in either left or right, either data or node
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
      var leftDataRightDataLeftOverwrites = 0;

      var dataToNodeMigrationTargets = 0;

      {
        var bitpos = minimumBitPos;
        var leftIdx = 0;
        var rightIdx = 0;
        var finished = false;

        while (!finished) {
          if ((bitpos & dataMap) != 0) {
            if ((bitpos & bm.dataMap) != 0) {
              if (getHash(leftIdx) == bm.getHash(rightIdx) &&
                  getPayload(leftIdx) == bm.getPayload(rightIdx)) {
                leftDataRightDataLeftOverwrites |= bitpos;
              } else {
                leftDataRightDataMigrateToNode |= bitpos;
                dataToNodeMigrationTargets |= Node.bitposFrom(
                    Node.maskFrom(Hashing.improve(getHash(leftIdx)), shift));
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
          leftDataOnly | rightDataOnly | leftDataRightDataLeftOverwrites;

      final newNodeMap = leftNodeRightNode |
          leftDataRightNode |
          leftNodeRightData |
          leftNodeOnly |
          rightNodeOnly |
          dataToNodeMigrationTargets;

      if ((newDataMap == (leftDataOnly | leftDataRightDataLeftOverwrites)) &&
          (newNodeMap == leftNodeOnly)) {
        // nothing from `bm` will make it into the result -- return early
        return this;
      }

      final newDataSize = Integer.bitCount(newDataMap);
      final newContentSize = newDataSize + Integer.bitCount(newNodeMap);

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
            final leftNode = getNode(leftNodeIdx);
            final newNode =
                leftNode.concat(bm.getNode(rightNodeIdx), nextShift);
            if (leftNode != newNode) {
              anyChangesMadeSoFar = true;
            }
            newContent[newContentSize - compressedNodeIdx - 1] = newNode;
            compressedNodeIdx += 1;
            rightNodeIdx += 1;
            leftNodeIdx += 1;
            newSize += newNode.size;
            newCachedHashCode += newNode.cachedDartKeySetHashCode;
          } else if ((bitpos & leftDataRightNode) != 0) {
            anyChangesMadeSoFar = true;

            final n = bm.getNode(rightNodeIdx);
            final leftPayload = getPayload(leftDataIdx);
            final leftOriginalHash = getHash(leftDataIdx);
            final leftImproved = Hashing.improve(leftOriginalHash);
            final newNode = n.updated(
                leftPayload, leftOriginalHash, leftImproved, nextShift);

            newContent[newContentSize - compressedNodeIdx - 1] = newNode;
            compressedNodeIdx += 1;
            rightNodeIdx += 1;
            leftDataIdx += 1;
            newSize += newNode.size;
            newCachedHashCode += newNode.cachedDartKeySetHashCode;
          } else if ((bitpos & leftNodeRightData) != 0) {
            final rightOriginalHash = bm.getHash(rightDataIdx);
            final leftNode = getNode(leftNodeIdx);
            final updated = leftNode.updated(
                bm.getPayload(rightDataIdx),
                bm.getHash(rightDataIdx),
                Hashing.improve(rightOriginalHash),
                nextShift);
            if (updated != leftNode) {
              anyChangesMadeSoFar = true;
            }
            final newNode = updated;

            newContent[newContentSize - compressedNodeIdx - 1] = newNode;
            compressedNodeIdx += 1;
            leftNodeIdx += 1;
            rightDataIdx += 1;
            newSize += newNode.size;
            newCachedHashCode += newNode.cachedDartKeySetHashCode;
          } else if ((bitpos & leftDataOnly) != 0) {
            final originalHash = originalHashes[leftDataIdx];
            newContent[compressedDataIdx] = getPayload(leftDataIdx);
            newOriginalHashes[compressedDataIdx] = originalHash;

            compressedDataIdx += 1;
            leftDataIdx += 1;
            newSize += 1;
            newCachedHashCode += Hashing.improve(originalHash!);
          } else if ((bitpos & rightDataOnly) != 0) {
            anyChangesMadeSoFar = true;
            final originalHash = bm.originalHashes[rightDataIdx];
            newContent[compressedDataIdx] = bm.getPayload(rightDataIdx);
            newOriginalHashes[compressedDataIdx] = originalHash;

            compressedDataIdx += 1;
            rightDataIdx += 1;
            newSize += 1;
            newCachedHashCode += Hashing.improve(originalHash!);
          } else if ((bitpos & leftNodeOnly) != 0) {
            final newNode = getNode(leftNodeIdx);
            newContent[newContentSize - compressedNodeIdx - 1] = newNode;
            compressedNodeIdx += 1;
            leftNodeIdx += 1;
            newSize += newNode.size;
            newCachedHashCode += newNode.cachedDartKeySetHashCode;
          } else if ((bitpos & rightNodeOnly) != 0) {
            anyChangesMadeSoFar = true;
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
              getPayload(leftDataIdx),
              leftOriginalHash,
              Hashing.improve(leftOriginalHash),
              bm.getPayload(rightDataIdx),
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
          } else if ((bitpos & leftDataRightDataLeftOverwrites) != 0) {
            final originalHash = bm.originalHashes[rightDataIdx];
            newContent[compressedDataIdx] = bm.getPayload(rightDataIdx);
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
        return BitmapIndexedSetNode(
          dataMap = newDataMap,
          nodeMap = newNodeMap,
          content = newContent,
          originalHashes = newOriginalHashes,
          size = newSize,
          cachedDartKeySetHashCode = newCachedHashCode,
        );
      } else {
        return this;
      }
    } else {
      throw UnsupportedError(
          'Cannot concatenate a HashCollisionSetNode with a BitmapIndexedSetNode');
    }
  }

  @override
  bool contains(A element, int originalHash, int elementHash, int shift) {
    final mask = Node.maskFrom(elementHash, shift);
    final bitpos = Node.bitposFrom(mask);

    if ((dataMap & bitpos) != 0) {
      final index = Node.indexFromMask(dataMap, mask, bitpos);
      return originalHashes[index] == originalHash &&
          element == getPayload(index);
    }

    if ((nodeMap & bitpos) != 0) {
      final index = Node.indexFromMask(nodeMap, mask, bitpos);
      return getNode(index).contains(
          element, originalHash, elementHash, shift + Node.BitPartitionSize);
    }

    return false;
  }

  @override
  BitmapIndexedSetNode<A> copy() {
    final contentClone = content.clone();
    final contentLength = contentClone.length;
    var i = Integer.bitCount(dataMap);

    while (i < contentLength) {
      contentClone[i] = (contentClone[i]! as SetNode<A>).copy();
      i += 1;
    }

    return BitmapIndexedSetNode(dataMap, nodeMap, contentClone,
        originalHashes.clone(), size, cachedDartKeySetHashCode);
  }

  @override
  BitmapIndexedSetNode<A> diff(SetNode<A> that, int shift) {
    if (that is BitmapIndexedSetNode<A>) {
      final bm = that;

      if (size == 0) {
        return this;
      } else if (size == 1) {
        final h = getHash(0);
        if (that.contains(getPayload(0), h, Hashing.improve(h), shift)) {
          return SetNode.empty();
        } else {
          return this;
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
        Queue<SetNode<A>>? nodesToMigrateToData;

        // bitmap of all nodes which, when filtered, returned themselves. They are passed forward to the returned node
        var nodesToPassThroughMap = 0;

        // bitmap of any nodes which, after being filtered, returned a node that is not empty, but also not `eq` itself
        // These are stored for later inclusion into the final `content` array
        // not named `newNodesMap` (plural) to avoid confusion with `newNodeMap` (singular)
        var mapOfNewNodes = 0;
        // each bit in `mapOfNewNodes` corresponds to one element in this queue
        Queue<SetNode<A>>? newNodes;

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
            final originalHash = getHash(dataIndex);
            final hash = Hashing.improve(originalHash);

            if (!bm.contains(payload, originalHash, hash, shift)) {
              newDataMap |= bitpos;
              oldDataPassThrough |= bitpos;
              newSize += 1;
              newCachedHashCode += hash;
            }

            dataIndex += 1;
          } else if ((bitpos & nodeMap) != 0) {
            final oldSubNode = getNode(nodeIndex);

            final SetNode<A> newSubNode;

            //     val newSubNode: SetNode[A] =
            if ((bitpos & bm.dataMap) != 0) {
              final thatDataIndex = Node.indexFrom(bm.dataMap, bitpos);
              final thatPayload = bm.getPayload(thatDataIndex);
              final thatOriginalHash = bm.getHash(thatDataIndex);
              final thatHash = Hashing.improve(thatOriginalHash);
              newSubNode = oldSubNode.removed(thatPayload, thatOriginalHash,
                  thatHash, shift + Node.BitPartitionSize);
            } else if ((bitpos & bm.nodeMap) != 0) {
              newSubNode = oldSubNode.diff(
                  bm.getNode(Node.indexFrom(bm.nodeMap, bitpos)),
                  shift + Node.BitPartitionSize);
            } else {
              newSubNode = oldSubNode;
            }

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

        return newNodeFrom(
          newSize,
          newDataMap,
          newNodeMap,
          minimumIndex,
          oldDataPassThrough,
          nodesToPassThroughMap,
          nodeMigrateToDataTargetMap,
          nodesToMigrateToData,
          mapOfNewNodes,
          newNodes,
          newCachedHashCode,
        );
      }
    } else {
      throw UnsupportedError('BitmapIndexedSetNode diff HashCollisionSetNode');
    }
  }

  @override
  BitmapIndexedSetNode<A> filterImpl(Function1<A, bool> pred, bool flipped) {
    if (size == 0) {
      return this;
    } else if (size == 1) {
      if (pred(getPayload(0)) != flipped) {
        return this;
      } else {
        return SetNode.empty();
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
      final minimumIndex = Integer.numberOfTrailingZeros(dataMap);
      final maximumIndex =
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
        return SetNode.empty();
      } else if (newDataMap == dataMap) {
        return this;
      } else {
        final newSize = Integer.bitCount(newDataMap);
        final newContent = Array.ofDim<dynamic>(newSize);
        final newOriginalHashCodes = Array.ofDim<int>(newSize);
        final newMaximumIndex =
            Node.BranchingFactor - Integer.numberOfLeadingZeros(newDataMap);

        var j = Integer.numberOfTrailingZeros(newDataMap);

        var newDataIndex = 0;

        while (j < newMaximumIndex) {
          final bitpos = Node.bitposFrom(j);
          if ((bitpos & newDataMap) != 0) {
            final oldIndex = Node.indexFrom(dataMap, bitpos);
            newContent[newDataIndex] = content[oldIndex];
            newOriginalHashCodes[newDataIndex] = originalHashes[oldIndex];
            newDataIndex += 1;
          }
          j += 1;
        }

        return BitmapIndexedSetNode(newDataMap, 0, newContent,
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

      // TODO: When filtering results in a single-elem node, simply `(A, originalHash, improvedHash)` could be returned,
      //  rather than a singleton node (to avoid pointlessly allocating arrays, nodes, which would just be inlined in
      //  the parent anyways). This would probably involve changing the return type of filterImpl to `AnyRef` which may
      //  return at runtime a SetNode[A], or a tuple of (A, Int, Int)

      //   // the queue of single-element, post-filter nodes
      // TODO: Switch to Ribs Queue when it's built
      Queue<SetNode<A>>? nodesToMigrateToData;

      //   // bitmap of all nodes which, when filtered, returned themselves. They are passed forward to the returned node
      var nodesToPassThroughMap = 0;

      // bitmap of any nodes which, after being filtered, returned a node that is not empty, but also not `eq` itself
      // These are stored for later inclusion into the final `content` array
      // not named `newNodesMap` (plural) to avoid confusion with `newNodeMap` (singular)
      var mapOfNewNodes = 0;
      // each bit in `mapOfNewNodes` corresponds to one element in this queue
      Queue<SetNode<A>>? newNodes;

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
              newNodes ??= Queue<SetNode<A>>();
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

      return newNodeFrom(
        newSize,
        newDataMap,
        newNodeMap,
        minimumIndex,
        oldDataPassThrough,
        nodesToPassThroughMap,
        nodeMigrateToDataTargetMap,
        nodesToMigrateToData,
        mapOfNewNodes,
        newNodes,
        newCachedHashCode,
      );
    }
  }

  @override
  void foreach<U>(Function1<A, U> f) {
    final thisPayloadArity = payloadArity;
    var i = 0;
    while (i < thisPayloadArity) {
      f(getPayload(i));
      i += 1;
    }

    final thisNodeArity = nodeArity;
    var j = 0;

    while (j < thisNodeArity) {
      getNode(j).foreach(f);
      j += 1;
    }
  }

  @override
  void foreachWithHash(Function2<A, int, void> f) {
    final iN = payloadArity; // arity doesn't change during this operation
    var i = 0;

    while (i < iN) {
      f(getPayload(i), getHash(i));
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
  bool foreachWithHashWhile(Function2<A, int, bool> f) {
    final thisPayloadArity = payloadArity;
    var pass = true;
    var i = 0;

    while (i < thisPayloadArity && pass) {
      pass = pass && f(getPayload(i), getHash(i));
      i += 1;
    }

    final thisNodeArity = nodeArity;
    var j = 0;

    while (j < thisNodeArity && pass) {
      pass = pass && getNode(j).foreachWithHashWhile(f);
      j += 1;
    }

    return pass;
  }

  @override
  int getHash(int index) => originalHashes[index]!;

  @override
  SetNode<A> getNode(int index) =>
      content[content.length - 1 - index]! as SetNode<A>;

  @override
  A getPayload(int index) => content[index] as A;

  @override
  bool get hasNodes => nodeMap != 0;

  @override
  bool get hasPayload => dataMap != 0;

  @override
  int get nodeArity => Integer.bitCount(nodeMap);

  @override
  int get payloadArity => Integer.bitCount(dataMap);

  @override
  BitmapIndexedSetNode<A> removed(
      A element, int originalHash, int elementHash, int shift) {
    final mask = Node.maskFrom(elementHash, shift);
    final bitpos = Node.bitposFrom(mask);

    if ((dataMap & bitpos) != 0) {
      final index = Node.indexFromMask(dataMap, mask, bitpos);
      final element0 = getPayload(index);

      if (element0 == element) {
        if (payloadArity == 2 && nodeArity == 0) {
          // Create new node with remaining pair. The new node will a) either become the new root
          // returned, or b) unwrapped and inlined during returning.
          final newDataMap = shift == 0
              ? (dataMap ^ bitpos)
              : Node.bitposFrom(Node.maskFrom(elementHash, 0));
          if (index == 0) {
            return BitmapIndexedSetNode(
                newDataMap,
                0,
                arr([getPayload(1)]),
                arr([originalHashes[1]]),
                size - 1,
                Hashing.improve(originalHashes[1]!));
          } else {
            return BitmapIndexedSetNode(
                newDataMap,
                0,
                arr([getPayload(0)]),
                arr([originalHashes[0]]),
                size - 1,
                Hashing.improve(originalHashes[0]!));
          }
        } else {
          return copyAndRemoveValue(bitpos, elementHash);
        }
      } else {
        return this;
      }
    }

    if ((nodeMap & bitpos) != 0) {
      final index = Node.indexFromMask(nodeMap, mask, bitpos);
      final subNode = getNode(index);

      final subNodeNew = subNode.removed(
          element, originalHash, elementHash, shift + Node.BitPartitionSize);

      if (subNodeNew == subNode) return this;

      // cache just in case subNodeNew is a hashCollision node, in which in
      // which case a little arithmetic is avoided in Vector#length
      final subNodeNewSize = subNodeNew.size;

      if (subNodeNewSize == 1) {
        if (size == subNode.size) {
          // subNode is the only child (no other data or node children of `this` exist)
          // escalate (singleton or empty) result
          return subNodeNew as BitmapIndexedSetNode<A>;
        } else {
          // inline value (move to front)
          return copyAndMigrateFromNodeToInline(
              bitpos, elementHash, subNode, subNodeNew);
        }
      } else if (subNodeNewSize > 1) {
        // modify current node (set replacement node)
        return copyAndSetNode(bitpos, subNode, subNodeNew);
      }
    }

    return this;
  }

  @override
  bool subsetOf(SetNode<A> that, int shift) {
    if (this == that) {
      return true;
    } else {
      if (that is BitmapIndexedSetNode<A>) {
        final node = that;

        final thisBitmap = dataMap | nodeMap;
        final nodeBitmap = node.dataMap | node.nodeMap;

        if ((thisBitmap | nodeBitmap) != nodeBitmap) return false;

        var bitmap = thisBitmap & nodeBitmap;
        var bitsToSkip = Integer.numberOfTrailingZeros(bitmap);

        var isValidSubset = true;

        while (isValidSubset && bitsToSkip < Node.HashCodeLength) {
          final bitpos = Node.bitposFrom(bitsToSkip);

          if ((dataMap & bitpos) != 0) {
            if ((node.dataMap & bitpos) != 0) {
              // Data x Data
              final payload0 = getPayload(Node.indexFrom(dataMap, bitpos));
              final payload1 =
                  node.getPayload(Node.indexFrom(node.dataMap, bitpos));
              isValidSubset = payload0 == payload1;
            } else {
              // Data x Node
              final thisDataIndex = Node.indexFrom(dataMap, bitpos);
              final payload = getPayload(thisDataIndex);
              final subNode =
                  that.getNode(Node.indexFrom(node.nodeMap, bitpos));
              final elementUnimprovedHash = getHash(thisDataIndex);
              final elementHash = Hashing.improve(elementUnimprovedHash);
              isValidSubset = subNode.contains(payload, elementUnimprovedHash,
                  elementHash, shift + Node.BitPartitionSize);
            }
          } else {
            // Node x Node
            final subNode0 = getNode(Node.indexFrom(nodeMap, bitpos));
            final subNode1 = node.getNode(Node.indexFrom(node.nodeMap, bitpos));
            isValidSubset =
                subNode0.subsetOf(subNode1, shift + Node.BitPartitionSize);
          }

          final newBitmap = bitmap ^ bitpos;
          bitmap = newBitmap;
          bitsToSkip = Integer.numberOfTrailingZeros(newBitmap);
        }

        return isValidSubset;
      } else {
        return false;
      }
    }
  }

  @override
  BitmapIndexedSetNode<A> updated(
      A element, int originalHash, int elementHash, int shift) {
    final mask = Node.maskFrom(elementHash, shift);
    final bitpos = Node.bitposFrom(mask);

    if (dataMap & bitpos != 0) {
      final index = Node.indexFromMask(dataMap, mask, bitpos);
      final element0 = getPayload(index);

      if (element0 == element) {
        return this;
      } else {
        final element0UnimprovedHash = getHash(index);
        final element0Hash = Hashing.improve(element0UnimprovedHash);
        if (originalHash == element0UnimprovedHash && element0 == element) {
          return this;
        } else {
          final subNodeNew = mergeTwoKeyValPairs(
              element0,
              element0UnimprovedHash,
              element0Hash,
              element,
              originalHash,
              elementHash,
              shift + Node.BitPartitionSize);
          return copyAndMigrateFromInlineToNode(
              bitpos, element0Hash, subNodeNew);
        }
      }
    }

    if ((nodeMap & bitpos) != 0) {
      final index = Node.indexFromMask(nodeMap, mask, bitpos);
      final subNode = getNode(index);

      final subNodeNew = subNode.updated(
          element, originalHash, elementHash, shift + Node.BitPartitionSize);
      if (subNode == subNodeNew) {
        return this;
      } else {
        return copyAndSetNode(bitpos, subNode, subNodeNew);
      }
    }

    return copyAndInsertValue(bitpos, element, originalHash, elementHash);
  }

  @override
  bool operator ==(Object that) => switch (that) {
        final BitmapIndexedSetNode<A> node => identical(this, node) ||
            ((cachedDartKeySetHashCode == node.cachedDartKeySetHashCode) &&
                (nodeMap == node.nodeMap) &&
                (dataMap == node.dataMap) &&
                (size == node.size) &&
                Array.equals(originalHashes, node.originalHashes) &&
                _deepContentEquality(content, node.content, content.length)),
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

  SetNode<A> mergeTwoKeyValPairs(A key0, int originalKeyHash0, int keyHash0,
      A key1, int originalKeyHash1, int keyHash1, int shift) {
    if (shift >= Node.HashCodeLength) {
      return HashCollisionSetNode(
          originalKeyHash0, keyHash0, ivec([key0, key1]));
    } else {
      final mask0 = Node.maskFrom(keyHash0, shift);
      final mask1 = Node.maskFrom(keyHash1, shift);

      if (mask0 != mask1) {
        // unique prefixes, payload fits on same level
        final dataMap = Node.bitposFrom(mask0) | Node.bitposFrom(mask1);
        final newCachedHashCode = keyHash0 + keyHash1;

        if (mask0 < mask1) {
          return BitmapIndexedSetNode(dataMap, 0, arr([key0, key1]),
              arr([originalKeyHash0, originalKeyHash1]), 2, newCachedHashCode);
        } else {
          return BitmapIndexedSetNode(dataMap, 0, arr([key1, key0]),
              arr([originalKeyHash1, originalKeyHash0]), 2, newCachedHashCode);
        }
      } else {
        // identical prefixes, payload must be disambiguated deeper in the trie
        final nodeMap = Node.bitposFrom(mask0);
        final node = mergeTwoKeyValPairs(key0, originalKeyHash0, keyHash0, key1,
            originalKeyHash1, keyHash1, shift + Node.BitPartitionSize);

        return BitmapIndexedSetNode(0, nodeMap, arr([node]), Array.empty<int>(),
            node.size, node.cachedDartKeySetHashCode);
      }
    }
  }

  BitmapIndexedSetNode<A> copyAndSetNode(
      int bitpos, SetNode<A> oldNode, SetNode<A> newNode) {
    final idx = content.length - 1 - nodeIndex(bitpos);

    final src = content;
    final dst = Array.ofDim<dynamic>(src.length);

    // copy 'src' and set 1 element(s) at position 'idx'
    Array.arraycopy(src, 0, dst, 0, src.length);
    dst[idx] = newNode;

    return BitmapIndexedSetNode(
        dataMap,
        nodeMap,
        content = dst,
        originalHashes,
        size = size - oldNode.size + newNode.size,
        cachedDartKeySetHashCode -
            oldNode.cachedDartKeySetHashCode +
            newNode.cachedDartKeySetHashCode);
  }

  BitmapIndexedSetNode<A> copyAndInsertValue(
      int bitpos, A key, int originalHash, int elementHash) {
    final dataIx = dataIndex(bitpos);
    final idx = SetNode.TupleLength * dataIx;

    final src = content;
    final dst = Array.ofDim<dynamic>(src.length + 1);

    // copy 'src' and insert 1 element(s) at position 'idx'
    Array.arraycopy(src, 0, dst, 0, idx);
    dst[idx] = key;
    Array.arraycopy(src, idx, dst, idx + 1, src.length - idx);
    final dstHashes = insertElement(originalHashes, dataIx, originalHash);

    return BitmapIndexedSetNode<A>(dataMap | bitpos, nodeMap, dst, dstHashes,
        size + 1, cachedDartKeySetHashCode + elementHash);
  }

  BitmapIndexedSetNode<A> copyAndSetValue(
      int bitpos, A key, int originalHash, int elementHash) {
    final dataIx = dataIndex(bitpos);
    final idx = SetNode.TupleLength * dataIx;

    final src = content;
    final dst = Array.ofDim<dynamic>(src.length);

    // copy 'src' and set 1 element(s) at position 'idx'
    Array.arraycopy(src, 0, dst, 0, src.length);
    dst[idx] = key;

    return BitmapIndexedSetNode(dataMap | bitpos, nodeMap, dst, originalHashes,
        size, cachedDartKeySetHashCode);
  }

  BitmapIndexedSetNode<A> copyAndRemoveValue(int bitpos, int elementHash) {
    final dataIx = dataIndex(bitpos);
    final idx = SetNode.TupleLength * dataIx;

    final src = content;
    final dst = Array.ofDim<dynamic>(src.length - 1);

    // copy 'src' and remove 1 element(s) at position 'idx'
    Array.arraycopy(src, 0, dst, 0, idx);
    Array.arraycopy(src, idx + 1, dst, idx, src.length - idx - 1);

    final dstHashes = removeElement(originalHashes, dataIx);

    return BitmapIndexedSetNode(dataMap ^ bitpos, nodeMap, dst, dstHashes,
        size - 1, cachedDartKeySetHashCode - elementHash);
  }

  BitmapIndexedSetNode<A> copyAndMigrateFromInlineToNode(
      int bitpos, int elementHash, SetNode<A> node) {
    final dataIx = dataIndex(bitpos);
    final idxOld = SetNode.TupleLength * dataIx;
    final idxNew = content.length - SetNode.TupleLength - nodeIndex(bitpos);

    final src = content;
    final dst = Array.ofDim<dynamic>(src.length - 1 + 1);

    // copy 'src' and remove 1 element(s) at position 'idxOld' and
    // insert 1 element(s) at position 'idxNew'
    // assert(idxOld <= idxNew)
    Array.arraycopy(src, 0, dst, 0, idxOld);
    Array.arraycopy(src, idxOld + 1, dst, idxOld, idxNew - idxOld);
    dst[idxNew] = node;
    Array.arraycopy(src, idxNew + 1, dst, idxNew + 1, src.length - idxNew - 1);
    final dstHashes = removeElement(originalHashes, dataIx);

    return BitmapIndexedSetNode(
      dataMap = dataMap ^ bitpos,
      nodeMap = nodeMap | bitpos,
      content = dst,
      originalHashes = dstHashes,
      size = size - 1 + node.size,
      cachedDartKeySetHashCode - elementHash + node.cachedDartKeySetHashCode,
    );
  }

  BitmapIndexedSetNode<A> migrateFromInlineToNodeInPlace(
      int bitpos, int keyHash, SetNode<A> node) {
    final dataIx = dataIndex(bitpos);
    final idxOld = SetNode.TupleLength * dataIx;
    final idxNew = content.length - SetNode.TupleLength - nodeIndex(bitpos);

    Array.arraycopy(content, idxOld + SetNode.TupleLength, content, idxOld,
        idxNew - idxOld);
    content[idxNew] = node;

    dataMap = dataMap ^ bitpos;
    nodeMap = nodeMap | bitpos;
    originalHashes = removeElement(originalHashes, dataIx);
    size = size - 1 + node.size;
    cachedDartKeySetHashCode =
        cachedDartKeySetHashCode - keyHash + node.cachedDartKeySetHashCode;

    return this;
  }

  BitmapIndexedSetNode<A> copyAndMigrateFromNodeToInline(
      int bitpos, int elementHash, SetNode<A> oldNode, SetNode<A> node) {
    final idxOld = content.length - 1 - nodeIndex(bitpos);
    final dataIxNew = dataIndex(bitpos);
    final idxNew = SetNode.TupleLength * dataIxNew;

    final src = content;
    final dst = Array.ofDim<dynamic>(src.length - 1 + 1);

    // copy 'src' and remove 1 element(s) at position 'idxOld' and
    // insert 1 element(s) at position 'idxNew'
    // assert(idxOld >= idxNew)
    Array.arraycopy(src, 0, dst, 0, idxNew);
    dst[idxNew] = node.getPayload(0);
    Array.arraycopy(src, idxNew, dst, idxNew + 1, idxOld - idxNew);
    Array.arraycopy(src, idxOld + 1, dst, idxOld + 1, src.length - idxOld - 1);

    final hash = node.getHash(0);
    final dstHashes = insertElement(originalHashes, dataIxNew, hash);

    return BitmapIndexedSetNode(
        dataMap = dataMap | bitpos,
        nodeMap = nodeMap ^ bitpos,
        content = dst,
        originalHashes = dstHashes,
        size = size - oldNode.size + 1,
        cachedDartKeySetHashCode -
            oldNode.cachedDartKeySetHashCode +
            node.cachedDartKeySetHashCode);
  }

  void migrateFromNodeToInlineInPlace(int bitpos, int originalHash,
      int elementHash, SetNode<A> oldNode, SetNode<A> node) {
    final idxOld = content.length - 1 - nodeIndex(bitpos);
    final dataIxNew = dataIndex(bitpos);
    final element = node.getPayload(0);
    Array.arraycopy(
        content, dataIxNew, content, dataIxNew + 1, idxOld - dataIxNew);
    content[dataIxNew] = element;
    final hash = node.getHash(0);
    final dstHashes = insertElement(originalHashes, dataIxNew, hash);

    dataMap = dataMap | bitpos;
    nodeMap = nodeMap ^ bitpos;
    originalHashes = dstHashes;
    size = size - oldNode.size + 1;
    cachedDartKeySetHashCode = cachedDartKeySetHashCode -
        oldNode.cachedDartKeySetHashCode +
        node.cachedDartKeySetHashCode;
  }

  BitmapIndexedSetNode<A> removeWithShallowMutations(
      A element, int originalHash, int elementHash) {
    final mask = Node.maskFrom(elementHash, 0);
    final bitpos = Node.bitposFrom(mask);

    if ((dataMap & bitpos) != 0) {
      final index = Node.indexFromMask(dataMap, mask, bitpos);
      final element0 = getPayload(index);

      if (element0 == element) {
        if (payloadArity == 2 && nodeArity == 0) {
          final newDataMap = dataMap ^ bitpos;

          if (index == 0) {
            final newContent = arr([getPayload(1)]);
            final newOriginalHashes = arr([originalHashes[1]]);
            final newCachedDartKeySetHashCode = Hashing.improve(getHash(1));
            content = newContent;
            originalHashes = newOriginalHashes;
            cachedDartKeySetHashCode = newCachedDartKeySetHashCode;
          } else {
            final newContent = arr([getPayload(0)]);
            final newOriginalHashes = arr([originalHashes[0]]);
            final newCachedDartKeySetHashCode = Hashing.improve(getHash(0));
            content = newContent;
            originalHashes = newOriginalHashes;
            cachedDartKeySetHashCode = newCachedDartKeySetHashCode;
          }
          dataMap = newDataMap;
          nodeMap = 0;
          size = 1;

          return this;
        } else {
          final dataIx = dataIndex(bitpos);
          final idx = SetNode.TupleLength * dataIx;

          final src = content;
          final dst = Array.ofDim<dynamic>(src.length - SetNode.TupleLength);

          Array.arraycopy(src, 0, dst, 0, idx);
          Array.arraycopy(src, idx + SetNode.TupleLength, dst, idx,
              src.length - idx - SetNode.TupleLength);

          final dstHashes = removeElement(originalHashes, dataIx);

          dataMap = dataMap ^ bitpos;
          content = dst;
          originalHashes = dstHashes;
          size -= 1;
          cachedDartKeySetHashCode -= elementHash;

          return this;
        }
      } else {
        return this;
      }
    } else if ((nodeMap & bitpos) != 0) {
      final index = Node.indexFromMask(nodeMap, mask, bitpos);
      final subNode = getNode(index);

      final subNodeNew = subNode.removed(
              element, originalHash, elementHash, Node.BitPartitionSize)
          as BitmapIndexedSetNode<A>;

      if (subNodeNew == subNode) return this;

      if (subNodeNew.size == 1) {
        if (payloadArity == 0 && nodeArity == 1) {
          dataMap = subNodeNew.dataMap;
          nodeMap = subNodeNew.nodeMap;
          content = subNodeNew.content;
          originalHashes = subNodeNew.originalHashes;
          size = subNodeNew.size;
          cachedDartKeySetHashCode = subNodeNew.cachedDartKeySetHashCode;

          return this;
        } else {
          migrateFromNodeToInlineInPlace(
              bitpos, originalHash, elementHash, subNode, subNodeNew);
          return this;
        }
      } else {
        // size must be > 1
        content[content.length - 1 - nodeIndex(bitpos)] = subNodeNew;
        size -= 1;
        cachedDartKeySetHashCode = cachedDartKeySetHashCode -
            subNode.cachedDartKeySetHashCode +
            subNodeNew.cachedDartKeySetHashCode;
        return this;
      }
    } else {
      return this;
    }
  }

  int updateWithShallowMutations(A element, int originalHash, int elementHash,
      int shift, int shallowlyMutableNodeMap) {
    final mask = Node.maskFrom(elementHash, shift);
    final bitpos = Node.bitposFrom(mask);

    if ((dataMap & bitpos) != 0) {
      final index = Node.indexFromMask(dataMap, mask, bitpos);
      final element0 = getPayload(index);
      final element0UnimprovedHash = getHash(index);
      if (element0UnimprovedHash == originalHash && element0 == element) {
        return shallowlyMutableNodeMap;
      } else {
        final element0Hash = Hashing.improve(element0UnimprovedHash);
        final subNodeNew = mergeTwoKeyValPairs(
            element0,
            element0UnimprovedHash,
            element0Hash,
            element,
            originalHash,
            elementHash,
            shift + Node.BitPartitionSize);
        migrateFromInlineToNodeInPlace(bitpos, element0Hash, subNodeNew);
        return shallowlyMutableNodeMap | bitpos;
      }
    } else if ((nodeMap & bitpos) != 0) {
      final index = Node.indexFromMask(nodeMap, mask, bitpos);
      final subNode = getNode(index);
      final subNodeSize = subNode.size;
      final subNodeCachedDartKeySetHashCode = subNode.cachedDartKeySetHashCode;

      var returnNodeMap = shallowlyMutableNodeMap;

      final SetNode<A> subNodeNew;

      if (subNode is BitmapIndexedSetNode<A> &&
          (bitpos & shallowlyMutableNodeMap) != 0) {
        subNode.updateWithShallowMutations(element, originalHash, elementHash,
            shift + Node.BitPartitionSize, 0);
        subNodeNew = subNode;
      } else {
        final newNode = subNode.updated(
            element, originalHash, elementHash, shift + Node.BitPartitionSize);
        if (newNode != subNode) {
          returnNodeMap |= bitpos;
        }
        subNodeNew = newNode;
      }

      content[content.length - 1 - nodeIndex(bitpos)] = subNodeNew;
      size = size - subNodeSize + subNodeNew.size;
      cachedDartKeySetHashCode = cachedDartKeySetHashCode -
          subNodeCachedDartKeySetHashCode +
          subNodeNew.cachedDartKeySetHashCode;
      return returnNodeMap;
    } else {
      final dataIx = dataIndex(bitpos);
      final idx = dataIx;

      final src = content;
      final dst = Array.ofDim<dynamic>(src.length + SetNode.TupleLength);

      // copy 'src' and insert 2 element(s) at position 'idx'
      Array.arraycopy(src, 0, dst, 0, idx);
      dst[idx] = element;
      Array.arraycopy(
          src, idx, dst, idx + SetNode.TupleLength, src.length - idx);

      final dstHashes = insertElement(originalHashes, dataIx, originalHash);

      dataMap |= bitpos;
      content = dst;
      originalHashes = dstHashes;
      size += 1;
      cachedDartKeySetHashCode += elementHash;

      return shallowlyMutableNodeMap;
    }
  }

  BitmapIndexedSetNode<A> newNodeFrom(
    int newSize,
    int newDataMap,
    int newNodeMap,
    int minimumIndex,
    int oldDataPassThrough,
    int nodesToPassThroughMap,
    int nodeMigrateToDataTargetMap,
    Queue<SetNode<A>>? nodesToMigrateToData,
    int mapOfNewNodes,
    Queue<SetNode<A>>? newNodes,
    int newCachedHashCode,
  ) {
    if (newSize == 0) {
      return SetNode.empty();
    } else if (newSize == size) {
      return this;
    } else {
      final newDataSize = Integer.bitCount(newDataMap);
      final newContentSize = newDataSize + Integer.bitCount(newNodeMap);
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
          newContent[newDataIndex] = getPayload(oldDataIndex);
          newOriginalHashes[newDataIndex] = getHash(oldDataIndex);
          newDataIndex += 1;
          oldDataIndex += 1;
        } else if ((bitpos & nodesToPassThroughMap) != 0) {
          newContent[newContentSize - newNodeIndex - 1] = getNode(oldNodeIndex);
          newNodeIndex += 1;
          oldNodeIndex += 1;
        } else if ((bitpos & nodeMigrateToDataTargetMap) != 0) {
          // we need not check for null here. If nodeMigrateToDataTargetMap != 0, then nodesMigrateToData must not be null
          final node = nodesToMigrateToData!.dequeue();
          newContent[newDataIndex] = node.getPayload(0);
          newOriginalHashes[newDataIndex] = node.getHash(0);
          newDataIndex += 1;
          oldNodeIndex += 1;
        } else if ((bitpos & mapOfNewNodes) != 0) {
          // we need not check for null here. If mapOfNewNodes != 0, then newNodes must not be null
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

      return BitmapIndexedSetNode(newDataMap, newNodeMap, newContent,
          newOriginalHashes, newSize, newCachedHashCode);
    }
  }
}

final class HashCollisionSetNode<A> extends SetNode<A> {
  final int originalHash;
  final int hash;
  IVector<A> content;

  HashCollisionSetNode(this.originalHash, this.hash, this.content);

  @override
  int get cachedDartKeySetHashCode => size * hash;

  @override
  SetNode<A> concat(SetNode<A> that, int shift) {
    if (that is HashCollisionSetNode<A>) {
      if (that == this) {
        return this;
      } else {
        IVectorBuilder<A>? newContent;
        final iter = that.content.iterator;

        while (iter.hasNext) {
          final nextPayload = iter.next();
          if (!content.contains(nextPayload)) {
            if (newContent == null) {
              newContent = IVectorBuilder();
              newContent.addAll(content);
            }

            newContent.addOne(nextPayload);
          }
        }

        if (newContent == null) {
          return this;
        } else {
          return HashCollisionSetNode(originalHash, hash, newContent.result());
        }
      }
    } else {
      throw UnsupportedError(
          'Cannot concatenate a HashCollisionSetNode with a BitmapIndexedSetNode');
    }
  }

  @override
  bool contains(A element, int originalHash, int hash, int shift) =>
      this.hash == hash && content.contains(element);

  @override
  HashCollisionSetNode<A> copy() =>
      HashCollisionSetNode(originalHash, hash, content);

  @override
  SetNode<A> diff(SetNode<A> that, int shift) =>
      filterImpl((a) => that.contains(a, originalHash, hash, shift), true);

  @override
  SetNode<A> filterImpl(Function1<A, bool> pred, bool flipped) {
    final newContent = flipped ? content.filterNot(pred) : content.filter(pred);

    final newContentLength = newContent.length;

    if (newContentLength == 0) {
      return SetNode.empty();
    } else if (newContentLength == 1) {
      return BitmapIndexedSetNode(Node.bitposFrom(Node.maskFrom(hash, 0)), 0,
          arr([newContent.head]), arr([originalHash]), 1, hash);
    } else if (newContent.length == content.length) {
      return this;
    } else {
      return HashCollisionSetNode(originalHash, hash, newContent);
    }
  }

  @override
  void foreach<U>(Function1<A, U> f) {
    final it = content.iterator;
    while (it.hasNext) {
      f(it.next());
    }
  }

  @override
  void foreachWithHash(Function2<A, int, void> f) {
    final iter = content.iterator;
    while (iter.hasNext) {
      f(iter.next(), originalHash);
    }
  }

  @override
  bool foreachWithHashWhile(Function2<A, int, bool> f) {
    var stillGoing = true;
    final iter = content.iterator;

    while (iter.hasNext && stillGoing) {
      final next = iter.next();
      stillGoing = stillGoing && f(next, originalHash);
    }

    return stillGoing;
  }

  @override
  int getHash(int index) => originalHash;

  @override
  SetNode<A> getNode(int index) =>
      throw RangeError('No sub-nodes present in hash collision leaf node.');

  @override
  A getPayload(int index) => content[index];

  @override
  bool get hasNodes => false;

  @override
  bool get hasPayload => true;

  @override
  int get nodeArity => 0;

  @override
  int get payloadArity => content.length;

  @override
  SetNode<A> removed(A element, int originalHash, int hash, int shift) {
    if (!contains(element, originalHash, hash, shift)) {
      return this;
    } else {
      final updatedContent =
          content.filterNot((element0) => element0 == element);

      return switch (updatedContent.size) {
        1 => BitmapIndexedSetNode<A>(Node.bitposFrom(Node.maskFrom(hash, 0)), 0,
            arr([updatedContent[0]]), arr([originalHash]), 1, hash),
        _ => HashCollisionSetNode(originalHash, hash, updatedContent),
      };
    }
  }

  @override
  int get size => content.length;

  @override
  bool subsetOf(SetNode<A> that, int shift) {
    if (this == that) {
      return true;
    } else {
      return switch (that) {
        final HashCollisionSetNode<A> node =>
          payloadArity <= node.payloadArity &&
              content.forall(node.content.contains),
        _ => false,
      };
    }
  }

  @override
  SetNode<A> updated(A element, int originalHash, int hash, int shift) {
    if (contains(element, originalHash, hash, shift)) {
      return this;
    } else {
      return HashCollisionSetNode(
          originalHash, hash, content.appended(element));
    }
  }
}

extension<A> on Queue<A> {
  A dequeue() => removeFirst();
}
