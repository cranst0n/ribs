import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:ribs_ip/ribs_ip.dart';
import 'package:test/test.dart';

import 'arbitraries.dart';

void main() {
  group('Multicast', () {
    forAll('support equality', genMulticast4, (mip) {
      expect(mip.address.asMulticast(), isSome(mip));
    });

    test('support SSM outside source specific range', () {
      final mip = Ipv4Address.fromBytes(239, 10, 10, 10);

      expect(mip.asSourceSpecificMulticast(), isNone());

      expect(
        mip.asSourceSpecificMulticastLenient().map((a) => a.address),
        isSome(mip),
      );
    });
  });
}
