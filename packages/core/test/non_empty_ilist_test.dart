import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/src/test/option.dart';
import 'package:test/test.dart';

void main() {
  test('NonEmptyIList.fromIterable', () {
    expect(NonEmptyIList.fromIterable(<int>[]), none<NonEmptyIList<int>>());
    expect(NonEmptyIList.fromIterable([1]), Some(nel(1)));
    expect(NonEmptyIList.fromIterable([1, 2, 3]), Some(nel(1, [2, 3])));
  });

  test('NonEmptyIList.fromIterableUnsafe', () {
    expect(NonEmptyIList.fromIterableUnsafe([1]), nel(1));
    expect(NonEmptyIList.fromIterableUnsafe([1, 2, 3]), nel(1, [2, 3]));
    expect(() => NonEmptyIList.fromIterableUnsafe(<int>[]), throwsStateError);
  });

  test('NonEmptyIList[]', () {
    expect(nel(1, [2, 3])[0], 1);
    expect(nel(1, [2, 3])[1], 2);
    expect(nel(1, [2, 3])[2], 3);
    expect(() => nel(1, [2, 3])[5], throwsRangeError);
  });

  test('NonEmptyIList.append', () {
    expect(nel(1).append(2), nel(1, [2]));
  });

  test('NonEmptyIList.concat', () {
    expect(nel(1).concat(ilist([])), nel(1));
    expect(nel(1).concat(ilist([2, 3])), nel(1, [2, 3]));
    expect(nel(1, [2, 3]).concat(ilist([2, 3])), nel(1, [2, 3, 2, 3]));
  });

  test('NonEmptyIList.concatNel', () {
    expect(nel(1).concatNel(nel(2, [3])), nel(1, [2, 3]));
    expect(nel(1, [2, 3]).concatNel(nel(4)), nel(1, [2, 3, 4]));
  });

  test('NonEmptyIList.contains', () {
    expect(nel(1).contains(1), isTrue);
    expect(nel(1).contains(2), isFalse);
    expect(nel(1, [2, 3]).contains(2), isTrue);
    expect(nel(1, [2, 3]).contains(4), isFalse);
  });

  test('NonEmptyIList.findLast', () {
    expect(nel(1, [2, 3, 4]).findLast((a) => a > 5), isNone());
    expect(nel(1, [2, 3, 4]).findLast((a) => a.isEven), isSome(4));
    expect(nel(1, [2, 3, 4]).findLast((a) => a.isOdd), isSome(3));
  });

  test('NonEmptyIList.flatMap', () {
    expect(nel(1, [2, 3]).flatMap((n) => nel(n - 1, [n, n + 1])),
        nel(0, [1, 2, 1, 2, 3, 2, 3, 4]));
  });

  test('NonEmptyIList.forAll', () {
    expect(nel(1, [2, 3]).forall((a) => a.isEven), isFalse);
    expect(nel(1, [2, 3]).forall((a) => a < 10), isTrue);
  });

  test('NonEmptyIList.forEach', () {
    var count = 0;

    nel(1, [2, 3]).forEach((a) => count += a);

    expect(count, 6);
  });

  test('NonEmptyIList.groupBy', () {
    final l = nel(1, [2, 3, 4, 5, 6, 7, 8, 9]);

    expect(
      l.groupBy((a) => a % 3),
      imap({
        0: nel(3, [6, 9]),
        1: nel(1, [4, 7]),
        2: nel(2, [5, 8]),
      }),
    );
  });

  test('NonEmptyIList.groupMap', () {
    final l = nel(1, [2, 3, 4, 5, 6, 7, 8, 9]);

    expect(
      l.groupMap((a) => a % 3, (a) => a * 2),
      imap({
        0: nel(6, [12, 18]),
        1: nel(2, [8, 14]),
        2: nel(4, [10, 16]),
      }),
    );
  });

  test('NonEmptyIList.last', () {
    expect(nel(1).last, 1);
    expect(nel(1, [2, 3]).last, 3);
  });

  test('NonEmptyIList.scanLeft', () {
    expect(nel(1).scanLeft(0, (a, b) => a + b), nel(0, [1]));
    expect(nel(1, [2, 3]).scanLeft(0, (a, b) => a + b), nel(0, [1, 3, 6]));
  });

  test('NonEmptyIList.scanRight', () {
    expect(nel(1).scanRight(0, (a, b) => a + b), nel(1, [0]));
    expect(nel(1, [2, 3]).scanRight(0, (a, b) => a + b), nel(6, [5, 3, 0]));
  });
}
