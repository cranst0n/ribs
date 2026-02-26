import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:ribs_ip/ribs_ip.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'arbitraries.dart';

void main() {
  group('Ipv6Address', () {
    test('fromString empty', () {
      expect(Ipv6Address.fromString(''), isNone());
      expect(Ipv6Address.fromString(' '), isNone());
    });

    test('fromString single :', () {
      expect(Ipv6Address.fromString(':'), isNone());
      expect(Ipv6Address.fromString(' : '), isNone());
    });

    test('fromString ::', () {
      expect(Ipv6Address.fromString('::'), isSome<Ipv6Address>());
      expect(Ipv6Address.fromString(' :: '), isSome<Ipv6Address>());
    });

    test('fromString :::', () {
      expect(Ipv6Address.fromString(':::'), isNone());
      expect(Ipv6Address.fromString(' ::: '), isNone());
    });

    genIpv4.forAll('parses mixed strings', (v4) {
      expect(Ipv6Address.fromString('::$v4'), isSome(v4.toCompatV6()));
      expect(Ipv6Address.fromString('::ffff:$v4'), isSome(v4.toMappedV6()));
    });

    test('parsing from string - does not misinterpret hosts', () {
      expect(Ipv6Address.fromString('db'), isNone());
    });

    genIpv6.forAll('support converting to uncondensed string format', (v6) {
      expect(v6.toUncondensedString().length, 4 * 8 + 7);
    });

    genIpv6.forAll('uncondensed string roundtrip', (v6) {
      expect(Ipv6Address.fromString(v6.toUncondensedString()), isSome(v6));
    });

    genIpv4.forAll('support converting to mixed string form', (v4) {
      expect(v4.toCompatV6().toMixedString(), '::$v4');
      expect(v4.toMappedV6().toMixedString(), '::ffff:$v4');
    });

    genIpv6.forAll('mixed string roundtrip', (v6) {
      expect(Ipv6Address.fromString(v6.toMixedString()), isSome(v6));
    });

    genIpv6.forAll('BigInt roundtrip', (v6) {
      expect(Ipv6Address.fromBigInt(v6.toBigInt()), v6);
    });

    genIpv6.tuple2.forAll('supports ordering', (tuple) {
      final (left, right) = tuple;

      final biCompare = left.toBigInt().compareTo(right.toBigInt());
      final result = left.compareTo(right);

      expect(biCompare.sign, result.sign);
    });

    test('compute next IP', () {
      expect(
        Ipv6Address.fromString('ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff').map((ip) => ip.next()),
        Ipv6Address.fromString('::'),
      );
    });

    test('compute previous IP', () {
      expect(
        Ipv6Address.fromString('::').map((ip) => ip.previous()),
        Ipv6Address.fromString('ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff'),
      );
    });

    genIpv6.forAll('compute next IP (gen)', (v6) {
      expect(v6.next(), Ipv6Address.fromBigInt(v6.toBigInt() + BigInt.one));
    });

    genIpv6.forAll('compute previous IP (gen)', (v6) {
      expect(v6.previous(), Ipv6Address.fromBigInt(v6.toBigInt() - BigInt.one));
    });

    test('converting V4 mapped address', () {
      final addr = Ipv6Address.fromString('::ffff:f:f').getOrElse(() => fail('ip parse failed'));

      expect(addr.version, IpVersion.v6);
      expect(addr.toString(), '::ffff:f:f');
      expect(addr.collapseMappedV4(), isA<Ipv4Address>());
      expect(addr.asIpv6(), Some(addr));
      expect(addr.asIpv4(), Ipv4Address.fromString('0.15.0.15'));
    });

    test('isMulticast', () {
      final ssmStart = Ipv6Address.MulticastRangeStart;
      final ssmEnd = Ipv6Address.MulticastRangeEnd;

      expect(ssmStart.isMulticast, isTrue);
      expect(ssmStart.next().isMulticast, isTrue);
      expect(ssmStart.previous().isMulticast, isFalse);

      expect(ssmEnd.isMulticast, isTrue);
      expect(ssmEnd.previous().isMulticast, isTrue);
      expect(ssmEnd.next().isMulticast, isFalse);
    });

    test('isSourceSpecificMulticast', () {
      final ssmStart = Ipv6Address.SourceSpecificMulticastRangeStart;
      final ssmEnd = Ipv6Address.SourceSpecificMulticastRangeEnd;

      expect(ssmStart.isSourceSpecificMulticast, isTrue);
      expect(ssmStart.next().isSourceSpecificMulticast, isTrue);
      expect(ssmStart.previous().isSourceSpecificMulticast, isFalse);

      expect(ssmEnd.isSourceSpecificMulticast, isTrue);
      expect(ssmEnd.previous().isSourceSpecificMulticast, isTrue);
      expect(ssmEnd.next().isSourceSpecificMulticast, isFalse);
    });

    test('prefixBits', () {
      final addr = Ipv6Address.mask(23);
      expect(addr.prefixBits(), 23);
    });
  });
}
