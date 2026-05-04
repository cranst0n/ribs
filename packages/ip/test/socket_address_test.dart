import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_ip/ribs_ip.dart';
import 'package:ribs_test/ribs_test_core.dart';
import 'package:test/test.dart';

import 'arbitraries.dart';

void main() {
  group('SocketAddress', () {
    genSocketAddress.forAll('roundtrip through string', (sa) {
      expect(SocketAddress.fromString(sa.toString()), isSome(sa));
    });
  });
}
