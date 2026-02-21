import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_ip/ribs_ip.dart';
import 'package:ribs_ip/src/network_interfaces_platform/network_interfaces_platform.dart';

final class NetworkInterfaces {
  static final _platformImpl = NetworkInterfacesPlatform();

  static const _instance = NetworkInterfaces._();

  factory NetworkInterfaces() => _instance;

  const NetworkInterfaces._();

  IO<IMap<String, NetworkInterface>> getAll() => _platformImpl.getAll();

  IO<Option<NetworkInterface>> getByAddress(IpAddress address) => getAll().map(
    (all) => all.values.collectFirst(
      (iface) => Option.when(
        () => iface.addresses.exists((addr) => addr.address == address),
        () => iface,
      ),
    ),
  );

  IO<Option<NetworkInterface>> getByName(String name) => getAll().map((all) => all.get(name));

  IO<IList<IpAddress>> loopback() => _platformImpl.loopback();
}
