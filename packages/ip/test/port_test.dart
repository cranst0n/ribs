import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:ribs_ip/ribs_ip.dart';
import 'package:test/test.dart';

import 'arbitraries.dart';

void main() {
  group('Port', () {
    forAll('roundtrip through string', genPort, (port) {
      expect(Port.fromString(port.toString()), isSome(port));
    });
  });
}
