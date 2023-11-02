import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/effect/std/internal/list_queue.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:test/test.dart';

import 'queue_test.dart';

void main() {
  test('demonstrate offer and take with zero capacity', () async {
    final test = PQueue.bounded(Order.ints, 0).flatMap((q) {
      return q.offer(1).start().flatMap((_) {
        return q.take().flatMap((v1) {
          return q.take().start().flatMap((f) {
            return q.offer(2).flatMap((_) {
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

  test('async take with zero capacity', () async {
    Option<int> futureValue = none();

    final test = PQueue.bounded(Order.ints, 0).flatMap((q) {
      return q.offer(1).start().flatMap((_) {
        return q.take().flatMap((v1) {
          return IO
              .delay(() => q
                  .take()
                  .unsafeRunFuture()
                  .then((value) => futureValue = Option(value)))
              .start()
              .flatMap((ff) {
            return ff.joinWithNever().flatMap((f) {
              expect(futureValue, isNone());

              return q.offer(2).flatMap((_) {
                return IO.fromFuture(IO.pure(f)).flatMap((v2) {
                  return expectIO(v1, 1)
                      .productR(() => expectIO(v2, isSome(2)));
                });
              });
            });
          });
        });
      });
    });

    expect(test, ioSucceeded());
  });

  test('offer/take with zero capacity', () async {
    const count = 1000;

    IO<Unit> producer(PQueue<int> q, int n) =>
        n > 0 ? q.offer(count - n).productR(() => producer(q, n - 1)) : IO.unit;

    IO<int> consumer(PQueue<int> q, int n, ListQueue<int> acc) => n > 0
        ? q.take().flatMap((a) => consumer(q, n - 1, acc.enqueue(a)))
        : IO.pure(acc.foldLeft(0, (a, b) => a + b));

    final test = PQueue.bounded(Order.ints, 0).flatMap((q) {
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

  QueueTests.tryOfferOnFullTests(
    (n) => PQueue.bounded(Order.ints, n),
    (q, a) => q.offer(a),
    (q, a) => q.tryOffer(a),
    false,
  );

  QueueTests.cancelableOfferTests(
    (n) => PQueue.bounded(Order.ints, n),
    (q, a) => q.offer(a),
    (q) => q.take(),
    (q) => q.tryTake(),
  );

  QueueTests.cancelableOfferBoundedTests(
    (n) => PQueue.bounded(Order.ints, n),
    (q, a) => q.offer(a),
    (q) => q.take(),
    (q, n) => q.tryTakeN(n),
  );

  QueueTests.cancelableTakeTests(
    (n) => PQueue.bounded(Order.ints, n),
    (q, a) => q.offer(a),
    (q) => q.take(),
  );

  QueueTests.tryOfferTryTakeTests(
    (n) => PQueue.bounded(Order.ints, n),
    (q, a) => q.tryOffer(a),
    (q) => q.tryTake(),
  );

  QueueTests.commonTests(
    (n) => PQueue.bounded(Order.ints, n),
    (q, a) => q.offer(a),
    (q, a) => q.tryOffer(a),
    (q) => q.take(),
    (q) => q.tryTake(),
    (q) => q.size(),
  );
}
