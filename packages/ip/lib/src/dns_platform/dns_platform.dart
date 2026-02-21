import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_ip/ribs_ip.dart';
import 'package:ribs_ip/src/dns_platform/dns_platform_stub.dart'
    if (dart.library.io) 'package:ribs_ip/src/dns_platform/dns_platform_io.dart'
    if (dart.library.html) 'package:ribs_ip/src/dns_platform/dns_platform_web.dart';

abstract class DnsPlatform {
  factory DnsPlatform() => DnsPlatformImpl();

  IO<IList<IpAddress>> loopback();

  IO<IList<IpAddress>> resolve(Hostname hostname);

  IO<Hostname> reverse(IpAddress address);

  IO<Option<Hostname>> reverseOption(IpAddress address) =>
      reverse(address).map((a) => a.some).handleError((_) => none());
}
