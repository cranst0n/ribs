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

import 'dart:typed_data';

import 'package:punycoder/punycoder.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_ip/ribs_ip.dart';

/// The sealed base type for anything that can act as a network host.
///
/// Subtypes are [IpAddress] (which covers [Ipv4Address] and [Ipv6Address]),
/// [Hostname] (ASCII domain name), and [IDN] (internationalized domain name).
///
/// Ordering places IP addresses before hostnames. IPv4 addresses sort before
/// IPv6 (by comparing them as IPv4-compatible IPv6 addresses). Hostnames and
/// IDNs compare lexicographically.
sealed class Host extends Ordered<Host> {
  const Host();

  /// Parses [value] as any supported host type — an IP address, ASCII
  /// hostname, or IDN — returning [None] if none match.
  static Option<Host> fromString(String value) {
    return IpAddress.fromString(value)
        .map((a) => a.asHost)
        .orElse(() => Hostname.fromString(value).map((a) => a.asHost))
        .orElse(() => IDN.fromString(value).map((a) => a.asHost));
  }

  /// Resolves this host to a list of [IpAddress] values.
  ///
  /// If this is already an [IpAddress], returns it immediately. For
  /// [Hostname] and [IDN] values, performs a DNS lookup via [Dns.resolve].
  IO<IList<IpAddress>> resolve() => switch (this) {
    final IpAddress ip => IO.pure(ilist([ip])),
    final Hostname hostname => Dns.resolve(hostname),
    final IDN idn => Dns.resolve(idn.hostname),
  };

  @override
  int compareTo(Host that) {
    return switch (this) {
      final Ipv4Address x => switch (that) {
        final Ipv4Address y => IpAddress.compareBytes(x, y),
        final Ipv6Address y => IpAddress.compareBytes(x.toCompatV6(), y),
        _ => -1,
      },
      final Ipv6Address x => switch (that) {
        final Ipv4Address y => IpAddress.compareBytes(x, y.toCompatV6()),
        final Ipv6Address y => IpAddress.compareBytes(x, y),
        _ => -1,
      },
      final Hostname x => switch (that) {
        final Ipv4Address _ => 1,
        final Ipv6Address _ => 1,
        final Hostname y => x.toString().compareTo(y.toString()),
        final IDN y => x.toString().compareTo(y.hostname.toString()),
      },
      final IDN x => switch (that) {
        final Ipv4Address _ => 1,
        final Ipv6Address _ => 1,
        final Hostname y => x.hostname.toString().compareTo(y.toString()),
        final IDN y => x.hostname.toString().compareTo(y.hostname.toString()),
      },
    };
  }

  /// Returns `this` as a [Host] (identity).
  Host get asHost => this;

  /// An [Order] instance for [Host] values based on [compareTo].
  static final order = Order.fromComparable<Host>();
}

/// An ASCII hostname, validated per RFC 1123.
///
/// Rules: 1–253 characters total; each dot-separated label is 1–63 characters;
/// labels may contain letters, digits, and hyphens but must not start or end
/// with a hyphen.
final class Hostname extends Host {
  /// The dot-separated label components of this hostname.
  final IList<HostnameLabel> labels;

  /// The original string representation of this hostname.
  final String repr;

  const Hostname(this.labels, this.repr);

  /// Parses [value] as an ASCII hostname, returning [None] if validation fails.
  static Option<Hostname> fromString(String value) {
    if (value.isEmpty || value.length > 253) {
      return none();
    } else if (_regex.hasMatch(value)) {
      final labels = value.split('.').toIList().map(HostnameLabel.new);
      return Option.when(
        () =>
            labels.nonEmpty &&
            !labels.exists(
              (lbl) =>
                  lbl.toString().length > 63 ||
                  lbl.toString().startsWith('-') ||
                  lbl.toString().endsWith('-'),
            ),
        () => Hostname(labels, value),
      );
    } else {
      return none();
    }
  }

  /// Returns a copy of this hostname with all labels lowercased.
  Hostname normalized() => Hostname(
    labels.map((l) => HostnameLabel(l.toString().toLowerCase())),
    toString().toLowerCase(),
  );

  @override
  String toString() => repr;

