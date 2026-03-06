import 'package:ribs_parse/src/char.dart';
import 'package:test/test.dart';

void main() {
  group('char() convenience constructor', () {
    test('wraps a single-character string', () {
      expect(char('a').codeUnit, equals('a'.codeUnitAt(0)));
    });

    test('produces same value as Char.fromString', () {
      expect(char('Z'), equals(Char.fromString('Z')));
    });
  });

  group('Char.fromString', () {
    test('creates Char with the correct code unit', () {
      expect(Char.fromString('A').codeUnit, equals(65));
      expect(Char.fromString('a').codeUnit, equals(97));
      expect(Char.fromString('0').codeUnit, equals(48));
    });
  });

  group('Char.checked', () {
    test('accepts values at MinValue and MaxValue boundaries', () {
      expect(Char.checked(0x0000), equals(Char.MinValue));
      expect(Char.checked(0xffff), equals(Char.MaxValue));
    });

    test('accepts an arbitrary in-range value', () {
      expect(Char.checked(65).codeUnit, equals(65));
    });

    test('throws RangeError for negative code unit', () {
      expect(() => Char.checked(-1), throwsRangeError);
    });

    test('throws RangeError for value above MaxValue', () {
      expect(() => Char.checked(0x10000), throwsRangeError);
    });
  });

  group('Char.MinValue / Char.MaxValue', () {
    test('MinValue has codeUnit 0x0000', () {
      expect(Char.MinValue.codeUnit, equals(0x0000));
    });

    test('MaxValue has codeUnit 0xffff', () {
      expect(Char.MaxValue.codeUnit, equals(0xffff));
    });

    test('MinValue < MaxValue', () {
      expect(Char.MinValue < Char.MaxValue, isTrue);
    });
  });

  group('isDigit', () {
    test('true for 0–9', () {
      for (final d in ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']) {
        expect(char(d).isDigit, isTrue, reason: d);
      }
    });

    test('false for letters and symbols', () {
      expect(char('a').isDigit, isFalse);
      expect(char('Z').isDigit, isFalse);
      expect(char('/').isDigit, isFalse);
      expect(char(':').isDigit, isFalse);
    });
  });

  group('isWhitespace', () {
    test('true for space, tab, LF, CR', () {
      expect(char(' ').isWhitespace, isTrue);
      expect(char('\t').isWhitespace, isTrue);
      expect(char('\n').isWhitespace, isTrue);
      expect(char('\r').isWhitespace, isTrue);
    });

    test('false for printable non-space characters', () {
      expect(char('a').isWhitespace, isFalse);
      expect(char('0').isWhitespace, isFalse);
    });
  });

  group('isUpperCase / isLowerCase', () {
    test('isUpperCase true for A–Z', () {
      expect(char('A').isUpperCase, isTrue);
      expect(char('Z').isUpperCase, isTrue);
      expect(char('M').isUpperCase, isTrue);
    });

    test('isUpperCase false for lowercase and digits', () {
      expect(char('a').isUpperCase, isFalse);
      expect(char('0').isUpperCase, isFalse);
    });

    test('isLowerCase true for a–z', () {
      expect(char('a').isLowerCase, isTrue);
      expect(char('z').isLowerCase, isTrue);
      expect(char('m').isLowerCase, isTrue);
    });

    test('isLowerCase false for uppercase and digits', () {
      expect(char('A').isLowerCase, isFalse);
      expect(char('0').isLowerCase, isFalse);
    });
  });

  group('isAscii', () {
    test('true for code units < 128', () {
      expect(char('A').isAscii, isTrue);
      expect(char(' ').isAscii, isTrue);
      expect(Char(0).isAscii, isTrue);
      expect(Char(127).isAscii, isTrue);
    });

    test('false for code units >= 128', () {
      expect(Char(128).isAscii, isFalse);
      expect(Char(0x00e9).isAscii, isFalse); // é
    });
  });

  group('isLetter', () {
    test('true for ASCII letters', () {
      expect(char('a').isLetter, isTrue);
      expect(char('Z').isLetter, isTrue);
    });

    test('true for Latin Extended characters (0x00c0–0x024f)', () {
      expect(Char(0x00c0).isLetter, isTrue);
      expect(Char(0x00e9).isLetter, isTrue); // é
      expect(Char(0x024f).isLetter, isTrue);
    });

    test('true for Greek characters (0x0370–0x03ff)', () {
      expect(Char(0x0370).isLetter, isTrue);
      expect(Char(0x03b1).isLetter, isTrue); // α
      expect(Char(0x03ff).isLetter, isTrue);
    });

    test('true for CJK Unified Ideographs (0x4e00–0x9fff)', () {
      expect(Char(0x4e00).isLetter, isTrue);
      expect(Char(0x9fff).isLetter, isTrue);
    });

    test('false for digits, symbols, and whitespace', () {
      expect(char('0').isLetter, isFalse);
      expect(char('!').isLetter, isFalse);
      expect(char(' ').isLetter, isFalse);
    });

    test('false for code units just outside the Latin Extended range', () {
      expect(Char(0x00bf).isLetter, isFalse);
      expect(Char(0x0250).isLetter, isFalse);
    });
  });

  group('toUpperCase', () {
    test('converts lowercase ASCII to uppercase', () {
      expect(char('a').toUpperCase, equals(char('A')));
      expect(char('z').toUpperCase, equals(char('Z')));
      expect(char('m').toUpperCase, equals(char('M')));
    });

    test('leaves uppercase unchanged', () {
      expect(char('A').toUpperCase, equals(char('A')));
    });

    test('leaves digits and symbols unchanged', () {
      expect(char('0').toUpperCase, equals(char('0')));
      expect(char('!').toUpperCase, equals(char('!')));
    });
  });

  group('toLoweCase (toLowercase)', () {
    test('converts uppercase ASCII to lowercase', () {
      expect(char('A').toLoweCase, equals(char('a')));
      expect(char('Z').toLoweCase, equals(char('z')));
      expect(char('M').toLoweCase, equals(char('m')));
    });

    test('leaves lowercase unchanged', () {
      expect(char('a').toLoweCase, equals(char('a')));
    });

    test('leaves digits and symbols unchanged', () {
      expect(char('0').toLoweCase, equals(char('0')));
    });
  });

  group('asString', () {
    test('returns a one-character string matching the original', () {
      expect(char('a').asString, equals('a'));
      expect(char('Z').asString, equals('Z'));
      expect(char('\n').asString, equals('\n'));
    });

    test('round-trips through Char.fromString', () {
      const original = 'x';
      expect(Char.fromString(original).asString, equals(original));
    });
  });

  group('arithmetic operators + and -', () {
    test('+ increments the code unit', () {
      expect(char('a') + 1, equals(char('b')));
      expect(char('A') + 25, equals(char('Z')));
    });

    test('- decrements the code unit', () {
      expect(char('b') - 1, equals(char('a')));
      expect(char('Z') - 25, equals(char('A')));
    });

    test('+ wraps around at 0xffff', () {
      expect((Char.MaxValue + 1).codeUnit, equals(0));
    });
  });

  group('comparison operators', () {
    test('< returns true when left code unit is smaller', () {
      expect(char('a') < char('b'), isTrue);
      expect(char('b') < char('a'), isFalse);
      expect(char('a') < char('a'), isFalse);
    });

    test('> returns true when left code unit is larger', () {
      expect(char('b') > char('a'), isTrue);
      expect(char('a') > char('b'), isFalse);
      expect(char('a') > char('a'), isFalse);
    });

    test('<= returns true for less-than or equal', () {
      expect(char('a') <= char('b'), isTrue);
      expect(char('a') <= char('a'), isTrue);
      expect(char('b') <= char('a'), isFalse);
    });

    test('>= returns true for greater-than or equal', () {
      expect(char('b') >= char('a'), isTrue);
      expect(char('a') >= char('a'), isTrue);
      expect(char('a') >= char('b'), isFalse);
    });

    test('== compares by code unit value', () {
      expect(char('a') == char('a'), isTrue);
      expect(char('a') == char('b'), isFalse);
      expect(Char(65) == Char.fromString('A'), isTrue);
    });
  });

  group('CharsRange', () {
    final digitRange = CharsRange((char('0'), char('9')));

    test('start and end return the bounds', () {
      expect(digitRange.start, equals(char('0')));
      expect(digitRange.end, equals(char('9')));
    });

    test('contains returns true for chars within the range', () {
      expect(digitRange.contains(char('0')), isTrue);
      expect(digitRange.contains(char('5')), isTrue);
      expect(digitRange.contains(char('9')), isTrue);
    });

    test('contains returns false for chars outside the range', () {
      expect(digitRange.contains(char('/')), isFalse); // one below '0'
      expect(digitRange.contains(char(':')), isFalse); // one above '9'
    });

    test('single-character range contains only that char', () {
      final singleRange = CharsRange((char('x'), char('x')));
      expect(singleRange.contains(char('x')), isTrue);
      expect(singleRange.contains(char('w')), isFalse);
      expect(singleRange.contains(char('y')), isFalse);
    });
  });
}
