import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:ribs_ip/src/mac_address.dart';
import 'package:test/test.dart';

import 'arbitraries.dart';

void main() {
  group('MacAddress', () {
    Gen.listOfN(6, Gen.byte).forAll('roundtrip through string', (bytes) {
      final addr = MacAddress.fromByteList(
        bytes,
      ).getOrElse(() => throw 'MacAddress string roundtrip failed: $bytes');
      expect(MacAddress.fromString(addr.toString()), isSome(addr));
    });

    genMacAddress.tuple2.forAll('support ordering', (macs) {
      final (left, right) = macs;
      final intCompare = left.toInt().compareTo(right.toInt());
      final result = left.compareTo(right);
      expect(result, intCompare);
    });
  });
}
