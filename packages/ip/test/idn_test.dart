import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:ribs_ip/ribs_ip.dart';
import 'package:test/test.dart';

import 'arbitraries.dart';

void main() {
  group('IDN', () {
    forAll('supports any hostname', genHostname, (hostname) {
      final representable = hostname.labels
          .forall((l) => !l.toString().toLowerCase().startsWith('xn--'));

      if (representable) {
        final idn = IDN.fromHostname(hostname);
        expect(idn.hostname, hostname);
        expect(IDN.fromString(hostname.toString()), isSome(idn));
      }
    });

    forAll('roundtrip through string', genIDN, (idn) {
      expect(IDN.fromString(idn.toString()), isSome(idn));
    });

    forAll('allow access to labels', genIDN, (idn) {
      expect(
        IDN.fromString(idn.labels.mkString(sep: '.')).map((idn) => idn.labels),
        isSome(idn.labels),
      );
    });

    forAll('require overall ascii length be less than 254 chars', genIDN,
        (idn) {
      final istr = idn.toString();
      final i2 = '$istr.$istr';

      final expected = Option.unless(
        () => idn.hostname.toString().length > 253 ~/ 2,
        () => IDN.fromString(i2).getOrElse(
              () => throw Exception('IDN overall length test failed: $idn'),
            ),
      );

      expect(IDN.fromString(i2), expected);
    });

    forAll('require labels be less than 64 ascii chars', genIDN, (idn) {
      final str = idn.toString();
      final suffix = str[str.length - 1] * 63;
      final tooLong = str + suffix;
      expect(IDN.fromString(tooLong), isNone());
    });

    forAll('disallow labels that end in a dash', genIDN, (idn) {
      // Note: simply appending a dash to final label doesn't guarantee the ASCII encoded label ends with a dash
      expect(IDN.fromString('$idn.a-'), isNone());
    });

    forAll('disallow labels that start with a dash', genIDN, (idn) {
      expect(IDN.fromString('-a.$idn'), isNone());
    });

    forAll('support normalization', genIDN, (idn) {
      final expected = IDN
          .fromString(idn.labels
              .map((a) => a.toString().toLowerCase())
              .mkString(sep: '.'))
          .getOrElse(
            () => throw Exception('IDN normalization test failed: $idn'),
          );

      expect(idn.normalized(), expected);
    });
  });
}
