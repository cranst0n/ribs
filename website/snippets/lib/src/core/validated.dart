import 'package:ribs_core/ribs_core.dart';

// create-user-1

// Some type aliases for clarity
typedef Name = String;
typedef Alias = String;
typedef Age = int;

final class User {
  final Name name;
  final Alias alias;
  final Age age;

  const User(this.name, this.alias, this.age);
}

Either<String, User> userEither(Name name, Alias alias, Age age) =>
    throw UnimplementedError();

// create-user-1

// create-user-2

ValidatedNel<String, Name> validateName(Name name) =>
    name.isEmpty ? 'No name provided!'.invalidNel() : name.validNel();

ValidatedNel<String, Alias> validateAlias(Alias alias) =>
    alias.isEmpty ? 'No alias provided!'.invalidNel() : alias.validNel();

ValidatedNel<String, Age> validateAge(Age age) =>
    age < 18 ? 'Too young!'.invalidNel() : age.validNel();

ValidatedNel<String, User> createUser(User user) => (
      validateName(user.name),
      validateAlias(user.alias),
      validateAge(user.age),
    ).mapN(User.new);

// create-user-2

// create-user-3

// Valid(Instance of 'User')
final good = createUser(const User('John', 'Doe', 30));

// Invalid(NonEmptyIList(No name provided!))
final noName = createUser(const User('', 'Doe', 30));

// Invalid(NonEmptyIList(Too young!))
final tooYoung = createUser(const User('John', 'Doe', 7));

// Invalid(NonEmptyIList(No name provided!, Too young!))
final noAliasAndTooYoung = createUser(const User('John', '', 10));

// Invalid(NonEmptyIList(No name provided!, No alias provided!))
final noNameNoAlias = createUser(const User('', '', 75));

// create-user-3

// create-user-4

final succeeded = createUser(const User('John', 'Doe', 30));
final failed = createUser(const User('', 'Doe', 3));

void notifyUser(String message) => throw UnimplementedError();
void storeUser(User user) => throw UnimplementedError();

void handleCreateUser() {
  succeeded.fold(
    (errors) =>
        notifyUser(errors.mkString(start: 'User creation failed: ', sep: ',')),
    (user) => storeUser(user),
  );
}

// create-user-4
