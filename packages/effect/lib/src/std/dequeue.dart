import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_effect/src/std/internal/bankers_queue.dart';
import 'package:ribs_effect/src/std/internal/list_queue.dart';

abstract class Dequeue<A> extends Queue<A> {
  static IO<Dequeue<A>> bounded<A>(int capacity) =>
      Ref.of(_State.empty<A>()).map((s) => _BoundedDequeue(capacity, s));

  static IO<Dequeue<A>> unbounded<A>() => bounded(9007199254740991);

  @override
  IO<Unit> offer(A a) => offerBack(a);

  @override
  IO<bool> tryOffer(A a) => tryOfferBack(a);

  IO<Unit> offerBack(A a);

  IO<bool> tryOfferBack(A a);

  IO<IList<A>> tryOfferBackN(IList<A> list);

  IO<Unit> offerFront(A a);

  IO<bool> tryOfferFront(A a);

  IO<IList<A>> tryOfferFrontN(IList<A> list);

  @override
  IO<A> take() => takeFront();

  @override
  IO<Option<A>> tryTake() => tryTakeFront();

  IO<A> takeBack();

  IO<Option<A>> tryTakeBack();

  IO<IList<A>> tryTakeBackN(Option<int> maxN);

  IO<A> takeFront();

  IO<Option<A>> tryTakeFront();

  IO<IList<A>> tryTakeFrontN(Option<int> maxN);

  IO<Unit> reverse();
}

class _BoundedDequeue<A> extends Dequeue<A> {
  final int capacity;
  final Ref<_State<A>> state;

  _BoundedDequeue(this.capacity, this.state);

  @override
  IO<Unit> offerBack(A a) => _offer(a, (q) => q.pushBack(a));

  @override
  IO<Unit> offerFront(A a) => _offer(a, (q) => q.pushFront(a));

  @override
  IO<Unit> reverse() => state.update((s) => s.copy(queue: s.queue.reverse()));

  @override
  IO<A> takeBack() => _take((a) => a.tryPopBack());

  @override
  IO<A> takeFront() => _take((a) => a.tryPopFront());

  @override
  IO<bool> tryOfferBack(A a) => _tryOffer((q) => q.pushBack(a));

  @override
  IO<IList<A>> tryOfferBackN(IList<A> list) => _tryOfferN(list, tryOfferBack);

  @override
  IO<bool> tryOfferFront(A a) => _tryOffer((q) => q.pushFront(a));

  @override
  IO<IList<A>> tryOfferFrontN(IList<A> list) => _tryOfferN(list, tryOfferFront);

  @override
  IO<Option<A>> tryTakeBack() => _tryTake((a) => a.tryPopBack());

  @override
  IO<IList<A>> tryTakeBackN(Option<int> maxN) => _tryTakeN(tryTakeBack(), maxN);

  @override
  IO<Option<A>> tryTakeFront() => _tryTake((a) => a.tryPopFront());

  @override
  IO<IList<A>> tryTakeFrontN(Option<int> maxN) =>
      _tryTakeN(tryTakeFront(), maxN);

  @override
  IO<int> size() => state.value().map((s) => s.size);

  IO<Unit> _offer(A a, Function1<BankersQueue<A>, BankersQueue<A>> update) {
    return IO.uncancelable((poll) {
      return Deferred.of<Unit>().flatMap((offerer) {
        return state.modify((s) {
          if (s.takers.nonEmpty) {
            final (taker, rest) = s.takers.dequeue();
            return (
              _State(update(s.queue), s.size + 1, rest, s.offerers),
              taker.complete(Unit()).voided(),
            );
          } else if (s.size < capacity) {
            return (
              _State(update(s.queue), s.size + 1, s.takers, s.offerers),
              IO.unit,
            );
          } else {
            final _State(:queue, :size, :takers, :offerers) = s;

            final cleanup = state.modify((s) {
              final offerers2 = s.offerers.filter((a) => a != offerer);

              if (offerers2.isEmpty) {
                return (s.copy(offerers: offerers2), IO.unit);
              } else {
                final (release, rest) = offerers2.dequeue();

                return (
                  s.copy(offerers: rest),
                  release.complete(Unit()).voided(),
                );
              }
            });

            return (
              _State(queue, size, takers, offerers.enqueue(offerer)),
              poll(offerer.value())
                  .productR(() => poll(_offer(a, update)))
                  .onCancel(cleanup.flatten()),
            );
          }
        }).flatten();
      });
    });
  }

  IO<bool> _tryOffer(Function1<BankersQueue<A>, BankersQueue<A>> update) {
    return state.flatModify((s) {
      if (s.takers.nonEmpty) {
        final (taker, rest) = s.takers.dequeue();
        return (
          _State(update(s.queue), s.size + 1, rest, s.offerers),
          taker.complete(Unit()).as(true),
        );
      } else if (s.size < capacity) {
        return (
          _State(update(s.queue), s.size + 1, s.takers, s.offerers),
          IO.pure(true),
        );
      } else {
        return (s, IO.pure(false));
      }
    });
  }

