import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/src/syntax/tuple.dart';
import 'package:test/test.dart';

void main() {
  group('Tuple', () {
    test('append', () {
      expect(
        (1, 2)
            .append(3)
            .append(4)
            .append(5)
            .append(6)
            .append(7)
            .append(8)
            .append(9)
            .append(10)
            .append(11)
            .append(12)
            .append(13)
            .append(14)
            .append(15)
            .append(16)
            .append(17)
            .append(18)
            .append(19)
            .append(20)
            .append(21)
            .append(22)
            .last,
        22,
      );
    });

    test('prepend', () {
      expect(
        (2, 1)
            .prepend(3)
            .prepend(4)
            .prepend(5)
            .prepend(6)
            .prepend(7)
            .prepend(8)
            .prepend(9)
            .prepend(10)
            .prepend(11)
            .prepend(12)
            .prepend(13)
            .prepend(14)
            .prepend(15)
            .prepend(16)
            .prepend(17)
            .prepend(18)
            .prepend(19)
            .prepend(20)
            .prepend(21)
            .prepend(22)
            .last,
        1,
      );
    });

    forAll('init', Gen.positiveInt.tuple3, (t) {
      expect(t.init().append(t.last), t);
    });

    forAll('tail', Gen.positiveInt.tuple3, (t) {
      expect(t.tail().prepend(t.$1), t);
    });
  });
}