  @override
  bool operator ==(Object other) => switch (other) {
    final Hostname that => toString() == that.toString(),
    _ => false,
  };

  @override
  int get hashCode => Object.hash(toString(), 'Hostname'.hashCode);

  static final _regex = RegExp(
    r'[a-zA-Z0-9](?:[a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?)*',
  );
}

/// A single dot-separated label within a [Hostname].
final class HostnameLabel extends Ordered<HostnameLabel> {
  final String _toStringF;

  const HostnameLabel(this._toStringF);

  @override
  int compareTo(HostnameLabel that) => toString().compareTo(that.toString());

  @override
  String toString() => _toStringF;

  @override
  bool operator ==(Object other) => switch (other) {
    final HostnameLabel that => toString() == that.toString(),
    _ => false,
  };

  @override
  int get hashCode => Object.hash(toString(), 'Label'.hashCode);
}

/// The IP protocol version.
enum IpVersion { v4, v6 }

/// The sealed base type for IP addresses.
///
/// Subtypes are [Ipv4Address] (32-bit) and [Ipv6Address] (128-bit).
/// Internally stored as a [Uint8List] of 4 or 16 bytes respectively.
sealed class IpAddress extends Host {
  final Uint8List _bytes;

  const IpAddress(this._bytes);

  /// Parses [value] as either an IPv4 or IPv6 address string, returning
  /// [None] if parsing fails.
  static Option<IpAddress> fromString(String value) => Ipv4Address.fromString(
    value,
  ).map((a) => a.asIpAddress).orElse(() => Ipv6Address.fromString(value));

  /// Returns an [IpAddress] from an iterable of exactly 4 (IPv4) or 16
  /// (IPv6) bytes, or [None] otherwise.
  static Option<IpAddress> fromBytes(Iterable<int> bytes) => Ipv4Address.fromByteList(
    bytes,
  ).map((a) => a.asIpAddress).orElse(() => Ipv6Address.fromByteList(bytes));

  /// Returns the loopback addresses for the current host via DNS.
  static IO<IList<IpAddress>> loopback() => Dns.loopback();

  /// Performs a reverse DNS lookup, returning the [Hostname] associated with
  /// this address. Fails the [IO] if no PTR record is found.
  IO<Hostname> reverse() => Dns.reverse(this);

  /// Performs a reverse DNS lookup, returning [Some] hostname if a PTR record
  /// exists or [None] otherwise.
  IO<Option<Hostname>> reverseOption() => Dns.reverseOption(this);

  /// Dispatches to [v4] or [v6] depending on the address family.
  A fold<A>(Function1<Ipv4Address, A> v4, Function1<Ipv6Address, A> v6);

  /// Returns `true` if this address is in the multicast range.
  bool get isMulticast;

  /// Returns a [Multicast] wrapper if this address is a multicast address,
  /// otherwise [None].
  Option<Multicast<IpAddress>> asMulticast() => Multicast.fromIpAddress(this);

  /// Returns `true` if this address is in the source-specific multicast (SSM)
  /// range.
  bool get isSourceSpecificMulticast;

  /// Returns a strict [SourceSpecificMulticastStrict] wrapper if this address
  /// is in the SSM range, otherwise [None].
  Option<SourceSpecificMulticastStrict<IpAddress>> asSourceSpecificMulticast() =>
      SourceSpecificMulticast.fromIpAddress(this);

  /// Returns a lenient [SourceSpecificMulticast] wrapper if this address is
  /// any multicast address, otherwise [None].
  Option<SourceSpecificMulticast<IpAddress>> asSourceSpecificMulticastLenient() =>
      SourceSpecificMulticast.fromIpAddressLenient(this);

  /// If this is an IPv6 address that is a mapped IPv4 address
  /// (i.e. `::ffff:a.b.c.d`), returns the corresponding [Ipv4Address].
  /// Otherwise returns this address unchanged.
  IpAddress collapseMappedV4() => fold(identity, (v6) {
    if (v6.isMappedV4) {
      return IpAddress.fromBytes(
        v6.toBytes().toIList().takeRight(4).toList(),
      ).getOrElse(() => throw Exception('IpAddress.collapseMappedV4 failure: $v6'));
    } else {
      return v6;
    }
  });

