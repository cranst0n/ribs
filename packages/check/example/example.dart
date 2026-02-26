import 'package:ribs_check/ribs_check.dart';
import 'package:test/test.dart';

void main() {
  group('List Properties', () {
    // A simple property test using forAllN
    Gen.listOf(Gen.chooseInt(0, 10), Gen.chooseInt(-100, 100)).forAll(
      'reversing a list twice returns the original list',
      (List<int> list) {
        expect(list.reversed.toList().reversed.toList(), equals(list));
      },
    );

    (
      Gen.chooseInt(-1000, 1000),
      Gen.chooseInt(-1000, 1000),
    ).forAll(
      'sum of two integers is commutative',
      (int a, int b) {
        expect(a + b, equals(b + a));
      },
    );

    (
      Gen.chooseInt(-100, 100),
      Gen.chooseInt(-100, 100),
      Gen.chooseInt(-100, 100),
    ).forAll(
      'addition is associative',
      (int a, int b, int c) {
        expect((a + b) + c, equals(a + (b + c)));
      },
    );
  });

  group('Custom Generators', () {
    // Composing generators using tuples and map
    final userGen = (
      Gen.alphaNumString(10),
      Gen.chooseInt(18, 100),
      Gen.boolean,
    ).tupled.map((t) => User(t.$1, t.$2, isAdmin: t.$3));

    userGen.forAll(
      'generated users meet domain constraints',
      (User user) {
        expect(user.name.length, lessThanOrEqualTo(10));
        expect(user.age, inInclusiveRange(18, 100));
      },
    );
  });

  group('Edge Cases and Shrinking', () {
    // ribs_check will automatically try edge cases from the generator's domain
    // and if a failure is found, it will "shrink" it to the simplest reproduction.
    Gen.chooseInt(0, 100).forAll(
      'all integers are less than 50 (this will fail and shrink!)',
      (int n) {
        if (n >= 50) {
          // This will fail for any n >= 50.
          // ribs_check will likely shrink this failure down to exactly 50.
          expect(n, lessThan(50));
        }
      },
      // skip: 'Expected to fail, demonstrating shrinking',
    );
  });
}

class User {
  final String name;
  final int age;
  final bool isAdmin;

  User(this.name, this.age, {this.isAdmin = false});

  @override
  String toString() => 'User(name: $name, age: $age, isAdmin: $isAdmin)';
}
