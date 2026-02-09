import 'package:ribs_core/ribs_core.dart';

// create-user-1

final class User {
  final String name;
  final String alias;
  final int age;

  const User(this.name, this.alias, this.age);
}

Option<User> userOption(String name, String alias, int age) => (
  Option.when(() => name.isEmpty, () => name),
  Option.when(() => alias.isEmpty, () => alias),
  Option.when(() => age >= 18, () => age),
).mapN(User.new);

// create-user-1

// create-user-2

final create1 = userOption('Jonathan', 'Jon', 21); // Some(User(...))
final create2 = userOption('Jonathan', '', 32); // None()
final create3 = userOption('', 'Jon', 55); // None()

// create-user-2

// create-user-3

Either<String, User> userEither(String name, String alias, int age) {
  if (name.isNotEmpty) {
    if (alias.isNotEmpty) {
      return Right(User(name, alias, age));
    } else {
      return const Left('Alias is required!');
    }
  } else {
    return const Left('Name is required!');
  }
}

final create4 = userEither('Jonathan', 'Jon', 21); // Right(Instance of 'User')
final create5 = userEither('Jonathan', '', 32); // Left(Alias is required!)
final create6 = userEither('', 'Jon', 55); // Left(Name is required!)

// create-user-3

// map-1

const myLeft = Left<int, String>(42);
const myRight = Right<int, String>('World');

String greet(String str) => 'Hello $str!';

final myLeft2 = myLeft.map(greet); // Left(42)
final myRight2 = myRight.map(greet); // Right(Hello World!)

// map-1

// flatMap-1

Either<String, User> validateName(User u) =>
    Either.cond(() => u.name.isNotEmpty, () => u, () => 'User name is empty!');

Either<String, User> validateAlias(User u) =>
    Either.cond(() => u.alias.isNotEmpty, () => u, () => 'User alias is empty!');

Either<String, User> validateAge(User u) =>
    Either.cond(() => u.age > 35, () => u, () => 'User is too young!');

const candidate = User('Harrison', 'Harry', 30);

final validatedCandidate = validateName(
  candidate,
).flatMap(validateAlias).flatMap(validateAge); // Left(User is too young!)

// flatMap-1

// fold-1

final foldLeft = const Left<bool, int>(false).fold(
  (boolean) => 'bool value is: $boolean',
  (integer) => 'int value is: $integer',
);

// fold-1