  /// Returns `true` if this is an IPv6 address in the `::ffff:0:0/96`
  /// (IPv4-mapped) block.
  bool get isMappedV4 => fold((_) => false, Ipv6Address.MappedV4Block.contains);

  /// The IP version of this address.
  IpVersion get version => fold((_) => IpVersion.v4, (_) => IpVersion.v6);

  /// The number of bits in this address (32 for IPv4, 128 for IPv6).
  int get bitSize => fold((_) => 32, (_) => 128);

  /// Returns a copy of the underlying bytes as a new [Uint8List].
  Uint8List toBytes() => Uint8List.fromList(_bytes.toList());

  /// Returns `this` as an [IpAddress] (identity).
  IpAddress get asIpAddress => this;

  /// Returns `Some(v4)` if this address is (or collapses to) an [Ipv4Address],
  /// otherwise [None].
  Option<Ipv4Address> asIpv4() => collapseMappedV4().fold((v4) => Some(v4), (_) => none());

  /// Returns `Some(v6)` if this is an [Ipv6Address], otherwise [None].
  Option<Ipv6Address> asIpv6() => fold((_) => none(), (v6) => Some(v6));

  /// Creates a [Cidr] block from this address and [prefixBits].
  Cidr<IpAddress> operator /(int prefixBits) => Cidr.of(this, prefixBits);

  /// Counts the number of leading one-bits in the address, treating the bytes
  /// as a network mask. Used to derive the prefix length from a mask address.
  int prefixBits() {
    int zerosIn(int value, int bits) {
      int res = 0;
      int x = value;

      while ((x & (1 << (bits - 1))) == 0 && res < bits) {
        x = x << 1;
        res++;
      }

      return res;
    }

    int zeros(Uint8List l) {
      int n = 0;

      for (final i in l) {
        n += zerosIn(~i, 8);

        if (n == 0 || n % 8 != 0) {
          return n;
        }
      }

      return n;
    }

    return zeros(_bytes);
  }

  @override
  bool operator ==(Object other) => switch (other) {
    final IpAddress that =>
      version == that.version && ilist(_bytes).zip(ilist(that._bytes)).forall((t) => t.$1 == t.$2),
    _ => false,
  };

  @override
  int get hashCode => Object.hashAll(_bytes);

  /// Compares two [IpAddress] values byte-by-byte, returning a negative,
  /// zero, or positive value.
  static int compareBytes(IpAddress x, IpAddress y) {
    int i = 0;
    int result = 0;

    final sz = x._bytes.length;

    while (i < sz && result == 0) {
      result = (x._bytes[i] & 0xff).compareTo(y._bytes[i] & 0xff);
      i++;
    }

    return result;
  }
}

/// A 32-bit IPv4 address stored as 4 bytes in network (big-endian) order.
///
/// Textual form is dotted-decimal notation: `"192.168.1.1"`.
final class Ipv4Address extends IpAddress {
  const Ipv4Address._(super._bytes);

  /// The wildcard IPv4 address `0.0.0.0`.
  static final Wildcard = Ipv4Address._(Uint8List.fromList([0, 0, 0, 0]));

  /// Returns the IPv4 loopback addresses for the current host.
  static IO<IList<IpAddress>> loopback() =>
      IpAddress.loopback().map((ifaces) => ifaces.filter((iface) => iface.version == IpVersion.v4));

  /// Parses a dotted-decimal IPv4 string (e.g. `"192.168.1.1"`),
  /// returning [None] if parsing fails.
  static Option<Ipv4Address> fromString(String value) {
    final trimmed = value.trim();
    final fields = trimmed.split('.');

    if (fields.length == 4) {
      final bytes = Uint8List(4);
      int idx = 0;

      while (idx < bytes.length) {
        final value = int.tryParse(fields[idx]) ?? -1;
        if (0 <= value && value <= 255) {
          bytes[idx] = value;
        } else {
          return none();
        }

        idx++;
      }

      return Some(_unsafeFromBytes(bytes));
    } else {
      return none();
    }
  }

  /// Returns an [Ipv4Address] from an iterable of exactly 4 bytes,
  /// or [None] otherwise.
  static Option<Ipv4Address> fromByteList(Iterable<int> bytes) =>
      Option.when(() => bytes.length == 4, () => _unsafeFromBytes(bytes));

