import 'package:ribs_core/ribs_core.dart';
import 'package:test/test.dart';

typedef Value = (int, int, int);
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
      (vA, vB, vC).sequence(),
      const (1, 2, 3).valid<Error>(),
    );

    expect(
      (iA, vB, vC).sequence(),
      'invalid username'.invalidNel<Value>(),
    );

    expect(
      (iA, iB, vC).sequence(),
      nel('invalid username', ['invalid password']).invalid<Value>(),
    );

    expect(
      (iA, iB, iC).sequence(),
      nel('invalid username', ['invalid password', 'invalid birthday'])
          .invalid<Value>(),
    );

    expect(
      (iA, vB, iC).sequence(),
      nel('invalid username', ['invalid birthday']).invalid<Value>(),
    );

    expect(
      (vA, vB, iC).sequence(),
      'invalid birthday'.invalidNel<Value>(),
    );
  });
}
