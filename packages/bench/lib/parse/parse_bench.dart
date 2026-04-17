// ignore_for_file: avoid_print

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:petitparser/petitparser.dart' as pp;
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_parse/ribs_parse.dart';

bool _isTchar(String c) {
  const delimiters = '()<>@,;:\\"/[]?={}';
  final code = c.codeUnitAt(0);
  return code > 32 && code < 127 && !delimiters.contains(c);
}

bool _isVchar(String c) {
  final code = c.codeUnitAt(0);
  return code >= 0x21 && code <= 0x7E;
}

bool _isOws(String c) => c == ' ' || c == '\t';

// Char-predicate variants for the ribs_parse API (which uses Char instead of int).
// Char is a zero-cost extension type, so these wrappers have no runtime overhead.
bool _isTcharChar(Char c) {
  final code = c.codeUnit;
  if (code <= 32 || code >= 127) return false;
  switch (code) {
    case 34: // "
    case 40: // (
    case 41: // )
    case 44: // ,
    case 47: // /
    case 58: // :
    case 59: // ;
    case 60: // <
    case 61: // =
    case 62: // >
    case 63: // ?
    case 64: // @
    case 91: // [
    case 92: // \
    case 93: // ]
    case 123: // {
    case 125: // }
      return false;
    default:
      return true;
  }
}

bool _isVcharChar(Char c) {
  final code = c.codeUnit;
  return code >= 0x21 && code <= 0x7E;
}

bool _isOwsChar(Char c) => c.codeUnit == 32 || c.codeUnit == 9;
bool _isUpperChar(Char c) => c.codeUnit >= 65 && c.codeUnit <= 90;
bool _isDigitChar(Char c) => c.codeUnit >= 48 && c.codeUnit <= 57;

/// HTAB / SP / vchar — everything legal on a header-value line except CR/LF.
bool _isFieldCharChar(Char c) => c.codeUnit == 9 || (c.codeUnit >= 32 && c.codeUnit <= 126);

/// ribs_parse: parse a single HTTP token.
class RibsTokenBenchmark extends BenchmarkBase {
  RibsTokenBenchmark(this._input) : super('ribs_parse  token  ${_input.length}c');

  final String _input;
  late Parser<String> _parser;

  @override
  void setup() {
    _parser = Parsers.charsWhile(_isTcharChar);
  }

  @override
  void run() {
    final r = _parser.parseAll(_input);
    assert(r.isRight);
  }
}

/// petitparser: parse a single HTTP token.
class PpTokenBenchmark extends BenchmarkBase {
  PpTokenBenchmark(this._input) : super('petitparser  token  ${_input.length}c');

  final String _input;
  late pp.Parser<String> _parser;

  @override
  void setup() {
    _parser = pp.predicate(1, (String c) => _isTchar(c), 'tchar').plusString().end();
  }

  @override
  void run() {
    final r = _parser.parse(_input);
    assert(r is pp.Success);
  }
}

/// ribs_parse: parse a 3-digit HTTP status code.
class RibsStatusCodeBenchmark extends BenchmarkBase {
  RibsStatusCodeBenchmark() : super('ribs_parse  status-code  3c');

  late Parser<int> _parser;

  @override
  void setup() {
    _parser = Parsers.charsWhile(_isDigitChar).map(int.parse);
  }

  @override
  void run() {
    final r = _parser.parseAll('404');
    assert(r.isRight);
  }
}

/// petitparser: parse a 3-digit HTTP status code.
class PpStatusCodeBenchmark extends BenchmarkBase {
  PpStatusCodeBenchmark() : super('petitparser  status-code  3c');

  late pp.Parser<int> _parser;

  @override
  void setup() {
    _parser = pp.digit().times(3).flatten().map(int.parse).end();
  }

  @override
  void run() {
    final r = _parser.parse('404');
    assert(r is pp.Success);
  }
}

/// ribs_parse: parse an HTTP version string.
class RibsHttpVersionBenchmark extends BenchmarkBase {
  RibsHttpVersionBenchmark() : super('ribs_parse  http-version  8c');

  late Parser<String> _parser;

  @override
  void setup() {
    final digits = Parsers.charsWhile(_isDigitChar);
    _parser = Parsers.string('HTTP/')
        .productR(digits)
        .productL(Parsers.string('.'))
        .product(digits)
        .map(((String, String) t) => 'HTTP/${t.$1}.${t.$2}');
  }