  /// Creates an [Ipv4Address] from four individual byte values.
  /// Each byte is masked to 8 bits.
  static Ipv4Address fromBytes(int a, int b, int c, int d) =>
      _unsafeFromBytes(Uint8List.fromList([a & 0xff, b & 0xff, c & 0xff, d & 0xff]));

  static Ipv4Address _unsafeFromBytes(Iterable<int> bytes) =>
      Ipv4Address._(Uint8List.fromList(bytes.toList()));

  /// Creates an [Ipv4Address] from a 32-bit integer in network byte order.
  static Ipv4Address fromInt(int value) {
    final bytes = Uint8List(4);

    var rem = value;

    Range.inclusive(3, 0, -1).foreach((i) {
      bytes[i] = rem & 0x0ff;
      rem = rem >> 8;
    });

    return _unsafeFromBytes(bytes);
  }

  /// Returns the subnet mask address for the given [bits] prefix length
  /// (0–32, clamped).
  static Ipv4Address mask(int bits) {
    final b = bits.clamp(0, 32);
    if (b == 0) return Ipv4Address.fromInt(0);
    final val = (BigInt.one << 32) - (BigInt.one << (32 - b));
    return Ipv4Address.fromInt(val.toInt());
  }

  @override
  A fold<A>(
    Function1<Ipv4Address, A> v4,
    Function1<Ipv6Address, A> v6,
  ) => v4(this);

  /// Returns the address that follows this one (wraps around on overflow).
  Ipv4Address next() => Ipv4Address.fromInt(toInt() + 1);

  /// Returns the address that precedes this one (wraps around on underflow).
  Ipv4Address previous() => Ipv4Address.fromInt(toInt() - 1);

  @override
  bool get isMulticast => multicastRangeStart <= this && this <= multicastRangeEnd;

  @override
  Option<Multicast<Ipv4Address>> asMulticast() => Multicast.fromIpAddress(this);

  @override
  bool get isSourceSpecificMulticast =>
      sourceSpecificMulticastRangeStart <= this && this <= sourceSpecificMulticastRangeEnd;

  @override
  Option<SourceSpecificMulticastStrict<Ipv4Address>> asSourceSpecificMulticast() =>
      SourceSpecificMulticast.fromIpAddress(this);

  @override
  Option<SourceSpecificMulticast<Ipv4Address>> asSourceSpecificMulticastLenient() =>
      SourceSpecificMulticast.fromIpAddressLenient(this);

  /// Returns the IPv4-compatible IPv6 representation (`::a.b.c.d`).
  Ipv6Address toCompatV6() {
    final compat = Uint8List(16);

    compat[12] = _bytes[0];
    compat[13] = _bytes[1];
    compat[14] = _bytes[2];
    compat[15] = _bytes[3];

    return Ipv6Address.fromByteList(
      compat,
    ).getOrElse(() => throw Exception('Error converting $this to compatible IPv6'));
  }

  /// Returns the IPv4-mapped IPv6 representation (`::ffff:a.b.c.d`).
  Ipv6Address toMappedV6() {
    final mapped = Uint8List(16);

    mapped[10] = 255;
    mapped[11] = 255;
    mapped[12] = _bytes[0];
    mapped[13] = _bytes[1];
    mapped[14] = _bytes[2];
    mapped[15] = _bytes[3];

    return Ipv6Address.fromByteList(
      mapped,
    ).getOrElse(() => throw Exception('Error converting $this to mapped IPv6'));
  }

  /// Returns this address ANDed with [mask] (bitwise AND).
  Ipv4Address masked(Ipv4Address mask) => Ipv4Address.fromInt(toInt() & mask.toInt());

  /// Returns the last address in the subnet defined by [mask]
  /// (bitwise OR of network prefix with the inverted mask).
  Ipv4Address maskedLast(Ipv4Address mask) =>
      Ipv4Address.fromInt(toInt() & mask.toInt() | ~mask.toInt());

  @override
  Cidr<Ipv4Address> operator /(int prefixBits) => Cidr.of(this, prefixBits);

