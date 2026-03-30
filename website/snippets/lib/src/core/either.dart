import 'package:ribs_core/ribs_core.dart';

// #region create-user-1
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
// #endregion create-user-1

// #region create-user-2
final create1 = userOption('Jonathan', 'Jon', 21); // Some(User(...))
final create2 = userOption('Jonathan', '', 32); // None()
final create3 = userOption('', 'Jon', 55); // None()
// #endregion create-user-2

// #region create-user-3
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
// #endregion create-user-3

// #region map-1
const myLeft = Left<int, String>(42);
const myRight = Right<int, String>('World');

String greet(String str) => 'Hello $str!';

final myLeft2 = myLeft.map(greet); // Left(42)
final myRight2 = myRight.map(greet); // Right(Hello World!)
// #endregion map-1

// #region flatMap-1
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
// #endregion flatMap-1

// #region fold-1
final foldLeft = const Left<bool, int>(false).fold(
  (boolean) => 'bool value is: $boolean',
  (integer) => 'int value is: $integer',
);
// #endregion fold-1
