import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_ip/ribs_ip.dart';

abstract class PlatformBase {
  IO<IList<IpAddress>> resolve(Hostname hostname);

  IO<Hostname> reverse(IpAddress address);

  IO<Option<Hostname>> reverseOption(IpAddress address) =>
      reverse(address).map((a) => a.some).handleError((_) => none());

  IO<IList<IpAddress>> loopback();
}
