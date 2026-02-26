import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:ribs_ip/ribs_ip.dart';
import 'package:test/test.dart';

import 'arbitraries.dart';

void main() {
  group('IDN', () {
    genHostname.forAll('supports any hostname', (hostname) {
      final representable = hostname.labels.forall(
        (l) => !l.toString().toLowerCase().startsWith('xn--'),
      );

      if (representable) {
        final idn = IDN.fromHostname(hostname);
        expect(idn.hostname, hostname);
        expect(IDN.fromString(hostname.toString()), isSome(idn));
      }
    });

    genIDN.forAll('roundtrip through string', (idn) {
      expect(IDN.fromString(idn.toString()), isSome(idn));
    });

    genIDN.forAll('allow access to labels', (idn) {
      expect(
        IDN.fromString(idn.labels.mkString(sep: '.')).map((idn) => idn.labels),
        isSome(idn.labels),
      );
    });

    genIDN.forAll('require overall ascii length be less than 254 chars', (idn) {
      final istr = idn.toString();
      final i2 = '$istr.$istr';

      final expected = Option.unless(
        () => idn.hostname.toString().length > 253 ~/ 2,
        () => IDN
            .fromString(i2)
            .getOrElse(
              () => throw Exception('IDN overall length test failed: $idn'),
            ),
      );

      expect(IDN.fromString(i2), expected);
    });

    genIDN.forAll('require labels be less than 64 ascii chars', (idn) {
      final str = idn.toString();
      final suffix = str[str.length - 1] * 63;
      final tooLong = str + suffix;
      expect(IDN.fromString(tooLong), isNone());
    });

    genIDN.forAll('disallow labels that end in a dash', (idn) {
      // Note: simply appending a dash to final label doesn't guarantee the ASCII encoded label ends with a dash
      expect(IDN.fromString('$idn.a-'), isNone());
    });

    genIDN.forAll('disallow labels that start with a dash', (idn) {
      expect(IDN.fromString('-a.$idn'), isNone());
    });

    genIDN.forAll('support normalization', (idn) {
      final expected = IDN
          .fromString(idn.labels.map((a) => a.toString().toLowerCase()).mkString(sep: '.'))
          .getOrElse(
            () => throw Exception('IDN normalization test failed: $idn'),
          );

      expect(idn.normalized(), expected);
    });
  });
}
