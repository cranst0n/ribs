import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/ribs_core_test.dart';
import 'package:ribs_ip/ribs_ip.dart';
import 'package:test/test.dart';

import 'arbitraries.dart';

void main() {
  // IPv4 address constants
  final nonMulticast4 = Ipv4Address.fromBytes(192, 168, 0, 1);
  final multicast4 = Ipv4Address.fromBytes(224, 0, 0, 1); // non-SSM multicast
  final ssm4 = Ipv4Address.fromBytes(232, 1, 2, 3); // in SSM range

  // IPv6 address constants
  final nonMulticast6 = Ipv6Address.fromString('2001::1').get;
  final multicast6 = Ipv6Address.fromString('ff0e::1').get; // non-SSM multicast
  final ssm6 = Ipv6Address.fromString('ff3e::1').get; // in SSM range (ff30–ff3f)

  group('Multicast', () {
    genMulticast4.forAll('support equality', (mip) {
      expect(mip.address.asMulticast(), isSome(mip));
    });

    test('support SSM outside source specific range', () {
      final mip = Ipv4Address.fromBytes(239, 10, 10, 10);

      expect(mip.asSourceSpecificMulticast(), isNone());

      expect(
        mip.asSourceSpecificMulticastLenient().map((a) => a.address),
        isSome(mip),
      );
    });

    group('fromIpAddress', () {
      test('non-multicast → None', () {
        expect(Multicast.fromIpAddress(nonMulticast4), isNone());
        expect(Multicast.fromIpAddress(nonMulticast6), isNone());
      });

      test('non-SSM multicast → Some non-SSM Multicast', () {
        final m = Multicast.fromIpAddress(multicast4).get;
        expect(m.address, multicast4);
        expect(m, isNot(isA<SourceSpecificMulticast<Ipv4Address>>()));
      });

      test('SSM address → Some SourceSpecificMulticast', () {
        final m = Multicast.fromIpAddress(ssm4).get;
        expect(m.address, ssm4);
        expect(m, isA<SourceSpecificMulticast<Ipv4Address>>());
      });

      test('IPv6 non-SSM multicast → Some Multicast', () {
        final m = Multicast.fromIpAddress(multicast6).get;
        expect(m.address, multicast6);
        expect(m, isNot(isA<SourceSpecificMulticast<Ipv6Address>>()));
      });

      test('IPv6 SSM address → Some SourceSpecificMulticast', () {
        final m = Multicast.fromIpAddress(ssm6).get;
        expect(m.address, ssm6);
        expect(m, isA<SourceSpecificMulticast<Ipv6Address>>());
      });
    });

    group('toString', () {
      test('non-SSM Multicast.toString returns address string', () {
        final m = Multicast.fromIpAddress(multicast4).get;
        expect(m.toString(), multicast4.toString());
      });

      test('SSM Multicast (lenient).toString returns address string', () {
        final m = multicast4.asSourceSpecificMulticastLenient().get;
        expect(m.toString(), multicast4.toString());
      });

      test('SourceSpecificMulticastStrict.toString returns address string', () {
        final m = ssm4.asSourceSpecificMulticast().get;
        expect(m.toString(), ssm4.toString());
      });
    });

    group('equality and hashCode', () {
      test('same non-SSM multicast address → equal', () {
        final m1 = Multicast.fromIpAddress(multicast4).get;
        final m2 = Multicast.fromIpAddress(multicast4).get;
        expect(m1 == m2, isTrue);
        expect(m1.hashCode, m2.hashCode);
      });

      test('different non-SSM multicast addresses → not equal', () {
        final m1 = Multicast.fromIpAddress(multicast4).get;
        final m2 = Multicast.fromIpAddress(Ipv4Address.fromBytes(224, 0, 0, 2)).get;
        expect(m1 == m2, isFalse);
      });

      test('Multicast vs non-Multicast → not equal', () {
        final m = Multicast.fromIpAddress(multicast4).get;
        // ignore: unrelated_type_equality_checks
        expect(m == multicast4, isFalse);
      });

      test('same SSM lenient address → equal', () {
        final m1 = multicast4.asSourceSpecificMulticastLenient().get;
        final m2 = multicast4.asSourceSpecificMulticastLenient().get;
        expect(m1 == m2, isTrue);
        expect(m1.hashCode, m2.hashCode);
      });

      test('different SSM lenient addresses → not equal', () {
        final m1 = multicast4.asSourceSpecificMulticastLenient().get;
        final m2 = Ipv4Address.fromBytes(224, 0, 0, 2).asSourceSpecificMulticastLenient().get;
        expect(m1 == m2, isFalse);
      });

      test('same SourceSpecificMulticastStrict address → equal', () {
        final m1 = ssm4.asSourceSpecificMulticast().get;
        final m2 = ssm4.asSourceSpecificMulticast().get;
        expect(m1 == m2, isTrue);
        expect(m1.hashCode, m2.hashCode);
      });

      test('different SourceSpecificMulticastStrict addresses → not equal', () {
        final m1 = ssm4.asSourceSpecificMulticast().get;
        final m2 = Ipv4Address.fromBytes(232, 1, 2, 4).asSourceSpecificMulticast().get;
        expect(m1 == m2, isFalse);
      });

      test('SourceSpecificMulticastStrict vs non-SSM → not equal', () {
        final strict = ssm4.asSourceSpecificMulticast().get;
        // ignore: unrelated_type_equality_checks
        expect(strict == ssm4, isFalse);
      });
    });
  });

  group('SourceSpecificMulticast', () {
    group('fromIpAddress (strict)', () {
      test('SSM address → Some SourceSpecificMulticastStrict', () {
        expect(SourceSpecificMulticast.fromIpAddress(ssm4).map((m) => m.address), isSome(ssm4));
      });

      test('non-SSM multicast → None', () {
        expect(SourceSpecificMulticast.fromIpAddress(multicast4), isNone());
      });

      test('non-multicast → None', () {
        expect(SourceSpecificMulticast.fromIpAddress(nonMulticast4), isNone());
      });

      test('IPv6 SSM → Some', () {
        expect(SourceSpecificMulticast.fromIpAddress(ssm6).map((m) => m.address), isSome(ssm6));
      });

      test('IPv6 non-SSM multicast → None', () {
        expect(SourceSpecificMulticast.fromIpAddress(multicast6), isNone());
      });
    });

    group('fromIpAddressLenient', () {
      test('SSM address → Some', () {
        expect(
          SourceSpecificMulticast.fromIpAddressLenient(ssm4).map((m) => m.address),
          isSome(ssm4),
        );
      });

      test('non-SSM multicast → Some', () {
        expect(
          SourceSpecificMulticast.fromIpAddressLenient(multicast4).map((m) => m.address),
          isSome(multicast4),
        );
      });

      test('non-multicast → None', () {
        expect(SourceSpecificMulticast.fromIpAddressLenient(nonMulticast4), isNone());
        expect(SourceSpecificMulticast.fromIpAddressLenient(nonMulticast6), isNone());
      });

      test('IPv6 multicast → Some', () {
        expect(
          SourceSpecificMulticast.fromIpAddressLenient(multicast6).map((m) => m.address),
          isSome(multicast6),
        );
      });
    });

    group('strict()', () {
      test('SSM address via lenient → strict() returns Some with same address', () {
        final lenient = ssm4.asSourceSpecificMulticastLenient().get;
        expect(lenient.strict().map((m) => m.address), isSome(ssm4));
      });

      test('non-SSM multicast via lenient → strict() returns None', () {
        final lenient = multicast4.asSourceSpecificMulticastLenient().get;
        expect(lenient.strict(), isNone());
      });

      test('IPv6 SSM via lenient → strict() returns Some with same address', () {
        final lenient = ssm6.asSourceSpecificMulticastLenient().get;
        expect(lenient.strict().map((m) => m.address), isSome(ssm6));
      });
    });
  });
}
