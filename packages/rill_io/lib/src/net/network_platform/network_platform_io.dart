import 'dart:async' show StreamSubscription;
import 'dart:io' as io;
import 'dart:io' show InternetAddress, RawDatagramSocket, RawSocketEvent;

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_ip/ribs_ip.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_rill_io/ribs_rill_io.dart';
import 'package:ribs_rill_io/src/net/network_platform/network_platform.dart';

final class NetworkPlatformImpl implements NetworkPlatform {
  @override
  Resource<ServerSocket> bind(SocketAddress<Host> address) => Resource.make(
    IO.fromFutureF(() => io.ServerSocket.bind(address.host.toString(), address.port.value)),
    (server) => IO.fromFutureF(server.close).voided(),
  ).map(_ServerSocketIO.new);

  @override
  Resource<DatagramSocket> bindDatagramSocket(SocketAddress<Host> address) => Resource.make(
    IO.fromFutureF(() => RawDatagramSocket.bind(address.host.toString(), address.port.value)),
    (socket) => IO.exec(socket.close),
  ).map((rawSocket) => _DatagramSocketIO(address, rawSocket));

  @override
  Resource<Socket> connect(SocketAddress<Host> address) => Resource.make(
    IO.fromFutureF(() => io.Socket.connect(address.host.toString(), address.port.value)),
    (socket) => IO.exec(socket.destroy),
  ).map(_SocketIO.new);
}

final class _DatagramSocketIO extends DatagramSocket {
  @override
  final SocketAddress address;

  final RawDatagramSocket _socket;

  final InternetAddress _ioAddress;

  _DatagramSocketIO(this.address, this._socket)
    : _ioAddress = InternetAddress(address.host.toString());

  @override
  IO<Unit> disconnect() => IO.exec(() => _socket.close());

  @override
  IO<Datagram> read() => IO.async((cb) {
    late StreamSubscription<RawSocketEvent> sub;

    sub = _socket.listen((event) {
      switch (event) {
        case RawSocketEvent.read:
          final raw = _socket.receive();

          if (raw != null) {
            sub.cancel();
            cb(_toDatagram(raw).toRight(() => StateError('invalid datagram')));
          }
        case RawSocketEvent.closed:
        case RawSocketEvent.readClosed:
          sub.cancel();
          cb(StateError('socket closed').asLeft());
        default:
          break;
      }
    });

    return IO.pure(Some(IO.fromFutureF(() => sub.cancel()).voided()));
  });

  @override
  Rill<Datagram> get reads =>
      Rill.fromStream(
        _socket
            .where((e) => e == RawSocketEvent.read)
            .expand((_) sync* {
              io.Datagram? raw;

              while ((raw = _socket.receive()) != null) {
                yield raw!;
              }
            })
            .map(_toDatagram),
      ).unNone;

  @override
  IO<Unit> write(Datagram datagram) => IO.exec(
    () => _socket.send(datagram.bytes.toList(), _ioAddress, address.port.value),
  );

  @override
  Pipe<Datagram, Never> get writes => (rill) => rill.foreach(write);

  Option<Datagram> _toDatagram(io.Datagram raw) {
    return (
      IpAddress.fromString(raw.address.address),
      Port.fromInt(raw.port),
    ).mapN(
      (remoteHost, remotePort) =>
          Datagram(SocketAddress(remoteHost, remotePort), Chunk.fromDart(raw.data)),
    );
  }
}

SocketAddress _parseAddress(InternetAddress addr, int port) => SocketAddress(
  IpAddress.fromString(addr.address).getOrElse(
    () => throw StateError('cannot parse socket address: ${addr.address}'),
  ),
  Port.fromInt(port).getOrElse(() => throw StateError('invalid port: $port')),
);

final class _ServerSocketIO extends ServerSocket {
  final io.ServerSocket _serverSocket;

  @override
  final SocketAddress localAddress;

  _ServerSocketIO(this._serverSocket)
    : localAddress = _parseAddress(_serverSocket.address, _serverSocket.port);

  @override
  Rill<Socket> get accept => Rill.fromStream(_serverSocket).map(_SocketIO.new);
}

final class _SocketIO extends Socket {
  final io.Socket _socket;

  @override
  final SocketAddress localAddress;

  @override
  final SocketAddress remoteAddress;

  _SocketIO(this._socket)
    : localAddress = _parseAddress(_socket.address, _socket.port),
      remoteAddress = _parseAddress(_socket.remoteAddress, _socket.remotePort);

  @override
  Rill<int> get reads => Rill.fromStream(_socket.expand((bytes) => bytes));

  @override
  IO<Unit> write(Chunk<int> bytes) => IO.exec(() => _socket.add(bytes.toDartList()));

  @override
  Pipe<int, Never> get writes => (rill) => rill.chunks().foreach(write);

  @override
  IO<Unit> endOfOutput() => IO.fromFutureF(_socket.close).voided();
}
