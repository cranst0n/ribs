import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_ip/ribs_ip.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_rill_io/ribs_rill_io.dart';
import 'package:ribs_rill_io/src/net/network_platform/network_platform.dart';

/// Pure, effectful networking operations for TCP and UDP communication.
///
/// [Network] provides a static API for creating client sockets, server
/// sockets, and datagram (UDP) sockets — all expressed as [Resource] or
/// [Rill] values that are referentially transparent and only execute when
/// interpreted.
final class Network {
  const Network._();

  static final _platform = NetworkPlatform();

  /// Binds a UDP socket to [address] and returns a resource-managed
  /// [DatagramSocket].
  ///
  /// The socket is automatically closed when the [Resource] is released.
  static Resource<DatagramSocket> bindDatagramSocket(SocketAddress address) =>
      _platform.bindDatagramSocket(address);

  /// Binds a TCP server socket to [address] and returns a resource-managed
  /// [ServerSocket].
  ///
  /// The server socket is automatically closed when the [Resource] is
  /// released. Use [ServerSocket.accept] to obtain connected client sockets,
  /// or use [bindAndAccept] for a more concise alternative.
  static Resource<ServerSocket> bind(SocketAddress address) => _platform.bind(address);

  /// Binds a TCP server to [address] and emits each accepted client
  /// connection as a [Socket].
  ///
  /// This is a convenience that combines [bind] with [ServerSocket.accept]
  /// into a single [Rill]. The server socket is automatically managed and
  /// closed when the stream terminates.
  static Rill<Socket> bindAndAccept(SocketAddress address) =>
      Rill.resource(bind(address)).flatMap((ss) => ss.accept);

  /// Establishes a TCP connection to [address] and returns a
  /// resource-managed [Socket].
  ///
  /// The socket is automatically closed when the [Resource] is released.
  static Resource<Socket> connect(SocketAddress address) => _platform.connect(address);

  /// Provides access to the network interfaces available on the host.
  static NetworkInterfaces get interfaces => NetworkInterfaces();
}
