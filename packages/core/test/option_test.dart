import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:test/test.dart';

void main() {
  const testSome = Some(1);
  const testNone = None<int>();

  int incInt(int i) => i + 1;

  group('Option', () {
    test('constructor', () {
      expect(Option(1), isSome(1));
      expect(Option(null), isNone());
    });

    test('unless', () {
      expect(Option.unless(() => true, () => 1), isNone());
      expect(Option.unless(() => false, () => 1), isSome(1));
    });

    test('when', () {
      expect(Option.when(() => true, () => 1), isSome(1));
      expect(Option.when(() => false, () => 1), isNone());
    });

    test('ap', () {
      final noneF = none<Function1<int, int>>();

      expect(testSome.ap(incInt.some), isSome(2));
      expect(testSome.ap(noneF), isNone());
      expect(testNone.ap(incInt.some), isNone());
      expect(testNone.ap(noneF), isNone());
    });

    test('isDefined', () {
      expect(testSome.isDefined, isTrue);
      expect(testNone.isDefined, isFalse);
    });

    test('isEmpty', () {
      expect(testSome.isEmpty, isFalse);
      expect(testNone.isEmpty, isTrue);
    });

    test('filter', () {
      expect(testSome.filter((a) => a > 0), isSome(1));
      expect(testSome.filter((a) => a < 0), isNone());
      expect(testNone.filter((a) => a > 0), isNone());
      expect(testNone.filter((a) => a < 0), isNone());
    });

    test('filterNot', () {
      expect(testSome.filterNot((a) => a > 0), isNone());
      expect(testSome.filterNot((a) => a < 0), isSome(1));
      expect(testNone.filterNot((a) => a > 0), isNone());
      expect(testNone.filterNot((a) => a < 0), isNone());
    });

    test('flatMap', () {
      expect(testSome.flatMap((a) => (a + 1).some), isSome(2));
      expect(testSome.flatMap((_) => testNone), isNone());
      expect(testNone.flatMap((a) => (a + 1).some), isNone());
      expect(testNone.flatMap((_) => testNone), isNone());
    });

    test('foldLeft', () {
      expect(testSome.foldLeft<int>(0, (a, b) => a + b), 1);
      expect(testNone.foldLeft<int>(0, (a, b) => a + b), 0);
    });

    test('foldRight', () {
      expect(testSome.foldRight<int>(0, (a, b) => a + b), 1);
      expect(testNone.foldRight<int>(0, (a, b) => a + b), 0);
    });

    test('getOrElse', () {
      expect(testSome.getOrElse(() => 42), 1);
      expect(testNone.getOrElse(() => 42), 42);
    });

    test('foreach', () {
      var count = 0;

      testNone.foreach((a) => count += a);
      expect(count, 0);

      testSome.foreach((a) => count += a);
      expect(count, 1);
    });

    test('map', () {
      expect(testSome.map((a) => a * 10), isSome(10));
      expect(testNone.map((a) => a * 10), isNone());
    });

    test('nonEmpty', () {
      expect(testSome.nonEmpty, isTrue);
      expect(testNone.nonEmpty, isFalse);
    });

    test('orElse', () {
      expect(testSome.orElse(() => 10.some), isSome(1));
      expect(testNone.orElse(() => testSome), isSome(1));
      expect(testNone.orElse(() => testNone), isNone());
    });

    test('toIList', () {
      expect(testSome.toIList(), IList.fromDart([1]));
      expect(testNone.toIList(), isEmpty);
    });

    test('toLeft', () {
      expect(testSome.toLeft(() => 'right'), isLeft<int, String>(1));
      expect(testNone.toLeft(() => 'right'), isRight<int, String>('right'));
    });

    test('toNullable', () {
      expect(Option(1).toNullable(), isNotNull);
      expect(Option<int>(null).toNullable(), isNull);
    });

    test('toRight', () {
      expect(testSome.toRight(() => 'left'), isRight<String, int>(1));
      expect(testNone.toRight(() => 'left'), isLeft<String, int>('left'));
    });

    test('toString', () {
      expect(Option.pure(1).toString(), 'Some(1)');
      expect(none<int>().toString(), 'None');
    });

    test('traverseIO', () {
      expect(
        const Some(1).traverseIO((a) => IO.pure(a * 2)),
        ioSucceeded(const Some(2)),
      );

      expect(
        none<int>().traverseIO((a) => IO.pure(a * 2)),
        ioSucceeded(none<int>()),
      );
    });

    test('traverseIO_', () async {
      var count = 0;

      await expectLater(
        const Some(1).traverseIO((a) => IO.exec(() => count += 1)),
        ioSucceeded(),
      );
      expect(count, 1);

      await expectLater(
        none<int>().traverseIO_((a) => IO.exec(() => count += 1)),
        ioSucceeded(),
      );
      expect(count, 1);
    });

    test('hashCode', () {
      expect(Option.pure(1).hashCode, Option.pure(1).hashCode);
      expect(none<int>().hashCode, none<int>().hashCode);
    });

    test('map2', () {
      expect((testSome, testSome).mapN((a, b) => a + b), 2.some);
      expect((testSome, testNone).mapN((a, b) => a + b), isNone());
      expect((testNone, testSome).mapN((a, b) => a + b), isNone());
      expect((testNone, testNone).mapN((a, b) => a + b), isNone());
    });

    test('flatten', () {
      expect(2.some.some.flatten(), isSome(2));
      expect(none<int>().some.flatten(), isNone());
    });
  });
}
