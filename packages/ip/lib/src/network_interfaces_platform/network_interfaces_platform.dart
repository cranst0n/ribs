import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_ip/ribs_ip.dart';
import 'package:ribs_ip/src/network_interfaces_platform/network_interfaces_platform_stub.dart'
    if (dart.library.io) 'package:ribs_ip/src/network_interfaces_platform/network_interfaces_platform_io.dart';

abstract class NetworkInterfacesPlatform {
  factory NetworkInterfacesPlatform() => NetworkInterfacesPlatformImpl();

  IO<IMap<String, NetworkInterface>> getAll();

  IO<IList<IpAddress>> loopback();
}
