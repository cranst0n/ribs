import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

typedef Value = Tuple3<int, int, int>;
typedef Error = NonEmptyIList<String>;

void main() {
  test('map3', () {
    final vA = 1.validNel<String>();
    final vB = 2.validNel<String>();
    final vC = 3.validNel<String>();

    final iA = 'invalid username'.invalidNel<int>();
    final iB = 'invalid password'.invalidNel<int>();
    final iC = 'invalid birthday'.invalidNel<int>();

    expect(
      Validated.tupled3(vA, vB, vC),
      const Tuple3(1, 2, 3).valid<Error>(),
    );

    expect(
      Validated.tupled3(iA, vB, vC),
      NonEmptyIList.one('invalid username').invalid<Value>(),
    );

    expect(
      Validated.tupled3(iA, iB, vC),
      NonEmptyIList.of('invalid username', [
        'invalid password',
      ]).invalid<Value>(),
    );

    expect(
      Validated.tupled3(iA, iB, iC),
      NonEmptyIList.of('invalid username', [
        'invalid password',
        'invalid birthday',
      ]).invalid<Value>(),
    );

    expect(
      Validated.tupled3(iA, vB, iC),
      NonEmptyIList.of('invalid username', [
        'invalid birthday',
      ]).invalid<Value>(),
    );

    expect(
      Validated.tupled3(vA, vB, iC),
      NonEmptyIList.one('invalid birthday').invalid<Value>(),
    );
  });
}
