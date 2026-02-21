import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_ip/ribs_ip.dart';
import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_rill_io/ribs_rill_io.dart';
import 'package:ribs_rill_io/src/net/network_platform/network_platform.dart';

final class Network {
  const Network._();

  static final _platform = NetworkPlatform();

  static Resource<DatagramSocket> bindDatagramSocket(SocketAddress address) =>
      _platform.bindDatagramSocket(address);

  static Resource<ServerSocket> bind(SocketAddress address) => _platform.bind(address);

  static Rill<Socket> bindAndAccept(SocketAddress address) =>
      Rill.resource(bind(address)).flatMap((ss) => ss.accept);

  static Resource<Socket> connect(SocketAddress address) => _platform.connect(address);

  static NetworkInterfaces get interfaces => NetworkInterfaces();
}