  /// Returns the dotted-decimal string, e.g. `"192.168.1.1"`.
  @override
  String toString() =>
      '${_bytes[0] & 0xff}.${_bytes[1] & 0xff}.${_bytes[2] & 0xff}.${_bytes[3] & 0xff}';

  /// Returns the address as a 32-bit unsigned integer in network byte order.
  int toInt() => _bytes.fold(0, (acc, b) => (acc << 8) | (0x0ff & b));

  /// First IP address in the IPv4 multicast range (224.0.0.0).
  static final multicastRangeStart = fromBytes(224, 0, 0, 0);

  /// Last IP address in the IPv4 multicast range (239.255.255.255).
  static final multicastRangeEnd = fromBytes(239, 255, 255, 255);

  /// First IP address in the IPv4 source specific multicast range (232.0.0.0).
  static final sourceSpecificMulticastRangeStart = fromBytes(232, 0, 0, 0);

  /// Last IP address in the IPv4 source specific multicast range (232.255.255.255).
  static final sourceSpecificMulticastRangeEnd = fromBytes(232, 255, 255, 255);
}

/// A 128-bit IPv6 address stored as 16 bytes in network (big-endian) order.
///
/// Textual form follows RFC 5952 compressed notation (e.g. `"::1"`,
/// `"2001:db8::1"`). Mixed IPv4/IPv6 strings (e.g. `"::ffff:192.0.2.1"`)
/// are also accepted by [fromString].
final class Ipv6Address extends IpAddress {
  const Ipv6Address._(super._bytes);

  /// Returns the IPv6 loopback addresses for the current host.
  static IO<IList<IpAddress>> loopback() =>
      IpAddress.loopback().map((ifaces) => ifaces.filter((iface) => iface.version == IpVersion.v6));

  /// Parses an IPv6 address string in standard or mixed notation,
  /// returning [None] if parsing fails.
  static Option<Ipv6Address> fromString(String value) =>
      _fromNonMixedString(value).orElse(() => _fromMixedString(value));

  static Option<Ipv6Address> _fromNonMixedString(String value) {
    var prefix = nil<int>();
    var beforeCondenser = true;
    var suffix = nil<int>();
    final trimmed = value.trim();

    Option<Ipv6Address>? result;

    final List<String> fields;

    if (trimmed == ':' || trimmed == '::') {
      fields = List<String>.empty(growable: true);
    } else if (trimmed.contains(':')) {
      fields = trimmed.split(':');
    } else {
      fields = List<String>.empty(growable: true);
    }

    var idx = 0;

    while (idx < fields.length && result == null) {
      final field = fields[idx];

      if (field.isEmpty) {
        if (beforeCondenser) {
          beforeCondenser = false;
          if (idx + 1 < fields.length && fields[idx + 1].isEmpty) {
            idx += 1;
          }
        } else {
          result = none();
        }
      } else {
        if (field.length > 4) {
          result = none();
        } else {
          final fieldValue = int.tryParse(field, radix: 16);
          if (fieldValue != null) {
            if (beforeCondenser) {
              prefix = prefix.prepended(fieldValue);
            } else {
              suffix = suffix.prepended(fieldValue);
            }
          } else {
            result = none();
          }
        }
      }

      idx += 1;
    }

    if (result != null) {
      return result;
    } else if (fields.isEmpty && (trimmed.isEmpty || trimmed != '::')) {
      return none();
    } else {
      final bytes = Uint8List(16);

      idx = 0;

      final prefixSize = prefix.size;
      var prefixIdx = prefixSize - 1;

      while (prefixIdx >= 0) {
        final value = prefix[prefixIdx];
        bytes[idx] = (value >> 8) & 0xff;
        bytes[idx + 1] = value & 0xff;
        prefixIdx -= 1;
        idx += 2;
      }

      final suffixSize = suffix.size;
      final numCondensedZeroes = bytes.length - idx - (suffixSize * 2);
      idx += numCondensedZeroes;

      var suffixIdx = suffixSize - 1;

      while (suffixIdx >= 0) {
        final value = suffix[suffixIdx];
        bytes[idx] = (value >> 8) & 0xff;
        bytes[idx + 1] = value & 0xff;
        suffixIdx -= 1;
        idx += 2;
      }

      return Some(_unsafeFromBytes(bytes));
    }
  }

