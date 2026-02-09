import 'package:ribs_core/ribs_core.dart';

final class BinomialHeap<A> {
  final IList<BinomialTree<A>> trees;

  final Order<A> order;

  const BinomialHeap(this.trees, this.order);

  static BinomialHeap<A> empty<A>(Order<A> order) => BinomialHeap(nil(), order);

  bool get nonEmpty => trees.nonEmpty;

  BinomialHeap<A> insertTree(BinomialTree<A> tree) =>
      BinomialHeap(_insertTreeImpl(tree, trees), order);

  BinomialHeap<A> insert(A a) => insertTree(BinomialTree(0, a, nil(), order));

  (BinomialHeap<A>, A) take() {
    final (ts, head) = _takeImpl(trees, order);
    return (BinomialHeap(ts, order), head.getOrElse(() => throw Exception('Empty Heap')));
  }

  (BinomialHeap<A>, Option<A>) tryTake() {
    final (ts, head) = _takeImpl(trees, order);
    return (BinomialHeap(ts, order), head);
  }

  static IList<BinomialTree<A>> _insertTreeImpl<A>(
    BinomialTree<A> tree,
    IList<BinomialTree<A>> trees,
  ) =>
      trees.headOption.fold(
        () => ilist([tree]),
        (hd) => tree.rank < hd.rank
            ? trees.prepended(tree)
            : _insertTreeImpl(tree.link(hd), trees.tail()),
      );

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
      final ts1 = lhs.tail();
      final t2 = rhs[0];
      final ts2 = rhs.tail();

      if (t1.rank < t2.rank) {
        return _merge(ts1, rhs).prepended(t1);
      } else if (t1.rank > t2.rank) {
        return _merge(lhs, ts2).prepended(t2);
      } else {
        return _insertTreeImpl(t1.link(t2), _merge(ts1, ts2));
      }
    }
  }

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

final class BinomialTree<A> {
  final int rank;
  final A value;
  final IList<BinomialTree<A>> children;

  final Order<A> order;

  const BinomialTree(this.rank, this.value, this.children, this.order);

  BinomialTree<A> link(BinomialTree<A> other) {
    if (order.lteqv(value, other.value)) {
      return BinomialTree(rank + 1, value, children.prepended(other), order);
    } else {
      return BinomialTree(rank + 1, other.value, other.children.prepended(this), order);
    }
  }
}
