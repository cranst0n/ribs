import 'package:ribs_core/ribs_core.dart';

extension EitherSyntaxOps<A> on A {
  Either<A, B> asLeft<B>() => Either.left(this);
  Either<B, A> asRight<B>() => Either.right(this);
}

extension IterableOps<A> on Iterable<A> {
  IList<A> get toIList => ilist(toList());
}

extension OptionSyntaxOps<A> on A {
  Option<A> get some => Some(this);
}

extension ValidatedSyntaxOps<A> on A {
  Validated<A, B> invalid<B>() => Validated.invalid(this);
  Validated<B, A> valid<B>() => Validated.valid(this);

  ValidatedNel<A, B> invalidNel<B>() =>
      Validated.invalid(NonEmptyIList.one(this));

  ValidatedNel<B, A> validNel<B>() => Validated.valid(this);
}
