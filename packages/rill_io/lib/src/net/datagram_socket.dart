import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_ip/ribs_ip.dart';
import 'package:ribs_rill/ribs_rill.dart';

/// A bound UDP socket for sending and receiving datagrams.
///
/// Unlike TCP [Socket]s, datagrams are connectionless — each [Datagram]
/// carries its own remote [SocketAddress], and messages are delivered as
/// discrete packets rather than a continuous byte stream.
///
/// Obtain instances via [Network.bindDatagramSocket], which returns a
/// resource-managed socket that is automatically closed on release.
abstract class DatagramSocket {
  /// The local address this socket is bound to.
  SocketAddress get address;

  /// Disconnects the socket, removing any previously set default remote
  /// address.
  IO<Unit> disconnect();

  /// Reads a single [Datagram] from the socket, blocking until one is
  /// available.
  IO<Datagram> read();

  /// A continuous stream of received datagrams. The [Rill] terminates when
  /// the socket is closed.
  Rill<Datagram> get reads;

  /// Sends [datagram] to the remote address specified within it.
  IO<Unit> write(Datagram datagram);

  /// A [Pipe] that sends all incoming datagrams through this socket.
  Pipe<Datagram, Never> get writes;
}

/// A UDP datagram pairing a payload with a remote address.
final class Datagram {
  /// The remote [SocketAddress] this datagram was received from or should
  /// be sent to.
  final SocketAddress remote;

  /// The raw bytes of the datagram payload.
  final Chunk<int> bytes;

  /// Creates a [Datagram] addressed to [remote] carrying [bytes].
  const Datagram(this.remote, this.bytes);
}
