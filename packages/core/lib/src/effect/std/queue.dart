import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/effect/std/internal/list_queue.dart';

abstract class Queue<A> {
  static IO<Queue<A>> bounded<A>(int capacity) {
    if (capacity == 0) {
      return synchronous();
    } else {
      return Ref.of(_State.empty<A>()).map((s) => _BoundedQueue(capacity, s));
    }
  }

  static IO<Queue<A>> circularBuffer<A>(int capacity) =>
      Ref.of(_State.empty<A>()).map((s) => _CircularBufferQueue(capacity, s));

  static IO<Queue<A>> dropping<A>(int capacity) =>
      Ref.of(_State.empty<A>()).map((s) => _DroppingQueue(capacity, s));

  static IO<Queue<A>> synchronous<A>() =>
      Ref.of(_SyncState.empty<A>()).map(_SyncQueue.new);

  static IO<Queue<A>> unbounded<A>() => bounded(9007199254740991);

  IO<int> size();

  IO<Unit> offer(A a);

  IO<bool> tryOffer(A a);

  IO<IList<A>> tryOfferN(IList<A> list) => list.uncons((hdtl) => hdtl.fold(
        () => IO.pure(list),
        (hdtl) => hdtl((hd, tl) =>
            tryOffer(hd).ifM(() => tryOfferN(tl), () => IO.pure(list))),
      ));

  IO<A> take();

  IO<Option<A>> tryTake();

  IO<IList<A>> tryTakeN(Option<int> maxN) {
    // todo: tailrec
    IO<IList<A>> loop(int i, int limit, IList<A> acc) {
      if (i >= limit) {
        return IO.pure(acc.reverse());
      } else {
        return tryTake().flatMap((a) => a.fold(
              () => IO.pure(acc.reverse()),
              (a) => loop(i + 1, limit, acc.prepend(a)),
            ));
      }
    }

    return loop(0, maxN.getOrElse(() => 9007199254740991), nil());
  }
}

final class _SyncQueue<A> extends Queue<A> {
  final Ref<_SyncState<A>> stateR;

  _SyncQueue(this.stateR);

  @override
  IO<int> size() => IO.pure(0);

  @override
  IO<Unit> offer(A a) {
    return Deferred.of<bool>().flatMap((latch) {
      return IO.uncancelable((poll) {
        final checkCommit =
            poll(latch.value()).ifM(() => IO.unit, () => poll(offer(a)));

        final modificationF = stateR.modify((s) {
          if (s.takers.nonEmpty) {
            final (taker, tail) = s.takers.dequeue();

            final finish =
                taker.complete((a, latch)).productR(() => checkCommit);

            return (_SyncState(s.offerers, tail), finish);
          } else {
            final cleanupF = stateR.update((s) =>
                _SyncState(s.offerers.filter((a) => a.$2 != latch), s.takers));

            return (
              _SyncState(s.offerers.enqueue((a, latch)), s.takers),
              checkCommit.onCancel(cleanupF)
            );
          }
        });

        return modificationF.flatten();
      });
    });
  }

  @override
  IO<A> take() {
    return Deferred.of<(A, Deferred<bool>)>().flatMap((latch) {
      return IO.uncancelable((poll) {
        final modificationF = stateR.modify((st) {
          if (st.offerers.nonEmpty) {
            final ((value, offerer), tail) = st.offerers.dequeue();

            return (
              _SyncState(tail, st.takers),
              offerer.complete(true).as(value)
            );
          } else {
            final removeListener = stateR.modify((st) {
              // todo: tailrec
              (bool, ListQueue<Z>) filterFound<Z>(
                ListQueue<Z> ins,
                ListQueue<Z> outs,
              ) {
                if (ins.isEmpty) {
                  return (false, outs);
                } else {
                  final (head, tail) = ins.dequeue();

                  if (head == latch) {
                    return (true, outs.concat(tail));
                  } else {
                    return filterFound(tail, outs.enqueue(head));
                  }
                }
              }

              final (found, takers2) = filterFound(
                  st.takers, ListQueue.empty<Deferred<(A, Deferred<bool>)>>());

              return (_SyncState(st.offerers, takers2), found);
            });

            final failCommit = latch.value().flatMap((a) =>
                a((_, commitLatch) => commitLatch.complete(false).voided()));

            final cleanupF =
                removeListener.ifM(() => IO.unit, () => failCommit);

            final awaitF = poll(latch.value())
                .onCancel(cleanupF)
                .flatMap((a) => a((a, latch) => latch.complete(true).as(a)));

            return (_SyncState(st.offerers, st.takers.enqueue(latch)), awaitF);
          }
        });

        return modificationF.flatten();
      });
    });
  }

