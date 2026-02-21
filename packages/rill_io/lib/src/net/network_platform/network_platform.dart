import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_ip/ribs_ip.dart';
import 'package:ribs_rill_io/ribs_rill_io.dart';
import 'package:ribs_rill_io/src/net/network_platform/network_platform_stub.dart'
    if (dart.library.io) 'package:ribs_rill_io/src/net/network_platform/network_platform_io.dart';

abstract class NetworkPlatform {
  factory NetworkPlatform() => NetworkPlatformImpl();

  Resource<ServerSocket> bind(SocketAddress address);

  Resource<DatagramSocket> bindDatagramSocket(SocketAddress address);

  Resource<Socket> connect(SocketAddress address);
}