  @override
  void run() {
    final r = _parser.parseAll('HTTP/1.1');
    assert(r.isRight);
  }
}

/// petitparser: parse an HTTP version string.
class PpHttpVersionBenchmark extends BenchmarkBase {
  PpHttpVersionBenchmark() : super('petitparser  http-version  8c');

  late pp.Parser<String> _parser;

  @override
  void setup() {
    _parser = (pp.string('HTTP/') & pp.digit() & pp.char('.') & pp.digit()).flatten().end();
  }

  @override
  void run() {
    final r = _parser.parse('HTTP/1.1');
    assert(r is pp.Success);
  }
}

/// ribs_parse: parse an HTTP header field line (name + value, no CRLF).
class RibsHeaderFieldBenchmark extends BenchmarkBase {
  RibsHeaderFieldBenchmark(this._input) : super('ribs_parse  header-field  ${_input.length}c');

  final String _input;
  late Parser<(String, String)> _parser;

  @override
  void setup() {
    final token = Parsers.charsWhile(_isTcharChar);
    final value = Parsers.charsWhile(_isFieldCharChar).map((String s) => s.trim());
    _parser = token.productL(Parsers.string(':')).product(value);
  }

  @override
  void run() {
    final r = _parser.parseAll(_input);
    assert(r.isRight);
  }
}

/// petitparser: parse an HTTP header field line.
class PpHeaderFieldBenchmark extends BenchmarkBase {
  PpHeaderFieldBenchmark(this._input) : super('petitparser  header-field  ${_input.length}c');

  final String _input;
  late pp.Parser<(String, String)> _parser;

  @override
  void setup() {
    final tchar = pp.predicate(1, (String c) => _isTchar(c), 'tchar');
    final token = tchar.plusString();
    final ows = pp.predicate(1, (String c) => _isOws(c), 'ows').starString();
    final fieldValue = pp.predicate(1, (String c) => _isVchar(c), 'vchar').plusString();
    _parser = (token & pp.char(':') & ows & fieldValue & ows).end().map(
      (list) => (list[0] as String, list[3] as String),
    );
  }

  @override
  void run() {
    final r = _parser.parse(_input);
    assert(r is pp.Success);
  }
}

/// ribs_parse: parse a comma-separated list of HTTP tokens.
class RibsCsvTokenBenchmark extends BenchmarkBase {
  RibsCsvTokenBenchmark(this._input) : super('ribs_parse  csv-tokens  ${_input.length}c');

  final String _input;
  late Parser<NonEmptyIList<String>> _parser;

  @override
  void setup() {
    final token = Parsers.charsWhile(_isTcharChar);
    final ows = Parsers.charsWhile0(_isOwsChar).voided;
    final sep = ows.productR(Parsers.string(',')).productL(ows);
    _parser = token.repSep(sep);
  }

  @override
  void run() {
    final r = _parser.parseAll(_input);
    assert(r.isRight);
  }
}

/// petitparser: parse a comma-separated list of HTTP tokens.
class PpCsvTokenBenchmark extends BenchmarkBase {
  PpCsvTokenBenchmark(this._input) : super('petitparser  csv-tokens  ${_input.length}c');

  final String _input;
  late pp.Parser<List<String>> _parser;

  @override
  void setup() {
    final tchar = pp.predicate(1, (String c) => _isTchar(c), 'tchar');
    final token = tchar.plusString();
    final ows = pp.predicate(1, (String c) => _isOws(c), 'ows').star();
    final sep = (ows & pp.char(',') & ows).flatten();
    _parser = token.plusSeparated(sep).map((sl) => sl.elements).end();
  }

  @override
  void run() {
    final r = _parser.parse(_input);
    assert(r is pp.Success);
  }
}

/// ribs_parse: parse an HTTP request line.
class RibsRequestLineBenchmark extends BenchmarkBase {
  RibsRequestLineBenchmark(this._input) : super('ribs_parse  request-line  ${_input.length}c');

  final String _input;
  late Parser<(String, String, String)> _parser;

