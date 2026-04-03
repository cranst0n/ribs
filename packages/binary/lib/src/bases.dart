import 'package:ribs_core/ribs_core.dart';

/// Constants used by [Alphabet] implementations to signal special handling
/// of characters during base decoding.
///
/// These sentinel values are returned from [Alphabet.toIndex] to communicate
/// that a character does not map to a value in the alphabet but should be
/// handled in a specific way rather than throwing an error.
abstract class Bases {
  /// Sentinel value returned from [Alphabet.toIndex] indicating that the
  /// character should be silently ignored during decoding.
  ///
  /// Characters such as whitespace or visual separators (e.g. `_`, `-`) are
  /// commonly mapped to this value.
  static const IgnoreChar = -1;

  /// Sentinel value returned from [Alphabet.toIndex] indicating that the
  /// character and the remainder of the line should be ignored during decoding.
  ///
  /// This is used for comment characters (e.g. `#`, `;`, `|`) in hex and
  /// binary string formats.
  static const IgnoreRestOfLine = -2;
}

/// Defines the bidirectional mapping between integer indices and characters
/// for a positional numeral system.
///
/// An alphabet provides the character set used for encoding and decoding
/// binary data in a particular base. Implementations define the valid
/// characters, their corresponding numeric values, and which characters
/// should be silently ignored (e.g. whitespace, separators).
///
/// See also:
/// - [PaddedAlphabet], for alphabets that include a padding character.
/// - [Alphabets], for pre-defined alphabet instances.
abstract class Alphabet {
  const Alphabet();

  /// Returns the character representation of the given [index].
  ///
  /// The [index] must be in the range `[0, base)` where `base` is the
  /// radix of this alphabet (e.g. 2 for binary, 16 for hex, 64 for base64).
  String toChar(int index);

  /// Returns the numeric index for the given character [c].
  ///
  /// Returns [Bases.IgnoreChar] if the character should be silently skipped,
  /// or [Bases.IgnoreRestOfLine] if the character indicates a comment.
  ///
  /// Throws [ArgumentError] if [c] is not a valid character in this alphabet
  /// and is not ignorable.
  int toIndex(String c);

  /// Returns `true` if the given character [c] should be silently ignored
  /// during decoding.
  ///
  /// Commonly returns `true` for whitespace, underscores, or other visual
  /// separators that may appear in formatted input.
  bool ignore(String c);
}

/// An [Alphabet] that includes a padding character used to align encoded
/// output to a required block size.
///
/// Padding is used in base32 and base64 encoding to ensure the encoded
/// output length is a multiple of the block size. The padding character
/// (typically `=`) is appended to the encoded output as needed.
abstract class PaddedAlphabet extends Alphabet {
  const PaddedAlphabet();

  /// The padding character appended to encoded output to meet block size
  /// requirements.
  ///
  /// Typically `=` for standard base32/base64 encodings, or `0` for
  /// no-pad variants where padding is omitted.
  String get pad;
}

/// An [Alphabet] for base-2 (binary) encoding.
///
/// Binary alphabets map between indices `{0, 1}` and a pair of characters.
///
/// See [Alphabets.binary] and [Alphabets.truthy] for pre-defined instances.
abstract class BinaryAlphabet extends Alphabet {
  const BinaryAlphabet();
}

/// An [Alphabet] for base-16 (hexadecimal) encoding.
///
/// Hex alphabets map between indices `[0, 15]` and hex digit characters.
///
/// See [Alphabets.hexLower] and [Alphabets.hexUpper] for pre-defined instances.
abstract class HexAlphabet extends Alphabet {
  const HexAlphabet();
}

/// An [Alphabet] for base-32 encoding.
///
/// Base32 alphabets map between indices `[0, 31]` and a set of 32
/// alphanumeric characters. Extends [PaddedAlphabet] since base32 encoding
/// uses padding to align output to 8-character blocks.
///
/// See [Alphabets.base32], [Alphabets.base32NoPad], and
/// [Alphabets.base32Crockford] for pre-defined instances.
abstract class Base32Alphabet extends PaddedAlphabet {
  const Base32Alphabet();
}

