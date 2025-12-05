import 'package:ribs_core/ribs_core.dart';

abstract class Bases {
  /// Result of `Alphabet#toIndex` that indicates the character should be ignored.
  static const IgnoreChar = -1;

  /// Result of `Alphabet#toIndex` that indicates the character and the rest of the line should be ignored.
  static const IgnoreRestOfLine = -2;
}

abstract class Alphabet {
  const Alphabet();

  String toChar(int index);

  int toIndex(String c);

  bool ignore(String c);
}

abstract class PaddedAlphabet extends Alphabet {
  const PaddedAlphabet();

  String get pad;
}

abstract class BinaryAlphabet extends Alphabet {
  const BinaryAlphabet();
}

abstract class HexAlphabet extends Alphabet {
  const HexAlphabet();
}

abstract class Base32Alphabet extends PaddedAlphabet {
  const Base32Alphabet();
}

abstract class Base58Alphabet extends Alphabet {
  const Base58Alphabet();
}

abstract class Base64Alphabet extends PaddedAlphabet {
  const Base64Alphabet();
}

final class Alphabets {
  Alphabets._();

  static const BinaryAlphabet binary = _BinaryAlphabet();
  static const BinaryAlphabet truthy = _TruthyAlphabet();

  static const HexAlphabet hexLower = _HexLowercase();
  static const HexAlphabet hexUpper = _HexUppercase();

  static const Base32Alphabet base32 = _Base32();
  static const Base32Alphabet base32NoPad = _Base32NoPad();
  static const Base32Alphabet base32Crockford = Base32Crockford();

  static const Base58Alphabet base58 = _Base58();

  static const Base64Alphabet base64 = _Base64();
  static const Base64Alphabet base64NoPad = _Base64NoPad();
  static const Base64Alphabet base64Url = _Base64Url();
  static const Base64Alphabet base64UrlNoPad = _Base64UrlNoPad();

  static bool isHexBinCommmentChar(String c) {
    return switch (c) {
      '#' => true,
      ';' => true,
      '|' => true,
      _ => false,
    };
  }
}

/// Binary alphabet that uses `{0, 1}` and allows whitespace
/// and underscores for separation.
final class _BinaryAlphabet extends BinaryAlphabet {
  const _BinaryAlphabet();

  @override
  bool ignore(String c) => c.trim().isEmpty || c == '_';

  @override
  String toChar(int index) => index == 0 ? '0' : '1';

  @override
  int toIndex(String c) => switch (c) {
        '0' => 0,
        '1' => 1,
        _ => throw ArgumentError('Invalid binary char: $c'),
      };
}

/// Binary alphabet that uses `{t, f}` and allows whitespace
/// and underscores for separation.
final class _TruthyAlphabet extends BinaryAlphabet {
  const _TruthyAlphabet();

  @override
  bool ignore(String c) => c.trim().isEmpty || c == '_';

  @override
  String toChar(int index) => index == 0 ? 't' : 'f';

  @override
  int toIndex(String c) => switch (c) {
        't' || 'T' => 0,
        'f' || 'F' => 1,
        _ => throw ArgumentError('Invalid binary char: $c'),
      };
}

abstract class LenientHex extends HexAlphabet {
  const LenientHex();

  @override
  int toIndex(String c) {
    final i = int.tryParse(c, radix: 16) ?? -1;

    if (i >= 0) {
      return i;
    } else {
      if (ignore(c)) {
        return -1;
      } else if (Alphabets.isHexBinCommmentChar(c)) {
        return Bases.IgnoreRestOfLine;
      } else {
        throw ArgumentError('Invalid hex char: $c');
      }
    }
  }

  @override
  bool ignore(String c) => c.trim().isEmpty || c == '_';
}

final class _HexLowercase extends LenientHex {
  const _HexLowercase();

  @override
  String toChar(int index) => _chars[index];

  static final _chars = _charRange('0', '9').concat(_charRange('a', 'f'));
}

final class _HexUppercase extends LenientHex {
  const _HexUppercase();

  @override
  String toChar(int index) => _chars[index];

  static final _chars = _charRange('0', '9').concat(_charRange('A', 'F'));
}

final class _Base32Base extends Base32Alphabet {
  const _Base32Base();

  @override
  bool ignore(String c) => c.trim().isEmpty;

  @override
  String get pad => '=';

  @override
  String toChar(int index) => _chars[index];

  @override
  int toIndex(String c) {
    final lookupIndex = c.codeUnitAt(0) - _indicesMin;

    if (0 <= lookupIndex &&
        lookupIndex < _indices.size &&
        _indices[lookupIndex] >= 0) {
      return _indices[lookupIndex];
    } else {
      throw ArgumentError();
    }
  }

  static final _chars = _charRange('A', 'Z').concat(_charRange('2', '7'));

  static final _indiciesAndMin =
      _charIndicesLookupArray(_chars.zipWithIndex().toIMap());

  static final _indicesMin = _indiciesAndMin.$1;
  static final _indices = _indiciesAndMin.$2;
}

final class _Base32 extends _Base32Base {
  const _Base32();
}

final class _Base32NoPad extends _Base32Base {
  const _Base32NoPad();

  @override
  String get pad => '0';
}

final class Base32Crockford extends Base32Alphabet {
  const Base32Crockford();

  @override
  String get pad => '=';

  @override
  String toChar(int index) => _chars[index];

