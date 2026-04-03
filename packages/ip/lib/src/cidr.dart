// This file is derived in part from ip4s.
// https://github.com/Comcast/ip4s
//
// ip4s (https://github.com/Comcast/ip4s)
//
// Copyright 2018 Comcast Cable Communications Management, LLC
//
// Licensed under Apache License 2.0
// (http://www.apache.org/licenses/LICENSE-2.0).
//
// See the NOTICE file distributed with this work for
// additional information regarding copyright ownership.

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_ip/ribs_ip.dart';

/// A CIDR (Classless Inter-Domain Routing) block — an [IpAddress] combined
/// with a prefix length that defines a subnet.
///
/// The [address] need not be the network address; use [normalized] or
/// [CidrStrict] to obtain a block whose address is the network prefix.
/// The prefix bits are clamped to the valid range for the address type
/// (0–32 for IPv4, 0–128 for IPv6).
///
/// Example: `192.168.1.100/24` describes the subnet `192.168.1.0/24`.
final class Cidr<A extends IpAddress> {
  /// The IP address component of this CIDR block.
  final A address;

  /// The number of leading bits that define the network prefix.
  final int prefixBits;

  const Cidr._(this.address, this.prefixBits);

  /// Creates a [Cidr] from an address and a subnet mask address.
  /// The prefix bits are derived from [mask] via [IpAddress.prefixBits].
  static Cidr<A> fromIpAndMask<A extends IpAddress>(A address, A mask) =>
      address / mask.prefixBits() as Cidr<A>;

  /// Creates a [Cidr] from [address] and [prefixBits], clamping [prefixBits]
  /// to the valid range for the address family.
  static Cidr<A> of<A extends IpAddress>(A address, int prefixBits) {
    final b = prefixBits.clamp(0, address.bitSize);
    return Cidr._(address, b);
  }

  /// Parses a CIDR string (e.g. `"192.168.0.0/24"` or `"::1/128"`) into a
  /// [Cidr<IpAddress>], returning [None] if parsing fails.
  static Option<Cidr<IpAddress>> fromString(String value) =>
      _fromStringGeneral(value, IpAddress.fromString);

  /// Parses an IPv4 CIDR string (e.g. `"10.0.0.0/8"`), returning [None] if
  /// parsing fails or the address is not IPv4.
  static Option<Cidr<Ipv4Address>> fromStringV4(String value) =>
      _fromStringGeneral(value, Ipv4Address.fromString);

  /// Parses an IPv6 CIDR string (e.g. `"2001:db8::/32"`), returning [None] if
  /// parsing fails or the address is not IPv6.
  static Option<Cidr<Ipv6Address>> fromStringV6(String value) =>
      _fromStringGeneral(value, Ipv6Address.fromString);

  static final _cidrRegex = RegExp(r'([^/]+)/(\d+)');

  static Option<Cidr<A>> _fromStringGeneral<A extends IpAddress>(
    String value,
    Function1<String, Option<A>> parseAddress,
  ) {
    return Option(_cidrRegex.firstMatch(value)).filter((a) => a.groupCount == 2).flatMap((
      regexMatch,
    ) {
      return Option(regexMatch.group(1)).flatMap(parseAddress).flatMap((addr) {
        return Option(regexMatch.group(2)).flatMap((prefixBitsStr) {
          return Option(int.tryParse(prefixBitsStr))
              .filter((n) => 0 <= n && n <= addr.bitSize)
              .map((prefixBits) => Cidr._(addr, prefixBits));
        });
      });
    });
  }

  /// Returns this block normalized to a [CidrStrict], where the address is
  /// the network prefix (all host bits zeroed).
  CidrStrict<A> normalized() => CidrStrict.from(this);

  /// Returns the subnet mask address corresponding to [prefixBits].
  A mask() => _transform(
    (_) => Ipv4Address.mask(prefixBits),
    (_) => Ipv6Address.mask(prefixBits),
  );

  /// Returns the first (network) address of this CIDR block.
  A prefix() => _transform(
    (v4) => v4.masked(Ipv4Address.mask(prefixBits)),
    (v6) => v6.masked(Ipv6Address.mask(prefixBits)),
  );

  /// Returns the last (broadcast/highest) address of this CIDR block.
  A last() => _transform(
    (v4) => v4.maskedLast(Ipv4Address.mask(prefixBits)),
    (v6) => v6.maskedLast(Ipv6Address.mask(prefixBits)),
  );

  /// Returns `true` if [a] falls within this CIDR block (i.e. between
  /// [prefix] and [last] inclusive).
  bool contains<AA extends IpAddress>(AA a) {
    final start = prefix();
    final end = last();

    return start <= a && a <= end;
  }

  A _transform(
    Function1<Ipv4Address, Ipv4Address> v4f,
    Function1<Ipv6Address, Ipv6Address> v6f,
  ) => address.fold((v4) => v4f(v4) as A, (v6) => v6f(v6) as A);

  /// Returns the CIDR notation string, e.g. `"192.168.1.0/24"`.
  @override
  String toString() => '$address/$prefixBits';

  @override
  bool operator ==(Object other) => switch (other) {
    final Cidr that => address == that.address && prefixBits == that.prefixBits,
    _ => false,
  };

  @override
  int get hashCode => Object.hashAll([address, prefixBits]);
}

/// A [Cidr] that is guaranteed to be in normal form: the [address] is the
/// network prefix with all host bits set to zero.
///
/// Obtain via [Cidr.normalized] or [CidrStrict.from].
final class CidrStrict<A extends IpAddress> extends Cidr {
  CidrStrict._(A super.address, super.prefixBits) : super._();

  /// Returns [cidr] if it is already a [CidrStrict], otherwise normalizes it
  /// by zeroing the host bits of the address.
  static CidrStrict<A> from<A extends IpAddress>(Cidr<A> cidr) {
    return switch (cidr) {
      final CidrStrict<A> s => s,
      _ => CidrStrict._(cidr.prefix(), cidr.prefixBits),
    };
  }
}
