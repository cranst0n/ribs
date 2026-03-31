---
sidebar_position: 1
---

# Limiter

`Limiter` is a **rate-limiting and concurrency-bounding** effect. It accepts
submitted `IO` jobs and ensures they run with:

- a **minimum interval** between consecutive job starts, and
- an optional **cap on concurrent executions** running at the same time.

Jobs that cannot run immediately are held in an **internal priority queue**,
so urgent work can be promoted ahead of lower-priority items already waiting.

:::tip
`Limiter` is created as a `Resource<Limiter>`. When the resource scope closes,
the background executor fiber is cancelled and all pending jobs are dropped
cleanly — no manual teardown required.
:::

## Creating a Limiter

`Limiter.start` is the single entry point:

```dart
Resource<Limiter> Limiter.start(
  Duration minInterval,   // minimum gap between consecutive job starts
  {
    int? maxConcurrent,   // max jobs running simultaneously (default: unbounded)
    int? maxQueued,       // max jobs waiting in the queue   (default: unbounded)
  }
)
```

A typical usage pattern:

```dart
Limiter.start(100.milliseconds, maxConcurrent: 3).use((limiter) {
  // submit jobs here
});
```

## Core operations

### Submitting jobs

`submit<A>(IO<A> job, {int priority = 0})` enqueues a job and returns an
`IO<A>` that completes when the job finishes. The caller suspends until the
limiter dequeues and executes the job.

If `maxQueued` is set and the queue is full, `submit` raises a
`LimitReachedException`.

| Method | Returns | Description |
|--------|---------|-------------|
| `submit(job)` | `IO<A>` | Enqueue `job`; resolves to its result |
| `submit(job, priority: n)` | `IO<A>` | Same, dequeued ahead of lower-priority items |

### Inspecting state

All queries return live values as `IO` effects:

| Property | Returns | Description |
|----------|---------|-------------|
| `pending` | `IO<int>` | Number of jobs waiting in the queue |
| `minInterval` | `IO<Duration>` | Current minimum gap between job starts |
| `maxConcurrent` | `IO<int>` | Current concurrent-execution cap |

### Runtime reconfiguration

Limits can be changed while the limiter is running without restarting it:

| Method | Returns | Description |
|--------|---------|-------------|
| `setMinInterval(d)` | `IO<Unit>` | Replace the minimum interval |
| `updateMinInterval(f)` | `IO<Unit>` | Apply `f` to the current interval |
| `setMaxConcurrent(n)` | `IO<Unit>` | Replace the concurrency cap |
| `updateMaxConcurrent(f)` | `IO<Unit>` | Apply `f` to the current cap |

## Basic usage

The example below starts a limiter that runs one job at a time with a 200 ms
gap between starts, then submits three jobs concurrently. The limiter's queue
absorbs the burst and drains it in order.

<<< @/../snippets/lib/src/limiter/limiter.dart#limiter-basic

---

## Real-world example: rate-limited API fetcher

The example below fetches a batch of pages from a hypothetical rate-limited
external API with two constraints applied simultaneously:

- **Concurrency**: at most 2 requests in flight at once (`maxConcurrent: 2`).
- **Frequency**: at least 150 ms between each job start (`minInterval`).

All jobs are submitted concurrently via `parTraverseIO_` — the limiter's
priority queue absorbs the burst and drains it at the configured rate. Pages
with a low id are flagged as urgent (`priority: 10`) and jump ahead of
normal-priority items even when they arrive after the others.

<<< @/../snippets/lib/src/limiter/limiter.dart#limiter-api-fetcher