  @override
  IO<bool> tryOffer(A a) {
    return stateR.flatModify((st) {
      if (st.takers.nonEmpty) {
        final (taker, tail) = st.takers.dequeue();

        final commitF = Deferred.of<bool>().flatMap((latch) {
          return IO.uncancelable((poll) {
            return taker
                .complete((a, latch)).productR(() => poll(latch.value()));
          });
        });

        return (_SyncState(st.offerers, tail), commitF);
      } else {
        return (st, IO.pure(false));
      }
    });
  }

  @override
  IO<Option<A>> tryTake() {
    return IO.uncancelable((_) {
      return stateR.flatModify((st) {
        if (st.offerers.nonEmpty) {
          final ((value, offerer), tail) = st.offerers.dequeue();

          return (
            _SyncState(tail, st.takers),
            offerer.complete(true).as(value.some)
          );
        } else {
          return (st, IO.none());
        }
      });
    });
  }
}

final class _SyncState<A> {
  final ListQueue<(A, Deferred<bool>)> offerers;
  final ListQueue<Deferred<(A, Deferred<bool>)>> takers;

  _SyncState(this.offerers, this.takers);

  static _SyncState<A> empty<A>() =>
      _SyncState(ListQueue.empty(), ListQueue.empty());
}

abstract class _AbstractQueue<A> extends Queue<A> {
  final int capacity;
  final Ref<_State<A>> state;

  _AbstractQueue(this.capacity, this.state);

  (_State<A>, IO<Unit>) onOfferNoCapacity(_State<A> s, A a,
      Deferred<Unit> offerer, Poll poll, Function0<IO<Unit>> recurse);

  (_State<A>, IO<bool>) onTryOfferNoCapacity(_State<A> s, A a);

  @override
  IO<Unit> offer(A a) {
    return IO.uncancelable((poll) {
      return Deferred.of<Unit>().flatMap((offerer) {
        final modificationF = state.modify((st) {
          if (st.takers.nonEmpty) {
            final (taker, rest) = st.takers.dequeue();

            return (
              _State(st.queue.enqueue(a), st.size + 1, rest, st.offerers),
              taker.complete(Unit()).voided(),
            );
          } else if (st.size < capacity) {
            return (
              _State(st.queue.enqueue(a), st.size + 1, st.takers, st.offerers),
              IO.unit,
            );
          } else {
            return onOfferNoCapacity(st, a, offerer, poll, () => offer(a));
          }
        });

        return modificationF.flatten();
      });
    });
  }

  @override
  IO<bool> tryOffer(A a) {
    return state.flatModify((st) {
      if (st.takers.nonEmpty) {
        final (taker, rest) = st.takers.dequeue();

        return (
          _State(st.queue.enqueue(a), st.size + 1, rest, st.offerers),
          taker.complete(Unit()).as(true),
        );
      } else if (st.size < capacity) {
        return (
          _State(st.queue.enqueue(a), st.size + 1, st.takers, st.offerers),
          IO.pure(true),
        );
      } else {
        return onTryOfferNoCapacity(st, a);
      }
    });
  }

  @override
  IO<A> take() {
    return IO.uncancelable((poll) {
      return Deferred.of<Unit>().flatMap((taker) {
        final modificationF = state.modify((st) {
          if (st.queue.nonEmpty && st.offerers.isEmpty) {
            final (a, rest) = st.queue.dequeue();
            return (
              _State(rest, st.size - 1, st.takers, st.offerers),
              IO.pure(a),
            );
          } else if (st.queue.nonEmpty) {
            final (a, rest) = st.queue.dequeue();

            if (st.size - 1 < capacity) {
              final (release, tail) = st.offerers.dequeue();
              return (
                _State(rest, st.size - 1, st.takers, tail),
                release.complete(Unit()).as(a),
              );
            } else {
              return (
                _State(rest, st.size - 1, st.takers, st.offerers),
                IO.pure(a),
              );
            }
          } else {
            final cleanup = state.modify((st) {
              final takers2 = st.takers.filter((a) => a != taker);
              if (takers2.isEmpty) {
                return (st.copy(takers: takers2), IO.unit);
              } else {
                final (taker, rest) = takers2.dequeue();
                return (st.copy(takers: rest), taker.complete(Unit()).voided());
              }
            });

            final awaitF = poll(taker.value())
                .onCancel(cleanup.flatten())
                .productR(
                    () => poll(take()).onCancel(_notifyNextTaker().flatten()));

            final (fulfill, offerers2) = st.offerers.isEmpty
                ? (awaitF, st.offerers)
                : st.offerers.dequeue()((release, rest) =>
                    (release.complete(Unit()).productR(() => awaitF), rest));

            return (
              _State(st.queue, st.size, st.takers.enqueue(taker), offerers2),
              fulfill,
            );
          }
        });

        return modificationF.flatten();
      });
    });
  }

