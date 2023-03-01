import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

void main() {
  test('IList.empty', () {
    expect(IList.empty<int>(), nil<int>());
    expect(IList.empty<int>().size, 0);
  });

  test('IList.fill', () {
    expect(IList.fill(5, 1).toList, [1, 1, 1, 1, 1]);
  });

  test('IList.of', () {
    expect(IList.of([1, 2, 3, 4]), ilist([1, 2, 3, 4]));
  });

  test('IList.pure', () {
    expect(IList.pure(42), ilist([42]));
  });

  test('IList.tabulate', () {
    expect(IList.tabulate(3, (ix) => ix * 2), ilist([0, 2, 4]));
  });

  test('IList.unfold', () {
    final l = IList.unfold(0,
        (int i) => Option.when(() => i < 5, () => Tuple2(i.toString(), i + 1)));

    expect(l, ilist(['0', '1', '2', '3', '4']));
  });

  test('IList.uncons', () {
    // head
    expect(ilist([1, 2, 3]).uncons((head, tail) => head.isDefined), isTrue);
    expect(nil<int>().uncons((head, tail) => head.isEmpty), isTrue);

    // tail
    expect(
        ilist([1, 2, 3]).uncons((head, tail) => tail == ilist([2, 3])), isTrue);
    expect(nil<int>().uncons((head, tail) => tail.isEmpty), isTrue);
  });

  test('IList[]', () {
    final l = ilist([0, 1, 2, 3, 4, 5]);

    expect(l[0], 0);
    expect(l[5], 5);

    expect(() => l[6], throwsException);
  });

  test('IList.ap', () {
    expect(
      ilist([0, 1, 2]).ap(ilist([
        (int x) => '*' * x,
        (int x) => x.toString() * 2,
      ])),
      ilist(['', '00', '*', '11', '**', '22']),
    );
  });

  test('IList.insertAt', () {
    final a = ilist([0, 1, 2, 3, 4, 5]);

    expect(a.insertAt(0, 999), ilist([999, 0, 1, 2, 3, 4, 5]));
    expect(a.insertAt(1, 999), ilist([0, 999, 1, 2, 3, 4, 5]));
    expect(a.insertAt(100, 999), ilist([0, 1, 2, 3, 4, 5, 999]));
  });
}
