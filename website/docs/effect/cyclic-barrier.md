---
sidebar_position: 66
---


# Cyclic Barrier

`CyclicBarrier` is a **reusable synchronisation barrier** that blocks a fixed
number of fibers until they have *all* called `await()`. Once the last fiber
arrives the barrier **releases every waiter simultaneously** and then
**resets itself** — the same barrier can be used for the next round without
any re-initialisation.

:::info
`CyclicBarrier` models the same primitive as `java.util.concurrent.CyclicBarrier`,
but every operation is an `IO` effect that integrates naturally with fiber
cancellation, resource safety, and the rest of the `ribs_effect` ecosystem.
:::

## Core operations

| Method | Returns | Description |
|---|---|---|
| `CyclicBarrier.withCapacity(n)` | `IO<CyclicBarrier>` | Allocate a new barrier that releases after *n* concurrent waiters |
| `await()` | `IO<Unit>` | Block until *n* fibers are waiting; returns immediately for a barrier of capacity 1 |

:::warning
`CyclicBarrier.withCapacity` throws `ArgumentError` if `n < 1`. Fibers that
cancel while waiting have their slot returned to the barrier so the remaining
fibers are not permanently stuck. For a one-shot barrier see `CountDownLatch`.
:::

## Basic usage

Create a barrier with capacity *n*, then start *n* worker fibers that each
call `await()`. No fiber is released until all *n* have arrived.

<<< @/../snippets/lib/src/effect/cyclic_barrier.dart#cb-basic

Both fibers suspend inside `await()` and are unblocked simultaneously the
moment the second one arrives.

## Reuse across multiple rounds

After each full rendezvous the barrier resets automatically. The same
`CyclicBarrier` can be awaited again in the next iteration — no
re-creation needed.

<<< @/../snippets/lib/src/effect/cyclic_barrier.dart#cb-reuse

All three fibers go through two rounds. The barrier resets between round 1
and round 2 with no additional setup.

## Cancellation safety

A fiber waiting at the barrier can be canceled at any time. The barrier
restores its slot so the remaining capacity is unchanged and other fibers are
not left waiting forever.

<<< @/../snippets/lib/src/effect/cyclic_barrier.dart#cb-cancel

## Comparison with CountDownLatch

| | `CyclicBarrier` | `CountDownLatch` |
|---|---|---|
| **Reusable** | Yes — resets after every cycle | No — one-shot |
| **How it works** | All *n* waiters arrive together | *n* `release()` calls counted down |
| **Producer/consumer** | Symmetric — all fibers both produce and consume | Asymmetric — releasers and waiters are distinct |
| **Use case** | Iterative phases, pipeline stages | Wait-for-startup, fan-out coordination |

---

## Real-world example: parallel pipeline stages

A common pattern in data-processing pipelines is to have multiple stages
(parse, transform, persist) run in parallel but advance in **lock-step** —
no stage should start chunk *N+1* before every stage has finished chunk *N*.

`CyclicBarrier` is the natural tool: each stage calls `await()` after
finishing a chunk, and the barrier ensures all three stages commit the same
chunk before any of them moves on.

<<< @/../snippets/lib/src/effect/cyclic_barrier.dart#cb-pipeline

Because the three stage fibers run concurrently via `parSequence_`, each
chunk takes only as long as the *slowest* stage. The barrier guarantees
consistency without any shared mutable state or polling.