  @override
  IO<Option<A>> tryTake() {
    return state.flatModify((st) {
      if (st.queue.nonEmpty && st.offerers.isEmpty) {
        final (a, rest) = st.queue.dequeue();
        return (_State(rest, st.size - 1, st.takers, st.offerers), IO.some(a));
      } else if (st.queue.nonEmpty) {
        final (a, rest) = st.queue.dequeue();
        final (release, tail) = st.offerers.dequeue();
        return (
          _State(rest, st.size - 1, st.takers, tail),
          release.complete(Unit()).as(a.some),
        );
      } else {
        return (st, IO.none());
      }
    });
  }

  @override
  IO<int> size() => state.value().map((s) => s.size);

  IO<IO<Unit>> _notifyNextTaker() => state.modify((s) {
        if (s.takers.isEmpty) {
          return (s, IO.unit);
        } else {
          final (taker, rest) = s.takers.dequeue();
          return (s.copy(takers: rest), taker.complete(Unit()).voided());
        }
      });
}

final class _State<A> {
  final ListQueue<A> queue;
  final int size;
  final ListQueue<Deferred<Unit>> takers;
  final ListQueue<Deferred<Unit>> offerers;

  _State(this.queue, this.size, this.takers, this.offerers);

  static _State<A> empty<A>() =>
      _State(ListQueue.empty(), 0, ListQueue.empty(), ListQueue.empty());

  _State<A> copy({
    ListQueue<A>? queue,
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

final class _BoundedQueue<A> extends _AbstractQueue<A> {
  _BoundedQueue(super.capacity, super.state);

  @override
  (_State<A>, IO<Unit>) onOfferNoCapacity(
    _State<A> s,
    A a,
    Deferred<Unit> offerer,
    Poll poll,
    Function0<IO<Unit>> recurse,
  ) {
    final _State(:queue, :size, :takers, :offerers) = s;

    final cleanup = state.modify((s) {
      final offerers2 = s.offerers.filter((a) => a != offerer);

      if (offerers2.isEmpty) {
        return (s.copy(offerers: offerers2), IO.unit);
      } else {
        final (offerer, rest) = offerers2.dequeue();
        return (s.copy(offerers: rest), offerer.complete(Unit()).voided());
      }
    });

    return (
      _State(queue, size, takers, offerers.enqueue(offerer)),
      poll(offerer.value())
          .productR(() => poll(recurse()))
          .onCancel(cleanup.flatten()),
    );
  }

  @override
  (_State<A>, IO<bool>) onTryOfferNoCapacity(_State<A> s, A a) =>
      (s, IO.pure(false));
}

final class _DroppingQueue<A> extends _AbstractQueue<A> {
  _DroppingQueue(super.capacity, super.state);

  @override
  (_State<A>, IO<Unit>) onOfferNoCapacity(
    _State<A> s,
    A a,
    Deferred<Unit> offerer,
    Poll poll,
    Function0<IO<Unit>> recurse,
  ) =>
      (s, IO.unit);

  @override
  (_State<A>, IO<bool>) onTryOfferNoCapacity(_State<A> s, A a) =>
      (s, IO.pure(false));
}

final class _CircularBufferQueue<A> extends _AbstractQueue<A> {
  _CircularBufferQueue(super.capacity, super.state);

  @override
  (_State<A>, IO<Unit>) onOfferNoCapacity(
    _State<A> s,
    A a,
    Deferred<Unit> offerer,
    Poll poll,
    Function0<IO<Unit>> recurse,
  ) {
    final (ns, fb) = onTryOfferNoCapacity(s, a);
    return (ns, fb.voided());
  }

  @override
  (_State<A>, IO<bool>) onTryOfferNoCapacity(_State<A> s, A a) {
    final _State(:queue, :size, :takers, :offerers) = s;
    final (_, rest) = queue.dequeue();

    return (_State(rest.enqueue(a), size, takers, offerers), IO.pure(true));
  }
}