  static Option<Ipv6Address> _fromMixedString(String value) {
    final match = Option(_mixedStringRegex.firstMatch(value));

    return match.filter((a) => a.groupCount == 2).flatMap((regexMatch) {
      return (
        Option(regexMatch[1]).flatMap((p) => _fromNonMixedString('${p}0:0')),
        Option(regexMatch[2]).flatMap(Ipv4Address.fromString),
      ).mapN((prefix, v4) {
        final bytes = prefix.toBytes();
        bytes.setRange(12, 16, v4.toBytes());
        return _unsafeFromBytes(bytes);
      });
    });
  }

  static final _mixedStringRegex = RegExp(r'([:a-fA-F0-9]+:)(\d+\.\d+\.\d+\.\d+)');

  /// Creates an [Ipv6Address] from 16 individual byte values.
  /// Each byte is masked to 8 bits.
  static Ipv6Address fromBytes(
    int b0,
    int b1,
    int b2,
    int b3,
    int b4,
    int b5,
    int b6,
    int b7,
    int b8,
    int b9,
    int b10,
    int b11,
    int b12,
    int b13,
    int b14,
    int b15,
  ) => _unsafeFromBytes(
    Uint8List.fromList(
      [
        b0,
        b1,
        b2,
        b3,
        b4,
        b5,
        b6,
        b7,
        b8,
        b9,
        b10,
        b11,
        b12,
        b13,
        b14,
        b15,
      ].map((b) => b & 0xff).toList(),
    ),
  );

  /// Returns an [Ipv6Address] from an iterable of exactly 16 bytes,
  /// or [None] otherwise.
  static Option<Ipv6Address> fromByteList(Iterable<int> bytes) =>
      Option.when(() => bytes.length == 16, () => _unsafeFromBytes(bytes));

  static Ipv6Address _unsafeFromBytes(Iterable<int> bytes) =>
      Ipv6Address._(Uint8List.fromList(bytes.toList()));

  /// Creates an [Ipv6Address] from a 128-bit [BigInt] value in network byte
  /// order.
  static Ipv6Address fromBigInt(BigInt value) {
    final bytes = Uint8List(16);

    var rem = value;
    Range.inclusive(15, 0, -1).foreach((i) {
      bytes[i] = (rem & BigInt.from(0x0ff)).toInt();
      rem = rem >> 8;
    });

    return _unsafeFromBytes(bytes);
  }

  /// Returns the subnet mask address for the given [bits] prefix length
  /// (0–128, clamped).
  static Ipv6Address mask(int bits) {
    final b = bits.clamp(0, 128);

    if (b == 0) {
      return Ipv6Address.fromBigInt(BigInt.zero);
    } else {
      final mask = (BigInt.one << 128) - (BigInt.one << (128 - b));
      return Ipv6Address.fromBigInt(mask);
    }
  }

  @override
  A fold<A>(
    Function1<Ipv4Address, A> v4,
    Function1<Ipv6Address, A> v6,
  ) => v6(this);

  /// Returns the address that follows this one (wraps around on overflow).
  Ipv6Address next() => Ipv6Address.fromBigInt(toBigInt() + BigInt.one);

  /// Returns the address that precedes this one (wraps around on underflow).
  Ipv6Address previous() => Ipv6Address.fromBigInt(toBigInt() - BigInt.one);

  @override
  bool get isMulticast => MulticastRangeStart <= this && this <= MulticastRangeEnd;

  @override
  Option<Multicast<Ipv6Address>> asMulticast() => Multicast.fromIpAddress(this);

  @override
  bool get isSourceSpecificMulticast =>
      SourceSpecificMulticastRangeStart <= this && this <= SourceSpecificMulticastRangeEnd;

  @override
  Option<SourceSpecificMulticastStrict<Ipv6Address>> asSourceSpecificMulticast() =>
      SourceSpecificMulticast.fromIpAddress(this);

  @override
  Option<SourceSpecificMulticast<Ipv6Address>> asSourceSpecificMulticastLenient() =>
      SourceSpecificMulticast.fromIpAddressLenient(this);

