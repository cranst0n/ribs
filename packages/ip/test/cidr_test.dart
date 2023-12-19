import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:ribs_ip/ribs_ip.dart';
import 'package:test/test.dart';

import 'arbitraries.dart';

void main() {
  group('Cidr', () {
    forAll('roundtrip through string', genCidr(genIp), (cidr) {
      expect(Cidr.fromString(cidr.toString()), isSome(cidr));
    });

    forAll('fromIpAndMask', (genIp, Gen.nonNegativeInt).tupled, (tuple) {
      final (ip, prefixBits0) = tuple;
      final prefixBits = (prefixBits0 % ip.bitSize) + 1;
      final maskInt = BigInt.from(-1) << (ip.bitSize - prefixBits);
      final mask = ip.fold(
        (_) => Ipv4Address.fromInt(maskInt.toInt() & 0xffffffff),
        (_) => Ipv6Address.fromBigInt(maskInt),
      );

      expect(Cidr.fromIpAndMask(ip, mask), Cidr.of(ip, prefixBits));
    });

    forAll('parsing from string: only masks with a valid length return a CIDR',
        (genIp, Gen.nonNegativeInt).tupled, (tuple) {
      final (ip, prefixBits) = tuple;

      final cidr = Cidr.fromString('$ip/$prefixBits');
      expect(cidr.isDefined, 0 <= prefixBits && prefixBits <= ip.bitSize);
    });
  });
}
