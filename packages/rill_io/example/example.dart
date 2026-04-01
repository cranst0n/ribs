// ignore_for_file: avoid_print
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_ip/ribs_ip.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_rill_io/ribs_rill_io.dart';

void main() async {
  await fileExample().productR(networkExample()).unsafeRunFuture();
}

// ---------------------------------------------------------------------------
// 1. File I/O — write UTF-8 lines to a temp file, then read them back.
// ---------------------------------------------------------------------------

IO<Unit> fileExample() {
  return Files.tempFile.use((path) {
    final lines = ['first line', 'second line', 'third line'];

    // Write lines to the temp file.
    final write = Rill.emits<String>(lines).through(Files.writeUtf8Lines(path)).compile.drain;

    // Stream them back one at a time and print each.
    final read = Files.readUtf8Lines(path).evalMap((line) => IO.print('  $line')).compile.drain;

    return IO
        .print('=== File I/O ===')
        .productR(write)
        .productR(IO.print('Wrote ${lines.length} lines — reading back:'))
        .productR(read);
  });
}

// ---------------------------------------------------------------------------
// 2. TCP echo server + client — a TCP echo server with a client that sends
//                               a message and prints the echoed reply.
// ---------------------------------------------------------------------------

IO<Unit> networkExample() {
  // Accept one connection and echo every byte back.
  IO<Unit> serve(ServerSocket server) {
    return server.accept
        .take(1)
        .evalMap(
          (socket) => socket.reads.through(socket.writes).compile.drain.start().voided(),
        )
        .compile
        .drain;
  }

  // Connect to the server, send a message, then read and print the echo.
  IO<Unit> runClient(SocketAddress serverAddr) {
    return Network.connect(serverAddr).use((socket) {
      const message = 'hello ribs_rill_io\n';

      final send = Rill.emits<int>(
        message.codeUnits.toList(),
      ).through(socket.writes).compile.drain.productR(socket.endOfOutput());

      final receive =
          socket.reads
              .through(Pipes.text.utf8.decode)
              .through(Pipes.text.lines)
              .evalMap((line) => IO.print('  echo: $line'))
              .compile
              .drain;

      return IO.both(send, receive).voided();
    });
  }

  return IO
      .print('\n=== TCP Echo ===')
      .productR(
        Network.bind(SocketAddress.Wildcard).use((server) {
          return IO
              .print('Bound on ${server.localAddress}')
              .productR(IO.both(serve(server), runClient(server.localAddress)).voided());
        }),
      );
}
