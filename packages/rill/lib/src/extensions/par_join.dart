import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';

extension ParJoinOps<O> on Rill<Rill<O>> {
  Rill<O> parJoinUnbounded() => parJoin(Integer.MaxValue);

  /// Runs [maxOpen] inner streams concurrently.
  ///
  /// - Waits for all inner streams to finish.
  /// - If any stream fails, the error is propagated and all other streams are cancelled.
  /// - If the output stream is interrupted, all running streams are cancelled.
  Rill<O> parJoin(int maxOpen) {
    // We need 4 pieces of shared state:
    // 1. Q: The channel for data and errors.
    // 2. Sem: Limits concurrency.
    // 3. Count: Tracks how many streams (including outer) are active.
    // 4. Fibers: Tracks running fibers for cancellation.
    final setup =
        (
          Queue.unbounded<Either<Object, Option<O>>>(),
          Semaphore.permits(maxOpen),
          Ref.of<int>(1), // Start at 1 to account for the "Outer" driver stream
          Ref.of<IList<IOFiber<void>>>(IList.empty()),
        ).tupled;

    return Rill.eval(setup).flatMap((state) {
      final (queue, semaphore, activeCount, activeFibers) = state;

      // --- Helpers ---

      // Decrements active count. If 0, signals "Done" to the queue.
      final decrementActive = activeCount.update((n) => n - 1).flatMap((_) {
        return activeCount.value().flatMap((n) => n == 0 ? queue.offer(Right(none())) : IO.unit);
      });

      // Registers a fiber so we can cancel it later.
      IO<Unit> register(IOFiber<void> f) => activeFibers.update((l) => l.prepended(f));

      // Deregisters a fiber when it finishes naturally (to keep list small).
      IO<Unit> deregister(IOFiber<void> f) => activeFibers.update((l) => l.filter((x) => x != f));

      // --- Inner Stream Runner ---

      IO<Unit> runInner(Rill<O> inner) {
        return inner
            .map((o) => Right<Object, Option<O>>(Some(o))) // Wrap data
            .evalMap(queue.offer) // Push to queue
            .compile
            .drain
            .handleErrorWith((err) => queue.offer(Left(err))) // Push error
            .guarantee(semaphore.release().productL(() => decrementActive)); // Cleanup
      }

      // --- The Driver (Outer Stream) ---

      final driver = evalMap((innerStream) {
            return semaphore.acquire().flatMap((_) {
              return activeCount.update((n) => n + 1).flatMap((_) {
                // Start inner stream
                return runInner(innerStream).start().flatMap((fiber) {
                  // Register fiber and attach deregistration hook
                  return register(fiber).productL(
                    () =>
                        // We don't await the fiber here, but we attach a hook to remove it from list when done
                        fiber.join().flatMap((_) => deregister(fiber)).start(),
                  );
                });
              });
            });
          }).compile.drain
          .handleErrorWith((err) => queue.offer(err.asLeft()))
          .guarantee(decrementActive); // Outer stream is done

      // --- Cleanup Logic ---

      // If the downstream consumer stops or fails, we must cancel everything.
      final cancelAll = activeFibers.value().flatMap((list) => list.traverseIO((f) => f.cancel()));

      return Rill.bracket(
        driver.start(),
        (driverFiber) => driverFiber.cancel().productL(() => cancelAll),
      ).flatMap((_) {
        return _consumeParJoinQueue(queue);
      });
    });
  }

  Rill<O> _consumeParJoinQueue(Queue<Either<Object, Option<O>>> q) {
    return Rill.eval(q.take()).flatMap((event) {
      return event.fold(
        (err) => Rill.eval(IO.raiseError(err)), // Failure: Propagate error
        (opt) => opt.fold(
          () => Rill.empty(), // Done: Right(None)
          (data) => Rill.pure(data) + _consumeParJoinQueue(q), // Data: Right(Some)
        ),
      );
    });
  }
}
