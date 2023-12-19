import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:ribs_ip/ribs_ip.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import 'arbitraries.dart';

void main() {
  Ipv4Address ipv4(int a, int b, int c, int d) =>
      Ipv4Address.fromBytes(a, b, c, d);

  group('Ipv4Address', () {
    test('fromString empty', () {
      expect(Ipv4Address.fromString(''), isNone());
      expect(Ipv4Address.fromString(' '), isNone());
    });

    test('fromString invalid octets', () {
      expect(Ipv4Address.fromString('192.168.0.256'), isNone());
      expect(Ipv4Address.fromString('192.168.o.256'), isNone());
    });

    test('fromString', () {
      expect(
        Ipv4Address.fromString('192.168.0.100'),
        isSome(ipv4(192, 168, 0, 100)),
      );
    });

    forAll('roundtrip through string', genIpv4, (v4) {
      expect(Ipv4Address.fromString(v4.toString()), isSome(v4));
    });

    forAll('roundtrip through int', genIpv4, (v4) {
      expect(Ipv4Address.fromInt(v4.toInt()), v4);
    });

    forAll('supports ordering', genIpv4.tuple2, (tuple) {
      final (left, right) = tuple;

      final biCompare = left.toInt().compareTo(right.toInt());
      final result = left.compareTo(right);

      expect(biCompare.sign, result.sign);
    });

    test('previous', () {
      expect(ipv4(192, 168, 0, 100).previous(), ipv4(192, 168, 0, 99));
      expect(ipv4(0, 0, 0, 0).previous(), ipv4(255, 255, 255, 255));
      expect(ipv4(255, 255, 255, 255).previous(), ipv4(255, 255, 255, 254));
    });

    forAll('compute previous IP (gen)', genIpv4, (v4) {
      expect(v4.previous(), Ipv4Address.fromInt(v4.toInt() - 1));
    });

    test('next', () {
      expect(ipv4(192, 168, 0, 100).next(), ipv4(192, 168, 0, 101));
      expect(ipv4(0, 0, 0, 0).next(), ipv4(0, 0, 0, 1));
      expect(ipv4(255, 255, 255, 255).next(), ipv4(0, 0, 0, 0));
    });

    forAll('compute next IP (gen)', genIpv4, (v4) {
      expect(v4.next(), Ipv4Address.fromInt(v4.toInt() + 1));
    });

    test('mask', () {
      expect(Ipv4Address.mask(15), ipv4(255, 254, 0, 0));
      expect(Ipv4Address.mask(16), ipv4(255, 255, 0, 0));
      expect(Ipv4Address.mask(17), ipv4(255, 255, 128, 0));
    });

    test('maskedLast', () {
      final addr = ipv4(192, 168, 0, 100);
      final mask = ipv4(255, 0, 0, 0);
      expect(addr.maskedLast(mask), ipv4(192, 255, 255, 255));
    });

    test('isMulticast', () {
      final ssmStart = Ipv4Address.MulticastRangeStart;
      final ssmEnd = Ipv4Address.MulticastRangeEnd;

      expect(ssmStart.isMulticast, isTrue);
      expect(ssmStart.next().isMulticast, isTrue);
      expect(ssmStart.previous().isMulticast, isFalse);

      expect(ssmEnd.isMulticast, isTrue);
      expect(ssmEnd.previous().isMulticast, isTrue);
      expect(ssmEnd.next().isMulticast, isFalse);
    });

    test('isSourceSpecificMulticast', () {
      final ssmStart = Ipv4Address.SourceSpecificMulticastRangeStart;
      final ssmEnd = Ipv4Address.SourceSpecificMulticastRangeEnd;

      expect(ssmStart.isSourceSpecificMulticast, isTrue);
      expect(ssmStart.next().isSourceSpecificMulticast, isTrue);
      expect(ssmStart.previous().isSourceSpecificMulticast, isFalse);

      expect(ssmEnd.isSourceSpecificMulticast, isTrue);
      expect(ssmEnd.previous().isSourceSpecificMulticast, isTrue);
      expect(ssmEnd.next().isSourceSpecificMulticast, isFalse);
    });
  });
}