  @override
  int toIndex(String c) {
    final lookupIndex = c.codeUnitAt(0) - _indicesMin;

    if (lookupIndex >= 0 &&
        lookupIndex < _indices.length &&
        _indices[lookupIndex] >= 0) {
      return _indices[lookupIndex];
    } else if (ignore(c)) {
      return Bases.IgnoreChar;
    } else {
      throw ArgumentError('Bad Crockford char: $c');
    }
  }

  @override
  bool ignore(String c) => c == '-' || c.trim().isEmpty;

  static final _chars = _charRange('0', '9')
      .concat(_charRange('A', 'H'))
      .concat(_charRange('J', 'K'))
      .concat(_charRange('M', 'N'))
      .concat(_charRange('P', 'T'))
      .concat(_charRange('V', 'Z'));

  static final _uppersAndLowers = _chars
      .zipWithIndex()
      .concat(_chars.map((c) => c.toLowerCase()).zipWithIndex())
      .toIMap();

  static final _minAndIndicies = _charIndicesLookupArray(
    _uppersAndLowers.concat(imap({
      'O': _uppersAndLowers['0'],
      'o': _uppersAndLowers['0'],
      'I': _uppersAndLowers['1'],
      'i': _uppersAndLowers['1'],
      'L': _uppersAndLowers['1'],
      'l': _uppersAndLowers['1']
    })),
  );

  static final _indicesMin = _minAndIndicies.$1;
  static final _indices = _minAndIndicies.$2;
}

final class _Base58 extends Base58Alphabet {
  const _Base58();

  @override
  String toChar(int index) => _chars[index];

  @override
  int toIndex(String c) {
    return switch (c) {
      _ when '1' <= c && c <= '9' => c - '1',
      _ when 'A' <= c && c <= 'H' => c - 'A' + 9,
      _ when 'J' <= c && c <= 'N' => c - 'J' + 9 + 8,
      _ when 'P' <= c && c <= 'Z' => c - 'P' + 9 + 8 + 5,
      _ when 'a' <= c && c <= 'k' => c - 'a' + 9 + 8 + 5 + 11,
      _ when 'm' <= c && c <= 'z' => c - 'm' + 9 + 8 + 5 + 11 + 11,
      _ when ignore(c) => Bases.IgnoreChar,
      _ => throw ArgumentError('invalid base58 char: $c'),
    };
  }

  @override
  bool ignore(String c) => c.trim().isEmpty;

  static final _chars = _charRange('1', '9')
      .concat(_charRange('A', 'Z'))
      .concat(_charRange('a', 'z'))
      .filterNot((c) => ilist(['O', 'I', 'l']).contains(c));
}

abstract class _Base64Base extends Base64Alphabet {
  const _Base64Base();

  @override
  bool ignore(String c) => c.trim().isEmpty;

  @override
  String get pad => '=';

  @override
  String toChar(int index) => _chars[index];

  @override
  int toIndex(String c) {
    return switch (c) {
      _ when 'A' <= c && c <= 'Z' => c - 'A',
      _ when 'a' <= c && c <= 'z' => c - 'a' + 26,
      _ when '0' <= c && c <= '9' => c - '0' + 26 + 26,
      '+' => 62,
      '/' => 63,
      _ => throw ArgumentError('invalid base64 char: $c'),
    };
  }

  static final _chars = _charRange('A', 'Z')
      .concat(_charRange('a', 'z'))
      .concat(_charRange('0', '9'))
      .appended('+')
      .appended('/');
}

final class _Base64 extends _Base64Base {
  const _Base64();
}

final class _Base64NoPad extends _Base64Base {
  const _Base64NoPad();

  @override
  String get pad => '0';
}

abstract class _Base64UrlBase extends Base64Alphabet {
  const _Base64UrlBase();

  @override
  bool ignore(String c) => c.trim().isEmpty;

  @override
  String get pad => '=';

  @override
  String toChar(int index) => chars[index];

  @override
  int toIndex(String c) {
    return switch (c) {
      _ when 'A' <= c && c <= 'Z' => c - 'A',
      _ when 'a' <= c && c <= 'z' => c - 'a' + 26,
      _ when '0' <= c && c <= '9' => c - '0' + 26 + 26,
      '-' => 62,
      '_' => 63,
      _ => throw ArgumentError(),
    };
  }

  static final chars = _charRange('A', 'Z')
      .concat(_charRange('a', 'z'))
      .concat(_charRange('0', '9'))
      .appended('-')
      .appended('_');
}

final class _Base64Url extends _Base64UrlBase {
  const _Base64Url();
}

final class _Base64UrlNoPad extends _Base64UrlBase {
  const _Base64UrlNoPad();

  @override
  String get pad => '0';
}

IList<String> _charRange(String start, String end) =>
    IList.rangeTo(start.codeUnitAt(0), end.codeUnitAt(0))
        .map(String.fromCharCode);

(int, IList<int>) _charIndicesLookupArray(IMap<String, int> indicesMap) {
  final indicesMin = indicesMap.keys
      .minOption(Order.strings)
      .getOrElse(() => throw Exception('charIndicesLookupArray: empty map'))
      .codeUnitAt(0);

  final indicesMax = indicesMap.keys
      .maxOption(Order.strings)
      .getOrElse(() => throw Exception('charIndicesLookupArray: empty map'))
      .codeUnitAt(0);

  final IList<int> indices = IList.tabulate(
    indicesMax - indicesMin + 1,
    (i) => indicesMap.getOrElse(String.fromCharCode(i + indicesMin), () => -1),
  );

  return (indicesMin, indices);
}

extension on String {
  bool operator <=(String that) => compareTo(that) <= 0;

  int operator -(String that) => codeUnitAt(0) - that.codeUnitAt(0);
}
