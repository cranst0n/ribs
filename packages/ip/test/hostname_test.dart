import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:ribs_ip/ribs_ip.dart';
import 'package:test/test.dart';

import 'arbitraries.dart';

void main() {
  group('Hostname', () {
    genHostname.forAll('roundtrip through string', (hostname) {
      expect(Hostname.fromString(hostname.toString()), isSome(hostname));
    });

    genHostname.forAll('allow access to labels', (hostname) {
      expect(
        Hostname.fromString(hostname.labels.mkString(sep: '.')).map((h) => h.labels),
        isSome(hostname.labels),
      );
    });

    genHostname.forAll('require overall length be less than 254 chars', (hostname) {
      final hstr = hostname.toString();
      final h2 = '$hstr.$hstr';

      final expected = Option.unless(
        () => h2.length > 253,
        () => Hostname.fromString(h2).getOrElse(
          () => throw Exception('IDN overall length test failed: $hostname'),
        ),
      );

      expect(Hostname.fromString(h2), expected);
    });

    genHostname.forAll('require labels be less than 64 chars', (hostname) {
      final hstr = hostname.toString();
      final suffix = hstr[hstr.length - 1] * 63;
      final tooLong = hstr + suffix;

      expect(Hostname.fromString(tooLong), isNone());
    });

    genHostname.forAll('disallow labels that end in a dash', (hostname) {
      expect(Hostname.fromString('$hostname-'), isNone());
    });

    genHostname.forAll('disallow labels that start with a dash', (hostname) {
      expect(Hostname.fromString('-$hostname'), isNone());
    });
  });
}
