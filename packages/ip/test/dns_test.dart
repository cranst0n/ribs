import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_ip/ribs_ip.dart';
import 'package:test/test.dart';

void main() {
  group('Dns', () {
    test('loopback', () async {
      final loopbacks = await Dns.loopback().unsafeRunFuture();

      expect(loopbacks.length, 2);
      expect(loopbacks.contains(Ipv4Address.fromBytes(127, 0, 0, 1)), isTrue);
      expect(
          loopbacks.contains(Ipv6Address.fromString('::1')
              .getOrElse(() => throw 'ipv6 loopback')),
          isTrue);
    });

    test('resolve / reverse roundtrip', () async {
      final hostname = Hostname.fromString('comcast.com')
          .getOrElse(() => throw 'Dns.resolve test failed');

      final addresses = await Dns.resolve(hostname).unsafeRunFuture();

      final hostnames =
          await addresses.traverseIO(Dns.reverse).unsafeRunFuture();

      final reversedAddresses =
          await hostnames.flatTraverseIO(Dns.resolve).unsafeRunFuture();

      expect(addresses.toISet(), reversedAddresses.toISet());
    });

    test('unknown host', () {
      expect(
        () =>
            Dns.reverse(Ipv4Address.fromBytes(240, 0, 0, 0)).unsafeRunFuture(),
        throwsException,
      );
    });
  });
}
