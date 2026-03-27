import 'dart:async';

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

/// Provides an unsafe API for running [IO] effects from outside the [IO]
/// world, bridging purely functional code to callback-based or
/// [Future]-based interfaces.
///
/// A [Dispatcher] is created as a [Resource] that scopes the lifecycle of
/// any effects submitted to it. On finalization, active effects are either
/// awaited or canceled depending on [waitForAll].
///
/// Two execution modes are available:
/// - [parallel]: each submitted effect runs as its own fiber concurrently.
/// - [sequential]: submitted effects are queued and run one at a time in
///   FIFO order by a single worker fiber.
abstract class Dispatcher {
  /// Submits [fa] for execution and returns a [Future] that resolves to the
  /// result along with a cancel function.
  (Future<A>, Function0<Future<Unit>>) unsafeToFutureCancelable<A>(IO<A> fa);

  /// Submits [fa] for execution and returns a [Future] that resolves to the
  /// result.
  Future<A> unsafeToFuture<A>(IO<A> fa) => unsafeToFutureCancelable(fa).$1;

  /// Submits [fa] for execution and returns a function to cancel it.
  Function0<Future<Unit>> unsafeRunCancelable<A>(IO<A> fa) => unsafeToFutureCancelable(fa).$2;

  /// Submits [fa] for execution, discarding the result. Fire-and-forget.
  void unsafeRunAndForget<A>(IO<A> fa) {
    unsafeToFutureCancelable(fa);
  }

  /// Creates a parallel [Dispatcher] where each submitted effect runs as its
  /// own fiber concurrently.
  ///
  /// If [waitForAll] is true, finalization waits for all active effects to
  /// complete. If false (the default), active effects are canceled.
  static Resource<Dispatcher> parallel({bool waitForAll = false}) {
    return Resource.make(
      IO.delay(() => _ParallelDispatcher()),
      (dispatcher) {
        final impl = dispatcher as _ParallelDispatcher;

        // Defer all mutations into IO so they only run at finalization time,
        // not when Resource.make calls release(d) eagerly to build the IO.
        return IO
            .delay(() {
              final active = impl._active ?? {};
              impl._active = null; // mark as finalized

              return active;
            })
            .flatMap((Map<int, (Future<dynamic>, Function0<Future<Unit>>)> active) {
              if (active.isEmpty) {
                return IO.unit;
              } else if (waitForAll) {
                // Wait for all active futures, ignoring errors (canceled = error).
                final silenced =
                    active.values.map((e) => e.$1.then((_) => null, onError: (_) => null)).toList();

                return IO.fromFutureF(() => Future.wait(silenced).then((_) => Unit()));
              } else {
                // Cancel all fibers concurrently.
                return active.values.fold<IO<Unit>>(
                  IO.unit,
                  (IO<Unit> acc, (Future<dynamic>, Function0<Future<Unit>>) e) =>
                      IO.both(acc, IO.fromFutureF(e.$2)).voided(),
                );
              }
            });
      },
    );
  }

  /// Creates a sequential [Dispatcher] where submitted effects are run in
  /// FIFO order by a single worker fiber.
  ///
  /// If [waitForAll] is true, finalization drains the queue and waits for
  /// all pending effects to complete before stopping. If false (the default),
  /// the worker is stopped immediately.
  ///
  /// Note: individual task cancellation sets a skip flag. If the task has
  /// already started running, it continues but its result is discarded.
  static Resource<Dispatcher> sequential({bool waitForAll = false}) {
    return Resource.eval(Queue.unbounded<IO<Unit>>()).flatMap(
      (queue) {
        final worker =
            queue.take().flatMap((task) => task.handleErrorWith((_) => IO.unit)).foreverM();

        return Resource.make(
          worker.start(),
          (workerFiber) {
            if (!waitForAll) {
              return workerFiber.cancel();
            } else {
              // Yield first so any pending unsafeRunFuture offer calls can
              // complete and their tasks are in the queue before the sentinel.
              return IO.cede.productR(
                Deferred.of<Unit>().flatMap((sentinel) {
                  return queue
                      .offer(sentinel.complete(Unit()).voided())
                      .productR(sentinel.value())
                      .productR(workerFiber.cancel());
                }),
              );
            }
          },
        ).map((_) => _SequentialDispatcher(queue));
      },
    );
  }
}

/// Parallel implementation
class _ParallelDispatcher extends Dispatcher {
  // Null means dispatcher is finalized. Maps id → (resultFuture, cancelFn).
  // Use a plain Dart map for synchronous access from unsafeToFutureCancelable.
  Map<int, (Future<dynamic>, Function0<Future<Unit>>)>? _active = {};

  int _nextId = 0;

  void _remove(int id) => _active?.remove(id);

  @override
  (Future<A>, Function0<Future<Unit>>) unsafeToFutureCancelable<A>(IO<A> fa) {
    final active = _active;

    if (active == null) throw StateError('Dispatcher finalized');

    final id = _nextId++;
    final (future, rawCancel) = fa.unsafeRunFutureCancelable();

    // Track this fiber and auto-remove when done. Attaching an error handler
    // here also prevents unhandled-rejection warnings if the caller discards
    // the returned future and the fiber is later canceled.
    active[id] = (future, rawCancel);

    future.then((_) => _remove(id), onError: (_) => _remove(id));

    Future<Unit> cancel() {
      _remove(id);
      return rawCancel();
    }

    return (future, cancel);
  }
}

/// Sequential implementation
class _SequentialDispatcher extends Dispatcher {
  final Queue<IO<Unit>> _queue;

  _SequentialDispatcher(this._queue);

  @override
  (Future<A>, Function0<Future<Unit>>) unsafeToFutureCancelable<A>(IO<A> fa) {
    final resultDeferred = Deferred.unsafe<Either<Object, A>>();
    final skipRef = Ref.unsafe(false);

    // The actual task enqueued for the worker to execute.
    final task = skipRef.value().flatMap((skip) {
      if (skip) {
        return resultDeferred.complete(Left(Exception('Dispatcher task canceled'))).voided();
      } else {
        return fa.attempt().flatMap((r) => resultDeferred.complete(r).voided());
      }
    });

    // Enqueue — fire and forget since we're outside IO.
    _queue.offer(task).unsafeRunFuture();

    final resultFuture =
        resultDeferred
            .value()
            .flatMap(
              (either) => either.fold(
                (err) => IO.raiseError<A>(err),
                (val) => IO.pure(val),
              ),
            )
            .unsafeRunFuture();

    // Cancel: set the skip flag and attempt to complete the deferred with an
    // error. If the task has already run, the complete() call is a no-op.
    Future<Unit> cancel() =>
        skipRef
            .setValue(true)
            .productR(
              resultDeferred.complete(Left(Exception('Dispatcher task canceled'))).voided(),
            )
            .unsafeRunFuture();

    return (resultFuture, cancel);
  }
}
