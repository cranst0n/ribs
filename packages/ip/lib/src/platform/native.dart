import 'dart:io';

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_ip/ribs_ip.dart';
import 'package:ribs_ip/src/platform/base.dart';

final class PlatformImpl extends PlatformBase {
  @override
  IO<IList<IpAddress>> loopback() => IO.delay(() => ilist([
        ipFromInternetAddress(InternetAddress.loopbackIPv4),
        ipFromInternetAddress(InternetAddress.loopbackIPv6),
      ]).unNone());

  @override
  IO<IList<IpAddress>> resolve(Hostname hostname) => IO
      .fromFutureF(() => InternetAddress.lookup(hostname.toString()))
      .map((addresses) => addresses.toIList().collect(ipFromInternetAddress));

  @override
  IO<Hostname> reverse(IpAddress address) => IO
      .fromFutureF(() => InternetAddress(address.toString()).reverse())
      .map(hostnameFromInternetAddress)
      .flatMap((hostnameOpt) => hostnameOpt.fold(
            () => IO.raiseError(
                RuntimeException('Reverse lookup failed for: $address')),
            (a) => IO.pure(a),
          ));

  Option<IpAddress> ipFromInternetAddress(InternetAddress addr) =>
      IpAddress.fromString(addr.address);

  Option<Hostname> hostnameFromInternetAddress(InternetAddress addr) =>
      Option(addr.host).flatMap(Hostname.fromString);
}
