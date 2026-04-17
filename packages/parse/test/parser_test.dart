import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_parse/src/accumulator.dart';
import 'package:ribs_parse/src/caret.dart';
import 'package:ribs_parse/src/char.dart';
import 'package:ribs_parse/src/error.dart';
import 'package:ribs_parse/src/parser.dart';
import 'package:test/test.dart';

/// Asserts the parser succeeds on [input], returning [value] with [remaining]
/// input left over.
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

/// Asserts the parser succeeds consuming the entire [input] string.
void expectSuccessAll<A>(Parser0<A> parser, String input, A value) {
  final result = parser.parseAll(input);
  result.fold(
    (err) => fail('Expected success (all) but got: $err'),
    (a) => expect(a, equals(value)),
  );
}

/// Asserts the parser fails on [input], optionally at [offset].
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

/// Asserts [parseAll] fails on [input].
void expectFailureAll<A>(Parser0<A> parser, String input) {
  expect(parser.parseAll(input).isLeft, isTrue, reason: 'Expected parseAll to fail');
}

// Tests

void main() {
  group('anyChar', () {
    final p = Parsers.anyChar;

    test('matches any single character', () {
      expectSuccess(p, 'a', 'a');
      expectSuccess(p, 'Z', 'Z');
      expectSuccess(p, '5', '5');
      expectSuccess(p, '!', '!');
    });

    test('leaves remaining input', () {
      expectSuccess(p, 'abc', 'a', remaining: 'bc');
    });

    test('fails on empty input', () {
      expectFailure(p, '', offset: 0);
    });

    test('parseAll fails when input has more than one char', () {
      expectFailureAll(p, 'ab');
    });
  });

  group('charIn', () {
    final p = Parsers.charIn(ilist(['a', 'b', 'c']));

    test('matches a character in the set', () {
      expectSuccess(p, 'apple', 'a', remaining: 'pple');
      expectSuccess(p, 'banana', 'b', remaining: 'anana');
      expectSuccess(p, 'cat', 'c', remaining: 'at');
    });

    test('fails on character not in set', () {
      expectFailure(p, 'dog', offset: 0);
      expectFailure(p, '', offset: 0);
    });

    test('single-char set matches that character', () {
      final single = Parsers.charIn(ilist(['x']));
      expectSuccess(single, 'xyz', 'x', remaining: 'yz');
      expectFailure(single, 'abc');
    });
  });

  group('string (Str)', () {
    test('matches the exact string', () {
      final p = Parsers.string('hello');
      expectSuccess(p, 'hello world', Unit(), remaining: ' world');
    });

    test('fails on mismatch', () {
      final p = Parsers.string('hello');
      expectFailure(p, 'Hell', offset: 0);
      expectFailure(p, '', offset: 0);
    });

    test('parseAll works when input is exactly matched', () {
      expectSuccessAll(Parsers.string('abc'), 'abc', Unit());
    });

    test('throws on empty string argument', () {
      expect(() => Parsers.string(''), throwsArgumentError);
    });
  });

  group('ignoreCase', () {
    final p = Parsers.ignoreCase('hello');

    test('matches regardless of case', () {
      expectSuccess(p, 'Hello!', Unit(), remaining: '!');
      expectSuccess(p, 'HELLO', Unit());
      expectSuccess(p, 'hello', Unit());
      expectSuccess(p, 'HeLLo world', Unit(), remaining: ' world');
    });

    test('fails on wrong string', () {
      expectFailure(p, 'world', offset: 0);
    });

    test('ignoreCase0 on empty string is unit', () {
      final p0 = Parsers.ignoreCase0('');
      expectSuccess(p0, 'abc', Unit(), remaining: 'abc');
    });
  });

  group('stringIn', () {
    // stringIn with 3+ strings creates a RadixNode-backed parser.
    final p = Parsers.stringIn(ilist(['foo', 'bar', 'baz']));

    test('matches any of the given strings', () {
      expectSuccess(p, 'fooXY', 'foo', remaining: 'XY');
      expectSuccess(p, 'barXY', 'bar', remaining: 'XY');
      expectSuccess(p, 'bazXY', 'baz', remaining: 'XY');
    });

    test('fails when no string matches', () {
      expectFailure(p, 'qux', offset: 0);
      expectFailure(p, '', offset: 0);
    });

    test('single string falls back to string parser', () {
      final p1 = Parsers.stringIn(ilist(['only']));
      expectSuccess(p1, 'only!', 'only', remaining: '!');
    });

    test('empty list always fails', () {
      final pEmpty = Parsers.stringIn(IList.empty<String>());
      expectFailure(pEmpty, 'anything');
    });

    test('stringIn0 allows empty string alternative', () {
      final p0 = Parsers.stringIn0(ilist(['foo', 'bar', 'baz', '']));
      expectSuccess(p0, 'nope', '', remaining: 'nope');
    });
  });

  group('length', () {
    test('reads exactly n characters', () {
      expectSuccess(Parsers.length(3), 'abcde', 'abc', remaining: 'de');
      expectSuccess(Parsers.length(1), 'x', 'x');
    });

    test('fails when not enough characters remain', () {
      expectFailure(Parsers.length(5), 'abc', offset: 0);
    });

    test('length0(0) returns emptyStringParser0', () {
      final p = Parsers.length0(0);
      expectSuccess(p, 'hello', '', remaining: 'hello');
    });

    test('length0(n) behaves like length(n) for n > 0', () {
      expectSuccess(Parsers.length0(2), 'hello', 'he', remaining: 'llo');
    });
  });

  group('pure / unit / fail / failWith', () {
    test('pure always succeeds without consuming input', () {
      expectSuccess(Parsers.pure(42), 'abc', 42, remaining: 'abc');
      expectSuccess(Parsers.pure('hello'), '', 'hello');
    });

    test('unit succeeds with Unit without consuming input', () {
      expectSuccess(Parsers.unit, 'xyz', Unit(), remaining: 'xyz');
    });

    test('fail always fails', () {
      expectFailure(Parsers.fail<String>(), 'abc', offset: 0);
      expectFailure(Parsers.fail<int>(), '', offset: 0);
    });

    test('failWith carries a message', () {
      final result = Parsers.failWith<String>('custom message').parse('abc');
      result.fold(
        (err) {
          expect(err.offset, equals(0));
          expect(err.expected.head.toString(), contains('custom message'));
        },
        (_) => fail('Expected failure'),
      );
    });
  });

  group('map', () {
    test('transforms the parsed value', () {
      final p = Parsers.anyChar.map((c) => c.toUpperCase());
      expectSuccess(p, 'hello', 'H', remaining: 'ello');
    });

    test('map on Parser0', () {
      final p = Parsers.pure(3).map((n) => n * 2);
      expectSuccess(p, '', 6);
    });

    test('map over fail propagates failure', () {
      final p = Parsers.fail<String>().map((s) => s.length);
      expectFailure(p, 'abc');
    });
  });

  group('as', () {
    test('replaces parsed value with a constant', () {
      expectSuccess(Parsers.string('hello').as(42), 'hello!', 42, remaining: '!');
    });

    test('as Unit produces voided parser', () {
      expectSuccess(Parsers.anyChar.as(Unit()), 'x', Unit());
    });
  });

  group('product / productL / productR', () {
    final a = Parsers.charIn(ilist(['a']));
    final b = Parsers.charIn(ilist(['b']));

    test('product pairs both results', () {
      expectSuccess(a.product(b), 'ab', ('a', 'b'));
    });

    test('product fails when first fails', () {
      expectFailure(a.product(b), 'xb', offset: 0);
    });

    test('product fails when second fails', () {
      expectFailure(a.product(b), 'ax', offset: 1);
    });

    test('productL keeps left value', () {
      expectSuccess(a.productL(b), 'ab', 'a');
    });

    test('productR keeps right value', () {
      expectSuccess(a.productR(b), 'ab', 'b');
    });
  });

  group('flatMap', () {
    test('Parser.flatMap uses first result to choose second parser', () {
      final p = Parsers.charIn(ilist(['a', 'b'])).flatMap((c) {
        return c == 'a' ? Parsers.string('1') : Parsers.string('2');
      });

      expectSuccess(p, 'a1', Unit());
      expectSuccess(p, 'b2', Unit());
      expectFailure(p, 'a2', offset: 1);
    });

    test('Parser0.flatMap0 works for non-consuming first', () {
      final p = Parsers.pure('x').flatMap((s) => Parsers.string(s));
      expectSuccess(p, 'x!', Unit(), remaining: '!');
    });
  });

  group('orElse / oneOf', () {
    final a = Parsers.string('foo');
    final b = Parsers.string('bar');

    test('operator | tries alternatives in order', () {
      expectSuccess(a | b, 'fooX', Unit(), remaining: 'X');
      expectSuccess(a | b, 'barX', Unit(), remaining: 'X');
    });

    test('fails when no alternative matches', () {
      expectFailure(a | b, 'baz', offset: 0);
    });

    test('oneOf picks the first match', () {
      final p = Parsers.oneOf(
        ilist([
          Parsers.string('foo'),
          Parsers.string('foobar'),
        ]),
      );
      expectSuccess(p, 'foobar', Unit(), remaining: 'bar');
    });

    test('oneOf0 with Parser0 alternatives', () {
      final p = Parsers.oneOf0(
        ilist([
          Parsers.pure<String>('default'),
          Parsers.anyChar.map((c) => 'char:$c'),
        ]),
      );
      // pure always succeeds, so the first alternative wins
      expectSuccess(p, 'hello', 'default', remaining: 'hello');
    });
  });

  group('opt', () {
    final p = Parsers.string('hello').as('hello').opt;

    test('returns Some when parser succeeds', () {
      expectSuccess(p, 'hello!', const Some('hello'), remaining: '!');
    });

    test('returns None when parser fails (no input consumed)', () {
      expectSuccess(p, 'world', none<String>(), remaining: 'world');
    });
  });

  group('rep / rep0', () {
    final digit = Parsers.charIn(ilist(['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']));

    test('rep0 matches zero or more', () {
      expectSuccess(digit.rep0(), '123abc', ilist(['1', '2', '3']), remaining: 'abc');
      expectSuccess(digit.rep0(), 'abc', ilist([]), remaining: 'abc');
    });

    test('rep matches one or more', () {
      expectSuccess(digit.rep(), '42!', nel('4', ['2']), remaining: '!');
      expectFailure(digit.rep(), 'abc', offset: 0);
    });

    test('rep with min constraint', () {
      expectSuccess(digit.rep(min: 2), '123', nel('1', ['2', '3']));
      // rep consumes '1' and '2' before determining min=3 is not met,
      // so the failure is reported at offset 2 (where the 3rd digit was expected).
      expectFailure(digit.rep(min: 3), '12', offset: 2);
    });

    test('rep with max constraint', () {
      expectSuccess(digit.rep(max: 2), '12345', nel('1', ['2']), remaining: '345');
    });

    test('rep0 with max constraint', () {
      expectSuccess(digit.rep0(max: 3), '12345', ilist(['1', '2', '3']), remaining: '45');
    });
  });

  group('repSep / repSep0', () {
    final letters = IList.tabulate(26, (i) => String.fromCharCode('a'.codeUnitAt(0) + i));
    final word = Parsers.charIn(letters).rep().map((nel) => nel.toIList().mkString());
    final comma = Parsers.string(',');

    test('repSep matches one or more separated values', () {
      expectSuccess(
        word.repSep(comma),
        'foo,bar,baz',
        nel('foo', ['bar', 'baz']),
      );
    });

    test('repSep fails when nothing matches', () {
      expectFailure(word.repSep(comma), ',foo', offset: 0);
    });

    test('repSep0 matches zero or more separated values', () {
      expectSuccess(word.repSep0(comma), 'a,b,c!', ilist(['a', 'b', 'c']), remaining: '!');
      expectSuccess(word.repSep0(comma), '!', ilist([]), remaining: '!');
    });
  });

  group('repUntil / repUntil0', () {
    final anyC = Parsers.anyChar;
    final end = Parsers.string('END');

    test('repUntil0 collects chars until terminator', () {
      expectSuccess(
        anyC.repUntil0(end),
        'abcEND',
        ilist(['a', 'b', 'c']),
        remaining: 'END',
      );
      expectSuccess(anyC.repUntil0(end), 'END', ilist([]), remaining: 'END');
    });

    test('repUntil requires at least one element before terminator', () {
      expectSuccess(anyC.repUntil(end), 'xEND', nel('x', []), remaining: 'END');
      expectFailure(anyC.repUntil(end), 'END', offset: 0);
    });
  });

  group('backtrack', () {
    test('backtrack resets offset on failure so alternatives can retry', () {
      // Parsers.string('foox') never matches 'foobar', so backtrack resets to 0.
      final failing = Parsers.string('foox').as('long');
      final shortStr = Parsers.string('foo').as('short');
      final p = failing.backtrack | shortStr;

      expectSuccess(p, 'foobar', 'short', remaining: 'bar');
    });

    test('without backtrack, partial match prevents alternative', () {
      // A product that partially consumes input ('a') then fails ('b' != 'x')
      // prevents the alternative from being tried.
      final partial = Parsers.anyChar.product(Parsers.string('x')).as('ab');
      final alt = Parsers.anyChar.as('any');

      expectFailure(partial | alt, 'ab');

      // With backtrack, offset resets so alt succeeds.
      final p = partial.backtrack | alt;
      expectSuccess(p, 'ab', 'any', remaining: 'b');
    });
  });

  group('soft product', () {
    // Soft product: if the second parser fails WITHOUT consuming, rewind to
    // before the first parser ran.
    test('soft productR backtracks when second fails without consuming', () {
      final a = Parsers.string('ab');
      final b = Parsers.string('XY').as('match');

      // a.soft.productR(b): parse 'ab', then try 'XY'; 'XY' fails immediately
      // (no consumption), so offset rewinds to before 'ab' was consumed.
      final p = a.soft.productR(b) | Parsers.string('ab').as('fallback');
      expectSuccess(p, 'abCD', 'fallback', remaining: 'CD');
    });

    test('soft does NOT rewind when second partially consumes', () {
      // If the second parser consumed some input before failing, soft does NOT
      // rewind — only full failure at offset 0 of second triggers rewind.
      final a = Parsers.string('ab');
      final b = Parsers.anyChar.product(Parsers.string('Z')).as('match');

      // b consumes 'C' (anyChar), then fails on 'D' != 'Z'. Since b consumed
      // input, soft does not rewind — the whole parse fails.
      final p = a.soft.productR(b) | Parsers.string('ab').as('fallback');
      expectFailure(p, 'abCD', offset: 3);
    });
  });

  group('peek', () {
    final p = Parsers.anyChar.peek;

    test('succeeds without consuming input', () {
      expectSuccess(p, 'abc', Unit(), remaining: 'abc');
    });

    test('fails when underlying parser fails', () {
      expectFailure(p, '', offset: 0);
    });
  });

  group('not', () {
    final notDigit = Parsers.charIn(ilist(['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'])).not;

    test('succeeds without consuming when parser would fail', () {
      expectSuccess(notDigit, 'abc', Unit(), remaining: 'abc');
    });

    test('fails without consuming when parser would succeed', () {
      expectFailure(notDigit, '5abc', offset: 0);
    });
  });

  group('between / surroundedBy', () {
    final open = Parsers.string('(');
    final close = Parsers.string(')');
    final letters = IList.tabulate(26, (i) => String.fromCharCode('a'.codeUnitAt(0) + i));

    final content = Parsers.charIn(letters).rep0().string;

    test('between parses content between two delimiters', () {
      expectSuccess(content.between(open, close), '(hello)', 'hello');
    });

    test('between fails when opening delimiter is missing', () {
      expectFailure(content.between(open, close), 'hello)', offset: 0);
    });

    test('surroundedBy uses same parser for both sides', () {
      final quote = Parsers.string('"');
      final letters2 = IList.tabulate(
        26,
        (i) => String.fromCharCode('a'.codeUnitAt(0) + i),
      ).concat(IList.tabulate(26, (i) => String.fromCharCode('A'.codeUnitAt(0) + i)));

      final inner = Parsers.charIn(letters2).rep().string;

      expectSuccess(inner.surroundedBy(quote), '"Hello"', 'Hello');
    });
  });

  group('withString / .string property', () {
    test('withString captures the matched substring alongside the value', () {
      final p = Parsers.anyChar.rep().withString;
      expectSuccess(p, 'abc', (nel('a', ['b', 'c']), 'abc'));
    });

    test('.string property returns the matched substring', () {
      // Use charIn (letters only) so rep stops before '!'.
      final letters = IList.tabulate(26, (i) => String.fromCharCode('a'.codeUnitAt(0) + i));
      final p = Parsers.charIn(letters).rep().string;
      expectSuccess(p, 'abc!', 'abc', remaining: '!');
    });

    test('.string on a Str parser captures the matched text', () {
      final p = Parsers.string('hello').string;
      expectSuccess(p, 'hello world', 'hello', remaining: ' world');
    });
  });

  group('filter / mapFilter', () {
    bool isDigit(String c) =>
        c.codeUnitAt(0) >= '0'.codeUnitAt(0) && c.codeUnitAt(0) <= '9'.codeUnitAt(0);
    final digit = Parsers.anyChar.filter(isDigit);

    test('filter keeps values satisfying predicate', () {
      expectSuccess(digit, '5abc', '5', remaining: 'abc');
    });

    test('filter rejects values that fail predicate', () {
      // anyChar commits after consuming 'a', so filter failing is at offset 1.
      expectFailure(digit, 'abc', offset: 1);
    });

    test('mapFilter converts and filters in one step', () {
      final p = Parsers.anyChar.mapFilter<int>((c) {
        final n = int.tryParse(c);
        return n != null ? Some(n) : none<int>();
      });

      expectSuccess(p, '7rest', 7, remaining: 'rest');
      // anyChar commits after consuming 'a', so mapFilter failing is at offset 1.
      expectFailure(p, 'abc', offset: 1);
    });
  });

  group('eitherOr', () {
    final digit = Parsers.charIn(ilist(['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']));
    final letters = IList.tabulate(26, (i) => String.fromCharCode('a'.codeUnitAt(0) + i));
    final letter = Parsers.charIn(letters);

    test('returns Right when first parser succeeds', () {
      expectSuccess(digit.eitherOr(letter), '5', const Right<String, String>('5'));
    });

    test('returns Left when first fails but second succeeds', () {
      expectSuccess(digit.eitherOr(letter), 'a', const Left<String, String>('a'));
    });

    test('fails when both fail', () {
      expectFailure(digit.eitherOr(letter), '!', offset: 0);
    });
  });

  group('defer / defer0', () {
    test('defer allows recursive parsers', () {
      // A right-recursive parser: one or more 'a' characters.
      Parser<NonEmptyIList<String>> makeParser() {
        late Parser<NonEmptyIList<String>> p;
        return p = Parsers.defer(
          () => Parsers.charIn(ilist(['a'])).flatMap((c) {
            return p.opt.map(
              (rest) => NonEmptyIList(c, rest.fold(() => nil(), (n) => n.toIList())),
            );
          }),
        );
      }

      final p = makeParser();
      expectSuccess(p, 'aaa!', nel('a', ['a', 'a']), remaining: '!');
      expectSuccess(p, 'a!', nel('a', []), remaining: '!');
      expectFailure(p, 'b', offset: 0);
    });

    test('defer0 wraps a Parser0 lazily', () {
      late Parser0<IList<String>> p;
      p = Parsers.defer0(() {
        return Parsers.charIn(ilist(['x']))
            .flatMap((c) => p.map((rest) => ilist([c]).appendedAll(rest)))
            .opt
            .map((opt) => opt.fold(() => ilist([]), (list) => list));
      });

      expectSuccess(p, 'xxxa', ilist(['x', 'x', 'x']), remaining: 'a');
      expectSuccess(p, 'abc', ilist([]), remaining: 'abc');
    });
  });

  group('withContext', () {
    test('wraps errors with context string', () {
      final p = Parsers.string('hello').withContext('greeting');
      final result = p.parse('world');
      result.fold(
        (err) {
          expect(err.expected.head, isA<WithContext>());
          final wc = err.expected.head as WithContext;
          expect(wc.context, equals('greeting'));
        },
        (_) => fail('Expected failure'),
      );
    });
  });

  group('Index / StartParser / EndParser / GetCaret', () {
    test('Index returns the current offset without consuming', () {
      expectSuccess(Index(), 'abc', 0, remaining: 'abc');

      // After consuming two chars, Index should report offset 2.
      final p2 = Parsers.anyChar.product(Parsers.anyChar).productR(Index());
      expectSuccess(p2, 'abc', 2, remaining: 'c');
    });

    test('StartParser succeeds at start, fails elsewhere', () {
      expectSuccess(StartParser(), 'abc', Unit(), remaining: 'abc');

      // After consuming one char we are no longer at the start.
      final p = Parsers.anyChar.productR(StartParser());
      expectFailure(p, 'a', offset: 1);
    });

    test('EndParser succeeds at end, fails in the middle', () {
      expectSuccess(EndParser(), '', Unit());
      expectFailure(EndParser(), 'a', offset: 0);

      // Consume all input, then check end.
      final p = Parsers.anyChar.product(EndParser());
      expectSuccess(p, 'x', ('x', Unit()));
      expectFailure(p, 'xy', offset: 1);
    });

    test('GetCaret returns line/col/offset', () {
      // Caret has no == override; verify fields directly.
      GetCaret().parse('hello').fold(
        (err) => fail('Expected success: $err'),
        (pair) {
          expect(pair.$1, equals('hello'), reason: 'should not consume');
          expect(pair.$2.line, equals(0));
          expect(pair.$2.col, equals(0));
          expect(pair.$2.offset, equals(0));
        },
      );

      // After consuming 'line\n' (5 chars), caret should be on line 1, col 0.
      final p2 = Parsers.length(5).productR(GetCaret());
      final result = p2.parse('line\nworld');
      result.fold(
        (err) => fail('Expected success: $err'),
        (pair) {
          final caret = pair.$2;
          expect(caret.line, equals(1));
          expect(caret.col, equals(0));
          expect(caret.offset, equals(5));
        },
      );
    });
  });

  group('parseAll vs parse', () {
    final p = Parsers.anyChar;

    test('parse returns remaining input', () {
      expectSuccess(p, 'abc', 'a', remaining: 'bc');
    });

    test('parseAll succeeds only when all input is consumed', () {
      expectSuccessAll(p, 'a', 'a');
      expectFailureAll(p, 'ab');
    });

    test('parseAll error carries end-of-string expectation', () {
      final result = p.parseAll('ab');
      result.fold(
        (err) {
          expect(err.offset, equals(1));
          expect(err.expected.head, isA<EndOfString>());
        },
        (_) => fail('Expected failure'),
      );
    });
  });

  group('voided', () {
    test('voided discards the parsed value, returns Unit', () {
      final p = Parsers.anyChar.voided;
      expectSuccess(p, 'abc', Unit(), remaining: 'bc');
    });

    test('voided0 works on Parser0', () {
      expectSuccess(Parsers.pure(42).voided, '', Unit());
    });
  });

  group('char', () {
    test('matches the exact character', () {
      expectSuccess(Parsers.char('a'), 'abc', Unit(), remaining: 'bc');
      expectSuccess(Parsers.char('Z'), 'Z', Unit());
      expectSuccess(Parsers.char('!'), '!rest', Unit(), remaining: 'rest');
    });

    test('fails on a different character', () {
      expectFailure(Parsers.char('a'), 'b', offset: 0);
    });

    test('fails on empty input', () {
      expectFailure(Parsers.char('x'), '', offset: 0);
    });

    test('is case-sensitive', () {
      expectFailure(Parsers.char('a'), 'A', offset: 0);
      expectFailure(Parsers.char('A'), 'a', offset: 0);
    });

    test('works for non-ASCII characters outside the cache range', () {
      // Chars below codeUnit 32 are outside the pre-built cache.
      expectSuccess(Parsers.char('\t'), '\t next', Unit(), remaining: ' next');
      expectFailure(Parsers.char('\t'), 'x', offset: 0);
    });
  });

  group('charInRange', () {
    final p = Parsers.charInRange('a', 'z');

    test('matches characters inside the range', () {
      expectSuccess(p, 'a!', 'a', remaining: '!');
      expectSuccess(p, 'm!', 'm', remaining: '!');
      expectSuccess(p, 'z!', 'z', remaining: '!');
    });

    test('fails on characters outside the range', () {
      expectFailure(p, 'A', offset: 0);
      expectFailure(p, '0', offset: 0);
      expectFailure(p, '{', offset: 0);
    });

    test('fails on empty input', () {
      expectFailure(p, '', offset: 0);
    });

    test('single-element range (start == end) matches only that character', () {
      final single = Parsers.charInRange('x', 'x');
      expectSuccess(single, 'xyz', 'x', remaining: 'yz');
      expectFailure(single, 'y', offset: 0);
    });

    test('digit range', () {
      final digits = Parsers.charInRange('0', '9');
      expectSuccess(digits, '5abc', '5', remaining: 'abc');
      expectFailure(digits, 'a', offset: 0);
    });
  });

  group('charInString', () {
    final p = Parsers.charInString('aeiou');

    test('matches a character present in the string', () {
      expectSuccess(p, 'apple', 'a', remaining: 'pple');
      expectSuccess(p, 'eel', 'e', remaining: 'el');
    });

    test('fails on a character not present in the string', () {
      expectFailure(p, 'sky', offset: 0);
    });

    test('fails on empty input', () {
      expectFailure(p, '', offset: 0);
    });

    test('single-char string matches only that character', () {
      final q = Parsers.charInString('x');
      expectSuccess(q, 'xyz', 'x', remaining: 'yz');
      expectFailure(q, 'yz', offset: 0);
    });
  });

  group('ignoreCaseChar', () {
    final p = Parsers.ignoreCaseChar('a');

    test('matches lowercase', () {
      expectSuccess(p, 'abc', 'a', remaining: 'bc');
    });

    test('matches uppercase', () {
      expectSuccess(p, 'Abc', 'A', remaining: 'bc');
    });

    test('fails on a different character', () {
      expectFailure(p, 'b', offset: 0);
      expectFailure(p, '', offset: 0);
    });

    test('works when constructed from uppercase input', () {
      final q = Parsers.ignoreCaseChar('Z');
      expectSuccess(q, 'z!', 'z', remaining: '!');
      expectSuccess(q, 'Z!', 'Z', remaining: '!');
      expectFailure(q, 'a', offset: 0);
    });
  });

  group('ignoreCaseCharInRange', () {
    final p = Parsers.ignoreCaseCharInRange('a', 'z');

    test('matches lowercase characters in range', () {
      expectSuccess(p, 'abc', 'a', remaining: 'bc');
      expectSuccess(p, 'z!', 'z', remaining: '!');
    });

    test('matches uppercase characters in range', () {
      expectSuccess(p, 'A!', 'A', remaining: '!');
      expectSuccess(p, 'Z!', 'Z', remaining: '!');
      expectSuccess(p, 'M!', 'M', remaining: '!');
    });

    test('fails on characters outside both case ranges', () {
      expectFailure(p, '0', offset: 0);
      expectFailure(p, '!', offset: 0);
      expectFailure(p, '', offset: 0);
    });

    test('case-insensitive range from uppercase bounds', () {
      final q = Parsers.ignoreCaseCharInRange('A', 'Z');
      expectSuccess(q, 'a!', 'a', remaining: '!');
      expectSuccess(q, 'A!', 'A', remaining: '!');
      expectFailure(q, '0', offset: 0);
    });

    test('digit range has no case distinction — behaves like charInRange', () {
      final q = Parsers.ignoreCaseCharInRange('0', '9');
      expectSuccess(q, '5abc', '5', remaining: 'abc');
      expectFailure(q, 'a', offset: 0);
    });
  });

  group('complex compositions', () {
    test('JSON-like number parser', () {
      final digit = Parsers.charIn(ilist(['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']));
      final digits = digit.rep().string;
      final minus = Parsers.string('-').string.opt.map((o) => o.fold(() => '', (s) => s));
      final number = minus.with1.product(digits).map((t) => '${t.$1}${t.$2}');

      expectSuccess(number, '123 ', '123', remaining: ' ');
      expectSuccess(number, '-42!', '-42', remaining: '!');
      expectFailure(number, 'abc', offset: 0);
    });

    test('comma-separated integers', () {
      final digit = Parsers.charIn(ilist(['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']));
      final integer = digit.rep().string.map(int.parse);
      final comma = Parsers.string(',').voided;
      final csv = integer.repSep(comma);

      expectSuccess(csv, '1,22,333', nel(1, [22, 333]));
    });

    test('nested brackets', () {
      final open = Parsers.string('[');
      final close = Parsers.string(']');
      final letters = IList.tabulate(26, (i) => String.fromCharCode('a'.codeUnitAt(0) + i));
      final inner = Parsers.charIn(letters).rep0().string;
      final p = inner.between(open, close);

      expectSuccess(p, '[hello]!', 'hello', remaining: '!');
      expectSuccess(p, '[]!', '', remaining: '!');
    });

    test('alternation with overlapping prefixes uses backtrack', () {
      final p1 = Parsers.string('ab').product(Parsers.string('cd')).as('abcd');
      final p2 = Parsers.string('ab').product(Parsers.string('ef')).as('abef');
      final p = p1.backtrack | p2;

      expectSuccess(p, 'abcd', 'abcd');
      expectSuccess(p, 'abef', 'abef');
      expectFailure(p, 'abxy', offset: 2);
    });
  });

  group('ignoreCaseCharIn', () {
    final p = Parsers.ignoreCaseCharIn(ilist(['a', 'b', 'c']));

    test('matches lowercase chars in the set', () {
      expectSuccess(p, 'apple', 'a', remaining: 'pple');
      expectSuccess(p, 'banana', 'b', remaining: 'anana');
      expectSuccess(p, 'cat', 'c', remaining: 'at');
    });

    test('matches uppercase chars in the set', () {
      expectSuccess(p, 'Apple', 'A', remaining: 'pple');
      expectSuccess(p, 'Banana', 'B', remaining: 'anana');
      expectSuccess(p, 'Cat', 'C', remaining: 'at');
    });

    test('fails on a character not in the set (any case)', () {
      expectFailure(p, 'dog', offset: 0);
      expectFailure(p, 'DOG', offset: 0);
      expectFailure(p, '', offset: 0);
    });

    test('single-char set matches that character both cases', () {
      final single = Parsers.ignoreCaseCharIn(ilist(['x']));
      expectSuccess(single, 'xyz', 'x', remaining: 'yz');
      expectSuccess(single, 'Xyz', 'X', remaining: 'yz');
      expectFailure(single, 'abc');
    });

    test('digit chars have no case distinction', () {
      final digits = Parsers.ignoreCaseCharIn(ilist(['1', '2', '3']));
      expectSuccess(digits, '1abc', '1', remaining: 'abc');
      expectFailure(digits, 'abc', offset: 0);
    });
  });

  group('ignoreCaseCharInString', () {
    final p = Parsers.ignoreCaseCharInString('aeiou');

    test('matches a vowel (lowercase)', () {
      expectSuccess(p, 'apple', 'a', remaining: 'pple');
      expectSuccess(p, 'echo', 'e', remaining: 'cho');
    });

    test('matches a vowel (uppercase)', () {
      expectSuccess(p, 'Apple', 'A', remaining: 'pple');
      expectSuccess(p, 'Echo', 'E', remaining: 'cho');
    });

    test('fails on a non-vowel', () {
      expectFailure(p, 'sky', offset: 0);
      expectFailure(p, 'SKY', offset: 0);
      expectFailure(p, '', offset: 0);
    });

    test('single-char string matches that character both cases', () {
      final q = Parsers.ignoreCaseCharInString('z');
      expectSuccess(q, 'zebra', 'z', remaining: 'ebra');
      expectSuccess(q, 'Zebra', 'Z', remaining: 'ebra');
      expectFailure(q, 'abc');
    });

    test('equivalent to ignoreCaseCharIn on the same char list', () {
      final fromList = Parsers.ignoreCaseCharIn(ilist(['x', 'y', 'z']));
      final fromStr = Parsers.ignoreCaseCharInString('xyz');
      expectSuccess(fromList, 'X!', 'X', remaining: '!');
      expectSuccess(fromStr, 'X!', 'X', remaining: '!');
      expectFailure(fromList, 'a');
      expectFailure(fromStr, 'a');
    });
  });

  group('recursive', () {
    test('parses a self-referential structure (nested parens)', () {
      // Grammar: atom = letter | '(' atom ')'
      final letter = Parsers.charInRange('a', 'z').string;
      final p = Parsers.recursive<String>((self) {
        return letter | self.between(Parsers.string('('), Parsers.string(')')).backtrack;
      });

      expectSuccess(p, 'x', 'x');
      expectSuccess(p, '(x)', 'x');
      expectSuccess(p, '((x))', 'x');
      // '()' fails: '(' is consumed, inner self fails, but .backtrack resets to 0
      expectFailure(p, '()', offset: 0);
    });

    test('parses a right-recursive list of digits', () {
      final digit = Parsers.charInRange('0', '9').string;
      // Grammar: digits = digit digits | digit
      final p = Parsers.recursive<IList<String>>((self) {
        return digit.flatMap(
          (d) => self.opt.map(
            (rest) => ilist([d]).appendedAll(rest.fold(() => nil(), (l) => l)),
          ),
        );
      });

      expectSuccess(p, '123!', ilist(['1', '2', '3']), remaining: '!');
      expectSuccess(p, '7', ilist(['7']));
      expectFailure(p, 'abc', offset: 0);
    });
  });

  group('ParseError.toString', () {
    test('single expectation without input shows offset', () {
      final err = ParseError.single(const ExpectationFail(3));
      expect(err.toString(), contains('at offset 3'));
      expect(err.toString(), contains('must fail'));
    });

    test('multiple expectations without input uses plural', () {
      final err = ParseError(
        none(),
        0,
        NonEmptyIList(const ExpectationFail(0), ilist([const ExpectationFail(0)])),
      );
      expect(err.toString(), contains('expectations:'));
    });

    test('with input shows source line and caret', () {
      final result = Parsers.string('hello').parse('world');
      final err = result.fold((e) => e, (_) => fail('Expected failure'));
      final str = err.toString();
      expect(str, contains('world'));
      expect(str, contains('^'));
    });

    test('error partway into a line shows correct caret position', () {
      final result = Parsers.string('abc').productR(Parsers.string('XYZ')).parse('abcDEF');
      final err = result.fold((e) => e, (_) => fail('Expected failure'));
      final str = err.toString();
      expect(str, contains('abcDEF'));
      // offset 3 → 3 spaces before caret
      expect(str, contains('   ^'));
    });

    test('error deep in a multiline input includes ellipsis and context', () {
      // Build 10 lines; fail on line 7 so beforeElipsis fires
      final input = List.generate(10, (i) => 'line$i').join('\n');
      final line7offset = input.indexOf('line7');
      final result = Parsers.length(line7offset).productR(Parsers.string('NOPE')).parse(input);
      final err = result.fold((e) => e, (_) => fail('Expected failure'));
      final str = err.toString();
      expect(str, contains('...'));
      expect(str, contains('line7'));
    });

    test('error near end of multiline input includes after-context lines', () {
      // 6 lines; fail on line 1 so afterContext lines (2,3) are included
      final input = List.generate(6, (i) => 'L$i').join('\n');
      final line1offset = input.indexOf('L1');
      final result = Parsers.length(line1offset).productR(Parsers.string('NOPE')).parse(input);
      final err = result.fold((e) => e, (_) => fail('Expected failure'));
      final str = err.toString();
      expect(str, contains('L1'));
      expect(str, contains('L2'));
    });

    test('parseAll failure path attaches input to error', () {
      final result = Parsers.string('hello').parseAll('world');
      final err = result.fold((e) => e, (_) => fail('Expected failure'));
      expect(err.input, isA<Some<String>>());
      expect(err.toString(), contains('world'));
    });
  });

  group('Expectation.toString', () {
    test('OneOfStr with multiple strings', () {
      final exp = Expectation.oneOfStr(0, ilist(['foo', 'bar']));
      expect(exp.toString(), contains('foo'));
      expect(exp.toString(), contains('bar'));
      expect(exp.toString(), contains('one of the strings'));
    });

    test('OneOfStr with single string', () {
      final exp = Expectation.oneOfStr(0, ilist(['hello']));
      expect(exp.toString(), contains('hello'));
      expect(exp.toString(), isNot(contains('one of the strings')));
    });

    test('InRange with distinct lower and upper', () {
      final exp = Expectation.inRange(0, Char.fromString('a'), Char.fromString('z'));
      expect(exp.toString(), contains('a'));
      expect(exp.toString(), contains('z'));
      expect(exp.toString(), contains('range'));
    });

    test('InRange with equal lower and upper (single char)', () {
      final exp = Expectation.inRange(0, Char.fromString('x'), Char.fromString('x'));
      expect(exp.toString(), contains('x'));
      expect(exp.toString(), isNot(contains('range')));
    });

    test('StartOfString', () {
      final exp = Expectation.startOfString(2);
      expect(exp.toString(), contains('start'));
    });

    test('EndOfString', () {
      final exp = Expectation.endOfString(5, 10);
      expect(exp.toString(), contains('end'));
    });

    test('Length', () {
      final exp = Expectation.length(0, 5, 3);
      expect(exp.toString(), contains('5'));
      expect(exp.toString(), contains('3'));
    });

    test('ExpectedFailureAt', () {
      final exp = Expectation.expectedFailureAt(0, 'abc');
      expect(exp.toString(), contains('abc'));
    });

    test('ExpectationFail', () {
      final exp = Expectation.fail(0);
      expect(exp.toString(), equals('must fail'));
    });

    test('ExpectationFailWith', () {
      final exp = Expectation.failWith(0, 'custom reason');
      expect(exp.toString(), contains('custom reason'));
    });

    test('WithContext', () {
      final inner = Expectation.fail(0);
      final exp = Expectation.withContext('myParser', inner);
      expect(exp.toString(), contains('myParser'));
      expect(exp.toString(), contains('must fail'));
    });

    test('ParseError equality and hashCode', () {
      final e1 = ParseError.single(const ExpectationFail(0));
      final e2 = ParseError.single(const ExpectationFail(0));
      final e3 = ParseError.single(const ExpectationFail(1));
      expect(e1, equals(e2));
      expect(e1.hashCode, equals(e2.hashCode));
      expect(e1, isNot(equals(e3)));
    });
  });

  group('charsWhile / charsWhile0', () {
    test('charsWhile matches one or more characters satisfying predicate', () {
      final digits = Parsers.charsWhile((Char c) => c.codeUnit >= 48 && c.codeUnit <= 57);
      expectSuccess(digits, '123abc', '123', remaining: 'abc');
      expectSuccess(digits, '9', '9');
    });

    test('charsWhile fails when no characters match', () {
      final digits = Parsers.charsWhile((Char c) => c.codeUnit >= 48 && c.codeUnit <= 57);
      expectFailure(digits, 'abc', offset: 0);
      expectFailure(digits, '', offset: 0);
    });

    test('charsWhile0 matches zero or more characters', () {
      final digits = Parsers.charsWhile0((Char c) => c.codeUnit >= 48 && c.codeUnit <= 57);
      expectSuccess(digits, '123abc', '123', remaining: 'abc');
      expectSuccess(digits, 'abc', '', remaining: 'abc');
      expectSuccess(digits, '', '');
    });

    test('charsWhile0 succeeds with empty string on empty input', () {
      final any = Parsers.charsWhile0((Char _) => true);
      expectSuccess(any, '', '');
    });

    test('charsWhile parseAll consumes entire matching input', () {
      final lower = Parsers.charsWhile((Char c) => c.codeUnit >= 97 && c.codeUnit <= 122);
      expectSuccessAll(lower, 'abc', 'abc');
    });
  });

  group('charWhere', () {
    test('matches a character satisfying the predicate', () {
      final vowel = Parsers.charWhere(
        (Char c) => 'aeiou'.contains(String.fromCharCode(c.codeUnit)),
      );
      expectSuccess(vowel, 'apple', 'a', remaining: 'pple');
      expectSuccess(vowel, 'every', 'e', remaining: 'very');
    });

    test('fails when predicate is not satisfied', () {
      final vowel = Parsers.charWhere(
        (Char c) => 'aeiou'.contains(String.fromCharCode(c.codeUnit)),
      );
      expectFailure(vowel, 'sky', offset: 1);
    });
  });

  group('Parsers convenience accessors', () {
    test('Parsers.caret returns current position without consuming', () {
      final result = Parsers.caret.parse('hello');
      result.fold(
        (err) => fail('Expected success: $err'),
        (pair) {
          expect(pair.$1, equals('hello'));
          expect(pair.$2.line, equals(0));
          expect(pair.$2.col, equals(0));
          expect(pair.$2.offset, equals(0));
        },
      );
    });

    test('Parsers.end succeeds at end, fails in middle', () {
      expectSuccess(Parsers.end, '', Unit());
      expectFailure(Parsers.end, 'x', offset: 0);
    });

    test('Parsers.start succeeds at start, fails elsewhere', () {
      expectSuccess(Parsers.start, 'abc', Unit(), remaining: 'abc');
      expectFailure(Parsers.anyChar.productR(Parsers.start), 'ab', offset: 1);
    });

    test('Parsers.index returns current offset without consuming', () {
      expectSuccess(Parsers.index, 'abc', 0, remaining: 'abc');
      final p = Parsers.anyChar.product(Parsers.index);
      expectSuccess(p, 'xy', ('x', 1), remaining: 'y');
    });
  });

  group('eitherOr (committing variant)', () {
    final p = Parsers.anyChar.eitherOr(Parsers.charInRange('a', 'z'));

    test('returns Right when first (committing) parser succeeds', () {
      expectSuccess(p, '5', const Right<String, String>('5'));
    });

    test('returns Left when first fails but second succeeds', () {
      final q = Parsers.charInRange('0', '9').eitherOr(Parsers.charInRange('a', 'z'));
      expectSuccess(q, 'a', const Left<String, String>('a'));
    });
  });

  group('fromCharMap / fromStringMap', () {
    test('fromCharMap looks up single characters', () {
      final map = IMap.fromDart({'a': 1, 'b': 2, 'c': 3});
      final p = Parsers.fromCharMap(map);
      expectSuccess(p, 'apple', 1, remaining: 'pple');
      expectSuccess(p, 'banana', 2, remaining: 'anana');
      expectFailure(p, 'dog', offset: 0);
    });

    test('fromStringMap0 looks up strings (zero-or-more semantics)', () {
      final map = IMap.fromDart({'foo': 1, 'bar': 2, 'baz': 3});
      final p = Parsers.fromStringMap0(map);
      expectSuccess(p, 'fooX', 1, remaining: 'X');
      expectSuccess(p, 'barX', 2, remaining: 'X');
      expectFailure(p, 'qux', offset: 0);
    });

    test('fromStringMap looks up strings (committing)', () {
      final map = IMap.fromDart({'hello': 'hi', 'bye': 'farewell', 'hey': 'greeting'});
      final p = Parsers.fromStringMap(map);
      expectSuccess(p, 'hello world', 'hi', remaining: ' world');
      expectSuccess(p, 'bye!', 'farewell', remaining: '!');
      expectFailure(p, 'nope', offset: 0);
    });
  });

  group('repExactlyAs', () {
    final digit = Parsers.charInRange('0', '9');

    test('repExactlyAs with times=1 maps single item', () {
      final p = digit.repExactlyAs(1, Accumulator.nel());
      expectSuccess(p, '5abc', nel('5'), remaining: 'abc');
    });

    test('repExactlyAs with times=3 collects exactly 3 items', () {
      final p = digit.repExactlyAs(3, Accumulator.nel());
      expectSuccess(p, '123abc', nel('1', ['2', '3']), remaining: 'abc');
      expectFailure(p, '12abc', offset: 2);
    });

    test('repAs with min == max uses repExactlyAs', () {
      final p = digit.repAs(Accumulator.nel(), min: 2, max: 2);
      expectSuccess(p, '42abc', nel('4', ['2']), remaining: 'abc');
      expectFailure(p, '4abc', offset: 1);
    });
  });

  group('repAs0 with max', () {
    final digit = Parsers.charInRange('0', '9');

    test('repAs0 with max=0 always returns empty', () {
      final p = digit.repAs0(Accumulator0.ilist(), max: 0);
      expectSuccess(p, '123', ilist([]), remaining: '123');
    });

    test('repAs0 with max=2 collects at most 2', () {
      final p = digit.repAs0(Accumulator0.ilist(), max: 2);
      expectSuccess(p, '12345', ilist(['1', '2']), remaining: '345');
      expectSuccess(p, 'abc', ilist([]), remaining: 'abc');
    });

    test('rep0 with min constraint delegates to repAs', () {
      final p = digit.rep0(min: 2);
      expectSuccess(p, '123', ilist(['1', '2', '3']));
      expectFailure(p, '1abc', offset: 1);
    });
  });

  group('repSep with bounds', () {
    final digit = Parsers.charInRange('0', '9').string;
    final comma = Parsers.string(',');

    test('repSep with min=1 max=1 returns nel of one element', () {
      final p = digit.repSep(comma, min: 1, max: 1);
      expectSuccess(p, '5,6', nel('5'), remaining: ',6');
      expectFailure(p, ',6', offset: 0);
    });

    test('repSep with max > 1 limits results', () {
      final p = digit.repSep(comma, max: 2);
      expectSuccess(p, '1,2,3', nel('1', ['2']), remaining: ',3');
    });

    test('repSep0 with max=0 always returns empty list', () {
      final p = digit.repSep0(comma, max: 0);
      expectSuccess(p, '1,2', ilist([]), remaining: '1,2');
    });

    test('repSep0 with max>0 limits separated items', () {
      final p = digit.repSep0(comma, max: 2);
      expectSuccess(p, '1,2,3', ilist(['1', '2']), remaining: ',3');
      expectSuccess(p, 'abc', ilist([]), remaining: 'abc');
    });

    test('repSep0 with min>0 requires at least that many items', () {
      final p = digit.repSep0(comma, min: 2);
      expectSuccess(p, '1,2,3', ilist(['1', '2', '3']));
      expectFailure(p, '1', offset: 1);
    });
  });

  group('repUntilAs0 / repUntilAs', () {
    final anyC = Parsers.anyChar;
    final end = Parsers.string('END');

    test('repUntilAs0 accumulates into a custom accumulator', () {
      final p = anyC.repUntilAs0(end, Accumulator0.string());
      expectSuccess(p, 'abcEND', 'abc', remaining: 'END');
      expectSuccess(p, 'END', '', remaining: 'END');
    });

    test('repUntilAs requires at least one element', () {
      final p = anyC.repUntilAs(end, Accumulator0.string());
      expectSuccess(p, 'xEND', 'x', remaining: 'END');
      expectFailure(p, 'END', offset: 0);
    });
  });

  group('select0 (via Parser0.filter and Parser0.mapFilter)', () {
    test('Parser0.filter via pure keeps matching values', () {
      // pure('7') is a Parser0 (not Parser), so uses select0
      final p = Parsers.pure('7').filter((s) => s == '7');
      expectSuccess(p, 'anything', '7', remaining: 'anything');
    });

    test('Parser0.mapFilter via pure transforms and filters', () {
      final p = Parsers.pure('42').mapFilter<int>((s) {
        final n = int.tryParse(s);
        return n != null ? Some(n) : none<int>();
      });
      expectSuccess(p, '', 42);
    });

    test('Parser0.filter via pure rejects non-matching values', () {
      final p = Parsers.pure('hello').filter((s) => s.isEmpty);
      expectFailure(p, 'anything', offset: 0);
    });
  });

  group('flatMap01 (Parser0 flatMap returning Parser)', () {
    test('maps a Parser0 result to a committing Parser', () {
      // A pure parser (Parser0) flatMapped with a function returning Parser
      // exercises flatMap01
      final p = Parsers.pure('a').flatMap((s) => Parsers.string(s));
      expectSuccess(p, 'a!', Unit(), remaining: '!');
      expectFailure(p, 'b', offset: 0);
    });
  });

  group('soft product with Parser0 first operand (softProduct01)', () {
    test('soft.product with Parser<B> second flips to softProduct01', () {
      final p0 = Parsers.pure('x');
      final p1 = Parsers.string('hello');
      // p0.soft wraps as Soft0; calling product(p1) goes through softProduct01
      final p = p0.soft.productR(p1).backtrack | Parsers.string('fallback');
      expectSuccess(p, 'hello!', Unit(), remaining: '!');
      expectSuccess(p, 'fallback', Unit());
    });
  });

  group('backtrack0 with voided parser', () {
    test('backtrack on voided Parser0 wraps Void0 correctly', () {
      // A voided pure parser is already always-succeeds, so backtrack is a no-op.
      // A voided non-trivial Parser0 should become Void0(Backtrack0(...)).
      final p = Parsers.string('ab').as(Unit()).backtrack | Parsers.string('ab').as(Unit());
      // Without backtrack the second alternative is unreachable after partial
      // match; with it the offset resets.
      expectSuccess(p, 'ab', Unit());
    });
  });

  group('oneOf edge cases', () {
    test('oneOf with empty list always fails', () {
      final p = Parsers.oneOf(IList.empty<Parser<String>>());
      expectFailure(p, 'anything', offset: 0);
    });

    test('oneOf with single element is equivalent to that parser', () {
      final p = Parsers.oneOf(ilist([Parsers.string('hello')]));
      expectSuccess(p, 'hello!', Unit(), remaining: '!');
      expectFailure(p, 'world', offset: 0);
    });

    test('oneOf0 with all-committing parsers delegates to _oneOfInternal', () {
      // All parsers are Parser<A>, so allCommitting path is taken
      final p = Parsers.oneOf0(
        ilist([
          Parsers.string('foo') as Parser0<Unit>,
          Parsers.string('bar') as Parser0<Unit>,
        ]),
      );
      expectSuccess(p, 'fooX', Unit(), remaining: 'X');
      expectSuccess(p, 'barX', Unit(), remaining: 'X');
      expectFailure(p, 'baz', offset: 0);
    });

    test('oneOf with voided parsers produces Void(OneOf(...))', () {
      // All parsers are Void, so the Void-lifting optimization fires
      final p = Parsers.oneOf(
        ilist([
          Parsers.string('a').voided,
          Parsers.string('b').voided,
          Parsers.string('c').voided,
        ]),
      );
      expectSuccess(p, 'aX', Unit(), remaining: 'X');
      expectSuccess(p, 'bX', Unit(), remaining: 'X');
      expectFailure(p, 'dX', offset: 0);
    });

    test('oneOf with string parsers produces StringP(OneOf(...))', () {
      // All parsers are StringP, so the StringP-lifting optimization fires
      final p = Parsers.oneOf(
        ilist([
          Parsers.string('alpha').string,
          Parsers.string('beta').string,
        ]),
      );
      expectSuccess(p, 'alpha!', 'alpha', remaining: '!');
      expectSuccess(p, 'beta!', 'beta', remaining: '!');
      expectFailure(p, 'gamma', offset: 0);
    });
  });

  group('Caret ordering', () {
    test('order compares by line first', () {
      const c1 = Caret(0, 5, 5);
      const c2 = Caret(1, 0, 6);
      expect(Caret.order.compare(c1, c2), lessThan(0));
      expect(Caret.order.compare(c2, c1), greaterThan(0));
    });

    test('order compares by col when lines are equal', () {
      const c1 = Caret(2, 3, 10);
      const c2 = Caret(2, 7, 14);
      expect(Caret.order.compare(c1, c2), lessThan(0));
    });

    test('order compares by offset when line and col are equal', () {
      const c1 = Caret(1, 1, 5);
      const c2 = Caret(1, 1, 6);
      expect(Caret.order.compare(c1, c2), lessThan(0));
    });

    test('equal carets compare as zero', () {
      const c = Caret(2, 3, 10);
      expect(Caret.order.compare(c, c), equals(0));
    });
  });

  group('map reassociation', () {
    test('chained maps reassociate correctly', () {
      // p.map(f1).map(f2).map(f3) should produce the same result as
      // applying all three in sequence, regardless of internal structure.
      final p = Parsers.anyChar.map((s) => s.codeUnitAt(0)).map((n) => n + 1).map((n) => n * 2);
      expectSuccess(p, 'A', ('A'.codeUnitAt(0) + 1) * 2);
    });

    test('map0 chaining reassociates correctly', () {
      final p = Parsers.pure(10).map((n) => n + 5).map((n) => n * 3);
      expectSuccess(p, '', 45);
    });
  });
}
