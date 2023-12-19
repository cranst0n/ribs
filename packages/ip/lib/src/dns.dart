import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_ip/ribs_ip.dart';

sealed class Dns {
  IO<IpAddress> resolve(Hostname hostname);

  IO<Option<IpAddress>> resolveOption(Hostname hostname);

  IO<IList<IpAddress>> resolveAll(Hostname hostname);

  IO<Hostname> reverse(IpAddress address);

  IO<Option<Hostname>> reverseOption(IpAddress address);

  IO<IpAddress> loopback();
}

// TODO: Platformize
final class DnsNative extends Dns {
  @override
  IO<IpAddress> loopback() {
    throw UnimplementedError();
  }

  @override
  IO<IpAddress> resolve(Hostname hostname) {
    throw UnimplementedError();
  }

  @override
  IO<IList<IpAddress>> resolveAll(Hostname hostname) {
    throw UnimplementedError();
  }

  @override
  IO<Option<IpAddress>> resolveOption(Hostname hostname) {
    throw UnimplementedError();
  }

  @override
  IO<Hostname> reverse(IpAddress address) {
    throw UnimplementedError();
  }

  @override
  IO<Option<Hostname>> reverseOption(IpAddress address) {
    throw UnimplementedError();
  }
}
