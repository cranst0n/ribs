---
sidebar_position: 30
---


# Pull

`Pull<O, R>` is the **low-level, trampolined primitive** that `Rill` is built
on. Every combinator in the `Rill` API is ultimately expressed in terms of
`Pull`. You rarely need to touch `Pull` directly, but understanding it helps
reason about how `Rill` works and gives you an escape hatch to implement
combinators that aren't in the standard library.

## What is a Pull?

A `Pull<O, R>` describes a computation that can:

1. **Emit** zero or more values of type `O` (always in `Chunk<O>` batches)
2. **Run** arbitrary `IO` effects
3. **Return** a final result of type `R`

It is an **algebraic data type** with a small set of constructors:

| Constructor | Type | Description |
|---|---|---|
| `Pull.pure(r)` | `Pull<Never, R>` | Return `r` with no output |
| `Pull.output(chunk)` | `Pull<O, Unit>` | Emit `chunk`, return `Unit` |
| `Pull.output1(value)` | `Pull<O, Unit>` | Emit a single value |
| `Pull.eval(io)` | `Pull<Never, R>` | Run `io`, return its result |
| `Pull.fail(err)` | `Pull<Never, Never>` | Raise an error |
| `Pull.done` | `Pull<Never, Unit>` | Emit nothing, return `Unit` |
| `Pull.suspend(f)` | `Pull<O, R>` | Lazily defer construction |

Pulls are composed with `flatMap`, `append`, `map`, and `handleErrorWith`,
then converted to a `Rill<O>` via `.rill` or `.rillNoScope`.

## Relationship to Rill

`Rill<O>` is a thin wrapper over `Pull<O, Unit>`. Conceptually:

```dart
class Rill<O> {
  final Pull<O, Unit> underlying;
  // ...
}
```

Every `Rill` combinator is implemented in terms of `Pull`. For example:

```dart
// filter and map are both implemented as mapChunks, which is:
Rill<O2> mapChunks<O2>(f) =>
    underlying.unconsFlatMap((hd) => Pull.output(f(hd))).rillNoScope;

// take is:
Rill<O> take(int n) => pull.take(n).flatMap((tail) => Pull.done).rillNoScope;
```

The `Rill` type is meant to be the primary API. Drop down to `Pull` only when
you need behaviour that `Rill` does not expose.

## Pull anatomy

<<< @/../snippets/lib/src/rill/pull.dart#pull-anatomy

The `.rill` extension (on `Pull<O, Unit>`) wraps the pull in a new resource
scope — finalizers registered inside the pull via `Pull.acquire` will run when
the scope closes. Use `.rillNoScope` inside combinators that manage scope
externally (most hand-written combinators fall into this category).

## Accessing Pull from a Rill

Every `Rill<O>` exposes its underlying pull through the `.pull` property, which
returns a `ToPull<O>`. `ToPull` provides higher-level inspection primitives:

| Method | Returns | Description |
|---|---|---|
| `pull.uncons` | `Pull<Never, Option<(Chunk<O>, Rill<O>)>>` | Peel one chunk; return chunk + remainder |
| `pull.uncons1` | `Pull<Never, Option<(O, Rill<O>)>>` | Peel one element |
| `pull.unconsN(n)` | `Pull<Never, Option<(Chunk<O>, Rill<O>)>>` | Peel exactly `n` elements |
| `pull.echo` | `Pull<O, Unit>` | Return the underlying pull unchanged |
| `pull.fold(z, f)` | `Pull<Never, B>` | Reduce to a single value |

`uncons` is the fundamental building block for custom combinators: peel one
chunk, process it, then recurse on the remainder.

---

## Building a custom combinator

The example below implements `takeEvery(step)` — a combinator that keeps only
every `step`-th element — using `Pull` directly. This combinator does not exist
in the standard `Rill` API.

<<< @/../snippets/lib/src/rill/pull.dart#pull-custom-combinator

The recursive structure follows the pattern used throughout the `Rill`
implementation:

1. Call `tp.uncons` to peel the next chunk and get the remaining stream.
2. If the stream is empty, signal completion with `Pull.pure(Unit())`.
3. Otherwise, compute the output chunk, emit it with `Pull.output`, then
   `append` a recursive call on the tail.
4. Wrap the finished `Pull<O, Unit>` in `.rillNoScope` to produce a `Rill<O>`.

:::tip
The same result can be achieved without `Pull` at all:

```dart
rill.zipWithIndex()
    .filter((t) => t.$2 % step == 0)
    .map((t) => t.$1)
```

Reach for `Pull` only when the combinator inherently requires chunk-level
control, explicit state carried across chunk boundaries, or access to
`Pull.acquire` for resource management.
:::

---

## Unsafe Cast Warning

:::warning
`Pull.flatMap`, `Pull.append`, and `Pull.handleErrorWith` all perform an
**unsafe runtime cast** due to a current limitation of the Dart type system.

```dart
// Actual implementation — note the cast:
Pull<O2, R2> flatMap<O2, R2>(Function1<R, Pull<O2, R2>> f) =>
    _Bind(this as Pull<O2, R>, Fn1(f));  // ← runtime cast
```

The cast widens the output type from `O` to `O2`. This is safe **only when
`O` is a subtype of `O2`** (e.g. widening from `Pull<Never, R>` to
`Pull<int, R>`). Widening to an incompatible type (e.g. `Pull<String, Unit>`
to `Pull<int, Unit>`) will throw a `TypeError` at runtime, not at compile time.
:::

The invariant to maintain: **always widen, never change to an unrelated type**.
In practice this means:

- `Pull<Never, R>` can safely be widened to any `Pull<O, R>` — `Never` is the
  bottom type and is always a valid subtype.
- Two `Pull<O, Unit>` values sharing the **same** `O` can be `append`ed safely
  (the cast is a no-op).
- Never use `append<B, Unit>` where `B` is unrelated to the current output type.

The Dart type checker cannot verify these invariants at compile time. The
`pull_cast_test.dart` tests in the library's test suite cover the known failure
modes.

In the future, if Dart adopts the following language features, these unsafe edge
cases can be avoided by using the compiler to refuse any unsafe type relationships.

* [Lower Type Bounds](https://github.com/dart-lang/language/issues/1674)
* [Variance](https://github.com/dart-lang/language/issues/213)