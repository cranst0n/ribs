import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

abstract class Semaphore {
  static IO<Semaphore> permits(int n) {
    return IO.ref(_State(n, IQueue.empty())).map(_SemaphoreImpl.new);
  }

  IO<int> available();

  IO<int> count();

  IO<Unit> acquireN(int n);

  IO<Unit> acquire() => acquireN(1);

  IO<bool> tryAcquireN(int n);

  IO<bool> tryAcquire() => tryAcquireN(1);

  IO<Unit> releaseN(int n);

  IO<Unit> release() => releaseN(1);

  Resource<Unit> permit();

  Resource<bool> tryPermit() => Resource.make(
      tryAcquire(), (acquired) => IO.whenA(acquired, () => release()));
}

final class Request {
  final int n;
  final Deferred<Unit> gate;

  const Request(this.n, this.gate);

  Request of(int newN) => Request(newN, gate);

  IO<Unit> wait() => gate.value();

  IO<bool> complete() => gate.complete(Unit());
}

final class _State {
  final int permits;
  final IQueue<Request> waiting;

  const _State(this.permits, this.waiting);
}

enum _Action { wait, done }

final class _SemaphoreImpl extends Semaphore {
  final Ref<_State> state;

  _SemaphoreImpl(this.state);

  IO<Request> newRequest() => IO.deferred<Unit>().map((a) => Request(0, a));

  @override
  IO<Unit> acquireN(int n) {
    if (n == 0) {
      return IO.unit;
    } else {
      return IO.uncancelable((poll) {
        return newRequest().flatMap((req) {
          return state.modify((currentState) {
            late _State newState;
            late _Action decision;

            if (currentState.waiting.nonEmpty) {
              newState = _State(0, currentState.waiting.enqueue(req.of(n)));
              decision = _Action.wait;
            } else {
              final diff = currentState.permits - n;

              if (diff >= 0) {
                newState = _State(diff, IQueue.empty());
                decision = _Action.done;
              } else {
                newState = _State(0, iqueue([req.of(diff.abs())]));
                decision = _Action.wait;
              }
            }

            final cleanup = state.modify((currentState) {
              // both hold correctly even if the Request gets canceled
              // after having been fulfilled
              final permitsAcquiredSoFar = n -
                  currentState.waiting
                      .find((x) => x == req)
                      .map((req) => req.n)
                      .getOrElse(() => 0);

              final waitingNow =
                  currentState.waiting.filterNot((x) => x == req);

              // releaseN is commutative, the separate Ref access is ok
              return (
                _State(currentState.permits, waitingNow),
                releaseN(permitsAcquiredSoFar)
              );
            }).flatten();

            final action = switch (decision) {
              _Action.done => IO.unit,
              _Action.wait => poll(req.wait()).onCancel(cleanup),
            };

            return (newState, action);
          }).flatten();
        });
      });
    }
  }

  @override
  IO<int> available() => state.value().map((s) => s.permits);

  @override
  IO<int> count() => state.value().map((state) {
        if (state.waiting.nonEmpty) {
          return -state.waiting.map((req) => req.n).sum();
        } else {
          return state.permits;
        }
      });

  @override
  Resource<Unit> permit() =>
      Resource.makeFull((poll) => poll(acquire()), (_) => release());

  @override
  IO<Unit> releaseN(int n) {
    // TODO: tailrec
    (int, IQueue<Request>, IQueue<Request>) fulfil(
      int n,
      IQueue<Request> requests,
      IQueue<Request> wakeup,
    ) {
      final (req, tail) = requests.dequeue();

      if (n < req.n) {
        // partially fulfil one request
        // return (0, req.of(req.n - n) +: tail, wakeup);
        return (0, tail.prepended(req.of(req.n - n)), wakeup);
      } else {
        // fulfil as many requests as `n` allows
        final newN = n - req.n;
        final newWakeup = wakeup.enqueue(req);

        if (tail.isEmpty || newN == 0) {
          return (newN, tail, newWakeup);
        } else {
          return fulfil(newN, tail, newWakeup);
        }
      }
    }

    if (n == 0) {
      return IO.unit;
    } else {
      return state.flatModify((currentState) {
        if (currentState.waiting.isEmpty) {
          return (
            _State(currentState.permits + n, currentState.waiting),
            IO.unit
          );
        } else {
          final (newN, waitingNow, wakeup) =
              fulfil(n, currentState.waiting, IQueue.empty());

          return (
            _State(newN, waitingNow),
            wakeup.toIList().traverseIO_((req) => req.complete())
          );
        }
      });
    }
  }

  @override
  IO<bool> tryAcquireN(int n) {
    if (n == 0) {
      return IO.pure(true);
    } else {
      return state.modify((state) {
        final permits = state.permits;

        if (permits >= n) {
          return (_State(permits - n, state.waiting), true);
        } else {
          return (state, false);
        }
      });
    }
  }
}
