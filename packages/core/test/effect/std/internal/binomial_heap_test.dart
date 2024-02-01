import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/effect/std/internal/binomial_heap.dart';
import 'package:test/test.dart';

void main() {
  forAll('dequeue by priority', Gen.ilistOfN(100, Gen.positiveInt), (l) {
    final heap = buildHeap(l, Order.ints);
    final back = toList(heap);

    expect(back, l.sorted(Order.ints));
  });

  forAll('maintain the heap property', Op.genList(Gen.positiveInt), (ops) {
    final heap = Op.toHeap(ops, Order.ints);
    expect(heap.trees.forall((t) => validHeap(t)), isTrue);
  });

  forAll('maintain correct subtree ranks', Op.genList(Gen.positiveInt), (ops) {
    final heap = Op.toHeap(ops, Order.ints);

    int currentRank = 0;

    heap.trees.forall((t) {
      final r = rank(t);
      expect(r > currentRank, isTrue);

      currentRank = r;
      return checkRank(r, t);
    });
  });
}

bool validHeap<A>(BinomialTree<A> tree) {
  bool isValid(A parent, BinomialTree<A> tree) =>
      tree.order.lteqv(parent, tree.value) &&
      tree.children.forall((a) => isValid(tree.value, a));

  return tree.children.isEmpty ||
      tree.children.forall((a) => isValid(tree.value, a));
}

BinomialHeap<A> buildHeap<A>(IList<A> elems, Order<A> order) => elems.foldLeft(
    BinomialHeap.empty(order), (heap, elem) => heap.insert(elem));

IList<A> toList<A>(BinomialHeap<A> heap) {
  final (remaining, a) = heap.tryTake();

  return a.fold(
    () => nil(),
    (a) => toList(remaining).prepended(a),
  );
}

int rank<A>(BinomialTree<A> tree) =>
    tree.children.uncons((hdtl) => hdtl.fold(() => 1, (a) => 1 + rank(a.$1)));

bool checkRank<A>(int rank, BinomialTree<A> tree) => switch (tree.children) {
      final IList<A> l when l.isEmpty => rank == 1,
      _ => Range.exclusive(0, rank)
          .reverse()
          .zip(tree.children)
          .forall((tup) => tup((r, t) => checkRank(r, t))),
    };

sealed class Op<A> {
  static BinomialHeap<A> toHeap<A>(IList<Op<A>> ops, Order<A> order) =>
      ops.foldLeft(
          BinomialHeap.empty(order),
          (heap, op) => switch (op) {
                Insert(:final a) => heap.insert(a),
                Take _ => heap.tryTake().$1,
              });

  static Gen<Op<A>> gen<A>(Gen<A> genA) => Gen.frequency([
        (1, Gen.constant(Take())),
        (3, genA.map(Insert.new)),
      ]);

  static Gen<IList<Op<A>>> genList<A>(Gen<A> genA) =>
      Gen.ilistOfN(100, gen(genA));
}

final class Insert<A> extends Op<A> {
  final A a; // ignore: unreachable_from_main

  Insert(this.a);
}

final class Take extends Op<Never> {}
