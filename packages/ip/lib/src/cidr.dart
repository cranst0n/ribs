import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_ip/ribs_ip.dart';

final class Cidr<A extends IpAddress> {
  final A address;
  final int prefixBits;

  const Cidr._(this.address, this.prefixBits);

  static Cidr<A> fromIpAndMask<A extends IpAddress>(A address, A mask) =>
      address / mask.prefixBits() as Cidr<A>;

  static Cidr<A> of<A extends IpAddress>(A address, int prefixBits) {
    final b = prefixBits.clamp(0, address.bitSize);
    return Cidr._(address, b);
  }

  static Option<Cidr<IpAddress>> fromString(String value) =>
      _fromStringGeneral(value, IpAddress.fromString);

  static Option<Cidr<Ipv4Address>> fromStringV4(String value) =>
      _fromStringGeneral(value, Ipv4Address.fromString);

  static Option<Cidr<Ipv6Address>> fromStringV6(String value) =>
      _fromStringGeneral(value, Ipv6Address.fromString);

  static final _cidrRegex = RegExp(r'([^/]+)/(\d+)');
  static Option<Cidr<A>> _fromStringGeneral<A extends IpAddress>(
    String value,
    Function1<String, Option<A>> parseAddress,
  ) {
    return Option(_cidrRegex.firstMatch(value))
        .filter((a) => a.groupCount == 2)
        .flatMap((regexMatch) {
      return Option(regexMatch.group(1)).flatMap(parseAddress).flatMap((addr) {
        return Option(regexMatch.group(2)).flatMap((prefixBitsStr) {
          return Option(int.tryParse(prefixBitsStr))
              .filter((n) => 0 <= n && n <= addr.bitSize)
              .map((prefixBits) => Cidr._(addr, prefixBits));
        });
      });
    });
  }

  CidrStrict<A> normalized() => CidrStrict.from(this);

  A mask() => _transform(
        (_) => Ipv4Address.mask(prefixBits),
        (_) => Ipv6Address.mask(prefixBits),
      );

  A prefix() => _transform(
        (v4) => v4.masked(Ipv4Address.mask(prefixBits)),
        (v6) => v6.masked(Ipv6Address.mask(prefixBits)),
      );

  A last() => _transform(
        (v4) => v4.maskedLast(Ipv4Address.mask(prefixBits)),
        (v6) => v6.maskedLast(Ipv6Address.mask(prefixBits)),
      );

  bool contains<AA extends IpAddress>(AA a) {
    final start = prefix();
    final end = last();

    return start <= a && a <= end;
  }

  A _transform(
    Function1<Ipv4Address, Ipv4Address> v4f,
    Function1<Ipv6Address, Ipv6Address> v6f,
  ) =>
      address.fold((v4) => v4f(v4) as A, (v6) => v6f(v6) as A);

  @override
  String toString() => '$address/$prefixBits';

  @override
  bool operator ==(Object that) => switch (that) {
        final Cidr that => address == that.address && prefixBits == that.prefixBits,
        _ => false,
      };

  @override
  int get hashCode => Object.hashAll([address, prefixBits]);
}

final class CidrStrict<A extends IpAddress> extends Cidr {
  CidrStrict._(A super.address, super.prefixBits) : super._();

  static CidrStrict<A> from<A extends IpAddress>(Cidr<A> cidr) {
    return switch (cidr) {
      final CidrStrict<A> s => s,
      _ => CidrStrict._(cidr.prefix(), cidr.prefixBits),
    };
  }
}
