import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_ip/ribs_ip.dart';
import 'package:ribs_rill/ribs_rill.dart';

/// A connected TCP socket, providing bidirectional byte-stream I/O.
///
/// A [Socket] exposes a [reads] stream for incoming data and [write] /
/// [writes] for outgoing data. Obtain one via [Network.client] (which
/// returns a resource-managed socket that is automatically closed on
/// release) or from a server's accepted connection stream.
///
/// ```dart
/// Network.client(host, port).use((socket) {
///   final response = socket.reads.through(Pipes.text.utf8.decode);
///   return socket.write(requestBytes).flatMap((_) => response.compile.string);
/// });
/// ```
abstract class Socket {
  /// Local address of this socket.
  SocketAddress get localAddress;

  /// Remote address of the connected server.
  SocketAddress get remoteAddress;

  /// Continuous stream of received bytes. Terminates on EOF (remote closed
  /// its write side).
  Rill<int> get reads;

  /// Write [bytes] to the socket.
  IO<Unit> write(Chunk<int> bytes);

  /// A pipe that writes all emitted bytes to this socket.
  Pipe<int, Never> get writes;

  /// Half-close the write side (flushes and sends TCP FIN). The socket can
  /// still receive data after this call. Use this when you are done writing
  /// but want to keep reading until the peer closes.
  IO<Unit> endOfOutput();
}
