import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/src/std/internal/binomial_heap.dart';
import 'package:ribs_effect/src/std/internal/list_queue.dart';

abstract class PQueue<A> extends Queue<A> {
  static IO<PQueue<A>> bounded<A>(Order<A> order, int capacity) =>
      Ref.of(_State.empty(order)).map((ref) => _BoundedPQueue._(ref, capacity));

  static IO<PQueue<A>> unbounded<A>(Order<A> order) =>
      bounded(order, Integer.MaxValue);
}

final class _State<A> {
  final BinomialHeap<A> heap;
  final int size;
  final ListQueue<Deferred<Unit>> takers;
  final ListQueue<Deferred<Unit>> offerers;

  const _State(this.heap, this.size, this.takers, this.offerers);

  static _State<A> empty<A>(Order<A> order) => _State(
      BinomialHeap.empty(order), 0, ListQueue.empty(), ListQueue.empty());

  _State<A> copy({
    BinomialHeap<A>? heap,
    int? size,
    ListQueue<Deferred<Unit>>? takers,
    ListQueue<Deferred<Unit>>? offerers,
  }) =>
      _State(
        heap ?? this.heap,
        size ?? this.size,
        takers ?? this.takers,
        offerers ?? this.offerers,
      );
}

class _BoundedPQueue<A> extends PQueue<A> {
  final Ref<_State<A>> ref;
  final int capacity;

  _BoundedPQueue._(this.ref, this.capacity);

  @override
  IO<Unit> offer(A a) {
    return IO.uncancelable((poll) {
      return Deferred.of<Unit>().flatMap((offerer) {
        return ref.modify((s) {
          if (s.takers.nonEmpty) {
            final (taker, rest) = s.takers.dequeue();
            return (
              _State(s.heap.insert(a), s.size + 1, rest, s.offerers),
              taker.complete(Unit()).voided(),
            );
          } else if (s.size < capacity) {
            return (
              _State(s.heap.insert(a), s.size + 1, s.takers, s.offerers),
              IO.unit,
            );
          } else {
            final heap = s.heap;
            final size = s.size;
            final takers = s.takers;
            final offerers = s.offerers;

            final cleanup = ref.modify((s) {
              final offerers2 = s.offerers.filter((a) => a != offerer);

              if (offerers2.isEmpty) {
                return (s.copy(offerers: offerers2), IO.unit);
              } else {
                final (release, rest) = offerers2.dequeue();
                return (
                  s.copy(offerers: rest),
                  release.complete(Unit()).voided()
                );
              }
            });

            return (
              _State(heap, size, takers, offerers.enqueue(offerer)),
              poll(offerer
                  .value()
                  .productR(() => poll(offer(a)))
                  .onCancel(cleanup.flatten()))
            );
          }
        }).flatten();
      });
    });
  }

  @override
  IO<int> size() => ref.value().map((s) => s.size);

  @override
  IO<A> take() {
    return IO.uncancelable((poll) {
      return Deferred.of<Unit>().flatMap((taker) {
        return ref.modify((s) {
          if (s.heap.nonEmpty && s.offerers.isEmpty) {
            final (rest, a) = s.heap.take();
            return (_State(rest, s.size - 1, s.takers, s.offerers), IO.pure(a));
          } else if (s.heap.nonEmpty) {
            final (rest, a) = s.heap.take();
            final (release, tail) = s.offerers.dequeue();
            return (
              _State(rest, s.size - 1, s.takers, tail),
              release.complete(Unit()).as(a)
            );
          } else {
            final cleanup = ref.modify((s) {
              final takers2 = s.takers.filter((a) => a != taker);

              if (takers2.isEmpty) {
                return (s.copy(takers: takers2), IO.unit);
              } else {
                final (release, rest) = takers2.dequeue();
                return (
                  s.copy(takers: rest),
                  release.complete(Unit()).voided()
                );
              }
            });

            final awaiter = poll(taker.value().productR(() => poll(take())))
                .onCancel(cleanup.flatten());

            final IO<A> fulfill;
            final ListQueue<Deferred<Unit>> offerers2;

            if (s.offerers.isEmpty) {
              fulfill = awaiter;
              offerers2 = s.offerers;
            } else {
              final (release, rest) = s.offerers.dequeue();
              fulfill = release.complete(Unit()).productR(() => awaiter);
              offerers2 = rest;
            }

            return (
              _State(s.heap, s.size, s.takers.enqueue(taker), offerers2),
              fulfill,
            );
          }
        });
      });
    }).flatten();
  }

  @override
  IO<bool> tryOffer(A a) {
    return ref.flatModify((s) {
      return switch (s) {
        _State(:final heap, :final size, :final takers, :final offerers)
            when takers.nonEmpty =>
          takers.dequeue()((taker, rest) => (
                _State(heap.insert(a), size + 1, rest, offerers),
                taker.complete(Unit()).as(true)
              )),
        _State(:final heap, :final size, :final takers, :final offerers)
            when size < capacity =>
          (_State(heap.insert(a), size + 1, takers, offerers), IO.pure(true)),
        _ => (s, IO.pure(false)),
      };
    });
  }

  @override
  IO<Option<A>> tryTake() {
    return ref.flatModify((s) {
      return switch (s) {
        _State(:final heap, :final size, :final takers, :final offerers)
            when heap.nonEmpty && offerers.isEmpty =>
          heap.take()((rest, a) =>
              (_State(rest, size - 1, takers, offerers), IO.pure(Some(a)))),
        _State(:final heap, :final size, :final takers, :final offerers)
            when heap.nonEmpty =>
          heap.take()((rest, a) => offerers.dequeue()((release, tail) => (
                _State(rest, size - 1, takers, tail),
                release.complete(Unit()).as(Some(a))
              ))),
        _ => (s, IO.none<A>()),
      };
    });
  }
}
