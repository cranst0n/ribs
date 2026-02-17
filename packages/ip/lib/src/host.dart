import 'dart:typed_data';

import 'package:punycoder/punycoder.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';
import 'package:ribs_ip/ribs_ip.dart';

sealed class Host extends Ordered<Host> {
  const Host();

  static Option<Host> fromString(String value) {
    return IpAddress.fromString(value)
        .map((a) => a.asHost)
        .orElse(() => Hostname.fromString(value).map((a) => a.asHost))
        .orElse(() => IDN.fromString(value).map((a) => a.asHost));
  }

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

  Host get asHost => this;

  static final order = Order.fromComparable<Host>();
}

final class Hostname extends Host {
  final IList<HostnameLabel> labels;
  final String repr;

  const Hostname(this.labels, this.repr);

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

  Hostname normalized() => Hostname(
    labels.map((l) => HostnameLabel(l.toString().toLowerCase())),
    toString().toLowerCase(),
  );

  @override
  String toString() => repr;

  @override
  bool operator ==(Object that) => switch (that) {
    final Hostname that => toString() == that.toString(),
    _ => false,
  };

  @override
  int get hashCode => Object.hash(toString(), 'Hostname'.hashCode);

  static final _regex = RegExp(
    r'[a-zA-Z0-9](?:[a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?)*',
  );
}

final class HostnameLabel extends Ordered<HostnameLabel> {
  final String _toStringF;

  const HostnameLabel(this._toStringF);

  @override
  int compareTo(HostnameLabel that) => toString().compareTo(that.toString());

  @override
  String toString() => _toStringF;

  @override
  bool operator ==(Object that) => switch (that) {
    final HostnameLabel that => toString() == that.toString(),
    _ => false,
  };

  @override
  int get hashCode => Object.hash(toString(), 'Label'.hashCode);
}

enum IpVersion { v4, v6 }

sealed class IpAddress extends Host {
  final Uint8List _bytes;

  const IpAddress(this._bytes);

  static Option<IpAddress> fromString(String value) => Ipv4Address.fromString(
    value,
  ).map((a) => a.asIpAddress).orElse(() => Ipv6Address.fromString(value));

  static Option<IpAddress> fromBytes(Iterable<int> bytes) => Ipv4Address.fromByteList(
    bytes,
  ).map((a) => a.asIpAddress).orElse(() => Ipv6Address.fromByteList(bytes));

  static IO<IList<IpAddress>> loopback() => Dns.loopback();

  IO<Hostname> reverse() => Dns.reverse(this);

  IO<Option<Hostname>> reverseOption() => Dns.reverseOption(this);

  A fold<A>(Function1<Ipv4Address, A> v4, Function1<Ipv6Address, A> v6);

  bool get isMulticast;

  Option<Multicast<IpAddress>> asMulticast() => Multicast.fromIpAddress(this);

  bool get isSourceSpecificMulticast;

  Option<SourceSpecificMulticastStrict<IpAddress>> asSourceSpecificMulticast() =>
      SourceSpecificMulticast.fromIpAddress(this);

  Option<SourceSpecificMulticast<IpAddress>> asSourceSpecificMulticastLenient() =>
      SourceSpecificMulticast.fromIpAddressLenient(this);

  IpAddress collapseMappedV4() => fold(identity, (v6) {
    if (v6.isMappedV4) {
      return IpAddress.fromBytes(
        v6.toBytes().toIList().takeRight(4).toList(),
      ).getOrElse(() => throw Exception('IpAddress.collapseMappedV4 failure: $v6'));
    } else {
      return v6;
    }
  });

  bool get isMappedV4 => fold((_) => false, Ipv6Address.MappedV4Block.contains);

  IpVersion get version => fold((_) => IpVersion.v4, (_) => IpVersion.v6);

  int get bitSize => fold((_) => 32, (_) => 128);

  Uint8List toBytes() => Uint8List.fromList(_bytes.toList());

