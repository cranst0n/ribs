---
sidebar_position: 63
---


# Count Down Latch

`CountDownLatch` is a **one-shot synchronisation barrier** that lets one or more
fibers wait until a fixed number of other fibers have each signalled completion.
You create it with a count *n*; every call to `release()` decrements that count
by one. Any fiber calling `await()` suspends until the count reaches zero, at
which point **all** waiters are unblocked simultaneously — and the latch stays
open permanently for any subsequent `await()` calls.

:::info
`CountDownLatch` models the same primitive as `java.util.concurrent.CountDownLatch`,
but every operation is an `IO` effect that integrates naturally with fiber
cancellation, resource safety, and the rest of the `ribs_effect` ecosystem.
:::

## Core operations

| Method | Returns | Description |
|---|---|---|
| `CountDownLatch.create(n)` | `IO<CountDownLatch>` | Allocate a new latch with a count of *n* |
| `release()` | `IO<Unit>` | Decrement the count by 1; unblocks all waiters when it reaches 0 |
| `await()` | `IO<Unit>` | Suspend until the count reaches 0; returns immediately if already 0 |

:::warning
`CountDownLatch.create` throws an `ArgumentError` if `n < 1`. The count can only
go down — there is no reset or reuse. For a reusable barrier see `CyclicBarrier`.
:::

## Basic usage

Create a latch with count *n*, then start *n* worker fibers alongside a
coordinator. Each worker calls `release()` when it finishes; the coordinator
calls `await()` and unblocks once all workers are done.

<<< @/../snippets/lib/src/effect/count_down_latch.dart#cdl-basic

The workers run concurrently via `parSequence_`. The coordinator fiber suspends
inside `await()` and is woken up the moment the third `release()` fires.

## Multiple waiters

Any number of fibers can call `await()` at the same time. They all unblock at
the same instant when the last `release()` is called.

<<< @/../snippets/lib/src/effect/count_down_latch.dart#cdl-await-multiple

## Latch stays open after reaching zero

Once the count hits zero the latch is permanently open. Any `await()` called
after that point — including calls that arrive arbitrarily later — returns
immediately without suspending.

<<< @/../snippets/lib/src/effect/count_down_latch.dart#cdl-already-done

---

## Real-world example: parallel service initialisation

A common pattern in service-oriented applications is to start several
subsystems concurrently and only expose the public API once **every** subsystem
is ready. Doing this with a manual boolean flag and polling is error-prone;
`CountDownLatch` makes it trivial.

Each service fiber performs its startup work independently, then calls
`release()`. The gateway fiber sits on `await()` and begins accepting traffic
the moment the last service signals readiness — with no polling, no shared
mutable flags, and no missed signals.

<<< @/../snippets/lib/src/effect/count_down_latch.dart#cdl-parallel-init

Because `parSequence_` starts all four fibers concurrently, the total startup
time is the *maximum* of the individual service startup times, not the sum.
The gateway never blocks the services, and the services never need to know
about each other.
