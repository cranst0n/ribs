import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_ip/ribs_ip.dart';
import 'package:ribs_ip/src/dns_platform/dns_platform.dart';

class DnsPlatformImpl implements DnsPlatform {
  @override
  IO<IList<IpAddress>> loopback() => throw UnimplementedError();

  @override
  IO<IList<IpAddress>> resolve(Hostname hostname) => throw UnimplementedError();

  @override
  IO<Hostname> reverse(IpAddress address) => throw UnimplementedError();

  @override
  IO<Option<Hostname>> reverseOption(IpAddress address) => throw UnimplementedError();
}
