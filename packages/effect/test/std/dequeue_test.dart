import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/src/std/internal/list_queue.dart';
import 'package:ribs_effect/test_matchers.dart';
import 'package:test/test.dart';

import 'queue_test.dart';

void main() {
  group('Bounded Dequeue', () {
    IO<Dequeue<int>> constructor(int n) => Dequeue.bounded<int>(n);

    group('(forward)', () {
      boundedDequeueTests(
        constructor,
        (q, a) => q.offerBack(a),
        (q, a) => q.tryOfferBack(a),
        (q) => q.takeFront(),
        (q) => q.tryTakeFront(),
        (q, a) => q.tryTakeFrontN(a),
        (q) => q.size(),
      );
    });

    group('(reversed)', () {
      boundedDequeueTests(
        constructor,
        (q, a) => q.offerFront(a),
        (q, a) => q.tryOfferFront(a),
        (q) => q.takeBack(),
        (q) => q.tryTakeBack(),
        (q, a) => q.tryTakeBackN(a),
        (q) => q.size(),
      );
    });

    DequeueTests.reverse(constructor);

    QueueTests.batchOfferTests(
      constructor,
      (q, a) => q.tryOfferBackN(a),
      (q, a) => q.tryTakeFrontN(a),
      identity,
    );

    QueueTests.batchOfferTests(
      constructor,
      (q, a) => q.tryOfferFrontN(a),
      (q, a) => q.tryTakeFrontN(a),
      identity,
    );

    QueueTests.batchOfferTests(
      constructor,
      (q, a) => q.tryOfferBackN(a),
      (q, a) => q.tryTakeBackN(a),
      (l) => l.reverse(),
    );

    QueueTests.batchOfferTests(
      constructor,
      (q, a) => q.tryOfferFrontN(a),
      (q, a) => q.tryTakeBackN(a),
      (l) => l.reverse(),
    );

    QueueTests.batchTakeTests(
      constructor,
      (q, a) => q.offer(a),
      (q, a) => q.tryTakeN(a),
      identity,
    );

    QueueTests.boundedBatchOfferTests(
      constructor,
      (q, a) => q.tryOfferBackN(a),
      (q, a) => q.tryTakeBackN(a),
      (l) => l.reverse(),
    );

    QueueTests.boundedBatchOfferTests(
      constructor,
      (q, a) => q.tryOfferFrontN(a),
      (q, a) => q.tryTakeBackN(a),
      (l) => l.reverse(),
    );

    QueueTests.commonTests(
      constructor,
      (q, a) => q.offer(a),
      (q, a) => q.tryOffer(a),
      (q) => q.take(),
      (q) => q.tryTake(),
      (q) => q.size(),
    );

    QueueTests.cancelableOfferTests(
      constructor,
      (q, a) => q.offer(a),
      (q) => q.take(),
      (q) => q.tryTake(),
    );

    QueueTests.cancelableOfferBoundedTests(
      constructor,
      (q, a) => q.offer(a),
      (q) => q.take(),
      (q, n) => q.tryTakeN(n),
    );

    QueueTests.cancelableTakeTests(
      constructor,
      (q, a) => q.offer(a),
      (q) => q.take(),
    );

    QueueTests.tryOfferOnFullTests(
      constructor,
      (q, a) => q.offer(a),
      (q, a) => q.tryOffer(a),
      false,
    );

    QueueTests.tryOfferTryTakeTests(
      constructor,
      (q, a) => q.tryOffer(a),
      (q) => q.tryTake(),
    );
  });

  group('Unbounded Dequeue', () {
    IO<Dequeue<int>> constructor(int n) => Dequeue.unbounded<int>();

    group('(forward)', () {
      unboundedDequeueTests(
        constructor,
        (q, a) => q.offerBack(a),
        (q, a) => q.tryOfferBack(a),
        (q) => q.takeFront(),
        (q) => q.tryTakeFront(),
        (q) => q.size(),
      );
    });

    group('(reversed)', () {
      unboundedDequeueTests(
        constructor,
        (q, a) => q.offerFront(a),
        (q, a) => q.tryOfferFront(a),
        (q) => q.takeBack(),
        (q) => q.tryTakeBack(),
        (q) => q.size(),
      );
    });
  });
}

class DequeueTests {
  static void reverse<Q extends Dequeue<int>>(
    Function1<int, IO<Q>> constructor,
  ) {
    forAll('reverse', Gen.ilistOfN(100, Gen.positiveInt), (l) {
      final test = constructor(1000000).flatMap((q) {
        return l.traverseIO_(q.offer).flatMap((_) {
          return q.reverse().flatMap((_) {
            return IList.fill(l.size, q.take()).sequence().flatMap((out) {
              return expectIO(out, l.reverse());
            });
          });
        });
      });

      expect(test, ioSucceeded());
    });
  }
}

