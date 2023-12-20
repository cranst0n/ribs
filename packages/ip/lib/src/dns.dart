import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_ip/src/host.dart';
import 'package:ribs_ip/src/platform/stub.dart'
    if (dart.library.html) 'platform/web.dart'
    if (dart.library.io) 'platform/native.dart';

final class Dns {
  static final PlatformImpl _platformImpl = PlatformImpl();

  static IO<IList<IpAddress>> loopback() => _platformImpl.loopback();

  static IO<IList<IpAddress>> resolve(Hostname hostname) =>
      _platformImpl.resolve(hostname);

  static IO<Hostname> reverse(IpAddress address) =>
      _platformImpl.reverse(address);

  static IO<Option<Hostname>> reverseOption(IpAddress address) =>
      _platformImpl.reverseOption(address);
}