  IpAddress get asIpAddress => this;

  Option<Ipv4Address> asIpv4() => collapseMappedV4().fold((v4) => Some(v4), (_) => none());

  Option<Ipv6Address> asIpv6() => fold((_) => none(), (v6) => Some(v6));

  Cidr<IpAddress> operator /(int prefixBits) => Cidr.of(this, prefixBits);

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
  bool operator ==(Object that) => switch (that) {
    final IpAddress that =>
      version == that.version && ilist(_bytes).zip(ilist(that._bytes)).forall((t) => t.$1 == t.$2),
    _ => false,
  };

  @override
  int get hashCode => Object.hashAll(_bytes);

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

///
///
///
///
///
final class Ipv4Address extends IpAddress {
  Ipv4Address._(super._bytes);

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

  static Option<Ipv4Address> fromByteList(Iterable<int> bytes) =>
      Option.when(() => bytes.length == 4, () => _unsafeFromBytes(bytes));

  static Ipv4Address fromBytes(int a, int b, int c, int d) =>
      _unsafeFromBytes(Uint8List.fromList([a & 0xff, b & 0xff, c & 0xff, d & 0xff]));

  static Ipv4Address _unsafeFromBytes(Iterable<int> bytes) =>
      Ipv4Address._(Uint8List.fromList(bytes.toList()));

  static Ipv4Address fromInt(int value) {
    final bytes = Uint8List(4);

    var rem = value;

    Range.inclusive(3, 0, -1).foreach((i) {
      bytes[i] = rem & 0x0ff;
      rem = rem >> 8;
    });

    return _unsafeFromBytes(bytes);
  }

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

  Ipv4Address next() => Ipv4Address.fromInt(toInt() + 1);

  Ipv4Address previous() => Ipv4Address.fromInt(toInt() - 1);

  @override
  bool get isMulticast => MulticastRangeStart <= this && this <= MulticastRangeEnd;

  @override
  Option<Multicast<Ipv4Address>> asMulticast() => Multicast.fromIpAddress(this);

  @override
  bool get isSourceSpecificMulticast =>
      SourceSpecificMulticastRangeStart <= this && this <= SourceSpecificMulticastRangeEnd;

  @override
  Option<SourceSpecificMulticastStrict<Ipv4Address>> asSourceSpecificMulticast() =>
      SourceSpecificMulticast.fromIpAddress(this);

  @override
  Option<SourceSpecificMulticast<Ipv4Address>> asSourceSpecificMulticastLenient() =>
      SourceSpecificMulticast.fromIpAddressLenient(this);

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

  Ipv4Address masked(Ipv4Address mask) => Ipv4Address.fromInt(toInt() & mask.toInt());

  Ipv4Address maskedLast(Ipv4Address mask) =>
      Ipv4Address.fromInt(toInt() & mask.toInt() | ~mask.toInt());

  @override
  Cidr<Ipv4Address> operator /(int prefixBits) => Cidr.of(this, prefixBits);

  @override
  String toString() =>
      '${_bytes[0] & 0xff}.${_bytes[1] & 0xff}.${_bytes[2] & 0xff}.${_bytes[3] & 0xff}';

  int toInt() => _bytes.fold(0, (acc, b) => (acc << 8) | (0x0ff & b));

  /// First IP address in the IPv4 multicast range.
  static final MulticastRangeStart = fromBytes(224, 0, 0, 0);

  /// Last IP address in the IPv4 multicast range.
  static final MulticastRangeEnd = fromBytes(239, 255, 255, 255);

  /// First IP address in the IPv4 source specific multicast range.
  static final SourceSpecificMulticastRangeStart = fromBytes(232, 0, 0, 0);

  /// Last IP address in the IPv4 source specific multicast range.
  static final SourceSpecificMulticastRangeEnd = fromBytes(232, 255, 255, 255);
}

///
///
///
///
///
final class Ipv6Address extends IpAddress {
  const Ipv6Address._(super._bytes);

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

