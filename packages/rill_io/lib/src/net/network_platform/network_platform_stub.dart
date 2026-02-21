import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_ip/ribs_ip.dart';
import 'package:ribs_rill_io/ribs_rill_io.dart';
import 'package:ribs_rill_io/src/net/network_platform/network_platform.dart';

class NetworkPlatformImpl implements NetworkPlatform {
  @override
  Resource<ServerSocket> bind(SocketAddress<Host> address) =>
      throw UnimplementedError('Network.bind');

  @override
  Resource<DatagramSocket> bindDatagramSocket(SocketAddress<Host> address) =>
      throw UnimplementedError('Network.bindDatagramSocket');

  @override
  Resource<Socket> connect(SocketAddress<Host> address) =>
      throw UnimplementedError('Network.connect');
}
