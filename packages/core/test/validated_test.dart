import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_core/test.dart';
import 'package:test/test.dart';

typedef Value = (int, int, int);
typedef Error = NonEmptyIList<String>;

void main() {
  group('Validated', () {
    test('invalidNel', () {
      expect(
        Validated.invalidNel<String, int>('error'),
        isInvalid(nel('error')),
      );
    });

    test('validNel', () {
      expect(
        Validated.validNel<String, int>(42),
        isValidNel(42),
      );
    });

    test('andThen', () {
      expect(
        42.valid<String>().andThen((x) => x.valid()),
        isValid(42),
      );

      expect(
        42.valid<String>().andThen((x) => 'boom'.invalid<int>()),
        isInvalid('boom'),
      );

      expect(
        'err'.invalid<int>().andThen((x) => x.valid()),
        isInvalid('err'),
      );

      expect(
        'err'.invalid<int>().andThen((x) => 'next'.invalid<int>()),
        isInvalid('err'),
      );
    });

    test('bimap', () {
      expect(
        21.valid<String>().bimap((a) => a.toLowerCase(), (x) => x * 2),
        isValid(42),
      );

      expect(
        'ERR'.invalid<int>().bimap((a) => a.toLowerCase(), (x) => x * 2),
        isInvalid('err'),
      );
    });

    test('ensure', () {
      expect(
        42.valid<String>().ensure((a) => a.isEven, () => 'fail'),
        isValid(42),
      );

      expect(
        42.valid<String>().ensure((a) => a.isOdd, () => 'fail'),
        isInvalid('fail'),
      );

      expect(
        'err'.invalid<int>().ensure((a) => a.isOdd, () => 'fail'),
        isInvalid('err'),
      );
    });

    test('ensureOr', () {
      expect(
        42.valid<String>().ensureOr((a) => a.isEven, (a) => a.toString()),
        isValid(42),
      );

      expect(
        42.valid<String>().ensureOr((a) => a.isOdd, (a) => a.toString()),
        isInvalid('42'),
      );

      expect(
        'err'.invalid<int>().ensureOr((a) => a.isOdd, (a) => a.toString()),
        isInvalid('err'),
      );
    });

    test('exists', () {
      expect(42.valid<String>().exists((a) => a.isEven), isTrue);
      expect(42.valid<String>().exists((a) => a.isOdd), isFalse);

      expect('err'.invalid<int>().exists((a) => a.isEven), isFalse);
      expect('err'.invalid<int>().exists((a) => a.isOdd), isFalse);
    });

    test('flatten', () {
      expect(42.valid<String>().valid<String>().flatten(), isValid(42));

      expect('err'.invalid<int>().valid<String>().flatten(), isInvalid('err'));
    });

    test('forall', () {
      expect(42.valid<String>().forall((a) => a.isEven), isTrue);
      expect(42.valid<String>().forall((a) => a.isOdd), isFalse);

      expect('err'.invalid<int>().forall((a) => a.isEven), isTrue);
      expect('err'.invalid<int>().forall((a) => a.isOdd), isTrue);
    });

    test('foreach', () {
      int count = 0;

      42.valid<String>().foreach((_) => count += 1);
      expect(count, 1);

      'err'.invalid<int>().foreach((_) => count += 1);
      expect(count, 1);
    });

    test('getOrElse', () {
      expect(42.valid<String>().getOrElse(() => 0), 42);
      expect('err'.invalid<int>().getOrElse(() => 0), 0);
    });

    test('isValid', () {
      expect(42.valid<String>().isValid, isTrue);
      expect('err'.invalid<int>().isValid, isFalse);
    });

    test('isInvalid', () {
      expect(42.valid<String>().isInvalid, isFalse);
      expect('err'.invalid<int>().isInvalid, isTrue);
    });

    test('leftMap', () {
      expect(
        42.valid<String>().leftMap((a) => a.toLowerCase()),
        isValid(42),
      );

      expect(
        'ERR'.invalid<int>().leftMap((a) => a.toLowerCase()),
        isInvalid('err'),
      );
    });

    test('orElse', () {
      expect(
        42.valid<String>().orElse(() => 0.valid()),
        isValid(42),
      );

      expect(
        'err'.invalid<int>().orElse(() => 0.valid()),
        isValid(0),
      );

      expect(
        'err'.invalid<int>().orElse(() => '2nd'.invalid()),
        isInvalid('2nd'),
      );
    });

    test('swap', () {
      expect(42.valid<String>().swap(), isInvalid(42));
      expect('err'.invalid<int>().swap(), isValid('err'));
    });

    test('toEither', () {
      expect(42.valid<String>().toEither(), isRight(42));
      expect('err'.invalid<int>().toEither(), isLeft('err'));
    });

    test('toIList', () {
      expect(42.valid<String>().toIList(), ilist([42]));
      expect('err'.invalid<int>().toIList(), nil<int>());
    });

    test('toOption', () {
      expect(42.valid<String>().toOption(), isSome(42));
      expect('err'.invalid<int>().toOption(), isNone());
    });

    test('toValidatedNel', () {
      expect(42.valid<String>().toValidatedNel(), isValidNel(42));
      expect(
        'err'.invalid<int>().toValidatedNel(),
        isInvalid(nel('err')),
      );
    });

    test('valueOr', () {
      expect(42.valid<String>().valueOr((a) => a.length), 42);
      expect('err'.invalid<int>().valueOr((a) => a.length), 3);
    });

    test('map3', () {
      final vA = 1.validNel<String>();
      final vB = 2.validNel<String>();
      final vC = 3.validNel<String>();

      final iA = 'invalid username'.invalidNel<int>();
      final iB = 'invalid password'.invalidNel<int>();
      final iC = 'invalid birthday'.invalidNel<int>();

      expect(
        (vA, vB, vC).tupled,
        const (1, 2, 3).valid<Error>(),
      );

      expect(
        (iA, vB, vC).tupled,
        'invalid username'.invalidNel<Value>(),
      );

      expect(
        (iA, iB, vC).tupled,
        nel('invalid username', ['invalid password']).invalid<Value>(),
      );

      expect(
        (iA, iB, iC).tupled,
        nel('invalid username', ['invalid password', 'invalid birthday']).invalid<Value>(),
      );

      expect(
        (iA, vB, iC).tupled,
        nel('invalid username', ['invalid birthday']).invalid<Value>(),
      );

      expect(
        (vA, vB, iC).tupled,
        'invalid birthday'.invalidNel<Value>(),
      );
    });
  });
}