  @override
  void setup() {
    final sp = Parsers.string(' ');
    final method = Parsers.charsWhile(_isUpperChar);
    final target = Parsers.charsWhile(_isVcharChar);
    final digits = Parsers.charsWhile(_isDigitChar);
    final version = Parsers.string('HTTP/')
        .productR(digits)
        .productL(Parsers.string('.'))
        .product(digits)
        .map(((String, String) t) => 'HTTP/${t.$1}.${t.$2}');
    _parser = method
        .productL(sp)
        .product(target.productL(sp).product(version))
        .map(((String, (String, String)) t) => (t.$1, t.$2.$1, t.$2.$2));
  }

  @override
  void run() {
    final r = _parser.parseAll(_input);
    assert(r.isRight);
  }
}

/// petitparser: parse an HTTP request line.
class PpRequestLineBenchmark extends BenchmarkBase {
  PpRequestLineBenchmark(this._input) : super('petitparser  request-line  ${_input.length}c');

  final String _input;
  late pp.Parser<(String, String, String)> _parser;

  @override
  void setup() {
    final sp = pp.char(' ');
    final method = pp.uppercase().plusString();
    final requestTarget = pp.predicate(1, (String c) => _isVchar(c), 'vchar').plusString();
    final httpVersion = (pp.string('HTTP/') & pp.digit() & pp.char('.') & pp.digit()).flatten();
    _parser = (method & sp & requestTarget & sp & httpVersion).end().map(
      (list) => (list[0] as String, list[2] as String, list[4] as String),
    );
  }

  @override
  void run() {
    final r = _parser.parse(_input);
    assert(r is pp.Success);
  }
}

const _multiHeaderInput =
    'Host: api.example.com\r\n'
    'Content-Type: application/json\r\n'
    'Content-Length: 1024\r\n'
    'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9\r\n'
    'Accept: application/json\r\n'
    'Accept-Encoding: gzip, deflate, br\r\n';

/// ribs_parse: parse 6 CRLF-terminated HTTP header lines into a list.
class RibsMultiHeaderBenchmark extends BenchmarkBase {
  RibsMultiHeaderBenchmark() : super('ribs_parse  multi-header  ${_multiHeaderInput.length}c');

  late Parser<NonEmptyIList<(String, String)>> _parser;

  @override
  void setup() {
    final name = Parsers.charsWhile(_isTcharChar);
    final value = Parsers.charsWhile(_isFieldCharChar).map((String s) => s.trim());
    final crlf = Parsers.string('\r\n');
    final line = name.productL(Parsers.string(':')).product(value).productL(crlf);
    _parser = line.rep();
  }

  @override
  void run() {
    final r = _parser.parseAll(_multiHeaderInput);
    assert(r.isRight);
  }
}

/// petitparser: parse 6 CRLF-terminated HTTP header lines into a list.
class PpMultiHeaderBenchmark extends BenchmarkBase {
  PpMultiHeaderBenchmark() : super('petitparser  multi-header  ${_multiHeaderInput.length}c');

  late pp.Parser<List<(String, String)>> _parser;

  @override
  void setup() {
    final tchar = pp.predicate(1, (String c) => _isTchar(c), 'tchar');
    final token = tchar.plusString();
    final fieldChar = pp.predicate(1, (String c) {
      final code = c.codeUnitAt(0);
      return code == 9 || (code >= 32 && code <= 126);
    }, 'field-char');
    final value = fieldChar.plusString().map((String s) => s.trim());
    final crlf = pp.string('\r\n');
    _parser =
        (token & pp.char(':') & value & crlf)
            .map((list) => (list[0] as String, list[2] as String))
            .plus()
            .end();
  }

  @override
  void run() {
    final r = _parser.parse(_multiHeaderInput);
    assert(r is pp.Success);
  }
}

const _fullRequestInput =
    'POST /api/v2/users/profile HTTP/1.1\r\n'
    'Host: api.example.com\r\n'
    'Content-Type: application/json\r\n'
    'Content-Length: 1024\r\n'
    'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9\r\n'
    'Accept: application/json\r\n'
    'Accept-Encoding: gzip, deflate, br\r\n'
    '\r\n';

/// ribs_parse: parse a complete HTTP/1.1 request header section.
class RibsFullRequestBenchmark extends BenchmarkBase {
  RibsFullRequestBenchmark() : super('ribs_parse  full-request  ${_fullRequestInput.length}c');

  late Parser<Unit> _parser;

