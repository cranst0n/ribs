---
sidebar_position: 10
---


# Rill

`Rill<O>` is Ribs' **purely functional, effect-ful stream** type. It lazily
describes a sequence of zero or more values of type `O`, where producing each
value may involve arbitrary `IO` effects.

## Motivation: why not Dart's `Stream`?

Dart's built-in `Stream` is fine for simple event handling, but its properties
make it unsuitable for purely functional programs.

**Eagerness.** Subscribing to a `Stream` starts effects immediately — you
cannot pass a stream around as a value without the work already being in
flight.

```dart
// The HTTP request starts the moment this line runs
final stream = Stream.fromFuture(fetchUserFromDatabase(id));
```

**Single subscription.** Most Dart streams can only be listened to once.
Reusing or composing them requires broadcasting boilerplate.

**Manual resource management.** There is no built-in way to tie a resource's
lifetime — a file, a socket, a database connection — to a stream's lifecycle.
Forgetting to close a `StreamController` or cancel a subscription silently
leaks resources.

**Awkward `IO` integration.** Mixing `async`/`await` with stream combinators
requires leaving the pure model, resulting in scattered callbacks and
`async*` generators.

`Rill` addresses all of these:

| | Dart `Stream` | `Rill` |
|---|---|---|
| Evaluation | Eager — effects start on subscribe | Lazy — just a description |
| Referential transparency | No | Yes |
| Resource safety | Manual | Built-in `bracket` |
| Effect model | `async`/`await` + callbacks | `IO` throughout |
| Reuse | Single-subscription by default | Compile as many times as needed |
| Concurrency | Limited | Fine-grained `parEvalMap` and `merge` |

## What is a Rill?

A `Rill<O>` is a **lazy, pure description** of a stream of `O` values. Nothing
runs until you call `.compile` and then execute the resulting `IO`:

```dart
// A Rill is inert — no effects have run
final rill = Rill.range(1, 6).map((int n) => n * 2);

// compile produces an IO that, when run, collects the elements
final io = rill.compile.toIList;

// The actual work only happens when the IO is run (e.g. unsafeRunFuture())
```

Because a `Rill` is referentially transparent, you can pass it to functions,
store it in a variable, and compile it more than once — each compilation
produces an independent `IO` that runs the full pipeline from scratch.

Internally, `Rill<O>` wraps `Pull<O, Unit>`, a trampolined computation that
emits `Chunk<O>` values and is stack-safe regardless of rill length. You
rarely work with `Pull` directly; `Rill` exposes a high-level API on top of it.

## Relationship to IO

Every terminal operation on a `Rill` returns an `IO`:

| Terminal | Returns | Description |
|---|---|---|
| `compile.toIList` | `IO<IList<O>>` | Collect all elements |
| `compile.drain` | `IO<Unit>` | Run for effects, discard results |
| `compile.fold(init, f)` | `IO<B>` | Reduce to a single value |
| `compile.count` | `IO<int>` | Count elements |
| `compile.last` | `IO<Option<O>>` | Get the last element |

This means a `Rill` pipeline always runs inside IO's fiber system, inheriting
IO's cancellation, error handling, and concurrency semantics. It composes
naturally with every other IO primitive: `Ref`, `Deferred`, `Semaphore`, etc.

Effects within the rill are expressed with `evalMap` and `evalTap`, which
lift `IO` actions into the pipeline without breaking the pure model.

---

## Creating a Rill

<<< @/../snippets/lib/src/rill/rill.dart#rill-create

Other useful constructors:

| Constructor | Description |
|---|---|
| `Rill.chunk(chunk)` | Emit an entire `Chunk<O>` |
| `Rill.unfold(s, f)` | Stateful generation: `S → Option<(O, S)>` |
| `Rill.unfoldEval(s, f)` | Same but `f` returns `IO<Option<(O, S)>>` |
| `Rill.fromStream(stream)` | Wrap a Dart `Stream` |
| `Rill.resource(resource)` | Emit the value produced by a `Resource` |
| `Rill.fixedRate(period)` | Emit `Unit` at a fixed interval |
| `Rill.never` | A rill that never emits or terminates |

## Transforming a Rill

<<< @/../snippets/lib/src/rill/rill.dart#rill-transform

`scan` is an _inclusive_ prefix-fold: it emits the initial accumulator
followed by each intermediate result, making the running state visible as a
rill element.

A selection of the most commonly used combinators:

| Combinator | Description |
|---|---|
| `map(f)` | Transform each element |
| `flatMap(f)` | Map then flatten (each element expands into a sub-rill) |
| `filter(pred)` | Keep elements satisfying `pred` |
| `take(n)` / `drop(n)` | First / skip *n* elements |
| `takeWhile(pred)` | Take while predicate holds |
| `scan(init, f)` | Emit running accumulated state |
| `zipWithIndex()` | Pair each element with its index |
| `changes()` | Emit only when the value differs from the previous |
| `concat` | Append one rill after another |

