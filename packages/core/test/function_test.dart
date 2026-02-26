import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/src/function.dart';
import 'package:ribs_core/src/syntax/tuple.dart';
import 'package:test/test.dart';

void main() {
  group('Functions', () {
    int inc(int a) => a + 1;
    int dub(int a) => a * 2;

    int a1(int a) => a;
    int a2(int a, int b) => a + b;
    int a3(int a, int b, int c) => a + b + c;

    (int, int) n2(int a) => (a, a + 1);
    (int, int, int) n3(int a) => n2(a).appended(a + 2);

    Gen.positiveInt.forAll('identity', (a) {
      expect(identity(a), a);
    });

    test('andThen', () {
      expect(a1.andThen(inc)(1), 2);
      expect(a2.andThen(inc)(1, 2), 4);
      expect(a3.andThen(inc)(1, 2, 3), 7);
    });

    test('compose', () {
      expect(inc.compose(dub)(1), 3);
      expect(dub.compose(inc)(1), 4);

      expect(a2.compose(n2)(1), 3);
      expect(a3.compose(n3)(1), 6);
    });

    test('curried', () {
      expect(a2.curried(1)(2), 3);
      expect(a3.curried(1)(2)(3), 6);
    });

    Gen.positiveInt.tuple2.forAll('uncurried', (tup) {
      expect(a2.curried.uncurried.tupled(tup), a2.tupled(tup));
    });
  });
}
