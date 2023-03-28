import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

void main() {
  const testSome = Some(1);
  const testNone = None<int>();

  int incInt(int i) => i + 1;

  test('Option.of', () {
    expect(Option.of(1), testSome);
    expect(Option.of(null), testNone);
  });

  test('Option.unless', () {
    expect(Option.unless(() => true, () => 1), testNone);
    expect(Option.unless(() => false, () => 1), testSome);
  });

  test('Option.when', () {
    expect(Option.when(() => true, () => 1), testSome);
    expect(Option.when(() => false, () => 1), testNone);
  });

  test('Option.ap', () {
    final noneF = none<Function1<int, int>>();

    expect(testSome.ap(incInt.some), 2.some);
    expect(testSome.ap(noneF), testNone);
    expect(testNone.ap(incInt.some), testNone);
    expect(testNone.ap(noneF), testNone);
  });

  test('Option.isDefined', () {
    expect(testSome.isDefined, isTrue);
    expect(testNone.isDefined, isFalse);
  });

  test('Option.isEmpty', () {
    expect(testSome.isEmpty, isFalse);
    expect(testNone.isEmpty, isTrue);
  });

  test('Option.filter', () {
    expect(testSome.filter((a) => a > 0), testSome);
    expect(testSome.filter((a) => a < 0), testNone);
    expect(testNone.filter((a) => a > 0), testNone);
    expect(testNone.filter((a) => a < 0), testNone);
  });

  test('Option.filterNot', () {
    expect(testSome.filterNot((a) => a > 0), testNone);
    expect(testSome.filterNot((a) => a < 0), testSome);
    expect(testNone.filterNot((a) => a > 0), testNone);
    expect(testNone.filterNot((a) => a < 0), testNone);
  });

  test('Option.flatMap', () {
    expect(testSome.flatMap((a) => (a + 1).some), 2.some);
    expect(testSome.flatMap((_) => testNone), testNone);
    expect(testNone.flatMap((a) => (a + 1).some), testNone);
    expect(testNone.flatMap((_) => testNone), testNone);
  });

  test('Option.foldLeft', () {
    expect(testSome.foldLeft<int>(0, (a, b) => a + b), 1);
    expect(testNone.foldLeft<int>(0, (a, b) => a + b), 0);
  });

  test('Option.foldRight', () {
    expect(testSome.foldRight<int>(0, (a, b) => a + b), 1);
    expect(testNone.foldRight<int>(0, (a, b) => a + b), 0);
  });

  test('Option.getOrElse', () {
    expect(testSome.getOrElse(() => 42), 1);
    expect(testNone.getOrElse(() => 42), 42);
  });

  test('Option.forEach', () {
    var count = 0;

    testNone.forEach((a) => count += a);
    expect(count, 0);

    testSome.forEach((a) => count += a);
    expect(count, 1);
  });

  test('Option.map', () {
    expect(testSome.map((a) => a * 10), 10.some);
    expect(testNone.map((a) => a * 10), testNone);
  });

  test('Option.nonEmpty', () {
    expect(testSome.nonEmpty, isTrue);
    expect(testNone.nonEmpty, isFalse);
  });

  test('Option.orElse', () {
    expect(testSome.orElse(() => 10.some), testSome);
    expect(testNone.orElse(() => testSome), testSome);
    expect(testNone.orElse(() => testNone), testNone);
  });

  test('Option.toIList', () {
    expect(testSome.toIList(), IList.of([1]));
    expect(testNone.toIList(), isEmpty);
  });

  test('Option.toLeft', () {
    expect(testSome.toLeft(() => 'right'), Either.left<int, String>(1));
    expect(testNone.toLeft(() => 'right'), Either.right<int, String>('right'));
  });

  test('Option.toRight', () {
    expect(testSome.toRight(() => 'left'), Either.right<String, int>(1));
    expect(testNone.toRight(() => 'left'), Either.left<String, int>('left'));
  });

  test('Option.toString', () {
    expect(Option.pure(1).toString(), 'Some(1)');
    expect(none<int>().toString(), 'None');
  });

  test('Option.hashCode', () {
    expect(Option.pure(1).hashCode, Option.pure(1).hashCode);
    expect(none<int>().hashCode, none<int>().hashCode);
  });

  test('Option.map2', () {
    expect(const Tuple2(testSome, testSome).mapN((a, b) => a + b), 2.some);
    expect(const Tuple2(testSome, testNone).mapN((a, b) => a + b), testNone);
    expect(const Tuple2(testNone, testSome).mapN((a, b) => a + b), testNone);
    expect(const Tuple2(testNone, testNone).mapN((a, b) => a + b), testNone);
  });

  test('Option.flatten', () {
    expect(2.some.some.flatten(), 2.some);
    expect(none<int>().some.flatten(), none<int>());
  });
}
