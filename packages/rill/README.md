# ribs_rill

`ribs_rill` is a purely functional, chunked stream processing library for Dart, inspired by [FS2](https://fs2.io/) from the Scala ecosystem. It is built on top of `ribs_effect` and provides composable, resource-safe streaming primitives.

Full documentation is available at the [ribs website](https://cranst0n.github.io/ribs/).

## Key Features

- **Chunked by default**: All streams operate on `Chunk<O>` internally for high throughput without sacrificing element-at-a-time ergonomics.
- **Resource safety**: Streams carry their own resource lifecycle — finalizers always run on success, error, and cancelation via `bracket`/`bracketCase`.
- **Composable via `Pipe`**: Stream transformations are plain functions `Rill<I> → Rill<O>`, composed with `through`.
- **Concurrent primitives**: `Channel`, `Signal`/`SignallingRef`, and `Topic` enable safe producer/consumer and reactive patterns.
- **Rich operator set**: `flatMap`, `merge`, `parEvalMap`, `groupWithin`, `debounce`, `interruptWhen`, and many more.
- **Dart `Stream` interop**: Convert to/from Dart's native `Stream` with `Rill.fromStream` and `compile.toStream`.

## Core Types

| Type | Description |
|---|---|
| `Rill<O>` | A stream that emits elements of type `O` |
| `Pull<O, R>` | The low-level primitive backing `Rill` — emits chunks and returns a value |
| `Pipe<I, O>` | A stream transformation: `Function1<Rill<I>, Rill<O>>` |
| `Channel<A>` | A concurrent queue with back-pressure for producer/consumer patterns |
| `Signal<A>` / `SignallingRef<A>` | Observable shared state; drives reactive streams and interruption |
| `Topic<A>` | Pub/sub broadcast — one publisher, many concurrent subscribers |
| `Chunk<O>` | An efficient, immutable sequence used as the transport unit |

## Basic Usage

### Creating Streams

```dart
import 'package:ribs_rill/ribs_rill.dart';

// Single element
final one = Rill.emit(42);

// Multiple elements
final nums = Rill.emits([1, 2, 3, 4, 5]);

// Integer range
final range = Rill.range(0, 100);

// Infinite stream from a seed
final evens = Rill.iterate(0, (n) => n + 2);

// Repeat an effect
final ticks = Rill.repeatEval(IO.print('.'));

// Fixed-rate ticker
final heartbeat = Rill.fixedRate(const Duration(seconds: 1));
```

### Transforming Streams

```dart
final result = Rill.range(1, 11)
    .filter((n) => n.isOdd)
    .map((n) => n * n)
    .take(3);

// Effectful map
final fetched = ids.evalMap((id) => fetchUser(id));

// Run up to 4 fetches concurrently, preserving order
final parallel = ids.parEvalMap(4, (id) => fetchUser(id));
```

### Compiling to a Result

```dart
// Drain all elements (for side-effecting streams)
await Rill.range(0, 1000)
    .evalMap((n) => IO.print(n))
    .compile
    .drain
    .unsafeRunFuture();

// Collect into a list
final items = await Rill.emits([1, 2, 3]).compile.toList().unsafeRunFuture();

// Fold to a single value
final sum = await Rill.range(1, 6).compile.fold(0, (acc, n) => acc + n).unsafeRunFuture();
```

### Pipes and Composition

`Pipe<I, O>` is just `Function1<Rill<I>, Rill<O>>`, so pipes compose naturally.

```dart
// Built-in text pipes
final lines = bytesRill.through(Pipes.text.utf8Decode).through(Pipes.text.lines);

// Custom pipe
Pipe<int, String> showEvens = (s) => s.filter((n) => n.isEven).map(n.toString);

final result = Rill.range(0, 20).through(showEvens);
```

### Resource Safety

```dart
// Bracket: acquire → use → release (always)
final managed = Rill.bracket(
  openConnection(),
  (conn) => conn.close(),
).flatMap((conn) => conn.readAll());

// Annotate cleanup to any scope
final safe = myRill.onFinalize(IO.print('stream done'));
```

### Channel (Producer / Consumer)

```dart
final program = Channel.bounded<int>(16).flatMap((chan) {
  final producer = Rill.range(0, 100)
      .through(chan.sendAll)
      .compile
      .drain;

  final consumer = chan.rill
      .evalMap((n) => IO.print('got $n'))
      .compile
      .drain;

  return producer.both(consumer);
});

await program.unsafeRunFuture();
```

### Signal (Observable State / Interruption)

```dart
final program = SignallingRef.of(false).flatMap((stop) {
  final worker = Rill.fixedRate(const Duration(milliseconds: 100))
      .evalMap((_) => IO.print('tick'))
      .interruptWhenSignaled(stop);

  final stopper = IO.sleep(const Duration(seconds: 1)).productR(stop.setValue(true));

  return worker.compile.drain.both(stopper);
});

await program.unsafeRunFuture();
```

### Merging Concurrent Streams

```dart
// Non-deterministically merge two streams
final merged = streamA.merge(streamB);

// Run a background stream and halt when it ends
final withBackground = foreground.concurrently(background);

// Fan-out to multiple pipes simultaneously
final broadcast = source.broadcastThrough(ilist([pipe1, pipe2, pipe3]));
```

### Time-Based Operations

```dart
// Emit at most one element per 200 ms
final debounced = fastStream.debounce(const Duration(milliseconds: 200));

// Collect elements into chunks of up to 50 within 500 ms windows
final windowed = eventStream.groupWithin(50, const Duration(milliseconds: 500));

// Stop after 30 seconds
final limited = longRunning.interruptAfter(const Duration(seconds: 30));
```

## File & Network I/O

For file system and network operations built on top of `ribs_rill`, see [`ribs_rill_io`](../rill_io/README.md).

## Example

See a complete working example in [example/example.dart](example/example.dart).
