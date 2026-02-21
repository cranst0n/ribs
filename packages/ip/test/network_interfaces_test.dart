import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_ip/ribs_ip.dart';
import 'package:test/test.dart';

void main() {
  test('loopback', () async {
    final loopbacks = await NetworkInterfaces().loopback().unsafeRunFuture();

    expect(loopbacks.length, 2);
    expect(loopbacks.contains(Ipv4Address.fromBytes(127, 0, 0, 1)), isTrue);
    expect(
      loopbacks.contains(Ipv6Address.fromString('::1').getOrElse(() => throw 'ipv6 loopback')),
      isTrue,
    );
  }, testOn: 'vm');
}
