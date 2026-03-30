---
sidebar_position: 3
---

# Why Use Ribs?

Dart is a capable, well-designed language. Its type system is solid, its
tooling is excellent, and its async/await model handles the common case well.
But the standard library leaves some hard problems largely unsolved — problems
that tend to show up not when code is first written, but months later, in
production, at inconvenient times.

Ribs is a suite of libraries that addresses those problems head-on:

- Collections that can never be accidentally mutated
- Optional values and errors that are part of the type, not hidden surprises
- Resources that are guaranteed to be released, no matter what goes wrong
- Concurrent code with real cancellation support
- Safe, composable data streams with automatic cleanup

None of these ideas require you to think about category theory or learn new
terminology. They are engineering tools with practical, measurable benefits.

---

## Immutable Collections

The Dart standard library's `List`, `Map`, and `Set` are mutable by default.
This is convenient for small local computations, but creates real problems when
data is shared:

- Pass a list to a helper function and it might be modified — your caller
  never finds out until something breaks.
- Iterate over a collection while it's being modified elsewhere and you get a
  `ConcurrentModificationError`.
- Store a list in a state object and any code with a reference to that object
  can change it without going through any controlled update path.

Dart does provide `List.unmodifiable(...)`, but that is a runtime check, not a
compile-time guarantee, and it only prevents mutation of the wrapper — not the
elements inside.

Ribs' `IList`, `IVector`, `IMap`, and `ISet` are **structurally immutable**:
there is no `add`, no `remove`, no `[]=`. Operations that transform a
collection return a *new* collection; the original is always untouched. You can
share them freely, pass them across isolates, store them without defensive
copying, and reason about them in isolation.

**Efficiency:** These are not naive copy-on-write types. They use persistent
data structures with structural sharing. Building up a large list element by
element, or inserting into the middle of a map, does not require copying
everything that came before. The time and memory complexity is comparable to
their mutable equivalents.

**Richness:** The collection types ship with a full suite of operations —
`map`, `filter`, `flatMap`, `foldLeft`, `scan`, `groupBy`, `sortBy`,
`partition`, `zip`, and more. There is no need to convert to a dart `List`
and back just to do common transformations.

**Non-empty collections:** `NonEmptyIList<A>` is a list guaranteed by the
type system to contain at least one element. If your function requires a
non-empty input, encoding that in the type means callers cannot accidentally
pass an empty list — the constraint is checked once, at construction, not
silently assumed everywhere it is used.

---

## Optional Values Done Right

Dart's nullable types (`String?`, `int?`) are a genuine improvement over
languages without them. But they compose awkwardly. To safely chain several
operations that each might produce no result, you need null checks at every
step, or you rely on `?.` chains that quickly become unreadable and offer no
way to attach context to the absence.

`Option<A>` makes the "might not be there" concept a first-class value that
can be transformed and composed without intermediate null checks:

- `map` applies a function to the value inside, if present — otherwise
  passes `None` through unchanged.
- `flatMap` chains operations that each might produce a value or nothing —
  the first `None` short-circuits the whole chain.
- `filter` turns a present value into an absent one if it fails a predicate.
- `getOrElse` extracts the value with a fallback.

The result is that a function returning `Option<User>` tells every caller,
without ambiguity, that the user might not exist. A function returning `User`
guarantees one will be returned. Those contracts are visible in the type, not
buried in documentation.

---

## Errors as Values

Dart's exception system is convenient but can hide behaviors. A function
signature cannot tell you whether it throws, what it might throw, or when you
are expected to handle it. Forgetting to wrap a call in try/catch is not a
compile time error — it is a production incident.

`Either<Failure, Success>` makes errors explicit. A function returning
`Either<String, User>` is contractually committed to one of two outcomes: a
`User` on success, or a `String` explaining what went wrong on failure. The
caller must handle both. The compiler enforces it.

Errors become ordinary values. You can transform the success value with `map`,
transform the failure description with `mapLeft`, chain operations that each
might fail with `flatMap`, and convert the whole thing into a successful
`Option` by discarding the error. Nothing is invisible.

### Accumulating Multiple Errors

`Either` stops at the first failure — which is right for most situations. But
when validating input with multiple independent rules (a form, a configuration
file, a parsed record), stopping at the first error gives users a frustrating
one-at-a-time correction loop.

`Validated<E, A>` accumulates every failure. Validate ten fields and you get
back all ten error messages at once. The type makes it impossible to accidentally
use the accumulating validator where you wanted early exit, or vice versa.

---

## Resource Safety

Any code that works with files, network connections, database handles, or locks
follows the same structure: acquire the resource, use it, release it. In Dart,
the standard approach is:

```
acquire resource
try {
  use resource
} finally {
  release resource
}
```

This works for a single resource. It becomes unwieldy quickly:

- Multiple resources require multiple levels of nesting.
- Resources that should be released in a specific order (innermost first)
  require careful manual management.
- Reusing acquisition logic across call sites means duplicating this structure
  everywhere.

