import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_parse/src/caret.dart';
import 'package:ribs_parse/src/location_map.dart';
import 'package:test/test.dart';

/// Converts an [Option<Caret>] to [Option<(line, col, offset)>] so that
/// standard value equality works in expectations.
Option<(int, int, int)> _fields(Option<Caret> opt) =>
    opt.map((Caret c) => (c.line, c.col, c.offset));

/// Convenience wrapper: call [LocationMap.toCaret] and extract fields.
Option<(int, int, int)> _caret(LocationMap m, int offset) => _fields(m.toCaret(offset));

void main() {
  group('empty string', () {
    final m = LocationMap('');

    test('lineCount is 1 (a string always has at least one line)', () {
      expect(m.lineCount, equals(1));
    });

    test('isValidOffset: only 0 is valid', () {
      expect(m.isValidOffset(0), isTrue);
      expect(m.isValidOffset(1), isFalse);
      expect(m.isValidOffset(-1), isFalse);
    });

    test('toCaret(0) returns (line=0, col=0, offset=0)', () {
      expect(_caret(m, 0), equals(const Some((0, 0, 0))));
    });

    test('toCaret out-of-range returns None', () {
      expect(_caret(m, 1), equals(none<(int, int, int)>()));
      expect(_caret(m, -1), equals(none<(int, int, int)>()));
    });

    test('toCaretUnsafe(0) returns Caret.Start', () {
      final c = m.toCaretUnsafe(0);
      expect((c.line, c.col, c.offset), equals((0, 0, 0)));
    });

    test('toCaretUnsafe out-of-range throws ArgumentError', () {
      expect(() => m.toCaretUnsafe(1), throwsArgumentError);
    });

    test('toLineCol(0) returns (0, 0)', () {
      expect(m.toLineCol(0), equals(const Some((0, 0))));
    });

    test('toLineCol out-of-range returns None', () {
      expect(m.toLineCol(1), equals(none<(int, int)>()));
    });

    test('getLine(0) returns Some empty string', () {
      expect(m.getLine(0), equals(const Some('')));
    });

    test('getLine out-of-range returns None', () {
      expect(m.getLine(1), equals(none<String>()));
      expect(m.getLine(-1), equals(none<String>()));
    });

    test('toOffset(0, 0) returns Some(0)', () {
      expect(m.toOffset(0, 0), equals(const Some(0)));
    });

    test('toOffset with negative line returns None', () {
      expect(m.toOffset(-1, 0), equals(none<int>()));
    });
  });

  group('single-character string "a"', () {
    final m = LocationMap('a');

    test('lineCount is 1', () {
      expect(m.lineCount, equals(1));
    });

    test('isValidOffset: 0 and 1 are valid, 2 is not', () {
      expect(m.isValidOffset(0), isTrue);
      expect(m.isValidOffset(1), isTrue); // offset == length is valid
      expect(m.isValidOffset(2), isFalse);
    });

    test('toCaret(0) is the first character', () {
      expect(_caret(m, 0), equals(const Some((0, 0, 0))));
    });

    test('toCaret(1) is end-of-input (col 1, same line, no trailing newline)', () {
      expect(_caret(m, 1), equals(const Some((0, 1, 1))));
    });
  });

  group('single-line string "hello"', () {
    final m = LocationMap('hello');

    test('lineCount is 1', () {
      expect(m.lineCount, equals(1));
    });

    test('getLine(0) returns the whole line', () {
      expect(m.getLine(0), equals(const Some('hello')));
    });

    test('toCaret at each offset returns correct col on line 0', () {
      for (var i = 0; i < 5; i++) {
        expect(
          _caret(m, i),
          equals(Some((0, i, i))),
          reason: 'offset $i',
        );
      }
    });

    test('toCaret at input.length bumps col (no trailing newline)', () {
      expect(_caret(m, 5), equals(const Some((0, 5, 5))));
    });

    test('toCaret beyond input.length returns None', () {
      expect(_caret(m, 6), equals(none<(int, int, int)>()));
    });

    test('toLineCol round-trips through toCaret', () {
      expect(m.toLineCol(3), equals(const Some((0, 3))));
    });

    test('toOffset(0, 3) returns Some(3)', () {
      expect(m.toOffset(0, 3), equals(const Some(3)));
    });

    test('toOffset for out-of-range line returns None', () {
      // line > lines.length (strictly) is rejected; line == lines.length is allowed
      expect(m.toOffset(2, 0), equals(none<int>()));
      expect(m.toOffset(-1, 0), equals(none<int>()));
    });
  });

  group('string ending with newline "hello\\n"', () {
    final m = LocationMap('hello\n');

    test('lineCount is 2 (trailing newline creates an empty second line)', () {
      expect(m.lineCount, equals(2));
    });

    test('getLine returns correct lines', () {
      expect(m.getLine(0), equals(const Some('hello')));
      expect(m.getLine(1), equals(const Some('')));
      expect(m.getLine(2), equals(none<String>()));
    });

    test('toCaret at the newline character is on line 0 col 5', () {
      // offset 5 is the '\n' — still on line 0
      expect(_caret(m, 5), equals(const Some((0, 5, 5))));
    });

    test('toCaret at input.length advances to line 1 col 0 (trailing newline)', () {
      // input.length == 6; ends with '\n' so position moves to next line
      expect(_caret(m, 6), equals(const Some((1, 0, 6))));
    });
  });

  group('two-line string "abc\\ndef"', () {
    final m = LocationMap('abc\ndef');

    test('lineCount is 2', () {
      expect(m.lineCount, equals(2));
    });

    test('getLine returns each line and None for out-of-range', () {
      expect(m.getLine(0), equals(const Some('abc')));
      expect(m.getLine(1), equals(const Some('def')));
      expect(m.getLine(2), equals(none<String>()));
    });

    test('toCaret for characters on line 0', () {
      expect(_caret(m, 0), equals(const Some((0, 0, 0))));
      expect(_caret(m, 1), equals(const Some((0, 1, 1))));
      expect(_caret(m, 2), equals(const Some((0, 2, 2))));
    });

    test('toCaret at the newline is on line 0 col 3', () {
      expect(_caret(m, 3), equals(const Some((0, 3, 3))));
    });

    test('toCaret at start of second line is line 1 col 0', () {
      expect(_caret(m, 4), equals(const Some((1, 0, 4))));
    });

    test('toCaret for characters on line 1', () {
      expect(_caret(m, 5), equals(const Some((1, 1, 5))));
      expect(_caret(m, 6), equals(const Some((1, 2, 6))));
    });

    test('toCaret at input.length is end-of-last-line (no trailing newline)', () {
      expect(_caret(m, 7), equals(const Some((1, 3, 7))));
    });

    test('toLineCol round-trips for both lines', () {
      expect(m.toLineCol(0), equals(const Some((0, 0))));
      expect(m.toLineCol(4), equals(const Some((1, 0))));
      expect(m.toLineCol(6), equals(const Some((1, 2))));
    });

    test('toOffset round-trips with toLineCol for every valid offset', () {
      for (var offset = 0; offset <= m.input.length; offset++) {
        m.toLineCol(offset).fold(
          () => fail('Expected Some for offset $offset'),
          ((int, int) lc) {
            expect(
              m.toOffset(lc.$1, lc.$2),
              equals(Some(offset)),
              reason: 'round-trip failed at offset $offset',
            );
          },
        );
      }
    });
  });

  group('two-line string "abc\\ndef\\n"', () {
    final m = LocationMap('abc\ndef\n');

    test('lineCount is 3', () {
      expect(m.lineCount, equals(3));
    });

    test('toCaret at input.length goes to line 2 col 0 (trailing newline)', () {
      expect(_caret(m, 8), equals(const Some((2, 0, 8))));
    });
  });

  group('three-line string "L0\\nL1\\nL2"', () {
    // offsets: L=0 0=1 \n=2  L=3 1=4 \n=5  L=6 2=7  end=8
    final m = LocationMap('L0\nL1\nL2');

    test('lineCount is 3', () {
      expect(m.lineCount, equals(3));
    });

    test('toCaret locates every character correctly', () {
      expect(_caret(m, 0), equals(const Some((0, 0, 0))));
      expect(_caret(m, 1), equals(const Some((0, 1, 1))));
      expect(_caret(m, 2), equals(const Some((0, 2, 2)))); // '\n'
      expect(_caret(m, 3), equals(const Some((1, 0, 3))));
      expect(_caret(m, 4), equals(const Some((1, 1, 4))));
      expect(_caret(m, 5), equals(const Some((1, 2, 5)))); // '\n'
      expect(_caret(m, 6), equals(const Some((2, 0, 6))));
      expect(_caret(m, 7), equals(const Some((2, 1, 7))));
      expect(_caret(m, 8), equals(const Some((2, 2, 8)))); // end-of-input
    });

    test('toCaretUnsafe agrees with toCaret for every valid offset', () {
      for (var i = 0; i <= m.input.length; i++) {
        final c = m.toCaretUnsafe(i);
        expect(
          Some((c.line, c.col, c.offset)),
          equals(_caret(m, i)),
          reason: 'offset $i',
        );
      }
    });

    test('toCaretUnsafe throws for invalid offset', () {
      expect(() => m.toCaretUnsafe(m.input.length + 1), throwsArgumentError);
    });
  });

  group('lines of varying length "a\\nbb\\nccc"', () {
    // offsets: a=0  \n=1  b=2 b=3  \n=4  c=5 c=6 c=7  end=8
    final m = LocationMap('a\nbb\nccc');

    test('toCaret for every offset', () {
      expect(_caret(m, 0), equals(const Some((0, 0, 0)))); // 'a'
      expect(_caret(m, 1), equals(const Some((0, 1, 1)))); // '\n'
      expect(_caret(m, 2), equals(const Some((1, 0, 2)))); // first 'b'
      expect(_caret(m, 3), equals(const Some((1, 1, 3)))); // second 'b'
      expect(_caret(m, 4), equals(const Some((1, 2, 4)))); // '\n'
      expect(_caret(m, 5), equals(const Some((2, 0, 5)))); // first 'c'
      expect(_caret(m, 6), equals(const Some((2, 1, 6)))); // second 'c'
      expect(_caret(m, 7), equals(const Some((2, 2, 7)))); // third 'c'
      expect(_caret(m, 8), equals(const Some((2, 3, 8)))); // end-of-input
    });
  });

  group('toOffset edge cases', () {
    final m = LocationMap('hello\nworld');

    test('toOffset for an out-of-range line (> lines.length) returns None', () {
      // 'hello\nworld' has 2 lines; line index 3 is strictly out of range
      expect(m.toOffset(3, 0), equals(none<int>()));
    });

    test('toOffset does not validate column — returns lineStart + col', () {
      // col beyond line length is not rejected by toOffset
      expect(m.toOffset(0, 100), equals(const Some(100)));
    });
  });

  group('single-newline input "\\n"', () {
    final m = LocationMap('\n');

    test('lineCount is 2', () {
      expect(m.lineCount, equals(2));
    });

    test('toCaret(0) is the newline on line 0 col 0', () {
      expect(_caret(m, 0), equals(const Some((0, 0, 0))));
    });

    test('toCaret(1) advances to line 1 col 0 (ends with newline)', () {
      expect(_caret(m, 1), equals(const Some((1, 0, 1))));
    });
  });

  group('toCaretUnsafe error message', () {
    test('message includes the invalid offset and the input length', () {
      final m = LocationMap('abc');
      expect(
        () => m.toCaretUnsafe(5),
        throwsA(
          isA<ArgumentError>().having(
            (ArgumentError e) => e.toString(),
            'message',
            allOf(contains('5'), contains('3')),
          ),
        ),
      );
    });
  });
}
