import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:ribs_ip/ribs_ip.dart';
import 'package:test/test.dart';

import 'arbitraries.dart';

void main() {
  group('SocketAddress', () {
    forAll('roundtrip through string', genSocketAddress, (sa) {
      expect(SocketAddress.fromString(sa.toString()), isSome(sa));
    });
  });
}
