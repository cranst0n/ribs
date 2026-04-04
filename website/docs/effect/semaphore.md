---
sidebar_position: 60
---


# Semaphore

`Semaphore` is a **purely functional concurrency primitive** that controls how
many fibers may execute a section of code simultaneously. It holds an integer
count of available *permits*; a fiber that wants to enter the guarded section
must first acquire a permit, and returns it when done. Any fiber that tries to
acquire when no permits are available will **suspend** until one is released.

:::info
`Semaphore` is to `IO` what a traditional counting semaphore is to threads —
but every operation is an `IO` effect, so it composes naturally with the rest
of your program and is safe to share across any number of concurrent fibers.
:::

## Common shapes

| Permits | Behavior |
|---|---|
| `Semaphore.permits(1)` | **Mutex** — only one fiber in the critical section at a time |
| `Semaphore.permits(n)` | **Rate limiter** — at most *n* fibers running concurrently |

## Core operations

| Method | Returns | Description |
|---|---|---|
| `Semaphore.permits(n)` | `IO<Semaphore>` | Allocate a new semaphore with *n* permits |
| `acquire()` | `IO<Unit>` | Acquire 1 permit, suspending if none are available |
| `acquireN(n)` | `IO<Unit>` | Acquire *n* permits |
| `tryAcquire()` | `IO<bool>` | Acquire 1 permit without suspending; `false` if unavailable |
| `release()` | `IO<Unit>` | Return 1 permit, unblocking a waiting fiber if any |
| `releaseN(n)` | `IO<Unit>` | Return *n* permits |
| `permit()` | `Resource<Unit>` | Acquire on open, release on close — preferred idiom |
| `available()` | `IO<int>` | Current number of available permits |
| `count()` | `IO<int>` | Available permits, or negative if fibers are waiting |

## Basic usage

With a `Semaphore.permits(2)`, the first two fibers to call `acquire` proceed
immediately. The third suspends until one of the first two calls `release`.

<<< @/../snippets/lib/src/effect/semaphore.dart#semaphore-basic

Note that `guarantee` is used to ensure the permit is always released, even if
the body raises an error or is canceled. This is the correct pattern for manual
acquire/release — but there is a better way.

## The `permit()` idiom

Manually pairing `acquire` with `release` is error-prone: a thrown exception or
fiber cancellation between the two will leak the permit permanently. `permit()`
wraps the pair in a `Resource`, which guarantees the release runs no matter how
the body exits.

<<< @/../snippets/lib/src/effect/semaphore.dart#semaphore-permit

`surround` is a convenient shorthand for `use((_) => body)` — use it when
the body doesn't need the permit value (which is always the case for a
`Resource<Unit>`).

:::tip
Prefer `permit().surround(body)` over manual `acquire` + `release`. It is
shorter, safer, and composes cleanly with the rest of the `Resource` ecosystem.
:::

---

## Real-world example: concurrency limiter

A common pattern in concurrent programs is to fan out work across many fibers
while capping the number that run simultaneously — for example, limiting
parallel HTTP requests to avoid overloading a server or exhausting a connection
pool.

`Semaphore` makes this trivial: wrap each unit of work in
`sem.permit().surround(...)` and launch all tasks with `parTraverseIO_`. The
semaphore does the bookkeeping automatically — surplus fibers queue behind the
gate and are released one-by-one as permits become available.

<<< @/../snippets/lib/src/effect/semaphore.dart#semaphore-rate-limit

Even though `parTraverseIO_` starts all fibers at once, at most
`maxConcurrent` will be executing their `IO.sleep` body at any moment. The rest
sit suspended inside `permit()`, waiting their turn. No polling, no sleep loops,
no manual counter needed.

:::tip
For a more robust rate limiter solution, check out the ribs_limiter project
and documentation.
:::