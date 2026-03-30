// ignore_for_file: unused_local_variable

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

// #region basics
IO<Unit> basics() => Ref.of(0).flatMap(
  (counter) => counter
      .update((n) => n + 1)
      .flatMap((_) => counter.update((n) => n + 1))
      .flatMap((_) => counter.value())
      .flatMap((n) => IO.print('counter: $n')),
); // counter: 2
// #endregion basics

// #region modify
IO<Unit> modifyExample() => Ref.of(<String>[]).flatMap(
  (log) => log
      .modify((msgs) => ([...msgs, 'first'], Unit()))
      .flatMap((_) => log.modify((msgs) => ([...msgs, 'second'], Unit())))
      .flatMap((_) => log.value())
      .flatMap((msgs) => IO.print(msgs.toString())),
);
// #endregion modify

// #region get-and-set
IO<Unit> getAndSet() => Ref.of('initial').flatMap(
  (ref) => ref
      .getAndSet('updated')
      .flatMap((prev) => IO.print('was: $prev')) // was: initial
      .flatMap((_) => ref.value())
      .flatMap((cur) => IO.print('now: $cur')),
); // now: updated
// #endregion get-and-set

// #region concurrent-counter
/// Spawn [fibers] fibers, each incrementing [counter] [increments] times.
IO<int> concurrentCounter({int fibers = 10, int increments = 100}) => Ref.of(0).flatMap((counter) {
  // Each worker performs the update action, replicated `increments` times
  final worker = counter.update((n) => n + 1).replicate_(increments);

  // Start all fibers, collecting their handles
  return IList.fill(fibers, worker)
      .traverseIO((w) => w.start())
      .flatMap((fibers) => fibers.traverseIO_((f) => f.join()))
      .flatMap((_) => counter.value());
});
// #endregion concurrent-counter

// #region request-cache
/// A simple in-memory cache backed by a [Ref].
IO<String> fetchUser(int id) => IO.pure('user-$id');

IO<Unit> requestCacheExample() {
  final emptyCache = <int, String>{};

  return Ref.of(emptyCache).flatMap((cache) {
    // Look up the cache; fetch and store on miss.
    IO<String> cachedFetch(int id) => cache.value().flatMap(
      (map) =>
          map.containsKey(id)
              ? IO.pure(map[id]!)
              : fetchUser(
                id,
              ).flatMap((user) => cache.update((m) => {...m, id: user}).map((_) => user)),
    );

    return cachedFetch(1)
        .flatMap((_) => cachedFetch(1)) // cache hit
        .flatMap((_) => cachedFetch(2))
        .flatMap((_) => cache.value())
        .flatMap((m) => IO.print('cache: $m'));
  });
}
// #endregion request-cache
