import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:ribs_optics/ribs_optics.dart';
import 'package:test/test.dart';

void main() {
  final first = Optional<IList<int>, int>(
    (a) => a.headOption.toRight(() => a),
    (a) => (s) => s.isEmpty ? s : s.tail().prepended(a),
  );

  final second = Optional<IList<int>, int>(
    (a) => a.lift(1).toRight(() => a),
    (a) => (s) => s.length < 2 ? s : s.updated(1, a),
  );

  final a = IList.fromDart([1, 2, 3]);
  final b = nil<int>();

  group('Optional', () {
    test('replace', () {
      expect(first.replace(42)(a), ilist([42, 2, 3]));
      expect(second.replace(42)(b), nil<int>());
    });

    test('modify', () {
      expect(first.modify((i) => i + 1)(a), ilist([2, 2, 3]));
      expect(second.modify((i) => i + 1)(a), ilist([1, 3, 3]));
    });

    test('getOrModify', () {
      expect(second.getOrModify(a), 2.asRight<IList<int>>());
      expect(second.getOrModify(b), nil<int>().asLeft<int>());
    });

    test('modifyOption', () {
      expect(first.modifyOption((i) => i + 1)(a), ilist([2, 2, 3]).some);
      expect(second.modifyOption((i) => i + 1)(b), none<IList<int>>());
    });

    test('replaceOption', () {
      expect(second.replaceOption(10)(a), isSome(ilist([1, 10, 3])));
      expect(second.replaceOption(10)(b), isNone());
    });

    test('andThenO', () {
      final doubleSecond =
          second.andThenO(Optional<int, int>((a) => a.asRight(), (a) => (b) => a * b));

      expect(doubleSecond.modify((x) => x)(a), ilist([1, 4, 3]));
    });
  });
}
