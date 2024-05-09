import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:ribs_ip/ribs_ip.dart';
import 'package:test/test.dart';

import 'arbitraries.dart';

void main() {
  group('Host', () {
    forAll('fromString: IPAddress', genIp, (ip) {
      expect(
        Host.fromString(ip.toString()),
        isSome(ip.asHost),
      );
    });

    forAll('fromString: Hostname', genHostname, (hostname) {
      expect(
        Host.fromString(hostname.toString()),
        isSome(hostname.asHost),
      );
    });

    forAll('fromString: IDN', genIDN, (idn) {
      expect(
        Host.fromString(idn.toString()).map((a) => a.toString()),
        isSome(idn.toString()),
      );
    });
  });
}
