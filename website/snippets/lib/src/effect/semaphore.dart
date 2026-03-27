// ignore_for_file: unused_local_variable

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

// semaphore-basic
/// A Semaphore(2) allows up to 2 fibers to hold a permit simultaneously.
/// The third `acquire` suspends until one of the first two calls `release`.
IO<Unit> semaphoreBasic() => Semaphore.permits(2).flatMap((sem) {
  IO<Unit> task(String name) =>
      sem.acquire().productR(IO.print('$name: running')).guarantee(sem.release());

  return ilist([task('A'), task('B'), task('C')]).parSequence_();
});
// semaphore-basic

// semaphore-permit
/// `permit()` returns a `Resource<Unit>` that acquires on open and releases
/// on close, even if the body raises an error or is canceled.
IO<Unit> semaphorePermit() => Semaphore.permits(1).flatMap(
  (sem) => sem.permit().use((_) => IO.print('inside critical section')),
);

/// `surround` is a convenient shorthand when the body doesn't need the permit value.
IO<Unit> semaphoreSurround() => Semaphore.permits(1).flatMap(
  (sem) => sem.permit().surround(IO.print('inside critical section')),
);
// semaphore-permit

// semaphore-rate-limit

/// Simulate fetching [count] URLs, but allow at most [maxConcurrent]
/// in-flight at any one time.
IO<Unit> rateLimitedFetches({int count = 10, int maxConcurrent = 3}) =>
    Semaphore.permits(maxConcurrent).flatMap((sem) {
      IO<Unit> fetch(int id) => sem.permit().surround(
        IO
            .print('fetch $id: start')
            .productR(IO.sleep(50.milliseconds))
            .productR(IO.print('fetch $id: done')),
      );

      return ilist(List.generate(count, (int i) => i + 1)).parTraverseIO_(fetch);
    });

// semaphore-rate-limit