:::info
These are only the most common combinators `Rill` provides. Review the API docs
to get the full picture of what is provided.
:::

## IO effects in a Rill

<<< @/../snippets/lib/src/rill/rill.dart#rill-effects

`evalTap` is the rill equivalent of `flatTap` on `IO` — it executes a
side-effect per element and passes the original element downstream unchanged.
Use it for logging, metrics, or state updates that should not alter the rill
type.

## Resource safety

`Rill.bracket(acquire, release)` ties a resource's lifetime to the rill's
lifetime. The release action runs **unconditionally** when the rill ends —
whether it completes normally, raises an error, or is canceled by the fiber
runtime.

<<< @/../snippets/lib/src/rill/rill.dart#rill-resource

:::tip
For attaching a finalizer at an arbitrary point in the pipeline rather than at
the source, use `rill.onFinalize(io)`. For access to the `ExitCase`
(succeeded / errored / canceled), use `rill.onFinalizeCase(f)`.
:::

## Interruption

Any `Rill` can be stopped early — cleanly, without leaking resources — using
one of the interrupt combinators. When a rill is interrupted, all `bracket`
finalizers and `onFinalize` hooks still run, exactly as they do on normal
completion.

| Combinator | Stops when |
|---|---|
| `interruptAfter(duration)` | A fixed duration elapses |
| `interruptWhen(io)` | An `IO<B>` completes (success or error) |
| `interruptWhenTrue(rill)` | A `Rill<bool>` emits `true` |
| `interruptWhenSignaled(signal)` | A `Signal<bool>` becomes `true` |

<<< @/../snippets/lib/src/rill/rill.dart#rill-interrupt

`interruptWhen(io)` is the most flexible form. Passing a `Deferred.value()`
as the signal gives any other fiber a handle to stop the rill on demand —
a clean alternative to canceling the whole fiber. The rill drains whatever
it has already produced before halting.

---

## Concurrency with `parJoin`

`parEvalMap` covers the common case of applying one IO-valued function to
each element concurrently. For more general concurrency — where each element
expands into a **multi-element sub-rill** — use `parJoin`.

`parJoin` lives on `Rill<Rill<O>>`. It subscribes to up to `maxOpen` inner
rills simultaneously and merges their outputs into a single rill. Results
arrive in **completion order**: whichever inner rill emits next appears next,
regardless of its position in the outer rill.

### Fixed set of concurrent rills

<<< @/../snippets/lib/src/rill/rill.dart#rill-par-join

All three sources run concurrently from the moment `parJoin` starts. Fast
sources do not wait for slow ones; the merged rill ends only after every
inner rill has completed.

### Dynamic concurrency with `flatMap` + `parJoin`

`flatMap` + `parJoin` is the general pattern when the number of inner rills
is not known up front or each outer element should fan out into multiple values.

<<< @/../snippets/lib/src/rill/rill.dart#rill-par-join-dynamic

:::info
`rill.parEvalMap(n, f)` is exactly `rill.map((o) => Rill.eval(f(o))).parJoin(n)`.
Use `parEvalMap` for the one-IO-per-element case; reach for `flatMap` +
`parJoin` when each element should produce a full sub-rill.
:::

### Error propagation and cancellation

If any inner rill raises an error, `parJoin` immediately cancels all
remaining inner rills and propagates the error to the outer rill. If the
outer rill itself is interrupted (e.g. via `interruptAfter`), all running
inner rills are canceled before the combined rill terminates.

`parJoinUnbounded()` is a convenience alias for `parJoin(Integer.MaxValue)` —
use it when you know the number of inner rills is bounded by the outer rill
and you do not need an explicit cap.

---

## Real-world example: parallel fetch pipeline

A common pattern is to fan out work across many concurrent operations while
keeping the number of simultaneous in-flight requests bounded — preventing
resource exhaustion without sacrificing throughput.

`parEvalMap(maxConcurrent, f)` runs `f` on up to `maxConcurrent` elements
simultaneously and emits results **in request order**, so the downstream
pipeline sees a consistent ordering even though the work runs out-of-order.

<<< @/../snippets/lib/src/rill/rill.dart#rill-realworld

Because every step is an `IO`, the progress counter in the `Ref` is updated
atomically and the log output is correctly sequenced. The same code that
counts, logs, and collects results would be awkward to write correctly with
`Stream` and `async`/`await` — with `Rill` it follows directly from the
compositionality of `IO`.

:::tip
For cases where ordering does not matter and throughput is the priority, swap
`parEvalMap` for `parEvalMapUnordered`. To run a background rill concurrently
with the main pipeline, see `rill.concurrently(other)`.
:::