/// An [Alphabet] for base-58 encoding.
///
/// Base58 alphabets use a 58-character subset of alphanumeric characters,
/// omitting visually ambiguous characters (`0`, `O`, `I`, `l`). This makes
/// base58 well-suited for human-readable encodings such as Bitcoin addresses.
///
/// See [Alphabets.base58] for the pre-defined instance.
abstract class Base58Alphabet extends Alphabet {
  const Base58Alphabet();
}

/// An [Alphabet] for base-64 encoding.
///
/// Base64 alphabets map between indices `[0, 63]` and a set of 64
/// characters. Extends [PaddedAlphabet] since base64 encoding uses padding
/// to align output to 4-character blocks.
///
/// See [Alphabets.base64], [Alphabets.base64NoPad], [Alphabets.base64Url],
/// and [Alphabets.base64UrlNoPad] for pre-defined instances.
abstract class Base64Alphabet extends PaddedAlphabet {
  const Base64Alphabet();
}

/// Provides a collection of pre-defined [Alphabet] instances for common
/// base encodings.
///
/// ## Available Alphabets
///
/// | Alphabet | Base | Description |
/// |---|---|---|
/// | [binary] | 2 | Standard `0`/`1` |
/// | [truthy] | 2 | `t`/`f` (truthy/falsy) |
/// | [hexLower] | 16 | Lowercase hex (`0-9`, `a-f`) |
/// | [hexUpper] | 16 | Uppercase hex (`0-9`, `A-F`) |
/// | [base32] | 32 | RFC 4648 with padding |
/// | [base32NoPad] | 32 | RFC 4648 without padding |
/// | [base32Crockford] | 32 | Crockford's Base32 |
/// | [base58] | 58 | Bitcoin-style Base58 |
/// | [base64] | 64 | RFC 4648 with padding |
/// | [base64NoPad] | 64 | RFC 4648 without padding |
/// | [base64Url] | 64 | URL-safe with padding |
/// | [base64UrlNoPad] | 64 | URL-safe without padding |
final class Alphabets {
  Alphabets._();

  /// Standard binary alphabet using characters `0` and `1`.
  ///
  /// Ignores whitespace and underscores during decoding.
  static const BinaryAlphabet binary = _BinaryAlphabet();

  /// Binary alphabet using `t` (true/0) and `f` (false/1).
  ///
  /// Ignores whitespace and underscores during decoding.
  /// Case-insensitive when decoding.
  static const BinaryAlphabet truthy = _TruthyAlphabet();

  /// Lowercase hexadecimal alphabet (`0-9`, `a-f`).
  ///
  /// Lenient during decoding: ignores whitespace and underscores, and
  /// treats `#`, `;`, and `|` as comment characters.
  static const HexAlphabet hexLower = _HexLowercase();

  /// Uppercase hexadecimal alphabet (`0-9`, `A-F`).
  ///
  /// Lenient during decoding: ignores whitespace and underscores, and
  /// treats `#`, `;`, and `|` as comment characters.
  static const HexAlphabet hexUpper = _HexUppercase();

  /// Standard Base32 alphabet per [RFC 4648](https://tools.ietf.org/html/rfc4648)
  /// using characters `A-Z` and `2-7`, with `=` padding.
  static const Base32Alphabet base32 = _Base32();

  /// Standard Base32 alphabet without padding.
  ///
  /// Uses the same character set as [base32] but omits trailing `=` padding.
  static const Base32Alphabet base32NoPad = _Base32NoPad();

  /// [Crockford's Base32](https://www.crockford.com/base32.html) alphabet.
  ///
  /// Designed for human readability: case-insensitive, and maps commonly
  /// confused characters (`I`, `l` → `1`; `O` → `0`). Ignores hyphens
  /// and whitespace.
  static const Base32Alphabet base32Crockford = Base32Crockford();

  /// Bitcoin-style Base58 alphabet.
  ///
  /// Uses characters `1-9`, `A-Z`, `a-z`, excluding visually ambiguous
  /// characters `0`, `O`, `I`, and `l`.
  static const Base58Alphabet base58 = _Base58();

