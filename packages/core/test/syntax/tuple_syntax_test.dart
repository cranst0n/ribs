import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/src/syntax/tuple.dart';
import 'package:test/test.dart';

void main() {
  group('Tuple', () {
    test('append', () {
      expect(
        (1, 2)
            .appended(3)
            .appended(4)
            .appended(5)
            .appended(6)
            .appended(7)
            .appended(8)
            .appended(9)
            .appended(10)
            .appended(11)
            .appended(12)
            .appended(13)
            .appended(14)
            .appended(15)
            .appended(16)
            .appended(17)
            .appended(18)
            .appended(19)
            .appended(20)
            .appended(21)
            .appended(22)
            .last,
        22,
      );
    });

    test('prepend', () {
      expect(
        (2, 1)
            .prepended(3)
            .prepended(4)
            .prepended(5)
            .prepended(6)
            .prepended(7)
            .prepended(8)
            .prepended(9)
            .prepended(10)
            .prepended(11)
            .prepended(12)
            .prepended(13)
            .prepended(14)
            .prepended(15)
            .prepended(16)
            .prepended(17)
            .prepended(18)
            .prepended(19)
            .prepended(20)
            .prepended(21)
            .prepended(22)
            .last,
        1,
      );
    });

    Gen.positiveInt.tuple3.forAll('init', (t) {
      expect(t.init.appended(t.last), t);
    });

    Gen.positiveInt.tuple3.forAll('tail', (t) {
      expect(t.tail.prepended(t.$1), t);
    });
  });
}
