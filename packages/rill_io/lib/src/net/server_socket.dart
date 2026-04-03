import 'package:ribs_ip/ribs_ip.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_rill_io/src/net/socket.dart';

/// A server socket that listens for incoming TCP connections.
///
/// Obtain instances via [Network.server] (which returns a resource-managed
/// server that is automatically closed on release). The [accept] Rill
/// emits connected [Socket] instances, each of which should be closed by
/// the caller when done (e.g. via [Resource] or [IO.bracket]).
abstract class ServerSocket {
  /// The local address this server is bound to.
  SocketAddress get localAddress;

  /// A Rill of accepted client connections. Each emitted [Socket] should be
  /// closed by the caller when done (e.g. via [Resource] or [IO.bracket]).
  Rill<Socket> get accept;
}
