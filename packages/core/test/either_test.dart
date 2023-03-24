import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

void main() {
  final testRight = Either.right<String, int>(1);
  final testLeft = Either.left<String, int>('left');

  int incInt(int i) => i + 1;
  String reverseString(String s) => String.fromCharCodes(s.codeUnits.reversed);
  int sum(int a, int b) => a + b;

  test('Either.catching (value)', () {
    expect(
        Either.catching(
            () => 1, (a, b) => fail('Either.catching value should not throw')),
        Either.pure<Never, int>(1));
  });

  test('Either.catching (throw)', () {
    expect(Either.catching(() => throw Exception('boom'), (a, b) => 'OK'),
        Either.left<String, Never>('OK'));
  });

  test('Either.cond', () {
    final ifFalse = Either.cond(() => false, () => 1, () => 'left');
    final ifTrue = Either.cond(() => true, () => 1, () => 'left');

    expect(ifFalse, testLeft);
    expect(ifTrue, testRight);
  });

  test('Either.fold', () {
    expect(testRight.fold((_) => 'L', (_) => 'R'), 'R');
    expect(testLeft.fold((_) => 'L', (_) => 'R'), 'L');
  });

  test('Either.ap', () {
    final rF = Either.right<String, Function1<int, int>>(incInt);
    final lF = Either.left<String, Function1<int, int>>('lF');

    expect(testRight.ap(rF), Either.right<String, int>(2));
    expect(testRight.ap(lF), Either.left<String, int>('lF'));
    expect(testLeft.ap(rF), testLeft);
    expect(testLeft.ap(lF), testLeft);
  });

  test('Either.bimap', () {
    expect(
        testRight.bimap(reverseString, incInt), Either.right<String, int>(2));
    expect(testLeft.bimap(reverseString, incInt),
        Either.left<String, int>('tfel'));
  });

  test('Either.contains', () {
    expect(testRight.contains(1), isTrue);
    expect(testRight.contains(2), isFalse);
    expect(testLeft.contains(1), isFalse);
  });

  test('Either.ensure', () {
    expect(testRight.ensure((a) => a > 0, () => fail('boom')), testRight);
    expect(testRight.ensure((a) => a < 0, () => 'left'), testLeft);
    expect(testLeft.ensure((a) => a < 0, () => 'left'), testLeft);
  });

  test('Either.filterOrElse', () {
    final zero = Either.left<String, int>('zero');

    expect(testRight.filterOrElse((a) => a > 0, () => fail('boom')), testRight);
    expect(testRight.filterOrElse((a) => a < 0, () => 'zero'), zero);
    expect(testLeft.filterOrElse((a) => fail('boom'), () => 'zero'), zero);
  });

  test('Either.flatMap', () {
    expect(testRight.flatMap((a) => Either.right(a + 1)),
        Either.right<String, int>(2));
    expect(testLeft.flatMap((a) => Either.right(a + 1)), testLeft);
    expect(testRight.flatMap((_) => testLeft), testLeft);
  });

  test('Either.flatten', () {
    expect(Either.right<String, Either<String, int>>(testRight).flatten(),
        testRight);
    expect(Either.right<String, Either<String, int>>(testLeft).flatten(),
        testLeft);
    expect(
        Either.left<String, Either<String, int>>('left').flatten(), testLeft);
  });

  test('Either.foldLeft', () {
    expect(testRight.foldLeft<int>(0, sum), 1);
    expect(testLeft.foldLeft<int>(0, sum), 0);
  });

  test('Either.foldRight', () {
    expect(testRight.foldRight<int>(0, sum), 1);
    expect(testLeft.foldRight<int>(0, sum), 0);
  });

  test('Either.getOrElse', () {
    expect(testRight.getOrElse(() => fail('boom')), 1);
    expect(testLeft.getOrElse(() => -1), -1);
  });

  test('Either.isLeft', () {
    expect(testLeft.isLeft, isTrue);
    expect(testRight.isLeft, isFalse);
  });

  test('Either.isRight', () {
    expect(testRight.isRight, isTrue);
    expect(testLeft.isRight, isFalse);
  });

  test('Either.leftMap', () {
    expect(testRight.leftMap(reverseString), testRight);
    expect(testLeft.leftMap(reverseString), Either.left<String, int>('tfel'));
  });

  test('Either.map', () {
    expect(testRight.map(incInt), Either.right<String, int>(2));
    expect(testLeft.map(incInt), testLeft);
  });

  test('Either.orElse', () {
    expect(testRight.orElse(() => testLeft), testRight);
    expect(testLeft.orElse(() => testRight), testRight);
  });

  test('Either.swap', () {
    expect(testRight.swap(), Either.left<int, String>(1));
    expect(testLeft.swap(), Either.right<int, String>('left'));
  });

  test('Either.toIList', () {
    expect(testRight.toIList(), IList.of([1]));
    expect(testLeft.toIList(), isEmpty);
  });

  test('Either.toOption', () {
    expect(testRight.toOption(), 1.some);
    expect(testLeft.toOption(), none<int>());
  });

  test('Either.toValidated', () {
    expect(testRight.toValidated().isValid, isTrue);
    expect(testLeft.toValidated().isValid, isFalse);
  });

  test('Either ==', () {
    expect(testRight == testRight, true);
    expect(testRight == testLeft, false);
    expect(testLeft == testRight, false);
    expect(testLeft == testLeft, true);
  });

  test('Either.toString', () {
    expect(testRight.toString(), 'Right(1)');
    expect(testLeft.toString(), 'Left(left)');
  });

  test('Either.hashCode', () {
    expect(Either.right<int, int>(42).hashCode,
        Either.right<int, int>(42).hashCode);
    expect(
        Either.left<int, int>(42).hashCode, Either.left<int, int>(42).hashCode);
  });

  test('Either.map2', () {
    expect(
        Either.map2(testRight, testRight, sum), Either.right<String, int>(2));
    expect(Either.map2(testRight, testLeft, sum), testLeft);
    expect(Either.map2(testLeft, testRight, sum), testLeft);
  });
}