  /// Returns this address ANDed with [mask] (bitwise AND).
  Ipv6Address masked(Ipv6Address mask) => Ipv6Address.fromBigInt(toBigInt() & mask.toBigInt());

  /// Returns the last address in the subnet defined by [mask]
  /// (bitwise OR of network prefix with the inverted mask).
  Ipv6Address maskedLast(Ipv6Address mask) =>
      Ipv6Address.fromBigInt(toBigInt() & mask.toBigInt() | ~mask.toBigInt());

  @override
  Cidr<Ipv6Address> operator /(int prefixBits) => Cidr.of(this, prefixBits);

  /// Returns the address as a 128-bit [BigInt].
  BigInt toBigInt() {
    var result = BigInt.zero;
    Iterable<int>.generate(_bytes.length).forEach((i) {
      result = (result << 8) | BigInt.from(0x0ff & _bytes[i]);
    });

    return result;
  }

  /// Returns the full uncondensed 32-hex-digit form, e.g.
  /// `"0000:0000:0000:0000:0000:0000:0000:0001"` for loopback.
  String toUncondensedString() {
    final str = StringBuffer();
    final bytes = toBytes();

    var idx = 0;

    while (idx < 16) {
      final field = ((bytes[idx] & 0xff) << 8) | (bytes[idx + 1] & 0xff);
      final hextet = field.toRadixString(16).padLeft(4, '0');
      str.write(hextet);
      idx += 2;
      if (idx < 15) {
        str.write(':');
      }
    }

    return str.toString();
  }

  /// Returns the mixed IPv4/IPv6 string form where the last 4 bytes are
  /// expressed as a dotted-decimal IPv4 address (e.g. `"::ffff:192.0.2.1"`).
  String toMixedString() {
    final bytes = toBytes();
    final v4 = Ipv4Address.fromByteList(
      bytes.getRange(12, 16),
    ).getOrElse(() => throw Exception('IPv6 toMixedString failure for: $this'));

    bytes.setRange(12, 16, [0, 1, 0, 1]);

    final s = _unsafeFromBytes(bytes).toString();
    final prefix = s.substring(0, s.length - 3);

    return prefix + v4.toString();
  }

  /// Returns the RFC 5952 compressed string, e.g. `"2001:db8::1"`.
  /// The longest run of consecutive all-zero groups is condensed to `"::"`;
  /// ties are resolved by the leftmost run.
  @override
  String toString() {
    final fields = List.filled(8, 0);
    var condensing = false;
    var condensedStart = -1;
    var maxCondensedStart = -1;
    var condensedLength = 0;
    var maxCondensedLength = 0;
    var idx = 0;

    while (idx < 8) {
      final j = 2 * idx;
      final field = ((0x0ff & _bytes[j]) << 8) | (0x0ff & _bytes[j + 1]);
      fields[idx] = field;

      if (field == 0) {
        if (!condensing) {
          condensing = true;
          condensedStart = idx;
          condensedLength = 0;
        }
        condensedLength += 1;
      } else {
        condensing = false;
      }
      if (condensedLength > maxCondensedLength) {
        maxCondensedLength = condensedLength;
        maxCondensedStart = condensedStart;
      }
      idx += 1;
    }

    if (maxCondensedLength == 1) {
      maxCondensedStart = -1;
    }

    final str = StringBuffer();
    idx = 0;

    while (idx < 8) {
      if (idx == maxCondensedStart) {
        str.write('::');
        idx += maxCondensedLength;
      } else {
        final hextet = fields[idx].toRadixString(16);
        str.write(hextet);
        idx += 1;
        if (idx < 8 && idx != maxCondensedStart) {
          str.write(':');
        }
      }
    }

    return str.toString();
  }

