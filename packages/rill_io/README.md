# ribs_rill_io

`ribs_rill_io` provides purely functional file system and network I/O for Dart, built on top of `ribs_rill` and `ribs_effect`. All operations are expressed as `IO`, `Resource`, or `Rill` values, giving you composable, resource-safe I/O that integrates naturally with the rest of the ribs ecosystem.

Full documentation is available at the [ribs website](https://cranst0n.github.io/ribs/).

## Key Features

- **Streaming file I/O**: Read and write files as `Rill<int>` byte streams or `Rill<String>` line streams.
- **Resource-safe handles**: File handles and sockets are managed as `Resource`, ensuring they are always closed.
- **Type-safe paths**: The `Path` extension type wraps strings with path manipulation utilities.
- **File watching**: React to file system events as a `Rill<WatcherEvent>` stream.
- **TCP & UDP networking**: Connect, bind, and accept connections with `Network`, backed by streaming `Socket` and `ServerSocket` types.
- **Platform abstraction**: Implementations target `dart:io` with stub fallbacks for unsupported platforms.

## File Operations

### Reading Files

```dart
import 'package:ribs_rill_io/ribs_rill_io.dart';

// Stream raw bytes
final bytes = Files.readAll(Path('data.bin'));

// Stream UTF-8 text lines
final lines = Files.readUtf8Lines(Path('log.txt'));

await lines
    .evalMap((line) => IO.print(line))
    .compile
    .drain
    .unsafeRunFuture();
```

### Writing Files

```dart
// Write bytes via a Pipe
await Rill.emits(Chunk.fromList([104, 101, 108, 108, 111]))
    .through(Files.writeAll(Path('out.bin')))
    .compile
    .drain
    .unsafeRunFuture();

// Write UTF-8 lines
await Rill.emits(Chunk.fromList(['line one', 'line two']))
    .through(Files.writeUtf8Lines(Path('out.txt')))
    .compile
    .drain
    .unsafeRunFuture();
```

### Rotating Log Files

`writeRotate` switches to a new file whenever the current one reaches the size limit.

```dart
int fileIndex = 0;
final rotatePipe = Files.writeRotate(
  IO.delay(() => Path('log-${fileIndex++}.txt')),
  limit: 1024 * 1024, // 1 MB per file
  flags: Flags.Append,
);
```

### Tailing a File

Stream the contents of a file and continue emitting as it grows, like `tail -f`.

```dart
final tail = Files.tail(
  Path('app.log'),
  pollDelay: const Duration(milliseconds: 250),
);
```

### Low-Level File Handles

For precise control use `Files.open` directly.

```dart
final program = Files.open(Path('data.bin'), Flags.Read).use((handle) {
  return handle.size.flatMap((size) {
    return handle.read(size, 0).flatMap((chunk) {
      return IO.print('Read ${chunk.map((c) => c.size).getOrElse(() => 0)} bytes');
    });
  });
});
```

### Directory Operations

```dart
// List a directory recursively
await Files.list(Path('src'))
    .evalMap((path) => IO.print(path.toString()))
    .compile
    .drain
    .unsafeRunFuture();

// Common file system operations
await Files.createDirectory(Path('output')).unsafeRunFuture();
await Files.copy(Path('a.txt'), Path('b.txt')).unsafeRunFuture();
await Files.move(Path('old.txt'), Path('new.txt')).unsafeRunFuture();
await Files.delete(Path('temp.txt')).unsafeRunFuture();
```

### Watching for Changes

```dart
await Files.watch(Path('config'), types: [WatcherEventType.modified])
    .evalMap((event) => IO.print('Changed: ${event.path}'))
    .compile
    .drain
    .unsafeRunFuture();
```

### Temporary Files

```dart
final result = Files.tempFile.use((path) {
  return Files.writeUtf8Lines(path)
      .apply(Rill.emit('hello'))
      .compile
      .drain
      .productR(Files.readUtf8Lines(path).compile.toIList());
});
```

## Network Operations

### TCP Client

```dart
import 'package:ribs_ip/ribs_ip.dart';

final address = SocketAddress.fromParts(ip4"127.0.0.1", port"8080");

final program = Network.connect(address).use((socket) {
  final send = Rill.emits(Chunk.fromList('hello'.codeUnits))
      .through(socket.writes)
      .compile
      .drain;

  final receive = socket.reads
      .through(utf8Decode)
      .evalMap((msg) => IO.print('Received: $msg'))
      .compile
      .drain;

  return send.productR(receive);
});
```

### TCP Server

```dart
final address = SocketAddress.fromParts(ip4"0.0.0.0", port"9000");

final server = Network.bindAndAccept(address).evalMap((socket) {
  // Echo server: pipe reads back to writes
  return socket.reads
      .through(socket.writes)
      .compile
      .drain
      .start(); // handle each connection in its own fiber
});

await server.compile.drain.unsafeRunFuture();
```

### UDP

```dart
final address = SocketAddress.fromParts(ip4"0.0.0.0", port"5000");

final program = Network.bindDatagramSocket(address).use((udp) {
  return udp.reads
      .evalMap((datagram) {
        final msg = String.fromCharCodes(datagram.bytes.toList());
        return IO.print('From ${datagram.remote}: $msg');
      })
      .compile
      .drain;
});
```

## Example

See a complete working example in [example/example.dart](example/example.dart).
