import 'package:ribs_core/ribs_core.dart';

/// A persistent priority queue implemented as a binomial heap.
///
/// A binomial heap is a forest of binomial trees that satisfies the
/// *heap-ordering* property: every node's value is less than or equal to the
/// values of its children (according to the provided [Order]).
///
/// This structure supports efficient insertion and minimum-extraction:
///
/// | Operation   | Time Complexity  |
/// |-------------|------------------|
/// | [insert]    | O(log n)         |
/// | [take]      | O(log n)         |
/// | [tryTake]   | O(log n)         |
///
/// Used as the backing data structure for [PQueue].
final class BinomialHeap<A> {
  /// The forest of [BinomialTree]s comprising this heap, ordered by
  /// increasing rank.
  final IList<BinomialTree<A>> trees;

  /// The [Order] used to compare elements for heap ordering.
  final Order<A> order;

  const BinomialHeap(this.trees, this.order);

  /// Creates an empty [BinomialHeap] with the given [order].
  static BinomialHeap<A> empty<A>(Order<A> order) => BinomialHeap(nil(), order);

  /// Returns `true` if this heap contains at least one element.
  bool get nonEmpty => trees.nonEmpty;

  /// Inserts a [BinomialTree] into this heap, merging trees of equal rank
  /// to maintain the binomial heap invariant.
  BinomialHeap<A> insertTree(BinomialTree<A> tree) =>
      BinomialHeap(_insertTreeImpl(tree, trees), order);

  /// Returns a new heap with [a] inserted.
  BinomialHeap<A> insert(A a) => insertTree(BinomialTree(0, a, nil(), order));

  /// Removes and returns the minimum element according to [order].
  ///
  /// Throws a [StateError] if the heap is empty.
  (BinomialHeap<A>, A) take() {
    final (ts, head) = _takeImpl(trees, order);
    return (BinomialHeap(ts, order), head.getOrElse(() => throw Exception('Empty Heap')));
  }

  /// Attempts to remove and return the minimum element.
  ///
  /// Returns a tuple of the resulting heap and an [Option] containing the
  /// removed element, or [None] if the heap is empty.
  (BinomialHeap<A>, Option<A>) tryTake() {
    final (ts, head) = _takeImpl(trees, order);
    return (BinomialHeap(ts, order), head);
  }

  /// Inserts [tree] into [trees], linking trees of equal rank to preserve
  /// the uniqueness of ranks within the forest.
  static IList<BinomialTree<A>> _insertTreeImpl<A>(
    BinomialTree<A> tree,
    IList<BinomialTree<A>> trees,
  ) => trees.headOption.fold(
    () => ilist([tree]),
    (hd) =>
        tree.rank < hd.rank ? trees.prepended(tree) : _insertTreeImpl(tree.link(hd), trees.tail),
  );

  /// Merges two sorted forests of binomial trees into a single sorted forest,
  /// linking trees of equal rank as necessary.
  static IList<BinomialTree<A>> _merge<A>(
    IList<BinomialTree<A>> lhs,
    IList<BinomialTree<A>> rhs,
  ) {
    if (lhs.isEmpty) {
      return rhs;
    } else if (rhs.isEmpty) {
      return lhs;
    } else {
      final t1 = lhs[0];
      final ts1 = lhs.tail;
      final t2 = rhs[0];
      final ts2 = rhs.tail;

      if (t1.rank < t2.rank) {
        return _merge(ts1, rhs).prepended(t1);
      } else if (t1.rank > t2.rank) {
        return _merge(lhs, ts2).prepended(t2);
      } else {
        return _insertTreeImpl(t1.link(t2), _merge(ts1, ts2));
      }
    }
  }

  /// Finds and removes the tree with the minimum root value from [trees].
  ///
  /// Returns the remaining forest (with the minimum tree's children merged
  /// back in) and an [Option] containing the minimum value.
  static (IList<BinomialTree<A>>, Option<A>) _takeImpl<A>(
    IList<BinomialTree<A>> trees,
    Order<A> order,
  ) {
    (BinomialTree<A>, IList<BinomialTree<A>>) min(
      IList<BinomialTree<A>> trees,
    ) {
      return trees.uncons((hdtl) {
        return hdtl.foldN(
          () => throw StateError('BinomialHead.take: empty trees'),
          (t, ts) {
            if (ts.isEmpty) {
              return (t, nil());
            } else {
              final (t1, ts1) = min(ts);
              if (order.lteqv(t.value, t1.value)) {
                return (t, ts);
              } else {
                return (t1, ts1.prepended(t));
              }
            }
          },
        );
      });
    }

    if (trees.isEmpty) {
      return (nil(), none());
    } else {
      final (t, ts) = min(trees);
      return (_merge(t.children.reverse(), ts), Some(t.value));
    }
  }
}

/// A single tree within a [BinomialHeap].
///
/// A binomial tree of rank *k* has exactly 2^k nodes. It is formed by
/// linking two trees of rank *k-1*, making one the leftmost child of the
/// other. The heap-ordering property (parent ≤ children according to
/// [order]) is maintained by [link].
final class BinomialTree<A> {
  /// The rank of this tree (a tree of rank *k* has 2^k nodes).
  final int rank;

  /// The root value of this tree, which is the minimum among all nodes
  /// (according to [order]).
  final A value;

  /// The children of this tree, stored in decreasing order of rank.
  final IList<BinomialTree<A>> children;

  /// The [Order] used to compare elements for heap ordering.
  final Order<A> order;

  const BinomialTree(this.rank, this.value, this.children, this.order);

  /// Links this tree with [other] (both must have the same [rank]).
  ///
  /// The tree with the smaller root becomes the parent, preserving
  /// the heap-ordering property. The resulting tree has rank `rank + 1`.
  BinomialTree<A> link(BinomialTree<A> other) {
    if (order.lteqv(value, other.value)) {
      return BinomialTree(rank + 1, value, children.prepended(other), order);
    } else {
      return BinomialTree(rank + 1, other.value, other.children.prepended(this), order);
    }
  }
}
