// ignore_for_file: unused_local_variable

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_rill/ribs_rill.dart';

// #region pull-anatomy
IO<Unit> pullAnatomy() {
  // Pull.pure: return a result with no output
  final pureResult = Pull.pure(42); // Pull<Never, int>

  // Pull.output: emit a Chunk with no result (Unit)
  final emitChunk = Pull.output(Chunk.fromList([1, 2, 3])); // Pull<int, Unit>

  // Pull.eval: run an IO and return its result
  final fromIO = Pull.eval(IO.delay(() => 'hello')); // Pull<Never, String>

  // Pull.fail: raise an error immediately
  final failed = Pull.fail('something went wrong'); // Pull<Never, Never>

  // Chain: emit a chunk, then emit another chunk, then stop
  final chained = Pull.output(
    Chunk.fromList([1, 2]),
  ).append<int, Unit>(() => Pull.output(Chunk.fromList([3, 4])));

  // Convert Pull<O, Unit> → Rill<O> via .rill (adds a resource scope)
  // or .rillNoScope (no scope — used for combinators that manage scope externally)
  final asRill = chained.rill; // Rill<int>

  return asRill.compile.toIList.flatMap((IList<int> xs) => IO.print('from pull: $xs'));
}
// #endregion pull-anatomy

// #region pull-custom-combinator
/// Keeps only every [step]th element starting at index 0: indices 0, step, 2*step, …
///
/// This is the same result as:
///   rill.zipWithIndex().filter((t) => t.$2 % step == 0).map((t) => t.$1)
///
/// Written with Pull to demonstrate the low-level API.
Rill<O> takeEvery<O>(Rill<O> rill, int step) {
  // Build a recursive Pull that carries the current index through each chunk.
  Pull<O, Unit> go(ToPull<O> tp, int idx) {
    // uncons: atomically peek at the next Chunk and the remaining Rill.
    // Returns Pull<Never, Option<(Chunk<O>, Rill<O>)>>.
    // flatMap<O, Unit> widens the output type from Never → O (safe: Never <: O).
    return tp.uncons.flatMap<O, Unit>((opt) {
      return opt.fold(
        // Empty stream — return Pull.pure(Unit()) to signal completion.
        () => Pull.pure(Unit()),
        (pair) {
          final (Chunk<O> chunk, Rill<O> tail) = pair;

          // Select elements at positions that are multiples of [step].
          final kept = Chunk.fromList([
            for (var i = 0; i < chunk.size; i++)
              if ((idx + i) % step == 0) chunk[i],
          ]);

          // Pull.output emits [kept], then append<O, Unit> chains the next step.
          // append's unsafe cast widens Pull<O, Unit> to Pull<O, Unit> — trivially safe here.
          return Pull.output(kept).append<O, Unit>(
            () => go(tail.pull, idx + chunk.size),
          );
        },
      );
    });
  }

  // rillNoScope wraps the Pull without adding an extra resource scope.
  // Use .rill instead if the Pull acquires resources via Pull.acquire.
  return go(rill.pull, 0).rillNoScope;
}

IO<Unit> customCombinatorExample() => takeEvery(
  Rill.range(0, 10),
  3,
).compile.toIList.flatMap((IList<int> xs) => IO.print('every 3rd: $xs')); // [0, 3, 6, 9]
// #endregion pull-custom-combinator