  /// First IP address in the IPv6 multicast range (ff00::).
  static final MulticastRangeStart = fromBytes(255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

  /// Last IP address in the IPv6 multicast range (ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff).
  static final MulticastRangeEnd = fromBytes(
    255,
    255,
    255,
    255,
    255,
    255,
    255,
    255,
    255,
    255,
    255,
    255,
    255,
    255,
    255,
    255,
  );

  /// First IP address in the IPv6 source specific multicast range (ff30::).
  static final SourceSpecificMulticastRangeStart = fromBytes(
    255,
    48,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
  );

  /// Last IP address in the IPv6 source specific multicast range (ff3f:ffff:ffff:ffff:ffff:ffff:ffff:ffff).
  static final SourceSpecificMulticastRangeEnd = fromBytes(
    255,
    63,
    255,
    255,
    255,
    255,
    255,
    255,
    255,
    255,
    255,
    255,
    255,
    255,
    255,
    255,
  );

  /// The IPv4-mapped address block `::ffff:0:0/96`.
  /// Used by [IpAddress.isMappedV4] and [IpAddress.collapseMappedV4].
  static Cidr<Ipv6Address> MappedV4Block = Cidr.of(
    Ipv6Address.fromBytes(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 255, 0, 0, 0, 0),
    96,
  );
}

/// An Internationalized Domain Name (IDN) — a domain name that may contain
/// non-ASCII Unicode characters, stored alongside its Punycode-encoded
/// [Hostname] representation.
final class IDN extends Host {
  /// The Unicode label components of this domain name.
  final IList<IDNLabel> labels;

  /// The ASCII-compatible (Punycode) hostname corresponding to this IDN.
  final Hostname hostname;

  final String _toStringF;

  const IDN(this.labels, this.hostname, this._toStringF);

  /// Creates an [IDN] from an existing ASCII [Hostname] by decoding any
  /// Punycode labels to their Unicode representation.
  static IDN fromHostname(Hostname hostname) {
    final labels = hostname.labels.map((l) => IDNLabel(toUnicode(l.toString())));
    return IDN(labels, hostname, labels.mkString(sep: '.'));
  }

  /// Parses [value] as an IDN (Unicode domain name), returning [None] if
  /// the value is empty or cannot be encoded as a valid ASCII hostname.
  static Option<IDN> fromString(String value) {
    if (value.isEmpty) {
      return none();
    } else {
      return Option(value.split(_regex).map(IDNLabel.new).toIList())
          .filter((a) => a.nonEmpty)
          .flatMap(
            (ls) => toAscii(value).flatMap(Hostname.fromString).map((h) => IDN(ls, h, value)),
          );
    }
  }

  /// Returns a copy of this IDN with all labels lowercased.
  IDN normalized() {
    final newLabels = labels.map((l) => IDNLabel(l.toString().toLowerCase()));
    return IDN(newLabels, hostname.normalized(), newLabels.mkString(sep: '.'));
  }

  @override
  bool operator ==(Object other) => switch (other) {
    final IDN that => toString() == that.toString(),
    _ => false,
  };

  @override
  int get hashCode => Object.hash(toString(), 'IDN'.hashCode);

  /// The Punycode codec used for encoding/decoding IDN labels.
  static const domainCodec = PunycodeCodec();

  /// Decodes the host component of [uri] from Punycode to Unicode.
  static Uri uriDecode(Uri uri) => uri.replace(host: domainCodec.decode(uri.host));

  /// Encodes the host component of [uri] to Punycode.
  static Uri uriEncode(Uri uri) =>
      uri.replace(host: domainCodec.encode(Uri.decodeComponent(uri.host)));

  /// Decodes a Punycode-encoded label string to Unicode.
  static String toUnicode(String s) => domainCodec.decode(s);

  /// Encodes a Unicode domain string to its Punycode representation,
  /// returning [None] if encoding fails.
  static Option<String> toAscii(String s) =>
      Either.catching(() => domainCodec.encode(s), (err, _) => err).toOption();

  /// Returns the Unicode string representation of this IDN.
  @override
  String toString() => _toStringF;

  static final _regex = RegExp(r'[\\.\u002e\u3002\uff0e\uff61]');
}

/// A single label within an [IDN], potentially containing Unicode characters.
final class IDNLabel extends Ordered<IDNLabel> {
  final String _toStringF;

  const IDNLabel(this._toStringF);

  @override
  int compareTo(IDNLabel that) => toString().compareTo(that.toString());

  @override
  String toString() => _toStringF;

  @override
  bool operator ==(Object other) => switch (other) {
    final IDNLabel that => toString() == that.toString(),
    _ => false,
  };

  @override
  int get hashCode => Object.hash(toString(), 'Label'.hashCode);
}
