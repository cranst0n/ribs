import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_ip/ribs_ip.dart';
import 'package:ribs_ip/src/network_interfaces_platform/network_interfaces_platform.dart';

class NetworkInterfacesPlatformImpl implements NetworkInterfacesPlatform {
  @override
  IO<IMap<String, NetworkInterface>> getAll() => throw UnimplementedError();

  @override
  IO<IList<IpAddress>> loopback() => throw UnimplementedError('NetworkInterfaces.loopback');
}
