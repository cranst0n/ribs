import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_parse/src/numbers.dart';
import 'package:ribs_parse/src/parser.dart';
import 'package:ribs_parse/src/rfc5234.dart';
import 'package:test/test.dart';

// ---------------------------------------------------------------------------
// Helpers (same as parser_test.dart)
// ---------------------------------------------------------------------------

void expectSuccess<A>(
  Parser0<A> parser,
  String input,
  A value, {
  String remaining = '',
}) {
  final result = parser.parse(input);
  result.fold(
    (err) => fail('Expected success but got: $err'),
    (pair) {
      expect(pair.$1, equals(remaining), reason: 'remaining input mismatch');
      expect(pair.$2, equals(value), reason: 'parsed value mismatch');
    },
  );
}

void expectSuccessAll<A>(Parser0<A> parser, String input, A value) {
  final result = parser.parseAll(input);
  result.fold(
    (err) => fail('Expected success (all) but got: $err'),
    (a) => expect(a, equals(value)),
  );
}

void expectFailure<A>(Parser0<A> parser, String input, {int? offset}) {
  final result = parser.parse(input);
  result.fold(
    (err) {
      if (offset != null) {
        expect(err.offset, equals(offset), reason: 'failure offset mismatch');
      }
    },
    (_) => fail('Expected failure but parser succeeded'),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  // =========================================================================
  group('Numbers', () {
    // -----------------------------------------------------------------------
    group('digit', () {
      test('matches each decimal digit', () {
        for (final d in '0123456789'.split('')) {
          expectSuccess(Numbers.digit, d, d);
        }
      });

      test('fails on non-digit characters', () {
        expectFailure(Numbers.digit, 'a', offset: 0);
        expectFailure(Numbers.digit, ' ', offset: 0);
        expectFailure(Numbers.digit, '', offset: 0);
      });

      test('leaves remaining input', () {
        expectSuccess(Numbers.digit, '5abc', '5', remaining: 'abc');
      });
    });

    // -----------------------------------------------------------------------
    group('digits0', () {
      test('matches one or more digits into a string', () {
        expectSuccess(Numbers.digits0, '123!', '123', remaining: '!');
        expectSuccess(Numbers.digits0, '0', '0');
      });

      test('succeeds with empty string when no digits present', () {
        expectSuccess(Numbers.digits0, 'abc', '', remaining: 'abc');
        expectSuccess(Numbers.digits0, '', '');
      });

      test('stops at first non-digit', () {
        expectSuccess(Numbers.digits0, '42x', '42', remaining: 'x');
      });
    });

    // -----------------------------------------------------------------------
    group('digits', () {
      test('matches one or more digits into a string', () {
        expectSuccess(Numbers.digits, '123!', '123', remaining: '!');
        expectSuccess(Numbers.digits, '0', '0');
      });

      test('fails when no digits are present', () {
        expectFailure(Numbers.digits, 'abc', offset: 0);
        expectFailure(Numbers.digits, '', offset: 0);
      });

      test('stops at first non-digit', () {
        expectSuccess(Numbers.digits, '7x', '7', remaining: 'x');
      });
    });

    // -----------------------------------------------------------------------
    group('nonZeroDigit', () {
      test('matches 1–9', () {
        for (final d in '123456789'.split('')) {
          expectSuccess(Numbers.nonZeroDigit, d, d);
        }
      });

      test('fails on zero', () {
        expectFailure(Numbers.nonZeroDigit, '0', offset: 0);
      });

      test('fails on non-digit', () {
        expectFailure(Numbers.nonZeroDigit, 'a', offset: 0);
      });
    });

    // -----------------------------------------------------------------------
    group('nonNegativeIntString', () {
      test('parses zero', () {
        expectSuccess(Numbers.nonNegativeIntString, '0', '0');
      });

      test('parses multi-digit numbers', () {
        expectSuccess(Numbers.nonNegativeIntString, '42!', '42', remaining: '!');
        expectSuccess(Numbers.nonNegativeIntString, '100', '100');
      });

      test('parses single non-zero digit', () {
        expectSuccess(Numbers.nonNegativeIntString, '7x', '7', remaining: 'x');
      });

      test('fails on empty input', () {
        expectFailure(Numbers.nonNegativeIntString, '', offset: 0);
      });

      test('fails on non-digit', () {
        expectFailure(Numbers.nonNegativeIntString, 'abc', offset: 0);
      });

      test('fails on negative numbers', () {
        expectFailure(Numbers.nonNegativeIntString, '-1', offset: 0);
      });
    });

    // -----------------------------------------------------------------------
    group('signedIntString', () {
      test('parses positive integers', () {
        expectSuccess(Numbers.signedIntString, '42!', '42', remaining: '!');
        expectSuccess(Numbers.signedIntString, '0', '0');
      });

      test('parses negative integers', () {
        expectSuccess(Numbers.signedIntString, '-1!', '-1', remaining: '!');
        expectSuccess(Numbers.signedIntString, '-999', '-999');
      });

      test('fails on bare minus', () {
        expectFailure(Numbers.signedIntString, '-', offset: 1);
      });

      test('fails on empty input', () {
        expectFailure(Numbers.signedIntString, '', offset: 0);
      });
    });

    // -----------------------------------------------------------------------
    group('bigInt', () {
      test('parses positive BigInt', () {
        expectSuccessAll(Numbers.bigInt, '12345', BigInt.from(12345));
      });

      test('parses negative BigInt', () {
        expectSuccessAll(Numbers.bigInt, '-42', BigInt.from(-42));
      });

      test('parses zero BigInt', () {
        expectSuccessAll(Numbers.bigInt, '0', BigInt.zero);
      });

      test('parses very large integer', () {
        const big = '99999999999999999999999999999';
        expectSuccessAll(Numbers.bigInt, big, BigInt.parse(big));
      });

      test('fails on non-numeric input', () {
        expectFailure(Numbers.bigInt, 'abc', offset: 0);
      });
    });

    // -----------------------------------------------------------------------
    group('jsonNumber', () {
      test('parses integer', () {
        expectSuccess(Numbers.jsonNumber, '42 ', '42', remaining: ' ');
      });

      test('parses negative integer', () {
        expectSuccess(Numbers.jsonNumber, '-7!', '-7', remaining: '!');
      });

      test('parses decimal fraction', () {
        expectSuccess(Numbers.jsonNumber, '3.14!', '3.14', remaining: '!');
      });

      test('parses negative decimal', () {
        expectSuccessAll(Numbers.jsonNumber, '-0.5', '-0.5');
      });

      test('parses number with exponent (e)', () {
        expectSuccessAll(Numbers.jsonNumber, '1e10', '1e10');
        expectSuccessAll(Numbers.jsonNumber, '1e1', '1e1');
      });

      test('parses number with exponent (E)', () {
        expectSuccessAll(Numbers.jsonNumber, '2E3', '2E3');
      });

      test('parses number with signed exponent', () {
        expectSuccessAll(Numbers.jsonNumber, '1e+2', '1e+2');
        expectSuccessAll(Numbers.jsonNumber, '1e-2', '1e-2');
      });

      test('parses number with fraction and exponent', () {
        expectSuccessAll(Numbers.jsonNumber, '6.022e23', '6.022e23');
      });

      test('fails on empty input', () {
        expectFailure(Numbers.jsonNumber, '', offset: 0);
      });

      test('fails on non-numeric input', () {
        expectFailure(Numbers.jsonNumber, 'abc', offset: 0);
      });
    });
  });

  // =========================================================================
  group('Rfc5234', () {
    // -----------------------------------------------------------------------
    group('alpha', () {
      test('matches uppercase letters', () {
        for (final c in 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('')) {
          expectSuccess(Rfc5234.alpha, c, c);
        }
      });

      test('matches lowercase letters', () {
        for (final c in 'abcdefghijklmnopqrstuvwxyz'.split('')) {
          expectSuccess(Rfc5234.alpha, c, c);
        }
      });

      test('fails on digits and symbols', () {
        expectFailure(Rfc5234.alpha, '0', offset: 0);
        expectFailure(Rfc5234.alpha, '!', offset: 0);
        expectFailure(Rfc5234.alpha, '', offset: 0);
      });
    });

    // -----------------------------------------------------------------------
    group('bit', () {
      test('matches 0 and 1', () {
        expectSuccess(Rfc5234.bit, '0', '0');
        expectSuccess(Rfc5234.bit, '1', '1');
      });

      test('fails on other digits and letters', () {
        expectFailure(Rfc5234.bit, '2', offset: 0);
        expectFailure(Rfc5234.bit, 'a', offset: 0);
      });
    });

    // -----------------------------------------------------------------------
    group('cr / lf', () {
      test('cr matches carriage return', () {
        expectSuccess(Rfc5234.cr, '\r!', Unit(), remaining: '!');
        expectFailure(Rfc5234.cr, '\n', offset: 0);
      });

      test('lf matches line feed', () {
        expectSuccess(Rfc5234.lf, '\n!', Unit(), remaining: '!');
        expectFailure(Rfc5234.lf, '\r', offset: 0);
      });
    });

    // -----------------------------------------------------------------------
    group('ctl', () {
      test('matches DEL (0x7f)', () {
        expectSuccess(Rfc5234.ctl, String.fromCharCode(0x7f), String.fromCharCode(0x7f));
      });

      test('matches control chars 0x00–0x1f', () {
        expectSuccess(Rfc5234.ctl, String.fromCharCode(0x00), String.fromCharCode(0x00));
        expectSuccess(Rfc5234.ctl, String.fromCharCode(0x1f), String.fromCharCode(0x1f));
      });

      test('fails on printable ASCII', () {
        expectFailure(Rfc5234.ctl, 'a', offset: 0);
        expectFailure(Rfc5234.ctl, ' ', offset: 0);
      });
    });

    // -----------------------------------------------------------------------
    group('digit', () {
      test('matches decimal digits', () {
        for (final d in '0123456789'.split('')) {
          expectSuccess(Rfc5234.digit, d, d);
        }
      });

      test('fails on letters', () {
        expectFailure(Rfc5234.digit, 'a', offset: 0);
      });
    });

    // -----------------------------------------------------------------------
    group('dquote', () {
      test('matches double-quote', () {
        expectSuccess(Rfc5234.dquote, '"!', Unit(), remaining: '!');
      });

      test('fails on single-quote', () {
        expectFailure(Rfc5234.dquote, "'", offset: 0);
      });
    });

    // -----------------------------------------------------------------------
    group('hexdig', () {
      test('matches decimal digits', () {
        for (final d in '0123456789'.split('')) {
          expectSuccess(Rfc5234.hexdig, d, d);
        }
      });

      test('matches uppercase hex letters A–F', () {
        for (final c in 'ABCDEF'.split('')) {
          expectSuccess(Rfc5234.hexdig, c, c);
        }
      });

      test('matches lowercase hex letters a–f', () {
        for (final c in 'abcdef'.split('')) {
          expectSuccess(Rfc5234.hexdig, c, c);
        }
      });

      test('fails on non-hex letters', () {
        expectFailure(Rfc5234.hexdig, 'g', offset: 0);
        expectFailure(Rfc5234.hexdig, 'G', offset: 0);
        expectFailure(Rfc5234.hexdig, 'z', offset: 0);
      });
    });

    // -----------------------------------------------------------------------
    group('htab / sp / wsp', () {
      test('htab matches horizontal tab', () {
        expectSuccess(Rfc5234.htab, '\t!', Unit(), remaining: '!');
        expectFailure(Rfc5234.htab, ' ', offset: 0);
      });

      test('sp matches space', () {
        expectSuccess(Rfc5234.sp, ' !', Unit(), remaining: '!');
        expectFailure(Rfc5234.sp, '\t', offset: 0);
      });

      test('wsp matches space or tab', () {
        expectSuccess(Rfc5234.wsp, ' x', Unit(), remaining: 'x');
        expectSuccess(Rfc5234.wsp, '\tx', Unit(), remaining: 'x');
        expectFailure(Rfc5234.wsp, 'a', offset: 0);
        expectFailure(Rfc5234.wsp, '', offset: 0);
      });
    });

    // -----------------------------------------------------------------------
    group('lwsp', () {
      test('succeeds with empty string (zero whitespace)', () {
        expectSuccess(Rfc5234.lwsp, 'abc', Unit(), remaining: 'abc');
        expectSuccess(Rfc5234.lwsp, '', Unit());
      });

      test('consumes a run of spaces and tabs', () {
        expectSuccess(Rfc5234.lwsp, '  \t abc', Unit(), remaining: 'abc');
      });

      test('consumes CRLF followed by whitespace (folded whitespace)', () {
        expectSuccess(Rfc5234.lwsp, '\r\n abc', Unit(), remaining: 'abc');
        expectSuccess(Rfc5234.lwsp, '\r\n\t!', Unit(), remaining: '!');
      });

      test('stops before non-whitespace', () {
        expectSuccess(Rfc5234.lwsp, '  xyz', Unit(), remaining: 'xyz');
      });
    });

    // -----------------------------------------------------------------------
    group('vchar', () {
      test('matches visible ASCII characters (0x21–0x7e)', () {
        expectSuccess(Rfc5234.vchar, '!', '!'); // 0x21
        expectSuccess(Rfc5234.vchar, '~', '~'); // 0x7e
        expectSuccess(Rfc5234.vchar, 'A', 'A');
        expectSuccess(Rfc5234.vchar, 'z', 'z');
      });

      test('fails on space (0x20)', () {
        expectFailure(Rfc5234.vchar, ' ', offset: 0);
      });

      test('fails on DEL (0x7f)', () {
        expectFailure(Rfc5234.vchar, String.fromCharCode(0x7f), offset: 0);
      });

      test('fails on control characters', () {
        expectFailure(Rfc5234.vchar, '\n', offset: 0);
        expectFailure(Rfc5234.vchar, '\t', offset: 0);
      });
    });

    // -----------------------------------------------------------------------
    group('octet', () {
      test('matches any byte value (0x00–0xff)', () {
        expectSuccess(Rfc5234.octet, String.fromCharCode(0x00), String.fromCharCode(0x00));
        expectSuccess(Rfc5234.octet, String.fromCharCode(0x7f), String.fromCharCode(0x7f));
        expectSuccess(Rfc5234.octet, String.fromCharCode(0xff), String.fromCharCode(0xff));
        expectSuccess(Rfc5234.octet, 'A', 'A');
      });

      test('fails on empty input', () {
        expectFailure(Rfc5234.octet, '', offset: 0);
      });
    });
  });
}