`Resource<A>` encodes the acquire-and-release lifecycle as a **composable
value**. You define how to acquire a resource and how to release it once.
Multiple resources combine with `flatMap` or `both`. Ribs guarantees the
release runs in every exit scenario — normal completion, error, or
mid-flight cancellation — with no extra effort from the caller.

Resource safety stops being a thing you have to remember. It becomes structural.

---

## Structured Concurrency

Dart's `Future<T>` has a fundamental characteristic that can cause problems at
scale: it starts running the moment it is created. You cannot build a `Future`
without also launching it. You cannot pass a description of an async computation
to another function without it already being in flight.

This makes several important patterns difficult:

**Cancellation.** Dart does not have a standard way to cancel a `Future`. You
can use `CancelToken` patterns, but they require threading a token through every
layer of code and checking it manually. There is no guarantee cleanup runs when
a computation is abandoned.

**Structured lifecycle.** When a parent operation is cancelled or fails, its
child tasks should be cleaned up. With raw `Future`, this requires significant
manual coordination.

**Testability.** A function that returns a `Future<void>` may produce side
effects the moment it is called. Testing it in isolation often requires
mocking infrastructure that the test doesn't really care about.

`IO<A>` is a *description* of a computation — it does nothing when constructed,
only when explicitly executed. This small distinction has large consequences:

- **Cancellation is built in.** Any `IO` can be cancelled at any `await`
  point. Cleanup registered with `Resource` or `bracket` runs automatically
  when a cancellation occurs.
- **Timeouts compose naturally.** Wrap any `IO` with a timeout; if it
  exceeds the limit, cleanup runs and the caller gets an error.
- **Concurrency with safety.** `IO.both`, `IO.parMapN`, and `IO.parSequence`
  run multiple computations concurrently and join their results. If one fails,
  the others are cancelled and any acquired resources are released.
- **Retry policies.** Declare retry behaviour declaratively —
  exponential backoff, maximum attempts, jitter — and attach it to any `IO`
  without modifying the operation itself.

For simple `async`/`await` code, `Future` remains entirely appropriate.
`IO` is the right tool when you need cancellation, structured concurrency,
or reliable cleanup in the face of failure.

---

## Safe Data Streaming

Dart's `Stream` API covers the common case of reading values over time. But
it does not model resource lifecycle. If a consumer stops reading a stream —
because it found what it needed, hit an error, or was cancelled — the producer
may keep running, and the underlying resource (a file handle, a socket, a
database cursor) may never be closed.

`Rill<A>` is ribs' streaming primitive. It is built on top of `IO` and
`Resource`, so:

- Resources acquired during a stream are released when the stream ends —
  whether it ran to completion, was interrupted, or encountered an error.
- Nothing runs until the stream is consumed. Creating a stream is not
  starting one.
- Transformations are expressed as `Pipe<Input, Output>` values that compose
  cleanly with `.through()`. Decode raw bytes to UTF-8; split by newlines;
  parse each line as JSON — each step is a separate, reusable pipe.
- Back-pressure is structural. A slow consumer automatically slows a fast
  producer.

The companion package `ribs_rill_io` provides streaming file access
(`Files.readAll`, `Files.readUtf8Lines`, `Files.list`), directory watching,
and network socket I/O — all built on `Rill`, all resource-safe by
construction.

---

## Type-Safe Network Addresses

`ribs_ip` provides first-class types for IP addresses (v4 and v6), ports,
hostnames, socket addresses, and CIDR ranges. Instead of passing strings
around and validating them somewhere deep in a network stack, you parse once
at the system boundary and work with values that are always structurally valid.
Invalid addresses are rejected immediately, not discovered three layers down.

---

## Property-Based Testing

Hand-written test cases are limited by the scenarios the author thought of.
`ribs_check` generates hundreds of random inputs automatically, trying to
disprove properties you define about your code — "encoding then decoding
produces the original value", "sorting twice gives the same result as sorting
once", "this function never returns a negative number".

When a property fails, `ribs_check` automatically shrinks the failing input to
the smallest example that still triggers the bug. Instead of debugging a
500-element list, you debug a 3-element one.

---

## How the Libraries Fit Together

Each library in ribs is useful independently. But their real power is that they
are designed to compose:

- `IO` handles the lifecycle of async computation; `Resource` handles
  acquisition and release; `Rill` handles streams of data. They fit together
  cleanly because they share the same model of effects and cleanup.
- `Either` and `Option` are used throughout ribs as the standard way to
  express failure and absence. You do not need to translate between error
  conventions at each library boundary.
- Immutable collections are the natural data types for a codebase that favours
  values over mutation. Pass them between `IO` computations, emit them from
  `Rill` streams, and store them in concurrent state — confident that sharing
  never produces unexpected mutation.

You can adopt any subset of ribs without committing to all of it. Start with
the collections if that is the most immediate need. Add `Option` and `Either`
for cleaner error handling. Reach for `IO` and `Resource` when your
concurrency requirements become complex. The libraries are designed to stay
out of each other's way until you want them to work together.
