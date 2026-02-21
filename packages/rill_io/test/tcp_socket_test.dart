import 'dart:async' show Completer;

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_ip/ribs_ip.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_rill_io/ribs_rill_io.dart';
import 'package:test/test.dart';

void main() {
  SocketAddress addr(int port) => SocketAddress(
    Ipv4Address.fromBytes(127, 0, 0, 1),
    Port.fromInt(port).getOrElse(() => throw StateError('invalid port: $port')),
  );

  group('Socket', () {
    test(
      'bind + connect: client bytes reach the server',
      () async {
        const payload = [1, 2, 3, 4, 5];

        // The Completer fires synchronously inside the Resource.use callback,
        // which is invoked only after io.ServerSocket.bind() has completed.
        // Awaiting it guarantees the server is listening before we connect.
        final serverReady = Completer<void>();

        final serverFuture =
            Network.bind(addr(58001)).use((server) {
              serverReady.complete();
              return server.accept
                  .take(1)
                  .flatMap((client) => client.reads.take(payload.length))
                  .compile
                  .toIList;
            }).unsafeRunFuture();

        await serverReady.future;

        final clientFuture =
            Network.connect(addr(58001)).use((socket) {
              return Rill.emits(payload).through(socket.writes).compile.drain;
            }).unsafeRunFuture();

        final received = await serverFuture;
        await clientFuture;

        expect(received.toList(), equals(payload));
      },
      testOn: 'vm',
    );

    test(
      'bindAndAccept: streams incoming client connections',
      () async {
        const payload = [10, 20, 30];

        // bindAndAccept binds lazily inside the Rill; yield to the event loop
        // via a short delay to let the bind complete before connecting.
        final serverFuture =
            Network.bindAndAccept(addr(58002))
                .take(1)
                .flatMap((client) => client.reads.take(payload.length))
                .compile
                .toIList
                .unsafeRunFuture();

        await Future<void>.delayed(const Duration(milliseconds: 50));

        final clientFuture =
            Network.connect(addr(58002)).use((socket) {
              return Rill.emits(payload).through(socket.writes).compile.drain;
            }).unsafeRunFuture();

        final received = await serverFuture;
        await clientFuture;

        expect(received.toList(), equals(payload));
      },
      testOn: 'vm',
    );
  });
}
