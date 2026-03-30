---
sidebar_position: 80
---


# Rill I/O

`ribs_rill_io` is the I/O layer for `ribs_rill`. It provides purely functional,
resource-safe abstractions for reading and writing files and network sockets,
all expressed as `Rill` streams and `IO` effects.

Two top-level namespaces cover the main use cases:

| Namespace | Description |
|---|---|
| `Files` | Stream file contents, write streams to disk, manage paths |
| `Network` | Bind TCP/UDP sockets, accept client connections, connect to servers |

---

## Files

### Path

`Path` is a lightweight extension type over `String` that wraps the `path`
package for cross-platform path manipulation.

```dart
final log  = Path.current / 'logs' / 'app.log'; // relative → absolute
final name = log.fileName;                        // Path('app.log')
final ext  = log.extension;                       // '.log'
```

The `/` operator joins segments; `+` joins two `Path` values. Both normalise
the result automatically.

---

### Reading

The three high-level read helpers cover the most common cases:

| Method | Returns | Description |
|---|---|---|
| `Files.readAll(path)` | `Rill<int>` | Stream raw bytes |
| `Files.readUtf8(path)` | `Rill<String>` | Decode bytes as UTF-8 |
| `Files.readUtf8Lines(path)` | `Rill<String>` | Decode and split by line |

All three are lazy — no file is opened until the `Rill` is compiled into an
`IO` and run. The file is closed automatically when the stream ends, errors, or
is canceled.

<<< @/../snippets/lib/src/rill_io/rill_io.dart#rill-io-files-read

For partial reads, `Files.readRange(path, start: s, end: e)` streams a
byte range, and `Files.tail(path)` emulates `tail -f` — it streams new bytes
as they are appended.

### Writing

Write helpers mirror the read API and return `Pipe<I, Never>` — apply them with
`.through(...)` to pipe a `Rill` directly into a file.

| Method | Returns | Description |
|---|---|---|
| `Files.writeAll(path)` | `Pipe<int, Never>` | Write raw bytes |
| `Files.writeUtf8(path)` | `Pipe<String, Never>` | Encode strings as UTF-8 |
| `Files.writeUtf8Lines(path)` | `Pipe<String, Never>` | Write strings separated by the platform line separator |

<<< @/../snippets/lib/src/rill_io/rill_io.dart#rill-io-files-write

To append rather than truncate, pass `flags: Flags.Append` to `writeAll` or
open a `WriteCursor` directly via `Files.writeCursor(path, Flags.Append)`.

### File management

`Files` also exposes the usual filesystem operations as `IO` effects:

| Method | Returns | Description |
|---|---|---|
| `Files.exists(path)` | `IO<bool>` | Check if a path exists |
| `Files.list(path)` | `Rill<Path>` | Stream directory entries |
| `Files.copy(src, dest)` | `IO<Unit>` | Copy a file |
| `Files.move(src, dest)` | `IO<Unit>` | Move / rename |
| `Files.delete(path)` | `IO<Unit>` | Delete a file or empty directory |
| `Files.deleteRecursively(path)` | `IO<Unit>` | Recursive delete |
| `Files.size(path)` | `IO<int>` | File size in bytes |
| `Files.tempFile` | `Resource<Path>` | Create a temp file, delete on release |
| `Files.tempDirectory` | `Resource<Path>` | Create a temp dir, delete on release |

---

## Network

`Network` provides TCP and UDP socket operations. All sockets are managed as
`Resource` values — they are closed automatically when the resource scope exits,
regardless of success, error, or cancellation.

### TCP client

`Network.connect(address)` opens a TCP connection and returns a
`Resource<Socket>`. Inside the resource:

- `socket.reads` — `Rill<int>` of received bytes, terminates on EOF
- `socket.writes` — `Pipe<int, Never>` that sends bytes to the server
- `socket.endOfOutput()` — half-close (send TCP FIN while still receiving)

<<< @/../snippets/lib/src/rill_io/rill_io.dart#rill-io-net-client

### TCP server

`Network.bind(address)` returns a `Resource<ServerSocket>`.
`Network.bindAndAccept(address)` is a convenience wrapper that turns the
server directly into a `Rill<Socket>`, one element per accepted connection.
Combine it with `parEvalMap` to handle connections concurrently:

<<< @/../snippets/lib/src/rill_io/rill_io.dart#rill-io-net-server

### UDP

`Network.bindDatagramSocket(address)` returns a `Resource<DatagramSocket>`.
`DatagramSocket.reads` streams `Datagram` values (each carrying a
`Chunk<int>` payload and a `SocketAddress` identifying the sender);
`DatagramSocket.writes` is a `Pipe<Datagram, Never>` for sending.

---

## Real-world example: echo server with logging

The example below combines file-level features with the network API to build a
small but complete TCP echo server. Each accepted connection is handled
concurrently by a dedicated fiber. An `IO.ref` counter assigns a unique ID to
each connection, and `guarantee` ensures the disconnect log line is printed even
if the handler errors or is canceled.

<<< @/../snippets/lib/src/rill_io/rill_io.dart#rill-io-realworld

Start it with:

```dart
void main() => loggingEchoServer(port: 9090).unsafeRunAndForget();
```

The server runs until the process exits. Canceling the outer `IO` (e.g. via
`SIGINT`) propagates through the `Rill` and causes `parEvalMap` to cancel all
in-flight connection handlers, guaranteeing that disconnect logs and any other
finalizers run cleanly.
