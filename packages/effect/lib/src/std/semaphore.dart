import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

/// A purely functional semaphore for controlling concurrent access to a
/// shared resource.
///
/// A [Semaphore] maintains a count of available permits. Fibers can
/// [acquire] permits (blocking if none are available) and [release] them
/// when done. The [permit] method provides a [Resource]-based API that
/// automatically releases the permit when the scope exits.
///
/// Supports both single-permit ([acquire]/[release]) and multi-permit
/// ([acquireN]/[releaseN]) operations.
abstract class Semaphore {
  /// Creates a [Semaphore] with [n] available permits.
  ///
  /// Throws an [ArgumentError] if [n] is negative.
  static IO<Semaphore> permits(int n) {
    if (n < 0) {
      throw ArgumentError('n must be nonnegative, was: $n');
    }

    return IO.ref(_State(n, IQueue.empty())).map(_SemaphoreImpl.new);
  }

  /// Returns the number of permits currently available.
  IO<int> available();

  /// Returns the number of permits currently available, or the negated
  /// number of permits being waited on if the semaphore is over-subscribed.
  IO<int> count();

  /// Acquires [n] permits, blocking (semantically) until they are available.
  IO<Unit> acquireN(int n);

  /// Acquires a single permit, blocking (semantically) until one is
  /// available.
  IO<Unit> acquire() => acquireN(1);

  /// Attempts to acquire [n] permits without blocking.
  ///
  /// Returns `true` if the permits were acquired, `false` otherwise.
  IO<bool> tryAcquireN(int n);

  /// Attempts to acquire a single permit without blocking.
  ///
  /// Returns `true` if the permit was acquired, `false` otherwise.
  IO<bool> tryAcquire() => tryAcquireN(1);

  /// Releases [n] permits back to the semaphore, potentially unblocking
  /// waiting fibers.
  IO<Unit> releaseN(int n);

  /// Releases a single permit back to the semaphore.
  IO<Unit> release() => releaseN(1);

  /// Returns a [Resource] that acquires a single permit on use and releases
  /// it on finalization.
  Resource<Unit> permit();

  /// Returns a [Resource] that attempts to acquire a single permit.
  ///
  /// The resource value is `true` if the permit was acquired. The permit
  /// is released on finalization only if it was actually acquired.
  Resource<bool> tryPermit() =>
      Resource.make(tryAcquire(), (acquired) => release().whenA(acquired));
}

final class _Request {
  final int n;
  final Deferred<Unit> gate;

  const _Request(this.n, this.gate);

  _Request of(int newN) => _Request(newN, gate);

  IO<Unit> wait() => gate.value();

  IO<bool> complete() => gate.complete(Unit());
}

final class _State {
  final int permits;
  final IQueue<_Request> waiting;

  const _State(this.permits, this.waiting);
}

enum _Action { wait, done }

final class _SemaphoreImpl extends Semaphore {
  final Ref<_State> state;

  _SemaphoreImpl(this.state);

  IO<_Request> _newRequest() => IO.deferred<Unit>().map((a) => _Request(0, a));

  @override
  IO<Unit> acquireN(int n) {
    if (n == 0) {
      return IO.unit;
    } else {
      return IO.uncancelable((poll) {
        return _newRequest().flatMap((req) {
          return state.modify((currentState) {
            final _State newState;
            final _Action decision;

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

            final cleanup =
                state.modify((currentState) {
                  // both hold correctly even if the Request gets canceled
                  // after having been fulfilled
                  final permitsAcquiredSoFar =
                      n -
                      currentState.waiting
                          .find((x) => x == req)
                          .map((req) => req.n)
                          .getOrElse(() => 0);

                  final waitingNow = currentState.waiting.filterNot((x) => x == req);

                  // releaseN is commutative, the separate Ref access is ok
                  return (_State(currentState.permits, waitingNow), releaseN(permitsAcquiredSoFar));
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
  Resource<Unit> permit() => Resource.makeFull((poll) => poll(acquire()), (_) => release());

  @override
  IO<Unit> releaseN(int n) {
    (int, IQueue<_Request>, IQueue<_Request>) fulfill(
      int n,
      IQueue<_Request> requests,
      IQueue<_Request> wakeup,
    ) {
      var currentN = n;
      var currentRequests = requests;
      var currentWakeup = wakeup;

      while (true) {
        final (req, tail) = currentRequests.dequeue();

        if (currentN < req.n) {
          // partially fulfil one request
          return (0, tail.prepended(req.of(req.n - currentN)), currentWakeup);
        } else {
          // fulfil as many requests as `n` allows
          currentN = currentN - req.n;
          currentWakeup = currentWakeup.enqueue(req);

          if (tail.isEmpty || currentN == 0) {
            return (currentN, tail, currentWakeup);
          } else {
            currentRequests = tail;
          }
        }
      }
    }

    if (n == 0) {
      return IO.unit;
    } else {
      return state.flatModify((currentState) {
        if (currentState.waiting.isEmpty) {
          return (_State(currentState.permits + n, currentState.waiting), IO.unit);
        } else {
          final (newN, waitingNow, wakeup) = fulfill(n, currentState.waiting, IQueue.empty());

          return (_State(newN, waitingNow), wakeup.toIList().traverseIO_((req) => req.complete()));
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
