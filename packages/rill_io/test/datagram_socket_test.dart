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

  group('DatagramSocket', () {
    test(
      'read - receives a written datagram',
      () async {
        final a = addr(57001);
        final payload = Chunk.fromList([1, 2, 3, 4, 5]);

        final result =
            await Network.bindDatagramSocket(a).use((socket) {
              return socket.write(Datagram(a, payload)).flatMap((_) => socket.read());
            }).unsafeRunFuture();

        expect(result.bytes, equals(payload));
        expect(result.remote.host.toString(), equals('127.0.0.1'));
        expect(result.remote.port.value, equals(57001));
      },
      testOn: 'vm',
    );

    test(
      'reads - receives multiple written datagrams',
      () async {
        final a = addr(57002);
        final payload = Chunk.fromList([10, 20, 30]);

        final result =
            await Network.bindDatagramSocket(a).use((socket) {
              return socket
                  .write(Datagram(a, payload))
                  .flatMap((_) => socket.write(Datagram(a, payload)))
                  .flatMap((_) => socket.write(Datagram(a, payload)))
                  .flatMap((_) => socket.reads.take(3).compile.toIList);
            }).unsafeRunFuture();

        expect(result.length, equals(3));

        for (var i = 0; i < result.length; i++) {
          expect(result[i].bytes, equals(payload));
        }
      },
      testOn: 'vm',
    );
  });
}