void boundedDequeueTests<Q extends Dequeue<int>>(
  Function1<int, IO<Q>> constructor,
  Function2<Q, int, IO<Unit>> offer,
  Function2<Q, int, IO<bool>> tryOffer,
  Function1<Q, IO<int>> take,
  Function1<Q, IO<Option<int>>> tryTake,
  Function2<Q, Option<int>, IO<IList<int>>> tryTakeN,
  Function1<Q, IO<int>> size,
) {
  test('demonstrate offer and take with zero capacity', () {
    final test = constructor(0).flatMap((q) {
      return offer(q, 1).start().flatMap((_) {
        return take(q).flatMap((v1) {
          return take(q).start().flatMap((f) {
            return offer(q, 2).flatMap((_) {
              return f.joinWithNever().flatMap((v2) {
                return expectIO(v1, 1).productR(() => expectIO(v2, 2));
              });
            });
          });
        });
      });
    });

    expect(test, ioSucceeded());
  });

  test('async take with zero capacity', () {
    final test = constructor(0).flatMap((q) {
      return offer(q, 1).start().flatMap((_) {
        return take(q).flatMap((v1) {
          return IO.delay(() => take(q).unsafeRunFuture()).start().flatMap((ff) {
            return ff.joinWithNever().flatMap((f) {
              return offer(q, 2).flatMap((_) {
                return IO.fromFuture(IO.pure(f)).flatMap((v2) {
                  return expectIO(v1, 1).productR(() => expectIO(v2, 2));
                });
              });
            });
          });
        });
      });
    });

    expect(test, ioSucceeded());
  });

  test('offer/take with zero capacity', () {
    const count = 1000;

    IO<Unit> producer(Q q, int n) =>
        n > 0 ? offer(q, count - n).productR(() => producer(q, n - 1)) : IO.unit;

    IO<int> consumer(Q q, int n, ListQueue<int> acc) =>
        n > 0
            ? take(q).flatMap((a) => consumer(q, n - 1, acc.enqueue(a)))
            : IO.pure(acc.foldLeft(0, (a, b) => a + b));

    final test = constructor(0).flatMap((q) {
      return producer(q, count).start().flatMap((p) {
        return consumer(q, count, ListQueue.empty()).start().flatMap((c) {
          return p.join().flatMap((_) {
            return c.joinWithNever().flatMap((v) {
              return expectIO(v, count * (count - 1) ~/ 2);
            });
          });
        });
      });
    });

    expect(test, ioSucceeded());
  });
}

void unboundedDequeueTests<Q extends Dequeue<int>>(
  Function1<int, IO<Q>> constructor,
  Function2<Q, int, IO<Unit>> offer,
  Function2<Q, int, IO<bool>> tryOffer,
  Function1<Q, IO<int>> take,
  Function1<Q, IO<Option<int>>> tryTake,
  Function1<Q, IO<int>> size,
) {
  QueueTests.batchOfferTests(
    constructor,
    (q, a) => q.tryOfferBackN(a),
    (q, a) => q.tryTakeFrontN(a),
    identity,
  );

  QueueTests.batchOfferTests(
    constructor,
    (q, a) => q.tryOfferFrontN(a),
    (q, a) => q.tryTakeFrontN(a),
    identity,
  );

  QueueTests.batchOfferTests(
    constructor,
    (q, a) => q.tryOfferBackN(a),
    (q, a) => q.tryTakeBackN(a),
    (l) => l.reverse(),
  );

  QueueTests.batchOfferTests(
    constructor,
    (q, a) => q.tryOfferFrontN(a),
    (q, a) => q.tryTakeBackN(a),
    (l) => l.reverse(),
  );

  QueueTests.batchTakeTests(
    constructor,
    (q, a) => q.offer(a),
    (q, a) => q.tryTakeFrontN(a),
    identity,
  );

  QueueTests.batchTakeTests(
    constructor,
    (q, a) => q.offer(a),
    (q, a) => q.tryTakeBackN(a),
    (l) => l.reverse(),
  );

  QueueTests.commonTests(
    constructor,
    (q, a) => q.offer(a),
    (q, a) => q.tryOffer(a),
    (q) => q.take(),
    (q) => q.tryTake(),
    (q) => q.size(),
  );

  QueueTests.tryOfferOnFullTests(
    constructor,
    (q, a) => q.offer(a),
    (q, a) => q.tryOffer(a),
    true,
  );

  QueueTests.tryOfferTryTakeTests(
    constructor,
    (q, a) => q.tryOffer(a),
    (q) => q.tryTake(),
  );
}
