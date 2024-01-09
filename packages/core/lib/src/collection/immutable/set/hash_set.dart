part of '../iset.dart';

final class IHashSet<A> with IterableOnce<A>, RibsIterable<A>, ISet<A> {
  final BitmapIndexedSetNode<A> _rootNode;

  IHashSet._(this._rootNode);

  static IHashSet<A> empty<A>() => IHashSet._(SetNode.empty());

  @override
  IHashSet<A> concat(covariant IterableOnce<A> that) {
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
          var shallowlyMutableNodeMap =
              Node.bitposFrom(Node.maskFrom(improved, 0));

          while (iter.hasNext) {
            final element = iter.next();
            final originalHash = element.hashCode;
            final improved = Hashing.improve(originalHash);
            shallowlyMutableNodeMap = current.updateWithShallowMutations(
                element, originalHash, improved, 0, shallowlyMutableNodeMap);
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
  ISet<A> excl(A elem) {
    final elementUnimprovedHash = elem.hashCode;
    final elementHash = Hashing.improve(elementUnimprovedHash);
    final newRootNode =
        _rootNode.removed(elem, elementUnimprovedHash, elementHash, 0);
    return _newHashSetOrThis(newRootNode);
  }

  @override
  ISet<A> incl(A elem) {
    final elementUnimprovedHash = elem.hashCode;
    final elementHash = Hashing.improve(elementUnimprovedHash);
    final newRootNode =
        _rootNode.updated(elem, elementUnimprovedHash, elementHash, 0);
    return _newHashSetOrThis(newRootNode);
  }

  @override
  bool get isEmpty => _rootNode.size == 0;

  @override
  RibsIterator<A> get iterator =>
      isEmpty ? RibsIterator.empty() : _SetIterator(_rootNode);

  @override
  int get knownSize => _rootNode.size;

  @override
  int get size => _rootNode.size;

  @override
  bool operator ==(Object that) => switch (that) {
        final IHashSet<A> thatSet => _rootNode.subsetOf(thatSet._rootNode, 0),
        _ => super == that,
      };

  @override
  int get hashCode => MurmurHash3.unorderedHash(
      _SetHashIterator(_rootNode), MurmurHash3.setSeed);

  IHashSet<A> _newHashSetOrThis(BitmapIndexedSetNode<A> newRootNode) =>
      _rootNode == newRootNode ? this : IHashSet._(newRootNode);
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