  /// Standard Base64 alphabet per [RFC 4648](https://tools.ietf.org/html/rfc4648)
  /// using `A-Z`, `a-z`, `0-9`, `+`, `/`, with `=` padding.
  static const Base64Alphabet base64 = _Base64();

  /// Standard Base64 alphabet without padding.
  ///
  /// Uses the same character set as [base64] but omits trailing `=` padding.
  static const Base64Alphabet base64NoPad = _Base64NoPad();

  /// URL-safe Base64 alphabet per [RFC 4648 §5](https://tools.ietf.org/html/rfc4648#section-5)
  /// using `-` and `_` instead of `+` and `/`, with `=` padding.
  static const Base64Alphabet base64Url = _Base64Url();

  /// URL-safe Base64 alphabet without padding.
  ///
  /// Uses the same character set as [base64Url] but omits trailing `=`
  /// padding.
  static const Base64Alphabet base64UrlNoPad = _Base64UrlNoPad();

  /// Returns `true` if [c] is a comment character used in hex and binary
  /// string formats.
  ///
  /// The recognized comment characters are `#`, `;`, and `|`. When
  /// encountered during decoding, the character and the rest of the line
  /// are ignored.
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

/// A [HexAlphabet] with lenient decoding that silently ignores whitespace,
/// underscores, and line comments.
///
/// Subclasses only need to implement [toChar] to define the output casing.
/// Decoding accepts both upper and lowercase hex digits by delegating to
/// [int.tryParse] with radix 16.
///
/// Comment characters (`#`, `;`, `|`) cause the rest of the line to be
/// ignored during decoding.
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

    if (0 <= lookupIndex && lookupIndex < _indices.size && _indices[lookupIndex] >= 0) {
      return _indices[lookupIndex];
    } else {
      throw ArgumentError();
    }
  }

  static final _chars = _charRange('A', 'Z').concat(_charRange('2', '7'));

  static final _indiciesAndMin = _charIndicesLookupArray(_chars.zipWithIndex().toIMap());

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

/// [Crockford's Base32](https://www.crockford.com/base32.html) alphabet
/// implementation.
///
/// This encoding is designed for human use and has the following properties:
/// - Case-insensitive decoding.
/// - Maps commonly confused characters: `I` and `l` are decoded as `1`,
///   `O` is decoded as `0`.
/// - Hyphens (`-`) and whitespace are silently ignored, allowing formatted
///   input such as `AXBQ-C4FT-3219`.
///
/// The character set excludes `I`, `L`, `O`, and `U` to avoid ambiguity
/// and accidental profanity.
final class Base32Crockford extends Base32Alphabet {
  /// Creates a Crockford Base32 alphabet.
  const Base32Crockford();

  @override
  String get pad => '=';

  @override
  String toChar(int index) => _chars[index];

  @override
  int toIndex(String c) {
    final lookupIndex = c.codeUnitAt(0) - _indicesMin;

    if (lookupIndex >= 0 && lookupIndex < _indices.length && _indices[lookupIndex] >= 0) {
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

  static final _uppersAndLowers =
      _chars.zipWithIndex().concat(_chars.map((c) => c.toLowerCase()).zipWithIndex()).toIMap();

  static final _minAndIndicies = _charIndicesLookupArray(
    _uppersAndLowers.concat(
      imap({
        'O': _uppersAndLowers['0'],
        'o': _uppersAndLowers['0'],
        'I': _uppersAndLowers['1'],
        'i': _uppersAndLowers['1'],
        'L': _uppersAndLowers['1'],
        'l': _uppersAndLowers['1'],
      }),
    ),
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

  static final _chars = _charRange(
    'A',
    'Z',
  ).concat(_charRange('a', 'z')).concat(_charRange('0', '9')).appended('+').appended('/');
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

  static final chars = _charRange(
    'A',
    'Z',
  ).concat(_charRange('a', 'z')).concat(_charRange('0', '9')).appended('-').appended('_');
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
    IList.rangeTo(start.codeUnitAt(0), end.codeUnitAt(0)).map(String.fromCharCode);

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
