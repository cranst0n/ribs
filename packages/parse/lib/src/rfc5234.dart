import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_parse/src/numbers.dart';
import 'package:ribs_parse/src/parser.dart';

/// Parsers for the core rules defined in
/// [RFC 5234 §B.1](https://www.rfc-editor.org/rfc/rfc5234#appendix-B.1)
/// (Augmented BNF for Syntax Specifications).
///
/// Each static field corresponds directly to a named ABNF rule and returns the
/// matched character or string. All parsers are lazy static fields constructed
/// on first access.
class Rfc5234 {
  Rfc5234._();

  /// `ALPHA` — an upper- or lower-case ASCII letter (`A`–`Z` / `a`–`z`).
  static final alpha = Parsers.charInRange('A', 'Z') | Parsers.charInRange('a', 'z');

  /// `BIT` — a binary digit (`0` or `1`).
  static final bit = Parsers.charInRange('0', '1');

  /// `CHAR` — any US-ASCII character except NUL (U+0001–U+007F).
  static final char = Parsers.charInRange(String.fromCharCode(0x01), String.fromCharCode(0x7f));

  /// `CR` — carriage return (U+000D).
  static final cr = Parsers.char('\r');

  /// `LF` — line feed (U+000A).
  static final lf = Parsers.char('\n');

  /// `CRLF` — internet-standard line ending (`\r\n`).
  static final crlf = Parsers.string('\r\n');

  /// `CTL` — a control character (U+0000–U+001F or U+007F).
  static final ctl =
      Parsers.charIn(ilist([String.fromCharCode(0x7f)])) |
      Parsers.charInRange(String.fromCharCode(0x00), String.fromCharCode(0x1f));

  /// `DIGIT` — a decimal digit (`0`–`9`). Delegates to [Numbers.digit].
  static final digit = Numbers.digit;

  /// `DQUOTE` — a double-quote character (`"`).
  static final dquote = Parsers.char('"');

  /// `HEXDIG` — a hexadecimal digit (`0`–`9` or `A`–`F`, case-insensitive).
  static final hexdig = Rfc5234.digit | Parsers.ignoreCaseCharInRange('A', 'F');

  /// `HTAB` — a horizontal tab character (U+0009).
  static final htab = Parsers.char('\t');

  /// `SP` — a single space character (U+0020).
  static final sp = Parsers.char(' ');

  /// `WSP` — whitespace: a single space or horizontal tab.
  static final wsp = sp | htab;

  /// `LWSP` — linear whitespace: zero or more [wsp] characters or CRLF
  /// followed by [wsp] (folded whitespace). Discards the matched content and
  /// returns [Unit].
  static final Parser0<Unit> lwsp = (wsp | crlf.productR(wsp)).rep0().voided;

  /// `OCTET` — any 8-bit byte (U+0000–U+00FF).
  static final octet = Parsers.charInRange(String.fromCharCode(0x00), String.fromCharCode(0xff));

  /// `VCHAR` — any visible (printable) US-ASCII character (U+0021–U+007E).
  static final vchar = Parsers.charInRange(String.fromCharCode(0x21), String.fromCharCode(0x7e));
}
