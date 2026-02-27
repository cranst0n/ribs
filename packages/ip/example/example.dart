// ignore_for_file: avoid_print

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_ip/ribs_ip.dart';

void main() async {
  // Use mapN to combine all independent Option values. If any are None, the entire result is None.
  final setupResult = (
    Ipv4Address.fromString('192.168.1.1'),
    Ipv6Address.fromString('2001:db8::1'),
    Port.fromInt(8080),
    Hostname.fromString('apple.com'),
    Cidr.fromString('10.0.0.0/8'),
    Ipv4Address.fromString('10.1.2.3'),
  ).mapN((ipv4, ipv6, port, hostname, subnet, testIp) {
    final printDetails = IO.exec(() {
      print('IPv4: $ipv4');
      print('IPv6: $ipv6');
      print('IPv4 as Mapped V6: ${ipv4.toMappedV6()}\n');

      print('Port: $port');
      print('Hostname: $hostname\n');

      print('Subnet: $subnet');
      print('Contains $testIp? ${subnet.contains(testIp)}');
      print('Prefix: ${subnet.prefix()}');
      print('Last address: ${subnet.last()}\n');

      final socketAddr = SocketAddress(ipv4, port);
      print('Socket Address: $socketAddr\n');
    });

    // Combine with asynchronous DNS effects
    return printDetails.productR(
      () => Dns.resolve(hostname).flatMap((ips) {
        print('--- DNS lookup for $hostname ---');
        ips.foreach((ip) => print('Resolved IP: $ip'));

        return ips.headOption.fold(
          () => IO.unit,
          (ip) =>
              Dns.reverse(ip).flatMap((reverse) => IO.print('Reverse lookup for $ip: $reverse')),
        );
      }),
    );
  });

  // Run the combined program, or report failure if input parsing failed.
  await setupResult.sequence().unsafeRunFuture();
}
