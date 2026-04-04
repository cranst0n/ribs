import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/ribs_core_test.dart';
import 'package:ribs_ip/ribs_ip.dart';
import 'package:test/test.dart';

import 'arbitraries.dart';

void main() {
  final v4a = Ipv4Address.fromBytes(10, 0, 0, 1);
  final v4b = Ipv4Address.fromBytes(10, 0, 0, 2);
  final v6a = Ipv6Address.fromString('::1').get;
  final v6b = Ipv6Address.fromString('2001::1').get;
  final hn1 = Hostname.fromString('abc.com').get;
  final hn2 = Hostname.fromString('xyz.com').get;
  final idn1 = IDN.fromString('abc.com').get;
  final idn2 = IDN.fromString('xyz.com').get;

  group('Host', () {
    genIp.forAll('fromString: IPAddress', (ip) {
      expect(
        Host.fromString(ip.toString()),
        isSome(ip.asHost),
      );
    });

    genHostname.forAll('fromString: Hostname', (hostname) {
      expect(
        Host.fromString(hostname.toString()),
        isSome(hostname.asHost),
      );
    });

    genIDN.forAll('fromString: IDN', (idn) {
      expect(
        Host.fromString(idn.toString()).map((a) => a.toString()),
        isSome(idn.toString()),
      );
    });

    test('fromString: invalid returns None', () {
      expect(Host.fromString(''), isNone());
      // Too long for any hostname (>253 chars); not a valid IP address either.
      expect(Host.fromString('a' * 300), isNone());
    });

    test('asHost: returns self for all subtypes', () {
      expect(identical(v4a.asHost, v4a), isTrue);
      expect(identical(v6a.asHost, v6a), isTrue);
      expect(identical(hn1.asHost, hn1), isTrue);
      expect(identical(idn1.asHost, idn1), isTrue);
    });

    group('compareTo: Ipv4 vs *', () {
      test('Ipv4 < Ipv4', () => expect(v4a.compareTo(v4b), isNegative));
      test('Ipv4 == Ipv4', () => expect(v4a.compareTo(v4a), 0));
      test('Ipv4 > Ipv4', () => expect(v4b.compareTo(v4a), isPositive));

      test('Ipv4 < Ipv6 when compat bytes are less', () {
        // 0.0.0.1.toCompatV6() = [0...,0,1]; ::2 = [0...,0,2]
        expect(
          Ipv4Address.fromBytes(0, 0, 0, 1).compareTo(Ipv6Address.fromString('::2').get),
          isNegative,
        );
      });

      test('Ipv4 vs Hostname → negative (IP sorts before name)', () {
        expect(v4a.compareTo(hn1), isNegative);
      });

      test('Ipv4 vs IDN → negative', () {
        expect(v4a.compareTo(idn1), isNegative);
      });
    });

    group('compareTo: Ipv6 vs *', () {
      test('Ipv6 < Ipv6', () => expect(v6a.compareTo(v6b), isNegative));
      test('Ipv6 == Ipv6', () => expect(v6a.compareTo(v6a), 0));

      test('Ipv6 < Ipv4 when compat bytes are greater', () {
        // ::1 vs 0.0.0.2.toCompatV6() = [0...,0,2]
        expect(v6a.compareTo(Ipv4Address.fromBytes(0, 0, 0, 2)), isNegative);
      });

      test('Ipv6 vs Hostname → negative', () {
        expect(v6a.compareTo(hn1), isNegative);
      });

      test('Ipv6 vs IDN → negative', () {
        expect(v6a.compareTo(idn1), isNegative);
      });
    });

    group('compareTo: Hostname vs *', () {
      test('Hostname vs Ipv4 → positive', () => expect(hn1.compareTo(v4a), isPositive));
      test('Hostname vs Ipv6 → positive', () => expect(hn1.compareTo(v6a), isPositive));

      test('Hostname < Hostname (lex)', () => expect(hn1.compareTo(hn2), isNegative));
      test('Hostname == Hostname', () => expect(hn1.compareTo(hn1), 0));

      test('Hostname < IDN when string < idn.hostname string', () {
        // hn1='abc.com' < idn2.hostname='xyz.com'
        expect(hn1.compareTo(idn2), isNegative);
      });

      test('Hostname > IDN when string > idn.hostname string', () {
        expect(hn2.compareTo(idn1), isPositive);
      });
    });

    group('compareTo: IDN vs *', () {
      test('IDN vs Ipv4 → positive', () => expect(idn1.compareTo(v4a), isPositive));
      test('IDN vs Ipv6 → positive', () => expect(idn1.compareTo(v6a), isPositive));

      test('IDN < Hostname when hostname string < target', () {
        // idn1.hostname='abc.com' < hn2='xyz.com'
        expect(idn1.compareTo(hn2), isNegative);
      });

      test('IDN < IDN', () => expect(idn1.compareTo(idn2), isNegative));
      test('IDN == IDN', () => expect(idn1.compareTo(idn1), 0));
    });

    group('order', () {
      test('lt, gt, eqv are consistent with compareTo', () {
        final ord = Host.order;
        expect(ord.lt(v4a, v4b), isTrue);
        expect(ord.gt(v4b, v4a), isTrue);
        expect(ord.eqv(v4a, v4a), isTrue);
        expect(ord.lt(v4a as Host, hn1), isTrue);
        expect(ord.gt(hn2, v6b as Host), isTrue);
      });
    });
  });

  group('Hostname', () {
    test('normalized: lowercases all labels', () {
      final h = Hostname.fromString('ABC.Example.COM').get;
      expect(h.normalized().toString(), 'abc.example.com');
    });

    test('normalized: idempotent on already-lowercase hostname', () {
      expect(hn1.normalized(), hn1);
    });

    test('equality: same string → equal', () {
      final h1 = Hostname.fromString('example.com').get;
      final h2 = Hostname.fromString('example.com').get;
      expect(h1 == h2, isTrue);
    });

    test('equality: different string → not equal', () {
      expect(hn1 == hn2, isFalse);
    });

    test('equality: non-Hostname → false', () {
      // ignore: unrelated_type_equality_checks
      expect(hn1 == 'abc.com', isFalse);
    });

    test('hashCode: equal hostnames have equal hashCode', () {
      final h1 = Hostname.fromString('example.com').get;
      final h2 = Hostname.fromString('example.com').get;
      expect(h1.hashCode, h2.hashCode);
    });
  });

  group('HostnameLabel', () {
    test('compareTo: less', () {
      expect(const HostnameLabel('abc').compareTo(const HostnameLabel('xyz')), isNegative);
    });

    test('compareTo: equal', () {
      expect(const HostnameLabel('abc').compareTo(const HostnameLabel('abc')), 0);
    });

    test('equality: same string → equal', () {
      expect(const HostnameLabel('abc') == const HostnameLabel('abc'), isTrue);
    });

    test('equality: different string → not equal', () {
      expect(const HostnameLabel('abc') == const HostnameLabel('xyz'), isFalse);
    });

    test('equality: non-HostnameLabel → false', () {
      // ignore: unrelated_type_equality_checks
      expect(const HostnameLabel('abc') == 'abc', isFalse);
    });

    test('hashCode: equal labels have equal hashCode', () {
      expect(const HostnameLabel('abc').hashCode, const HostnameLabel('abc').hashCode);
    });
  });

  group('IpAddress', () {
    group('fromString', () {
      test('parses valid IPv4', () {
        expect(IpAddress.fromString('1.2.3.4'), isSome(Ipv4Address.fromBytes(1, 2, 3, 4)));
      });

      test('parses valid IPv6', () {
        expect(IpAddress.fromString('::1'), isSome(v6a));
      });

      test('returns None for invalid input', () {
        expect(IpAddress.fromString('not an ip'), isNone());
        expect(IpAddress.fromString(''), isNone());
      });
    });

    group('fromBytes', () {
      test('4 bytes → Some Ipv4Address', () {
        expect(
          IpAddress.fromBytes([192, 168, 0, 1]),
          isSome(Ipv4Address.fromBytes(192, 168, 0, 1)),
        );
      });

      test('16 bytes → Some Ipv6Address', () {
        final bytes = List.filled(16, 0)..[15] = 1;
        expect(IpAddress.fromBytes(bytes), isSome(v6a));
      });

      test('wrong length → None', () {
        expect(IpAddress.fromBytes([1, 2, 3]), isNone());
        expect(IpAddress.fromBytes([]), isNone());
      });
    });

    group('compareBytes', () {
      test('equal → 0', () => expect(IpAddress.compareBytes(v4a, v4a), 0));
      test('less → negative', () => expect(IpAddress.compareBytes(v4a, v4b), isNegative));
      test('greater → positive', () => expect(IpAddress.compareBytes(v4b, v4a), isPositive));
    });

    group('isMappedV4', () {
      test('IPv4 address is not mapped', () => expect(v4a.isMappedV4, isFalse));
      test('regular IPv6 is not mapped', () => expect(v6b.isMappedV4, isFalse));
      test('::ffff:x.x.x.x is mapped', () => expect(v4a.toMappedV6().isMappedV4, isTrue));
    });

    group('collapseMappedV4', () {
      test('IPv4 returns self', () => expect(v4a.collapseMappedV4(), v4a));

      test('mapped IPv6 collapses to the original IPv4', () {
        expect(v4a.toMappedV6().collapseMappedV4(), v4a);
      });

      test('non-mapped IPv6 returns self', () => expect(v6b.collapseMappedV4(), v6b));
    });

    group('version', () {
      test('Ipv4Address → IpVersion.v4', () => expect(v4a.version, IpVersion.v4));
      test('Ipv6Address → IpVersion.v6', () => expect(v6a.version, IpVersion.v6));
    });

    group('bitSize', () {
      test('IPv4 → 32', () => expect(v4a.bitSize, 32));
      test('IPv6 → 128', () => expect(v6a.bitSize, 128));
    });

    group('asIpv4 / asIpv6', () {
      test('Ipv4.asIpv4 → Some', () => expect(v4a.asIpv4(), isSome(v4a)));
      test('Ipv4.asIpv6 → None', () => expect(v4a.asIpv6(), isNone()));
      test('Ipv6.asIpv6 → Some', () => expect(v6a.asIpv6(), isSome(v6a)));
      test('non-mapped Ipv6.asIpv4 → None', () => expect(v6b.asIpv4(), isNone()));

      test('mapped Ipv6.asIpv4 → Some (collapsed to original IPv4)', () {
        expect(v4a.toMappedV6().asIpv4(), isSome(v4a));
      });
    });

    group('prefixBits', () {
      test('0.0.0.0 → 0', () => expect(Ipv4Address.fromBytes(0, 0, 0, 0).prefixBits(), 0));
      test('255.0.0.0 → 8', () => expect(Ipv4Address.fromBytes(255, 0, 0, 0).prefixBits(), 8));
      test(
        '255.255.0.0 → 16',
        () => expect(Ipv4Address.fromBytes(255, 255, 0, 0).prefixBits(), 16),
      );
      test(
        '255.255.255.0 → 24',
        () => expect(Ipv4Address.fromBytes(255, 255, 255, 0).prefixBits(), 24),
      );
      test(
        '255.255.255.255 → 32',
        () => expect(Ipv4Address.fromBytes(255, 255, 255, 255).prefixBits(), 32),
      );
    });

    group('equality and hashCode', () {
      test('same address → equal', () {
        expect(Ipv4Address.fromBytes(1, 2, 3, 4) == Ipv4Address.fromBytes(1, 2, 3, 4), isTrue);
      });

      test('different address → not equal', () => expect(v4a == v4b, isFalse));

      test('different IP version → not equal', () => expect(v4a == v6a, isFalse));

      test('equal addresses have same hashCode', () {
        expect(
          Ipv4Address.fromBytes(1, 2, 3, 4).hashCode,
          Ipv4Address.fromBytes(1, 2, 3, 4).hashCode,
        );
      });

      test('non-IpAddress → not equal', () {
        // ignore: unrelated_type_equality_checks
        expect(v4a == '10.0.0.1', isFalse);
      });
    });
  });

  group('IDN', () {
    test('equality: same string → equal', () {
      final i1 = IDN.fromString('abc.com').get;
      final i2 = IDN.fromString('abc.com').get;
      expect(i1 == i2, isTrue);
    });

    test('equality: different string → not equal', () => expect(idn1 == idn2, isFalse));

    test('equality: non-IDN → false', () {
      // ignore: unrelated_type_equality_checks
      expect(idn1 == 'abc.com', isFalse);
    });

    test('hashCode: equal IDNs have same hashCode', () {
      final i1 = IDN.fromString('abc.com').get;
      final i2 = IDN.fromString('abc.com').get;
      expect(i1.hashCode, i2.hashCode);
    });

    test('fromString: empty string returns None', () {
      expect(IDN.fromString(''), isNone());
    });

    group('toAscii / toUnicode', () {
      test('toAscii of ASCII-only string returns Some(same)', () {
        expect(IDN.toAscii('example.com'), isSome('example.com'));
      });

      test('toUnicode of ASCII string returns same', () {
        expect(IDN.toUnicode('example.com'), 'example.com');
      });

      test('toAscii then toUnicode roundtrips for Unicode labels', () {
        final ascii = IDN.toAscii('δ.com');
        expect(ascii.map(IDN.toUnicode), isSome('δ.com'));
      });
    });

    group('uriDecode / uriEncode', () {
      test('ASCII URI is unchanged by encode→decode roundtrip', () {
        final uri = Uri.parse('https://example.com/path');
        expect(IDN.uriDecode(IDN.uriEncode(uri)), uri);
      });

      test('uriEncode produces Punycode host for Unicode URI', () {
        final uri = Uri.parse('https://δ.com/path');
        final encoded = IDN.uriEncode(uri);
        expect(encoded.host, isNot('δ.com'));
      });

      test('uriDecode restores Unicode host from Punycode URI', () {
        final unicode = Uri.parse('https://δ.com/path');
        final encoded = IDN.uriEncode(unicode);
        final decoded = IDN.uriDecode(encoded);
        // Dart percent-encodes non-ASCII hosts in Uri, so decode before comparing.
        expect(Uri.decodeComponent(decoded.host), 'δ.com');
      });
    });
  });

  group('IDNLabel', () {
    test('compareTo: less', () {
      expect(const IDNLabel('abc').compareTo(const IDNLabel('xyz')), isNegative);
    });

    test('compareTo: equal', () {
      expect(const IDNLabel('abc').compareTo(const IDNLabel('abc')), 0);
    });

    test('equality: same string → equal', () {
      expect(const IDNLabel('abc') == const IDNLabel('abc'), isTrue);
    });

    test('equality: different string → not equal', () {
      expect(const IDNLabel('abc') == const IDNLabel('xyz'), isFalse);
    });

    test('equality: non-IDNLabel → false', () {
      // ignore: unrelated_type_equality_checks
      expect(const IDNLabel('abc') == 'abc', isFalse);
    });

    test('hashCode: equal labels have equal hashCode', () {
      expect(const IDNLabel('abc').hashCode, const IDNLabel('abc').hashCode);
    });
  });

  group('IpVersion', () {
    test('v4 and v6 are distinct', () {
      expect(IpVersion.v4, isNot(IpVersion.v6));
    });
  });
}
