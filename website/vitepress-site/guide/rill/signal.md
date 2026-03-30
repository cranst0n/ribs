---
sidebar_position: 70
---


# Signal

A `Signal<A>` is **observable state** — a value that can be read at any time
and also observed as a stream. Where a plain `Ref<A>` only lets you read and
write, a `Signal` additionally lets you subscribe to changes via a `Rill`.

```dart
abstract class Signal<A> {
  IO<A> value();                   // read the current value
  Rill<A> get discrete;            // stream of changes (deduped)
  Rill<A> get continuous;          // stream of snapshots (every poll)
  IO<Unit> waitUntil(Function1<A, bool> p);  // block until condition holds
  Signal<B> map<B>(Function1<A, B> f);       // derived signal
}
```

`SignallingRef<A>` is the concrete read-write implementation. It extends both
`Ref<A>` and `Signal<A>`, giving you atomic updates alongside stream
observation.

## When to use a Signal

| Use case | Recommended type |
|---|---|
| Cancellation token — stop a rill from outside | `Signal<bool>` + `interruptWhenSignaled` |
| Pause / resume a rill | `Signal<bool>` + `pauseWhenSignal` |
| Live progress counter observed by multiple fibers | `SignallingRef<int>` |
| Read-only view of changing state | `Signal<A>` (from `map` or `holdResource`) |
| Convert a `Rill` into always-readable state | `Rill.holdResource` |

## Creating a SignallingRef

`SignallingRef.of(initial)` returns `IO<SignallingRef<A>>`. Because
`SignallingRef` extends `Ref`, all the familiar atomic operations are
available — `update`, `modify`, `getAndUpdate`, etc.

<<< @/../snippets/lib/src/rill/signal.dart#signal-basics

`map` produces a derived `Signal` whose observed value is the result of
applying the function to the underlying signal's current value. The mapping is
lazy — it runs on every read, not at construction time.

## Observing changes: `discrete` vs `continuous`

### `discrete` — emit on change

`discrete` emits the current value immediately, then emits again each time the
value changes. If the producer updates the signal faster than the consumer
reads, intermediate values are **dropped** — the consumer always receives the
latest value, never a stale one.

<<< @/../snippets/lib/src/rill/signal.dart#signal-discrete

Use `discrete` for event-driven consumers: UI updates, progress logging,
threshold alerts. The guarantee that you always see the *latest* value (rather
than every intermediate value) is usually exactly what you want.

### `continuous` — emit on every poll

`continuous` emits the current value on every element poll without waiting for
a change. Use it for polling-based consumers that need a consistent snapshot
rate regardless of how often the underlying value changes.

<<< @/../snippets/lib/src/rill/signal.dart#signal-continuous

## Cancellation: `interruptWhenSignaled`

`Signal<bool>` is the standard cancellation-token pattern for `Rill`. The
rill does not need to know who signals the stop or when — it simply observes
the signal and terminates when it becomes `true`.

<<< @/../snippets/lib/src/rill/signal.dart#signal-interrupt

Related rill methods that accept a `Signal<bool>`:

| Method | Behaviour |
|---|---|
| `rill.interruptWhenSignaled(signal)` | Terminate when signal becomes `true` |
| `rill.pauseWhenSignal(signal)` | Suspend while signal is `true`; resume when `false` |

## Waiting for a condition

`signal.waitUntil(predicate)` is a convenience method that blocks the calling
fiber until the signal's value satisfies the predicate:

```dart
// Block until at least 100 items have been processed.
await itemCount.waitUntil((int n) => n >= 100).unsafeRunFuture();
```

Internally it uses `discrete.forall((a) => !p(a)).compile.drain` — it consumes
the change stream, discarding values, until one fails the negated predicate.

## Turning a Rill into a Signal: `holdResource`

`rill.holdResource(initial)` wraps a `Rill` in a `Signal` that always holds
the most recently emitted value. The stream runs in a background fiber for the
lifetime of the returned `Resource`.

```dart
// A live-updating signal that always holds the latest temperature reading.
final sensorSignal = temperatureRill.holdResource(0.0);

sensorSignal.use((Signal<double> temp) async {
  // read the latest sensor value at any point in the resource scope
  final current = await temp.value().unsafeRunFuture();
});
```

## Real-world example: pauseable processor with watchdog

<<< @/../snippets/lib/src/rill/signal.dart#signal-realworld

Four fibers share three `SignallingRef` values:

- **`itemCount`** — incremented by the processor on every item. Both the
  logger (via `discrete`) and the watchdog (via `waitUntil`) observe it.
- **`paused`** — the pause controller sets it to `true` at 50 items then
  immediately back to `false`, exercising the `pauseWhenSignal` path.
- **`stop`** — the watchdog sets it to `true` at 100 items, which terminates
  both the processor and the logger via `interruptWhenSignaled`.

`IO.both` runs the work pair (processor + logger) and the control pair
(watchdog + pause controller) concurrently, then reads the final item count
once all four fibers have finished.
