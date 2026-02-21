import 'dart:io';

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_ip/ribs_ip.dart';
import 'package:ribs_ip/src/network_interfaces_platform/network_interfaces_platform.dart';

final class NetworkInterfacesPlatformImpl implements NetworkInterfacesPlatform {
  @override
  IO<IMap<String, NetworkInterface>> getAll() {
    throw UnimplementedError();
  }

  @override
  IO<IList<IpAddress>> loopback() => IO.delay(
    () =>
        ilist([
          IpAddress.fromString(InternetAddress.loopbackIPv4.address),
          IpAddress.fromString(InternetAddress.loopbackIPv6.address),
        ]).unNone(),
  );
}
