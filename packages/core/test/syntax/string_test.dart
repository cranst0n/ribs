import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test.dart';
import 'package:test/test.dart';

void main() {
  group('StringOps', () {
    group('drop', () {
      test('drops n characters from the front', () {
        expect('hello'.drop(2), 'llo');
      });

      test('drops all when n >= length', () {
        expect('hello'.drop(5), '');
        expect('hello'.drop(10), '');
      });

      test('returns whole string when n == 0', () {
        expect('hello'.drop(0), 'hello');
      });

      test('empty string stays empty', () {
        expect(''.drop(3), '');
      });
    });

    group('dropRight', () {
      test('drops n characters from the end', () {
        expect('hello'.dropRight(2), 'hel');
      });

      test('drops all when n >= length', () {
        expect('hello'.dropRight(5), '');
        expect('hello'.dropRight(10), '');
      });

      test('returns whole string when n == 0', () {
        expect('hello'.dropRight(0), 'hello');
      });

      test('empty string stays empty', () {
        expect(''.dropRight(3), '');
      });
    });

    // -------------------------------------------------------------------------
    // dropWhile
    // -------------------------------------------------------------------------
    group('dropWhile', () {
      test('drops leading characters matching predicate', () {
        expect('   hello'.dropWhile((c) => c == ' '), 'hello');
      });

      test('returns empty string when all match', () {
        expect('aaa'.dropWhile((c) => c == 'a'), '');
      });

      test('returns whole string when none match', () {
        expect('hello'.dropWhile((c) => c == 'z'), 'hello');
      });

      test('empty string stays empty', () {
        expect(''.dropWhile((c) => c == 'a'), '');
      });
    });

    group('exists', () {
      test('returns true when predicate satisfied', () {
        expect('hello'.exists((c) => c == 'e'), isTrue);
      });

      test('returns false when predicate never satisfied', () {
        expect('hello'.exists((c) => c == 'z'), isFalse);
      });

      test('empty string returns false', () {
        expect(''.exists((c) => c == 'a'), isFalse);
      });
    });

    group('filter', () {
      test('keeps only matching characters', () {
        expect('hello world'.filter((c) => c != ' '), 'helloworld');
      });

      test('returns same string when all match', () {
        const s = 'hello';
        expect(s.filter((c) => c.isNotEmpty), same(s));
      });

      test('returns empty string when none match', () {
        expect('hello'.filter((c) => c == 'z'), '');
      });

      test('empty string stays empty', () {
        expect(''.filter((c) => c == 'a'), '');
      });
    });

    group('filterNot', () {
      test('removes matching characters', () {
        expect('hello world'.filterNot((c) => c == ' '), 'helloworld');
      });

      test('returns empty string when all match', () {
        expect('aaa'.filterNot((c) => c == 'a'), '');
      });
    });

    group('find', () {
      test('returns Some with first matching character', () {
        expect('hello'.find((c) => c == 'l'), isSome('l'));
      });

      test('returns None when no match', () {
        expect('hello'.find((c) => c == 'z'), isNone());
      });

      test('empty string returns None', () {
        expect(''.find((c) => c == 'a'), isNone());
      });
    });

    group('foreach', () {
      test('visits every character in order', () {
        final chars = <String>[];
        'abc'.foreach(chars.add);
        expect(chars, ['a', 'b', 'c']);
      });

      test('visits no characters for empty string', () {
        final chars = <String>[];
        ''.foreach(chars.add);
        expect(chars, isEmpty);
      });
    });

    group('forall', () {
      test('returns true when all characters match', () {
        expect('aaa'.forall((c) => c == 'a'), isTrue);
      });

      test('returns false when any character fails', () {
        expect('abc'.forall((c) => c == 'a'), isFalse);
      });

      test('returns true for empty string (vacuous)', () {
        expect(''.forall((c) => c == 'a'), isTrue);
      });
    });

    group('fold / foldLeft', () {
      test('accumulates left to right', () {
        expect('hello'.foldLeft('', (acc, c) => acc + c), 'hello');
      });

      test('fold delegates to foldLeft', () {
        expect('hello'.fold('', (acc, c) => acc + c), 'hello');
      });

      test('empty string returns seed', () {
        expect(''.foldLeft('z', (acc, c) => acc + c), 'z');
      });
    });

    group('foldRight', () {
      test('accumulates right to left', () {
        expect('hello'.foldRight('', (c, acc) => c + acc), 'hello');
      });

      test('reverses string', () {
        expect('abc'.foldRight('', (c, acc) => acc + c), 'cba');
      });

      test('empty string returns seed', () {
        expect(''.foldRight('z', (c, acc) => c + acc), 'z');
      });
    });

    group('grouped', () {
      test('splits into groups of given size', () {
        expect('abcdef'.grouped(2).toIList().toList(), ['ab', 'cd', 'ef']);
      });

      test('last group may be smaller', () {
        expect('abcde'.grouped(2).toIList().toList(), ['ab', 'cd', 'e']);
      });

      test('group size larger than string', () {
        expect('ab'.grouped(5).toIList().toList(), ['ab']);
      });

      test('empty string produces no groups', () {
        expect(''.grouped(2).toIList().toList(), isEmpty);
      });
    });

    group('head', () {
      test('returns first character', () {
        expect('hello'.head, 'h');
      });

      test('throws on empty string', () {
        expect(() => ''.head, throwsRangeError);
      });
    });

    group('headOption', () {
      test('returns Some with first character', () {
        expect('hello'.headOption, isSome('h'));
      });

      test('returns None on empty string', () {
        expect(''.headOption, isNone());
      });
    });

    group('indexWhere', () {
      test('returns index of first match', () {
        expect('hello'.indexWhere((c) => c == 'l'), 2);
      });

      test('returns -1 when no match', () {
        expect('hello'.indexWhere((c) => c == 'z'), -1);
      });

      test('empty string returns -1', () {
        expect(''.indexWhere((c) => c == 'a'), -1);
      });
    });

    group('lastIndexWhere', () {
      test('returns index of last match', () {
        expect('hello'.lastIndexWhere((c) => c == 'l'), 3);
      });

      test('returns -1 when no match', () {
        expect('hello'.lastIndexWhere((c) => c == 'z'), -1);
      });

      test('empty string returns -1', () {
        expect(''.lastIndexWhere((c) => c == 'a'), -1);
      });
    });

    group('init', () {
      test('returns all but last character', () {
        expect('hello'.init, 'hell');
      });

      test('returns empty string for single character', () {
        expect('a'.init, '');
      });

      test('returns empty string for empty string', () {
        expect(''.init, '');
      });
    });

    group('inits', () {
      test('produces all prefixes including empty', () {
        expect(
          'abc'.inits.toIList().toList(),
          ['abc', 'ab', 'a', ''],
        );
      });

      test('empty string produces just empty string', () {
        expect(''.inits.toIList().toList(), ['']);
      });
    });

    group('last', () {
      test('returns last character', () {
        expect('hello'.last, 'o');
      });

      test('throws on empty string', () {
        expect(() => ''.last, throwsRangeError);
      });
    });

    group('lastOption', () {
      test('returns Some with last character', () {
        expect('hello'.lastOption, isSome('o'));
      });

      test('returns None on empty string', () {
        expect(''.lastOption, isNone());
      });
    });

    group('nonEmpty', () {
      test('returns true for non-empty string', () {
        expect('hello'.nonEmpty, isTrue);
      });

      test('returns false for empty string', () {
        expect(''.nonEmpty, isFalse);
      });
    });

    group('partition', () {
      test('splits into matching and non-matching', () {
        expect('hello'.partition((c) => c == 'l'), ('ll', 'heo'));
      });

      test('all match goes into first', () {
        expect('aaa'.partition((c) => c == 'a'), ('aaa', ''));
      });

      test('none match goes into second', () {
        expect('abc'.partition((c) => c == 'z'), ('', 'abc'));
      });

      test('empty string produces two empty strings', () {
        expect(''.partition((c) => c == 'a'), ('', ''));
      });
    });

    group('riterator', () {
      test('iterates over characters in order', () {
        expect('abc'.riterator.toIList().toList(), ['a', 'b', 'c']);
      });

      test('empty string produces empty iterator', () {
        expect(''.riterator.toIList().toList(), isEmpty);
      });
    });

    group('slice', () {
      test('extracts substring', () {
        expect('hello'.slice(1, 4), 'ell');
      });

      test('clamps to valid range', () {
        expect('hello'.slice(-2, 100), 'hello');
      });

      test('returns empty when from >= until', () {
        expect('hello'.slice(3, 2), '');
        expect('hello'.slice(3, 3), '');
      });
    });

    group('sliding', () {
      test('default step of 1', () {
        expect('abcd'.sliding(2).toIList().toList(), ['ab', 'bc', 'cd']);
      });

      test('step > 1', () {
        expect('abcde'.sliding(2, 2).toIList().toList(), ['ab', 'cd', 'e']);
      });

      test('empty string produces no windows', () {
        expect(''.sliding(2).toIList().toList(), isEmpty);
      });
    });

    group('splitAt', () {
      test('splits at index', () {
        expect('hello'.splitAt(2), ('he', 'llo'));
      });

      test('split at 0', () {
        expect('hello'.splitAt(0), ('', 'hello'));
      });

      test('split at length', () {
        expect('hello'.splitAt(5), ('hello', ''));
      });
    });

    group('span', () {
      test('splits at first non-matching character', () {
        expect('aabbc'.span((c) => c == 'a'), ('aa', 'bbc'));
      });

      test('all match: second part is empty', () {
        expect('aaa'.span((c) => c == 'a'), ('aaa', ''));
      });

      test('none match: first part is empty', () {
        expect('bbb'.span((c) => c == 'a'), ('', 'bbb'));
      });

      test('empty string', () {
        expect(''.span((c) => c == 'a'), ('', ''));
      });
    });

    group('stripPrefix', () {
      test('strips matching prefix', () {
        expect('foobar'.stripPrefix('foo'), 'bar');
      });

      test('returns original when prefix does not match', () {
        expect('foobar'.stripPrefix('baz'), 'foobar');
      });

      test('strips entire string when prefix equals string', () {
        expect('foo'.stripPrefix('foo'), '');
      });
    });

    group('stripSuffix', () {
      test('strips matching suffix', () {
        expect('foobar'.stripSuffix('bar'), 'foo');
      });

      test('returns original when suffix does not match', () {
        expect('foobar'.stripSuffix('baz'), 'foobar');
      });

      test('strips entire string when suffix equals string', () {
        expect('foo'.stripSuffix('foo'), '');
      });
    });

    group('tail', () {
      test('returns all but first character', () {
        expect('hello'.tail, 'ello');
      });

      test('returns empty string for single character', () {
        expect('a'.tail, '');
      });

      test('throws on empty string', () {
        expect(() => ''.tail, throwsRangeError);
      });
    });

    group('tails', () {
      test('produces all suffixes including empty', () {
        expect(
          'abc'.tails.toIList().toList(),
          ['abc', 'bc', 'c', ''],
        );
      });

      test('empty string produces just empty string', () {
        expect(''.tails.toIList().toList(), ['']);
      });
    });

    group('take', () {
      test('takes n characters from front', () {
        expect('hello'.take(3), 'hel');
      });

      test('returns whole string when n >= length', () {
        expect('hello'.take(10), 'hello');
      });

      test('returns empty when n == 0', () {
        expect('hello'.take(0), '');
      });

      test('empty string stays empty', () {
        expect(''.take(3), '');
      });
    });

    group('takeRight', () {
      test('takes n characters from end', () {
        expect('hello'.takeRight(3), 'llo');
      });

      test('returns whole string when n >= length', () {
        expect('hello'.takeRight(10), 'hello');
      });

      test('returns empty when n == 0', () {
        expect('hello'.takeRight(0), '');
      });

      test('empty string stays empty', () {
        expect(''.takeRight(3), '');
      });
    });

    group('takeWhile', () {
      test('takes leading characters matching predicate', () {
        expect('aaabbb'.takeWhile((c) => c == 'a'), 'aaa');
      });

      test('returns whole string when all match', () {
        expect('aaa'.takeWhile((c) => c == 'a'), 'aaa');
      });

      test('returns empty when first character does not match', () {
        expect('hello'.takeWhile((c) => c == 'z'), '');
      });

      test('empty string stays empty', () {
        expect(''.takeWhile((c) => c == 'a'), '');
      });
    });
  });
}
