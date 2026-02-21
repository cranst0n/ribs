import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_ip/ribs_ip.dart';
import 'package:test/test.dart';

void main() {
  test('resolve / reverse roundtrip', () async {
    final hostname = Hostname.fromString(
      'comcast.com',
    ).getOrElse(() => throw 'Dns.resolve test failed');

    final addresses = await Dns.resolve(hostname).unsafeRunFuture();

    final hostnames = await addresses.traverseIO(Dns.reverse).unsafeRunFuture();

    final reversedAddresses = await hostnames.flatTraverseIO(Dns.resolve).unsafeRunFuture();

    expect(addresses.toISet(), reversedAddresses.toISet());
  }, testOn: 'vm');

  test('unknown host', () {
    expect(
      () => Dns.reverse(Ipv4Address.fromBytes(240, 0, 0, 0)).unsafeRunFuture(),
      throwsException,
    );
  }, testOn: 'vm');
}
