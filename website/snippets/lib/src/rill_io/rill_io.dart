// ignore_for_file: unused_local_variable

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_ip/ribs_ip.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_rill_io/ribs_rill_io.dart';

// rill-io-files-read

/// Print each line of a file with a 1-based line number prefix.
IO<Unit> printNumberedLines(Path path) =>
    Files.readUtf8Lines(
      path,
    ).zipWithIndex().evalTap((t) => IO.print('${t.$2 + 1}: ${t.$1}')).compile.drain;

/// Count lines in a file.
IO<int> countLines(Path path) => Files.readUtf8Lines(path).compile.count;

// rill-io-files-read

// rill-io-files-write

/// Copy a file byte-for-byte.
IO<Unit> copyFile(Path src, Path dest) =>
    Files.readAll(src).through(Files.writeAll(dest)).compile.drain;

/// Write a list of strings to a file, one per line.
IO<Unit> writeLines(List<String> lines, Path dest) =>
    Rill.emits(lines).through(Files.writeUtf8Lines(dest)).compile.drain;

// rill-io-files-write

// rill-io-net-client

/// Connect to [addr], send [request] bytes, and collect all response bytes
/// until the server closes the connection.
IO<IList<int>> sendAndReceive(SocketAddress<Ipv4Address> addr, List<int> request) =>
    Network.connect(addr).use((Socket socket) {
      final send = Rill.emits(request).through(socket.writes).compile.drain;
      final recv = socket.reads.compile.toIList;

      // Run send and receive concurrently; the server may start responding
      // before we finish sending.
      return IO.both(send, recv).map((t) => t.$2);
    });

// rill-io-net-client

// rill-io-net-server

/// A TCP echo server: every byte received on a connection is written back.
///
/// [bindAndAccept] turns the server socket into a `Rill<Socket>`.
/// [parEvalMap] handles up to [maxConnections] clients concurrently.
IO<Unit> echoServer(SocketAddress<Ipv4Address> addr, {int maxConnections = 100}) =>
    Network.bindAndAccept(addr)
        .parEvalMap(
          maxConnections,
          (Socket socket) => socket.reads.through(socket.writes).compile.drain,
        )
        .compile
        .drain;

// rill-io-net-server

// rill-io-realworld

/// A TCP echo server with per-connection logging and a connection counter.
///
/// Demonstrates:
/// - [Network.bindAndAccept] to stream incoming connections as a `Rill`
/// - [IO.ref] for shared mutable state across concurrent fibers
/// - [parEvalMap] for bounded concurrency over the connection stream
/// - [guarantee] to log disconnections on success, error, or cancellation
IO<Unit> loggingEchoServer({int port = 9090, int maxConnections = 100}) => IO.ref(0).flatMap((
  Ref<int> counter,
) {
  IO<Unit> handle(Socket socket) => counter.modify((int n) => (n + 1, n + 1)).flatMap((int id) {
    final tag = '[#$id ${socket.remoteAddress}]';

    return IO
        .print('$tag connected')
        .productR(() => socket.reads.through(socket.writes).compile.drain)
        .guarantee(IO.print('$tag disconnected'));
  });

  return Network.bindAndAccept(
    SocketAddress.Wildcard,
  ).parEvalMap(maxConnections, handle).compile.drain;
});

// rill-io-realworld
