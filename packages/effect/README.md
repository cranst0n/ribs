# ribs_effect

`ribs_effect` is a high-performance, purely functional effect system for Dart, heavily inspired by [Cats Effect](https://typelevel.org/cats-effect/). It provides a robust foundation for building asynchronous and resource-safe applications.

At the core of the library is `IO`, a data type that describes an effect as a value. This allows you to treat side-effects (like network calls, file I/O, or console output) as referentially transparent values that can be composed, transformed and passed around before being executed.

## Key Features

- **Purely Functional**: Side-effects are deferred until the "end of the world," making your code easier to reason about and test.
- **Fiber-based Concurrency**: Lightweight fibers provide efficient concurrency that's easier to manage than raw Futures.
- **Interruption/Cancellation**: Built-in support for safely canceling running tasks.
- **Resource Safety**: Guaranteed cleanup of resources (like file handles or sockets) even in the face of errors or cancellation.
- **Rich Standard Library**: Includes concurrent primitives like `Ref`, `Deferred`, `Semaphore`, and `Queue`.

## Documentation

For more detailed information, guides, and API documentation, visit the [Full Ribs Documentation Site](https://cranst0n.github.io/ribs/).

## Use Cases

### Composing Effects
Easily sequence and transform effects using standard functional combinators.

```dart
final program = IO.delay(() => 42)
  .map((n) => n * 2)
  .flatMap((result) => IO.print('The result is $result'));

await program.unsafeRunFuture();
```

### Safe Resource Management
Ensure resources are always released, no matter what happens during execution.

```dart
final result = IO.print('Opening file...').bracket(
  (file) => processFile(file), // use
  (file) => IO.print('Closing file...'), // release
);
```

### The Resource Type
While `bracket` is great for simple cases, `Resource` is a first-class data type that wraps acquisition and release logic. It's a tool for managing resources, allowing you to:
- Compose multiple resources easily.
- Ensure resources are released in the correct (reverse) order.
- Avoid "callback hell" of nested `bracket` calls.

```dart
final server = Resource.make(
  IO.print('Starting server...').as('localhost:8080'),
  (addr) => IO.print('Stopping server at $addr...'),
);

final connection = Resource.make(
  IO.print('Opening connection...').as('conn_123'),
  (id) => IO.print('Closing connection $id...'),
);

// Compose resources to get both values
final app = server.product(connection);

// Both are acquired, provided to the block, then released in reverse order.
await app.use((data) {
  final (server, connection) = data;
  return IO.print('App at $server and connection $connection');
}).unsafeRunFuture();
```

### Coordination with Ref and Deferred
Synchronize and share state between concurrent fibers.

```dart
final coordination = IO.deferred<int>().flatMap((deferred) {
  return ilist([
    IO.sleep(const Duration(seconds: 1)).flatMap((_) => deferred.complete(42)),
    deferred.get().flatMap((value) => IO.print('Received: $value')),
  ]).parSequence();
});
```

### Concurrent Execution
Run multiple independent tasks concurrently and gather their results safely.

```dart
final tasks = ilist([
  fetchData(1),
  fetchData(2),
  fetchData(3),
]);

// Runs all tasks concurrently and returns an IList of results
final results = await tasks.parSequence().unsafeRunFuture();
```

### Fiber Cancellation
Fibers can be canceled to stop ongoing work. This is handled safely, ensuring that any attached finalizers are executed.

```dart
final program = IO.print('Working...').delayBy(Duration(seconds: 10))
  .onCancel(IO.print('Cleanup done!'))
  .start()
  .flatMap((fiber) => fiber.cancel());

await program.unsafeRunFuture();
```

### Fine Grained Cancellation
Use `uncancelable` to prevent an effect from being interrupted. You can use the provided `Poll` to create specific regions where cancellation is allowed again.

```dart
final safeOperation = IO.uncancelable((poll) =>
  IO.print('Acquired') .flatMap((_) =>
    poll(IO.print('Interruptible work...'))
      .guarantee(IO.print('Released'))
  )
);
```

### Testing with Ticker
`ribs_effect` provides a `Ticker` runtime for deterministic testing of time-based effects without actually waiting for real time to pass.

```dart
import 'package:ribs_effect/test.dart';

test('delayed effect', () async {
  final io = IO.sleep(Duration(seconds: 1)).as('Done');
  
  final ticker = io.ticked;
  
  ticker.advance(Duration(milliseconds: 500));
  expect(await ticker.outcome.isCompleted, isFalse);
  
  ticker.advanceAndTick(Duration(milliseconds: 500));
  expect(await ticker.outcome, ioSucceeded('Done'));
});
```

### IO Tracing
Tracing provides a high-level view of your `IO` execution history, which is much easier to debug than raw Dart stack traces.

#### Enabling Tracing
Tracing must be enabled globally before running any effects:

```dart
IOTracingConfig.tracingEnabled = true;
```

### Manual Tracing
You can add labels to specific points in your program to make traces more informative:

```dart
final tracked = IO.pure(42).traced('my-trace-point');
```

When an error occurs, the resulting `StackTrace` will be an `IOFiberTrace` containing the history of executed effect labels.

## Example

Check out the full example program in [example/example.dart](example/example.dart).