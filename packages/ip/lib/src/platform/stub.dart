import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_ip/ribs_ip.dart';
import 'package:ribs_ip/src/platform/base.dart';

class PlatformImpl extends PlatformBase {
  @override
  IO<IList<IpAddress>> loopback() => throw UnimplementedError();

  @override
  IO<IList<IpAddress>> resolve(Hostname hostname) => throw UnimplementedError();

  @override
  IO<Hostname> reverse(IpAddress address) => throw UnimplementedError();
}
