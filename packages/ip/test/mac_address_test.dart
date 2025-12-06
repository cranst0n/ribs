import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:ribs_ip/src/mac_address.dart';
import 'package:test/test.dart';

import 'arbitraries.dart';

void main() {
  group('MacAddress', () {
    forAll('roundtrip through string', Gen.listOfN(6, Gen.byte), (bytes) {
      final addr = MacAddress.fromByteList(
        bytes,
      ).getOrElse(() => throw 'MacAddress string roundtrip failed: $bytes');
      expect(MacAddress.fromString(addr.toString()), isSome(addr));
    });

    forAll('support ordering', genMacAddress.tuple2, (macs) {
      final (left, right) = macs;
      final intCompare = left.toInt().compareTo(right.toInt());
      final result = left.compareTo(right);
      expect(result, intCompare);
    });
  });
}
