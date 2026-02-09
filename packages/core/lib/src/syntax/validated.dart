import 'package:ribs_core/ribs_core.dart';

part 'generated/tuple_validated_nel.dart';

extension ValidatedSyntaxOps<A> on A {
  /// Lifts this value into a [Validated], specifically an [Invalid].
  Validated<A, B> invalid<B>() => Validated.invalid(this);

  /// Lifts this value into a [Validated], specifically a [Valid].
  Validated<B, A> valid<B>() => Validated.valid(this);

  /// Lifts this value into a [ValidatedNel], specifically an [Invalid].
  ValidatedNel<A, B> invalidNel<B>() => Validated.invalid(NonEmptyIList.one(this));

  /// Lifts this value into a [ValidatedNel], specifically a [Valid].
  ValidatedNel<B, A> validNel<B>() => Validated.valid(this);
}
