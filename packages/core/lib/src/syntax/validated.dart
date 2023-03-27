import 'package:ribs_core/src/non_empty_ilist.dart';
import 'package:ribs_core/src/validated.dart';

extension ValidatedSyntaxOps<A> on A {
  Validated<A, B> invalid<B>() => Validated.invalid(this);
  Validated<B, A> valid<B>() => Validated.valid(this);

  ValidatedNel<A, B> invalidNel<B>() =>
      Validated.invalid(NonEmptyIList.one(this));

  ValidatedNel<B, A> validNel<B>() => Validated.valid(this);
}
