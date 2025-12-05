import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_ip/src/host.dart';
import 'package:ribs_ip/src/platform/base.dart';

final class PlatformImpl extends PlatformBase {
  @override
  IO<IList<IpAddress>> loopback() =>
      throw UnimplementedError('Loopback not implemented for web platform');

  @override
  IO<IList<IpAddress>> resolve(Hostname hostname) =>
      throw UnimplementedError('DNS lookup not implemented for web platform');

  @override
  IO<Hostname> reverse(IpAddress address) =>
      throw UnimplementedError('DNS reverse lookup not implemented for web platform');
}
