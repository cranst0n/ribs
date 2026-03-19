// ignore_for_file: unused_local_variable

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';

// rill-create
IO<Unit> rillCreate() {
  // Rill.emits: emit from a fixed Dart list
  final fromList = Rill.emits([1, 2, 3, 4, 5]);

  // Rill.range: lazily generate integers in [start, stopExclusive)
  final range = Rill.range(1, 11);

  // Rill.eval: embed a single IO as a one-element stream
  final fromIO = Rill.eval(IO.delay(() => DateTime.now().millisecondsSinceEpoch));

  // Rill.repeatEval: repeat an IO forever — combine with .take or .interruptAfter
  final ticks = Rill.repeatEval(IO.delay(() => DateTime.now()));

  // compile.toIList runs the Rill and collects all elements: IO<IList<O>>
  // compile.drain runs the Rill and discards results:        IO<Unit>
  return fromList
      .map((int n) => n * 2)
      .compile
      .toIList
      .flatMap((IList<int> xs) => IO.print('doubled: $xs'));
}
// rill-create

// rill-transform
IO<Unit> rillTransform() => Rill.range(1, 11) // 1  2  3  4  5  6  7  8  9  10
    .filter((int n) => n.isOdd) // 1  3  5  7  9
    .map((int n) => n * n) // 1  9  25 49 81
    .take(3) // 1  9  25
    .scan(0, (int acc, int n) => acc + n) // running sum: 0  1  10  35
    .compile
    .toIList
    .flatMap((IList<int> xs) => IO.print('sums: $xs')); // [0, 1, 10, 35]
// rill-transform

// rill-effects
IO<Unit> rillEffects() =>
    Rill.emits([1, 2, 3, 4, 5])
        // evalTap: execute an IO per element and pass the element through unchanged
        .evalTap((int n) => IO.print('input: $n'))
        // evalMap: replace each element with the result of an IO
        .evalMap((int n) => IO.pure(n * n))
        .evalTap((int n) => IO.print('squared: $n'))
        .compile
        .drain;
// rill-effects

// rill-resource
IO<Unit> rillResource() => Rill.bracket(
      // acquire: runs when the stream starts
      IO.print('opened connection').productR(() => IO.pure('conn')),
      // release: always runs when the stream ends — success, error, or cancellation
      (String conn) => IO.print('closed: $conn'),
    )
    .flatMap(
      (String conn) => Rill.emits([
        'query-1',
        'query-2',
        'query-3',
      ]).evalMap((String q) => IO.pure('[$conn] $q result')),
    )
    .compile
    .toIList
    .flatMap((IList<String> results) => IO.print('results: $results'));
// rill-resource

// rill-interrupt

// interruptAfter: stop the stream after a fixed wall-clock duration.
// Any elements already emitted are kept; the stream ends cleanly.
IO<IList<int>> interruptAfterExample() =>
    Rill.repeatEval(IO.delay(() => DateTime.now().millisecond))
        .metered(20.milliseconds) // emit one value every 20 ms
        .interruptAfter(110.milliseconds) // stop after ~110 ms ≈ 5 elements
        .compile
        .toIList;

// interruptWhen: stop the stream when an external IO completes.
// The IO can be a Deferred completed by another fiber — a clean shutdown signal.
IO<IList<int>> interruptWhenExample() => IO.deferred<Unit>().flatMap((stop) {
  final source = Rill.range(0, 1000)
      .evalMap((int n) => IO.sleep(20.milliseconds).as(n))
      .interruptWhen(stop.value()); // halts as soon as stop is completed

  // Complete `stop` from outside after 3 elements have had time to arrive
  final trigger = IO.sleep(70.milliseconds).productR(() => stop.complete(Unit()));

  return IO.both(source.compile.toIList, trigger).map((t) => t.$1);
});

// rill-interrupt

// rill-par-join

/// Run [inner] streams concurrently and merge their outputs.
///
/// [parJoin(n)] subscribes to at most [n] inner streams simultaneously.
/// Results arrive in **completion order** — faster inner streams
/// appear first regardless of their position in the outer stream.
IO<IList<String>> parJoinExample() {
  Rill<String> source(String name, int delayMs, int count) => Rill.range(
    1,
    count + 1,
  ).evalMap((int n) => IO.sleep(Duration(milliseconds: delayMs)).as('$name-$n'));

  return Rill.emits([
        source('slow', 40, 3), // emits at 40 ms intervals
        source('medium', 20, 4), // emits at 20 ms intervals
        source('fast', 10, 2), // emits at 10 ms intervals
      ])
      .parJoin(3) // run all three concurrently
      .compile
      .toIList; // elements arrive interleaved by speed
}

// rill-par-join

// rill-par-join-dynamic

/// [flatMap] produces one inner stream per element.
/// [parJoin] then runs those inner streams concurrently.
///
/// This is the general pattern behind [parEvalMap] — use it directly
/// when each element should expand into a multi-element sub-stream.
IO<IList<String>> dynamicParJoin() =>
    Rill.range(1, 6)
        .map(
          (int id) =>
          // Each element fans out into its own sub-stream of events
          Rill.range(1, 4).evalMap(
            (int ev) => IO.sleep(Duration(milliseconds: (6 - id) * 15)).as('source-$id/event-$ev'),
          ),
        )
        .parJoin(3) // at most 3 sub-streams active at once
        .compile
        .toIList;

// rill-par-join-dynamic

// rill-realworld

/// Simulate an async lookup — in practice an HTTP call or database query.
IO<String> fetchRecord(int id) =>
    IO.sleep(Duration(milliseconds: 20 + (id * 7) % 50)).productR(() => IO.pure('record_$id'));

/// Fetch [count] records with at most [maxConcurrent] in-flight at once.
///
/// Results are emitted in **request order** regardless of which fetch
/// finishes first. The running tally is tracked with a [Ref].
IO<IList<String>> parallelFetchPipeline({int count = 10, int maxConcurrent = 3}) => IO
    .ref(0)
    .flatMap(
      (Ref<int> completed) =>
          Rill.range(1, count + 1)
              // Dispatch up to [maxConcurrent] fetches concurrently.
              // Back-pressure prevents unbounded in-flight work.
              .parEvalMap(maxConcurrent, fetchRecord)
              // evalTap runs sequentially on the ordered output.
              .evalTap(
                (String record) => completed
                    .modify((int n) => (n + 1, n + 1))
                    .flatMap((int n) => IO.print('[$n/$count] $record')),
              )
              .compile
              .toIList,
    );

// rill-realworld
