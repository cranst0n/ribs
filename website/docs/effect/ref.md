---
sidebar_position: 30
---


# Ref

`Ref<A>` is a **purely functional mutable variable**. It wraps a single value
of type `A` and exposes every read and write as an `IO` effect, so mutations
stay within the effect system and remain composable, testable, and safe to
reason about.

:::tip
Because all access goes through `IO`, a `Ref` is safe to share across
concurrent fibers — reads and writes are atomic.
:::

## Creating a Ref

Use `Ref.of(initialValue)` to allocate a ref inside `IO`, preserving
referential transparency:

```dart
final IO<Ref<int>> ref = Ref.of(0);
```

## Core operations

| Method | Returns | Description |
|--------|---------|-------------|
| `value()` | `IO<A>` | Read the current value |
| `setValue(a)` | `IO<Unit>` | Overwrite the value |
| `update(f)` | `IO<Unit>` | Apply a pure function to the value |
| `updateAndGet(f)` | `IO<A>` | Apply `f` and return the new value |
| `getAndUpdate(f)` | `IO<A>` | Apply `f` and return the old value |
| `getAndSet(a)` | `IO<A>` | Replace and return the old value |
| `modify(f)` | `IO<B>` | Atomically update and produce a result |

### Basic read / write

<<< @/../snippets/lib/src/effect/ref.dart#basics

### Modifying with a result

`modify` lets you update the value and return something in a single atomic
step. The function receives the current value and returns a tuple of
`(newValue, result)`:

<<< @/../snippets/lib/src/effect/ref.dart#modify

### Swapping values

`getAndSet` replaces the value and returns what was there before:

<<< @/../snippets/lib/src/effect/ref.dart#get-and-set

---

## Concurrent counter

Because every `Ref` operation is atomic, a `Ref<int>` works correctly as a
shared counter even when many fibers update it at the same time.

The example below spawns 10 fibers concurrently, each incrementing the counter
100 times, then reads the final value. `IO.start` launches each worker as an
independent fiber and returns an `IOFiber` handle; `joinWithNever` then waits
for each fiber to complete before the final value is read.

<<< @/../snippets/lib/src/effect/ref.dart#concurrent-counter

No matter how the fiber scheduler interleaves the increments, the final result
is always `fibers × increments` (1,000 by default) — the atomicity of
`update` makes lost updates impossible.

---

## Real-world scenario: in-memory request cache

A common use for `Ref` is a simple cache that avoids redundant work. The
`Ref` holds a `Map` of results; lookups check the map first and only perform
the real fetch on a miss, updating the cache atomically before returning.

<<< @/../snippets/lib/src/effect/ref.dart#request-cache

Because the cache is a `Ref`, it can be passed to any number of concurrent
fibers without risk of conflicting writes — every `update` is an atomic
compare-and-swap under the hood.
