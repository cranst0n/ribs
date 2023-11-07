// ignore_for_file: unreachable_from_main

import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/effect/std/internal/bankers_queue.dart';
import 'package:test/test.dart';

void main() {
  forAll('maintain size invariants', Op.genList(Gen.positiveInt), (ops) {
    final queue = Op.fold(ops);

    expect(
      queue.frontLen <= queue.backLen * BankersQueue.RebalanceConstant + 1,
      isTrue,
    );

    expect(
      queue.backLen <= queue.frontLen * BankersQueue.RebalanceConstant + 1,
      isTrue,
    );
  });

  forAll('dequeue in order from front', Op.genList(Gen.positiveInt), (ops) {
    expect(toListFromFront(buildQueue(ops)), ops);
  });

  forAll('dequeue in order from back', Op.genList(Gen.positiveInt), (ops) {
    expect(toListFromBack(buildQueue(ops)), ops.reverse());
  });

  forAll('reverse', Op.genList(Gen.positiveInt), (ops) {
    expect(toListFromFront(buildQueue(ops).reverse()), ops.reverse());
  });
}

BankersQueue<A> buildQueue<A>(IList<A> elems) =>
    elems.foldLeft(BankersQueue.empty(), (heap, e) => heap.pushBack(e));

IList<A> toListFromFront<A>(BankersQueue<A> queue) =>
    queue.tryPopFront()((rest, hd) =>
        hd.fold(() => nil(), (a) => toListFromFront(rest).prepend(a)));

IList<A> toListFromBack<A>(BankersQueue<A> queue) => queue.tryPopBack()(
    (rest, hd) => hd.fold(() => nil(), (a) => toListFromBack(rest).prepend(a)));

sealed class Op<A> {
  static Gen<Op<A>> gen<A>(Gen<A> genA) => Gen.frequency(
        ilist([
          (1, Gen.constant(PopFront())),
          (1, Gen.constant(PopBack())),
          (3, genA.map(PushFront.new)),
          (3, genA.map(PushBack.new)),
        ]),
      );

  static Gen<IList<Op<A>>> genList<A>(Gen<A> genA) =>
      Gen.ilistOfN(100, gen(genA));

  static BankersQueue<A> fold<A>(IList<Op<A>> ops) => ops.foldLeft(
      BankersQueue.empty<A>(),
      (queue, op) => switch (op) {
            PushFront(value: final a) => queue.pushFront(a),
            PushBack(value: final a) => queue.pushBack(a),
            PopFront _ => queue.nonEmpty ? queue.tryPopFront().$1 : queue,
            PopBack _ => queue.nonEmpty ? queue.tryPopBack().$1 : queue,
          });
}

final class PushFront<A> extends Op<A> {
  final A value;
  PushFront(this.value);
}

final class PushBack<A> extends Op<A> {
  final A value;
  PushBack(this.value);
}

final class PopFront extends Op<Never> {}

final class PopBack extends Op<Never> {}