  @override
  void setup() {
    final sp = Parsers.string(' ');
    final crlf = Parsers.string('\r\n');
    final method = Parsers.charsWhile(_isUpperChar);
    final target = Parsers.charsWhile(_isVcharChar);
    final digits = Parsers.charsWhile(_isDigitChar);
    final version = Parsers.string('HTTP/')
        .productR(digits)
        .productL(Parsers.string('.'))
        .product(digits)
        .map(((String, String) t) => 'HTTP/${t.$1}.${t.$2}');
    final requestLine =
        method.productL(sp).product(target.productL(sp).product(version)).productL(crlf).voided;
    final name = Parsers.charsWhile(_isTcharChar);
    final value = Parsers.charsWhile(_isFieldCharChar).map((String s) => s.trim());
    final headerLine = name.productL(Parsers.string(':')).product(value).productL(crlf).voided;
    _parser = requestLine.productR(headerLine.rep().voided).productR(crlf.voided);
  }

  @override
  void run() {
    final r = _parser.parseAll(_fullRequestInput);
    assert(r.isRight);
  }
}

/// petitparser: parse a complete HTTP/1.1 request header section.
class PpFullRequestBenchmark extends BenchmarkBase {
  PpFullRequestBenchmark() : super('petitparser  full-request  ${_fullRequestInput.length}c');

  late pp.Parser<String> _parser;

  @override
  void setup() {
    final sp = pp.char(' ');
    final crlf = pp.string('\r\n');
    final method = pp.uppercase().plusString();
    final requestTarget = pp.predicate(1, (String c) => _isVchar(c), 'vchar').plusString();
    final httpVersion = (pp.string('HTTP/') & pp.digit() & pp.char('.') & pp.digit()).flatten();
    final requestLine = (method & sp & requestTarget & sp & httpVersion & crlf).flatten();
    final tchar = pp.predicate(1, (String c) => _isTchar(c), 'tchar');
    final token = tchar.plusString();
    final fieldChar = pp.predicate(1, (String c) {
      final code = c.codeUnitAt(0);
      return code == 9 || (code >= 32 && code <= 126);
    }, 'field-char');
    final value = fieldChar.plusString();
    final headerLine = (token & pp.char(':') & value & crlf).flatten();
    _parser = (requestLine & headerLine.plus() & crlf).flatten().end();
  }

  @override
  void run() {
    final r = _parser.parse(_fullRequestInput);
    assert(r is pp.Success);
  }
}

const _largeCsvInput =
    'Accept-Encoding, Content-Type, Authorization, X-Request-Id, Cache-Control, '
    'X-Forwarded-For, User-Agent, Accept, Host, Connection, '
    'Upgrade-Insecure-Requests, Sec-Fetch-Dest, Sec-Fetch-Mode, Sec-Fetch-Site, '
    'Sec-CH-UA, Sec-CH-UA-Mobile, Sec-CH-UA-Platform, DNT, Referer, Pragma';

/// ribs_parse: parse 20 comma-separated HTTP tokens.
class RibsLargeCsvBenchmark extends BenchmarkBase {
  RibsLargeCsvBenchmark() : super('ribs_parse  large-csv  ${_largeCsvInput.length}c');

  late Parser<NonEmptyIList<String>> _parser;

  @override
  void setup() {
    final token = Parsers.charsWhile(_isTcharChar);
    final ows = Parsers.charsWhile0(_isOwsChar).voided;
    final sep = ows.productR(Parsers.string(',')).productL(ows);
    _parser = token.repSep(sep);
  }

  @override
  void run() {
    final r = _parser.parseAll(_largeCsvInput);
    assert(r.isRight);
  }
}

/// petitparser: parse 20 comma-separated HTTP tokens.
class PpLargeCsvBenchmark extends BenchmarkBase {
  PpLargeCsvBenchmark() : super('petitparser  large-csv  ${_largeCsvInput.length}c');

  late pp.Parser<List<String>> _parser;

  @override
  void setup() {
    final tchar = pp.predicate(1, (String c) => _isTchar(c), 'tchar');
    final token = tchar.plusString();
    final ows = pp.predicate(1, (String c) => _isOws(c), 'ows').star();
    final sep = (ows & pp.char(',') & ows).flatten();
    _parser = token.plusSeparated(sep).map((sl) => sl.elements).end();
  }

  @override
  void run() {
    final r = _parser.parse(_largeCsvInput);
    assert(r is pp.Success);
  }
}
