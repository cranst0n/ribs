import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test_matchers.dart';
import 'package:test/test.dart';

void main() {
  final testRight = Either.right<String, int>(1);
  final testLeft = Either.left<String, int>('left');

  int incInt(int i) => i + 1;
  String reverseString(String s) => String.fromCharCodes(s.codeUnits.reversed);
  int sum(int a, int b) => a + b;

  group('Either', () {
    test('catching (value)', () {
      expect(
          Either.catching(() => 1,
              (a, b) => fail('Either.catching value should not throw')),
          isRight<Never, int>(1));
    });

    test('catching (throw)', () {
      expect(Either.catching(() => throw Exception('boom'), (a, b) => 'OK'),
          isLeft<String, Never>('OK'));
    });

    test('cond', () {
      final ifFalse = Either.cond(() => false, () => 1, () => 'left');
      final ifTrue = Either.cond(() => true, () => 1, () => 'left');

      expect(ifFalse, isLeft<String, int>('left'));
      expect(ifTrue, isRight<String, int>(1));
    });

    test('fold', () {
      expect(testRight.fold((_) => 'L', (_) => 'R'), 'R');
      expect(testLeft.fold((_) => 'L', (_) => 'R'), 'L');
    });

    test('ap', () {
      final rF = Either.right<String, Function1<int, int>>(incInt);
      final lF = Either.left<String, Function1<int, int>>('lF');

      expect(testRight.ap(rF), isRight<String, int>(2));
      expect(testRight.ap(lF), isLeft<String, int>('lF'));
      expect(testLeft.ap(rF), isLeft<String, int>('left'));
      expect(testLeft.ap(lF), isLeft<String, int>('left'));
    });

    test('bimap', () {
      expect(
        testRight.bimap(reverseString, incInt),
        isRight<String, int>(2),
      );

      expect(
        testLeft.bimap(reverseString, incInt),
        isLeft<String, int>('tfel'),
      );
    });

    test('contains', () {
      expect(testRight.contains(1), isTrue);
      expect(testRight.contains(2), isFalse);
      expect(testLeft.contains(1), isFalse);
    });

    test('ensure', () {
      expect(testRight.ensure((a) => a > 0, () => fail('boom')), testRight);
      expect(testRight.ensure((a) => a < 0, () => 'left'), testLeft);
      expect(testLeft.ensure((a) => a < 0, () => 'left'), testLeft);
    });

    test('filterOrElse', () {
      final zero = Either.left<String, int>('zero');

      expect(
          testRight.filterOrElse((a) => a > 0, () => fail('boom')), testRight);
      expect(testRight.filterOrElse((a) => a < 0, () => 'zero'), zero);
      expect(testLeft.filterOrElse((a) => fail('boom'), () => 'zero'), zero);
    });

    test('flatMap', () {
      expect(testRight.flatMap((a) => Either.right(a + 1)),
          isRight<String, int>(2));
      expect(testLeft.flatMap((a) => Either.right(a + 1)), testLeft);
      expect(testRight.flatMap((_) => testLeft), testLeft);
    });

    test('flatten', () {
      expect(Either.right<String, Either<String, int>>(testRight).flatten(),
          testRight);
      expect(Either.right<String, Either<String, int>>(testLeft).flatten(),
          testLeft);
      expect(
          Either.left<String, Either<String, int>>('left').flatten(), testLeft);
    });

    test('foldLeft', () {
      expect(testRight.foldLeft<int>(0, sum), 1);
      expect(testLeft.foldLeft<int>(0, sum), 0);
    });

    test('foldRight', () {
      expect(testRight.foldRight<int>(0, sum), 1);
      expect(testLeft.foldRight<int>(0, sum), 0);
    });

    test('getOrElse', () {
      expect(testRight.getOrElse(() => fail('boom')), 1);
      expect(testLeft.getOrElse(() => -1), -1);
    });

    test('isLeft', () {
      expect(testLeft.isLeft, isTrue);
      expect(testRight.isLeft, isFalse);
    });

    test('isRight', () {
      expect(testRight.isRight, isTrue);
      expect(testLeft.isRight, isFalse);
    });

    test('leftMap', () {
      expect(testRight.leftMap(reverseString), testRight);
      expect(testLeft.leftMap(reverseString), isLeft<String, int>('tfel'));
    });

    test('map', () {
      expect(testRight.map(incInt), Either.right<String, int>(2));
      expect(testLeft.map(incInt), testLeft);
    });

    test('orElse', () {
      expect(testRight.orElse(() => testLeft), testRight);
      expect(testLeft.orElse(() => testRight), testRight);
    });

    test('product', () {
      expect(
        1.asRight<String>().product(2.asRight<String>()),
        (1, 2).asRight<String>(),
      );

      expect(
        'err'.asLeft<int>().product(1.asRight<String>()),
        'err'.asLeft<int>(),
      );

      expect(
        1.asRight<String>().product('err'.asLeft<int>()),
        'err'.asLeft<int>(),
      );
    });

    test('swap', () {
      expect(testRight.swap(), isLeft<int, String>(1));
      expect(testLeft.swap(), isRight<int, String>('left'));
    });

    test('toIList', () {
      expect(testRight.toIList(), IList.of([1]));
      expect(testLeft.toIList(), isEmpty);
    });

    test('toOption', () {
      expect(testRight.toOption(), 1.some);
      expect(testLeft.toOption(), none<int>());
    });

    test('toValidated', () {
      expect(testRight.toValidated().isValid, isTrue);
      expect(testLeft.toValidated().isValid, isFalse);
    });

    test('Either ==', () {
      expect(testRight == testRight, true);
      expect(testRight == testLeft, false);
      expect(testLeft == testRight, false);
      expect(testLeft == testLeft, true);
    });

    test('toString', () {
      expect(testRight.toString(), 'Right(1)');
      expect(testLeft.toString(), 'Left(left)');
    });

    test('hashCode', () {
      expect(Either.right<int, int>(42).hashCode,
          Either.right<int, int>(42).hashCode);
      expect(Either.left<int, int>(42).hashCode,
          Either.left<int, int>(42).hashCode);
    });

    test('mapN', () {
      expect((testRight, testRight).mapN(sum), isRight<String, int>(2));
      expect((testRight, testLeft).mapN(sum), testLeft);
      expect((testLeft, testRight).mapN(sum), testLeft);
    });
  });
}
