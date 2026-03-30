---
sidebar_position: 40
---


# Queue

`Queue<A>` is a **purely functional, concurrent queue**. Every operation —
enqueuing an item, dequeuing an item, checking the size — is expressed as
an `IO` effect, so queues compose naturally with the rest of an `IO` program
and are safe to share across concurrent fibers.

## Why a functional queue?

Mutable queues from `dart:collection` expose methods that perform effects
immediately. That makes them hard to compose, test, or reason about in a
program built around `IO`:

```dart
// Imperative: the effect happens now, unconditionally
final q = Queue<int>();
q.add(42); // side effect — no way to defer, retry, or cancel this
```

A ribs `Queue` defers every operation inside `IO`. Adding an item is a
*description* of an add that can be composed, passed to other functions,
or wrapped in error handling before it ever runs:

```dart
// Functional: the effect is described, not performed
final program = Queue.bounded<int>(10).flatMap((q) => q.offer(42));
```

Beyond composability, ribs queues provide two properties that are essential
for concurrent programs:

- **Fiber-safe.** Any number of producer and consumer fibers can access the
  same queue simultaneously — all operations are atomic.
- **Backpressure by default.** A bounded queue suspends a producer fiber when
  full and suspends a consumer fiber when empty, rather than throwing or
  silently dropping data.

## Queue variants

| Constructor | Behavior when full |
|---|---|
| `Queue.bounded(n)` | Suspends the producer until a slot opens |
| `Queue.unbounded()` | Never suspends the producer |
| `Queue.dropping(n)` | Drops the new item; producer returns `false` via `tryOffer` |
| `Queue.circularBuffer(n)` | Drops the **oldest** item to make room |
| `Queue.synchronous()` | No internal buffer; producer suspends until a consumer is ready |

## Core operations

| Method | Returns | Blocks? | Description |
|---|---|---|---|
| `offer(a)` | `IO<Unit>` | Yes, if full | Enqueue an item |
| `tryOffer(a)` | `IO<bool>` | No | Enqueue if capacity is available |
| `take()` | `IO<A>` | Yes, if empty | Dequeue the next item |
| `tryTake()` | `IO<Option<A>>` | No | Dequeue if an item is available |
| `tryTakeN(maxN)` | `IO<IList<A>>` | No | Dequeue up to N items at once |
| `size()` | `IO<int>` | No | Current number of items |

## Basic usage

<<< @/../snippets/lib/src/effect/queue.dart#queue-basic

## Backpressure in action

With a bounded queue, a producer that outpaces its consumers is
automatically slowed down — no polling, no sleep loops required.

<<< @/../snippets/lib/src/effect/queue.dart#queue-backpressure

The third `offer` suspends the producer fiber until the consumer takes
an element, freeing a slot. The moment a slot opens, the producer
resumes without any explicit coordination code.

---

## Real-world example: pub-sub

A queue is a natural fit for **publish-subscribe** message passing. The
publisher sends events without knowing who is listening; each subscriber
processes events independently at its own pace.

In a pure program, the pattern looks like this:

1. Allocate one bounded `Queue` per subscriber (each gets its own inbox).
2. A publisher fiber fans the same event out to every inbox via `offer`.
3. Each subscriber fiber loops on `take`, processing events as they arrive.
4. Everything runs concurrently — `parSequence_` starts all fibers and waits
   for them to finish.

The example below models a temperature sensor publishing readings to two
independent subscribers: an alert worker that warns on high temperatures,
and a logger that records every reading.

<<< @/../snippets/lib/src/effect/queue.dart#queue-pub-sub

Because `offer` suspends if an inbox is full, a slow subscriber naturally
applies backpressure to the publisher — the sensor will pause until the
slow subscriber catches up, preventing unbounded memory growth.

:::tip
For a higher-level streaming abstraction built on top of `Queue`, see
the `ribs_rill` package. `Channel` wraps a `Queue` and exposes both a
`Rill` (stream of taken values) and a `send` function (IO-based offer),
making producer-consumer pipelines easier to express.
:::
