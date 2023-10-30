import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:test/test.dart';

void main() {
  forAll('Foldable.count', Gen.ilistOf(100, Gen.positiveInt))((l) {
    expect(l.count((a) => a > 0), 100);
    expect(l.count((a) => a <= 0), 0);
  }).run();

  forAll('Foldable.find',
      Gen.ilistOf(20, Gen.chooseInt(0, 1000).map((x) => x * 2)))((l) {
    expect(l.find((x) => x.isEven).isDefined, isTrue);
  }).run();

  test('Foldable.find (nil)', () {
    expect(nil<int>().find((_) => true), isNone());
  });

  forAll('Foldable.exists',
      Gen.ilistOf(20, Gen.chooseInt(0, 1000).map((x) => x * 2)))((l) {
    expect(l.exists((x) => x.isEven), isTrue);
  }).run();

  test('Foldable.forall', () {
    final a = ilist([1, 2, 3, 4, 5]);

    expect(a.forall((x) => x <= 5), isTrue);
    expect(nil<int>().forall((x) => x <= 5), isTrue);
    expect(a.forall((x) => x < 5), isFalse);
  });

  test('Foldable.isEmpty', () {
    final a = ilist([1, 2, 3, 4, 5]);
    final b = nil<int>();

    expect(a.isEmpty, isFalse);
    expect(a.nonEmpty, isTrue);

    expect(b.isEmpty, isTrue);
    expect(b.nonEmpty, isFalse);
  });
}
