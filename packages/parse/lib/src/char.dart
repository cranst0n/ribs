/// Convenience constructor — wraps a single-character string as a [Char].
Char char(String str) => Char.fromString(str);

/// A single UTF-16 code unit, represented as a zero-cost extension type over
/// [int].
///
/// Parsers that inspect individual characters receive a [Char] rather than a
/// raw [int], which makes predicate signatures self-documenting and avoids
/// confusion with other integer values.
extension type Char(int codeUnit) {
  /// The smallest possible [Char] value (U+0000).
  static Char MinValue = Char(0x0000);

  /// The largest possible [Char] value (U+FFFF).
  static Char MaxValue = Char(0xffff);

  /// Creates a [Char] from the first code unit of [str].
  ///
  /// Asserts that [str] contains exactly one code unit.
  factory Char.fromString(String str) {
    assert(str.length == 1, 'Char.fromString requires single code unit string, found: $str');
    return Char.checked(str.codeUnitAt(0));
  }

  /// Creates a [Char] after validating that [codeUnit] is in the range
  /// `[MinValue, MaxValue]`, throwing a [RangeError] otherwise.
  factory Char.checked(int codeUnit) {
    RangeError.checkValueInInterval(codeUnit, MinValue.codeUnit, MaxValue.codeUnit, 'codeUnit');
    return Char(codeUnit);
  }

  /// Whether this character is a letter (ASCII, Latin Extended, Greek, or CJK).
  bool get isLetter => _category(codeUnit) <= 4;

  /// Whether this character is an ASCII decimal digit (`0`–`9`).
  bool get isDigit => 0x30 <= codeUnit && codeUnit <= 0x39;

  /// Whether this character is ASCII whitespace (space, tab, LF, or CR).
  bool get isWhitespace =>
      codeUnit == 0x20 || codeUnit == 0x09 || codeUnit == 0x0a || codeUnit == 0x0d;

  /// Whether this character is an ASCII upper-case letter (`A`–`Z`).
  bool get isUpperCase => 0x41 <= codeUnit && codeUnit <= 0x5a;

  /// Whether this character is an ASCII lower-case letter (`a`–`z`).
  bool get isLowerCase => 0x61 <= codeUnit && codeUnit <= 0x7a;

  /// Whether this character falls in the ASCII range (code unit < 128).
  bool get isAscii => codeUnit < 128;

  /// Returns the upper-case equivalent of this character if it is an ASCII
  /// lower-case letter; otherwise returns `this` unchanged.
  Char get toUpperCase => isLowerCase ? Char(codeUnit - 32) : this;

  /// Returns the lower-case equivalent of this character if it is an ASCII
  /// upper-case letter; otherwise returns `this` unchanged.
  Char get toLoweCase => isUpperCase ? Char(codeUnit + 32) : this;

  /// Returns a one-character [String] containing this code unit.
  String get asString => String.fromCharCode(codeUnit);

  /// Returns a new [Char] whose code unit is `(this.codeUnit + offset) & 0xffff`.
  Char operator +(int offset) => Char((codeUnit + offset) & 0xffff);

  /// Returns a new [Char] whose code unit is `(this.codeUnit - offset) & 0xffff`.
  Char operator -(int offset) => Char((codeUnit - offset) & 0xffff);

  /// Whether this character's code unit is strictly less than [other]'s.
  bool operator <(Char other) => codeUnit < other.codeUnit;

  /// Whether this character's code unit is strictly greater than [other]'s.
  bool operator >(Char other) => codeUnit > other.codeUnit;

  /// Whether this character's code unit is less than or equal to [other]'s.
  bool operator <=(Char other) => codeUnit <= other.codeUnit;

  /// Whether this character's code unit is greater than or equal to [other]'s.
  bool operator >=(Char other) => codeUnit >= other.codeUnit;

  int _category(int c) {
    return switch (c) {
      _ when (0x41 <= c && c <= 0x5a) || (0x61 <= c && c <= 0x7a) => 1, // ASCII
      _ when 0x00c0 <= c && c <= 0x024f => 2, // Latin Extended
      _ when 0x0370 <= c && c <= 0x03ff => 3, // Greek
      _ when 0x4e00 <= c && c <= 0x9fff => 4, // CJK Unified
      _ => 99,
    };
  }
}

/// An inclusive range of [Char] values `[start, end]`.
extension type CharsRange((Char, Char) bounds) {
  /// Whether [c] falls within this range (inclusive on both ends).
  bool contains(Char c) => bounds.$1 <= c && c <= bounds.$2;

  /// The lower bound of the range.
  Char get start => bounds.$1;

  /// The upper bound of the range.
  Char get end => bounds.$2;
}