  IO<IList<A>> _tryOfferN(IList<A> list, Function1<A, IO<bool>> tryOfferF) =>
      list.uncons((hdtl) => hdtl.foldN(
            () => IO.pure(list),
            (hd, tl) => tryOfferF(hd).ifM(
              () => tryOfferN(tl),
              () => IO.pure(list),
            ),
          ));

  IO<IList<A>> _tryTakeN(IO<Option<A>> tryTakeF, Option<int> maxN) {
    IO<IList<A>> loop(int i, int limit, IList<A> acc) {
      if (i >= limit) {
        return IO.pure(acc.reverse());
      } else {
        return tryTakeF.flatMap((a) => a.fold(
              () => IO.pure(acc.reverse()),
              (a) => loop(i + 1, limit, acc.prepended(a)),
            ));
      }
    }

    return loop(0, maxN.getOrElse(() => 9007199254740991), nil());
  }

  IO<A> _take(
      Function1<BankersQueue<A>, (BankersQueue<A>, Option<A>)> dequeue) {
    return IO.uncancelable((poll) {
      return Deferred.of<Unit>().flatMap((taker) {
        final modificationF = state.modify((s) {
          if (s.queue.nonEmpty && s.offerers.isEmpty) {
            final (rest, ma) = dequeue(s.queue);
            final a = ma.getOrElse(
                () => throw Exception('Dequeue.take.get on empty Option'));

            return (_State(rest, s.size - 1, s.takers, s.offerers), IO.pure(a));
          } else if (s.queue.nonEmpty) {
            final (rest, ma) = dequeue(s.queue);
            final a = ma.getOrElse(
                () => throw Exception('Dequeue.take.get on empty Option'));
            final (release, tail) = s.offerers.dequeue();

            return (
              _State(rest, s.size - 1, s.takers, tail),
              release.complete(Unit()).as(a),
            );
          } else {
            final cleanup = state.modify((s) {
              final takers2 = s.takers.filter((a) => a != taker);

              if (takers2.isEmpty) {
                return (s.copy(takers: takers2), IO.unit);
              } else {
                final (taker, rest) = takers2.dequeue();
                return (s.copy(takers: rest), taker.complete(Unit()).voided());
              }
            });

            final awaiter = poll(taker.value())
                .onCancel(cleanup.flatten())
                .productR(() => poll(_take(dequeue))
                    .onCancel(_notifyNextTaker().flatten()));

            final (fulfill, offerer2) = s.offerers.isEmpty
                ? (awaiter, s.offerers)
                : s.offerers.dequeue()((release, rest) =>
                    (release.complete(Unit()).productR(() => awaiter), rest));

            return (
              _State(s.queue, s.size, s.takers.enqueue(taker), offerer2),
              fulfill
            );
          }
        });

        return modificationF.flatten();
      });
    });
  }

  IO<IO<Unit>> _notifyNextTaker() {
    return state.modify((s) {
      if (s.takers.isEmpty) {
        return (s, IO.unit);
      } else {
        final (taker, rest) = s.takers.dequeue();
        return (s.copy(takers: rest), taker.complete(Unit()).voided());
      }
    });
  }

  IO<Option<A>> _tryTake(
      Function1<BankersQueue<A>, (BankersQueue<A>, Option<A>)> dequeue) {
    return state.flatModify((s) {
      if (s.queue.nonEmpty && s.offerers.isEmpty) {
        final (rest, ma) = dequeue(s.queue);
        return (_State(rest, s.size - 1, s.takers, s.offerers), IO.pure(ma));
      } else if (s.queue.nonEmpty) {
        final (rest, ma) = dequeue(s.queue);
        final (release, tail) = s.offerers.dequeue();

        return (
          _State(rest, s.size - 1, s.takers, tail),
          release.complete(Unit()).as(ma),
        );
      } else {
        return (s, IO.none());
      }
    });
  }
}

final class _State<A> {
  final BankersQueue<A> queue;
  final int size;
  final ListQueue<Deferred<Unit>> takers;
  final ListQueue<Deferred<Unit>> offerers;

  _State(this.queue, this.size, this.takers, this.offerers);

  static _State<A> empty<A>() =>
      _State(BankersQueue.empty(), 0, ListQueue.empty(), ListQueue.empty());

  _State<A> copy({
    BankersQueue<A>? queue,
    int? size,
    ListQueue<Deferred<Unit>>? takers,
    ListQueue<Deferred<Unit>>? offerers,
  }) =>
      _State(
        queue ?? this.queue,
        size ?? this.size,
        takers ?? this.takers,
        offerers ?? this.offerers,
      );
}
