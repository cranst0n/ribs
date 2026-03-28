import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart' hide Queue;
import 'package:ribs_effect/test.dart';
import 'package:ribs_limiter/src/internal/queue.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:test/test.dart';

void main() {
  Gen.listOf(
    Gen.chooseInt(0, 100),
    Gen.integer,
  ).forAll('dequeue the highest priority elements first', (elems) {
    final test = Queue.create<int>()
        .map((q) {
          return Rill.emits(elems)
              .zipWithIndex()
              .evalMap((elemAndIx) => q.enqueue(elemAndIx.$1, priority: elemAndIx.$2))
              .drain()
              .widen<int>()
              .append(() => q.dequeueAll().take(elems.length));
        })
        .flatMap((rill) => rill.compile.toIVector);

    expect(test, succeeds(elems.toIVector().reverse()));
  });

  Gen.listOf(
    Gen.chooseInt(0, 100),
    Gen.integer,
  ).forAll('dequeue elements with the same priority in FIFO order', (elems) {
    final test = Queue.create<int>()
        .map((q) {
          return Rill.emits(
            elems,
          ).evalMap(q.enqueue).drain().widen<int>().append(() => q.dequeueAll()).take(elems.length);
        })
        .flatMap((rill) => rill.compile.toIVector);

    expect(test, succeeds(elems.toIVector()));
  });

  test('fail an enqueue attempt if the queue if full', () {
    final test = Queue.create<int>(1).flatMap((q) => q.enqueue(1).productR(q.enqueue(1)));
    expect(test, errors());
  });

  test('successfully enqueue after dequeueing from a full queue', () {
    final test = Queue.create<int>(
      1,
    ).flatMap(
      (q) => q
          .enqueue(1)
          .productR(q.enqueue(2).attempt())
          .productR(q.dequeue())
          .productR(q.enqueue(3))
          .productR(q.dequeue()),
    );

    expect(test, succeeds(3));
  });

  test('block on an empty queue until an element is available', () {
    final test = Queue.create<Unit>().flatMap((q) {
      final producer = IO.sleep(1.second).productR(q.enqueue(Unit()));
      final consumer = q.dequeue().timeout(3.seconds);

      return producer.start().productR(consumer);
    });

    expect(test.ticked, succeeds());
  });

  test('If a dequeue get canceled before an enqueue, no elements are lost in the next dequeue', () {
    final test = Queue.create<Unit>().flatMap((q) {
      return q
          .dequeue()
          .timeout(2.seconds)
          .attempt()
          .productR(q.enqueue(Unit()))
          .productR(q.dequeue().timeout(1.second));
    });

    expect(test.ticked, succeeds());
  });

  test('Mark an element as deleted', () {
    final test = Queue.create<int>().flatMap((q) {
      return q.enqueue(1).flatMap((id) {
        return q
            .enqueue(2)
            .productR(q.delete(id))
            .productR(
              (q.dequeue(), q.dequeue().map((n) => n.some).timeoutTo(1.second, IO.none())).tupled,
            );
      });
    });

    expect(test.ticked, succeeds((2, const None())));
  });

  test('Delete return true <-> element is marked as deleted', () {
    const n = 1000;

    final test = Queue.create<int>().flatMap((q) {
      return q.enqueue(1).flatMap((id) {
        return q.enqueue(2).productR((q.delete(id), q.dequeue()).parTupled);
      });
    });

    final verify = test.replicate(n).map((results) {
      return results.forall((tuple) {
        final (deleted, elem) = tuple;

        return deleted ? elem == 2 : elem == 1;
      });
    });

    expect(verify, succeeds(true));
  });
}
