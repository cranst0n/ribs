# ribs_limiter

`ribs_limiter` is a purely functional rate limiter for Dart, built on top of `ribs_effect`'s `IO` type. It allows you to control the rate and concurrency of job execution while preserving the composability and resource-safety guarantees of the `ribs_effect` ecosystem.

Full documentation is available at the [ribs website](https://cranst0n.github.io/ribs/).

## Key Features

- **Rate Limiting**: Enforce a minimum interval between job executions.
- **Concurrency Control**: Cap the number of jobs running simultaneously.
- **Bounded Queue**: Optionally limit the number of pending jobs, raising `LimitReachedException` when the queue is full.
- **Priority Scheduling**: Submit jobs with a priority; higher-priority jobs are dequeued first.
- **Dynamic Configuration**: Adjust `minInterval` and `maxConcurrent` at runtime without restarting.
- **Cancellation-Safe**: Canceling a submitted job removes it from the queue (if not yet running) or cancels the underlying fiber.
- **Resource-Safe**: The limiter is exposed as a `Resource<Limiter>`, ensuring the background executor fiber is always cleaned up.

## Usage

### Creating a Limiter

`Limiter.start` returns a `Resource<Limiter>`. The limiter's background executor fiber runs for the lifetime of the resource.

```dart
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_limiter/ribs_limiter.dart';

final program = Limiter.start(
  const Duration(milliseconds: 100), // minimum interval between jobs
  maxConcurrent: 2,                  // at most 2 jobs running at once
  maxQueued: 50,                     // reject new jobs when 50 are pending
).use((limiter) {
  // submit jobs inside the resource scope
  return limiter.submit(IO.print('hello'));
});
```

### Submitting Jobs

`submit` wraps any `IO<A>` and returns an `IO<A>` that completes when the job finishes executing.

```dart
final result = await Limiter.start(Duration(milliseconds: 50)).use((limiter) {
  return limiter.submit(IO.pure(42));
}).unsafeRunFuture();

print(result); // 42
```

### Priority Scheduling

Jobs with a higher `priority` value are dequeued before lower-priority jobs when a slot becomes available.

```dart
limiter.submit(lowPriorityTask, priority: 0);
limiter.submit(highPriorityTask, priority: 10); // runs first
```

### Bounded Queue

When `maxQueued` is set, submitting a job to a full queue raises `LimitReachedException`.

```dart
final safe = limiter
    .submit(myJob)
    .handleError((e) => e is LimitReachedException ? fallbackValue : throw e);
```

### Inspecting State

```dart
final pending = await limiter.pending.unsafeRunFuture();
final interval = await limiter.minInterval.unsafeRunFuture();
final concurrency = await limiter.maxConcurrent.unsafeRunFuture();
```

### Dynamic Reconfiguration

The interval and concurrency limit can be changed while the limiter is running.

```dart
// slow down under load
await limiter.setMinInterval(const Duration(milliseconds: 500)).unsafeRunFuture();

// scale back concurrency
await limiter.updateMaxConcurrent((n) => n ~/ 2).unsafeRunFuture();
```

## Example

See a complete working example in [example/example.dart](example/example.dart).