  static Option<Ipv6Address> fromByteList(Iterable<int> bytes) =>
      Option.when(() => bytes.length == 16, () => _unsafeFromBytes(bytes));

  static Ipv6Address _unsafeFromBytes(Iterable<int> bytes) =>
      Ipv6Address._(Uint8List.fromList(bytes.toList()));

  static Ipv6Address fromBigInt(BigInt value) {
    final bytes = Uint8List(16);

    var rem = value;
    Range.inclusive(15, 0, -1).foreach((i) {
      bytes[i] = (rem & BigInt.from(0x0ff)).toInt();
      rem = rem >> 8;
    });

    return _unsafeFromBytes(bytes);
  }

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

  Ipv6Address next() => Ipv6Address.fromBigInt(toBigInt() + BigInt.one);

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

  Ipv6Address masked(Ipv6Address mask) => Ipv6Address.fromBigInt(toBigInt() & mask.toBigInt());

  Ipv6Address maskedLast(Ipv6Address mask) =>
      Ipv6Address.fromBigInt(toBigInt() & mask.toBigInt() | ~mask.toBigInt());

  @override
  Cidr<Ipv6Address> operator /(int prefixBits) => Cidr.of(this, prefixBits);

  BigInt toBigInt() {
    var result = BigInt.zero;
    Iterable<int>.generate(_bytes.length).forEach((i) {
      result = (result << 8) | BigInt.from(0x0ff & _bytes[i]);
    });

    return result;
  }

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

  /// First IP address in the IPv6 multicast range.
  static final MulticastRangeStart = fromBytes(255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

  /// Last IP address in the IPv6 multicast range.
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

  /// First IP address in the IPv6 source specific multicast range.
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

  /// Last IP address in the IPv6 source specific multicast range.
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

  static Cidr<Ipv6Address> MappedV4Block = Cidr.of(
    Ipv6Address.fromBytes(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 255, 255, 0, 0, 0, 0),
    96,
  );
}

final class IDN extends Host {
  final IList<IDNLabel> labels;
  final Hostname hostname;
  final String _toStringF;

  const IDN(this.labels, this.hostname, this._toStringF);

  static IDN fromHostname(Hostname hostname) {
    final labels = hostname.labels.map((l) => IDNLabel(toUnicode(l.toString())));
    return IDN(labels, hostname, labels.mkString(sep: '.'));
  }

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

  IDN normalized() {
    final newLabels = labels.map((l) => IDNLabel(l.toString().toLowerCase()));
    return IDN(newLabels, hostname.normalized(), newLabels.mkString(sep: '.'));
  }

  @override
  bool operator ==(Object that) => switch (that) {
    final IDN that => toString() == that.toString(),
    _ => false,
  };

  @override
  int get hashCode => Object.hash(toString(), 'IDN'.hashCode);

  static const domainCodec = PunycodeCodec();

  static Uri uriDecode(Uri uri) => uri.replace(host: domainCodec.decode(uri.host));

  static Uri uriEncode(Uri uri) =>
      uri.replace(host: domainCodec.encode(Uri.decodeComponent(uri.host)));

  static String toUnicode(String s) => domainCodec.decode(s);
  static Option<String> toAscii(String s) =>
      Either.catching(() => domainCodec.encode(s), (err, _) => err).toOption();

  @override
  String toString() => _toStringF;

  static final _regex = RegExp(r'[\\.\u002e\u3002\uff0e\uff61]');
}

final class IDNLabel extends Ordered<IDNLabel> {
  final String _toStringF;

  const IDNLabel(this._toStringF);

  @override
  int compareTo(IDNLabel that) => toString().compareTo(that.toString());

  @override
  String toString() => _toStringF;

  @override
  bool operator ==(Object that) => switch (that) {
    final IDNLabel that => toString() == that.toString(),
    _ => false,
  };

  @override
  int get hashCode => Object.hash(toString(), 'Label'.hashCode);
}
