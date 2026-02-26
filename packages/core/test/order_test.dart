import 'package:ribs_check/ribs_check.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

void main() {
  test('max', () {
    expect(Order.ints.max(1, 2), 2);
    expect(Order.doubles.max(1.1, 1.2), 1.2);
    expect(Order.strings.max('cat', 'chat'), 'chat');
  });

  test('min', () {
    expect(Order.ints.min(1, 2), 1);
    expect(Order.doubles.min(1.1, 1.2), 1.1);
    expect(Order.strings.min('cat', 'chat'), 'cat');
  });

  test('eqv', () {
    expect(Order.ints.eqv(1, 2), isFalse);
    expect(Order.ints.eqv(1, 1), isTrue);

    expect(Order.doubles.eqv(1.1, 1.2), isFalse);
    expect(Order.doubles.eqv(1.1, 1.1), isTrue);

    expect(Order.strings.eqv('cat', 'chat'), isFalse);
    expect(Order.strings.eqv('cat', 'cat'), isTrue);
  });

  test('neqv', () {
    expect(Order.ints.neqv(1, 2), isTrue);
    expect(Order.ints.neqv(1, 1), isFalse);

    expect(Order.doubles.neqv(1.1, 1.2), isTrue);
    expect(Order.doubles.neqv(1.1, 1.1), isFalse);

    expect(Order.strings.neqv('cat', 'chat'), isTrue);
    expect(Order.strings.neqv('cat', 'cat'), isFalse);
  });

  test('lt', () {
    expect(Order.ints.lt(1, 2), isTrue);
    expect(Order.ints.lt(1, 1), isFalse);

    expect(Order.doubles.lt(1.1, 1.2), isTrue);
    expect(Order.doubles.lt(1.1, 1.1), isFalse);

    expect(Order.strings.lt('cat', 'chat'), isTrue);
    expect(Order.strings.lt('cat', 'cat'), isFalse);
  });

  test('gt', () {
    expect(Order.ints.gt(1, 2), isFalse);
    expect(Order.ints.gt(1, 1), isFalse);

    expect(Order.doubles.gt(1.1, 1.2), isFalse);
    expect(Order.doubles.gt(1.1, 1.1), isFalse);

    expect(Order.strings.gt('cat', 'chat'), isFalse);
    expect(Order.strings.gt('cat', 'cat'), isFalse);
  });

  test('gteqv', () {
    expect(Order.ints.gteqv(1, 2), isFalse);
    expect(Order.ints.gteqv(1, 1), isTrue);

    expect(Order.doubles.gteqv(1.1, 1.2), isFalse);
    expect(Order.doubles.gteqv(1.1, 1.1), isTrue);

    expect(Order.strings.gteqv('cat', 'chat'), isFalse);
    expect(Order.strings.gteqv('cat', 'cat'), isTrue);
  });

  Gen.integer.tuple2.forAll('reverse', (ab) {
    final (a, b) = ab;

    expect(
      Order.ints.reverse().reverse().compare(a, b),
      Order.ints.compare(a, b),
    );
  });
}
