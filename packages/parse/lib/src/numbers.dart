import 'package:ribs_parse/src/accumulator.dart';
import 'package:ribs_parse/src/parser.dart';

/// A collection of common numeric parsers.
///
/// All parsers are lazy static fields, so they are constructed on first access
/// and reused thereafter.
final class Numbers {
  Numbers._();

  /// Parses a single decimal digit (`0`–`9`) and returns it as a one-character
  /// string.
  static final digit = Parsers.charInRange('0', '9');

  /// Parses zero or more decimal digits and returns them concatenated as a
  /// string. Succeeds with an empty string when no digits are present.
  static final Parser0<String> digits0 = digit.repAs0(Accumulator0.string());

  /// Parses one or more decimal digits and returns them concatenated as a
  /// string. Fails if no digits are present.
  static final Parser<String> digits = digit.repAs(Accumulator.string());

  /// Parses a single non-zero decimal digit (`1`–`9`).
  static final nonZeroDigit = Parsers.charInRange('1', '9');

  /// Parses a non-negative integer as a string, accepting either `"0"` or a
  /// non-zero digit followed by any number of digits (no leading zeros).
  static final nonNegativeIntString =
      nonZeroDigit.product(digits0).voided.orElse(Parsers.char('0')).string;

  /// Parses an optionally signed integer as a string (e.g. `"-42"`, `"0"`,
  /// `"123"`).
  static final signedIntString = Parsers.char('-').opt.with1.product(nonNegativeIntString).string;

  /// Parses a signed integer and converts it to a [BigInt].
  static final bigInt = signedIntString.map(BigInt.parse);

  static final _jsonFrac = Parsers.char('.').product(digits);
  static final _jsonExp =
      Parsers.charInString('eE').product(Parsers.charInString('+-').opt.product(digits)).voided;

  /// Parses a JSON number literal (integer, optional fractional part, optional
  /// exponent) and returns the raw matched string. Does not convert to a
  /// numeric type.
  static final jsonNumber = signedIntString.product(_jsonFrac.opt).product(_jsonExp.opt).string;
}
