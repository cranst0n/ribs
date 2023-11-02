import 'package:ribs_core/ribs_core.dart';

/// Type alias for [Validated] where the error case is fixed to
/// [NonEmptyIList]<E>.
typedef ValidatedNel<E, A> = Validated<NonEmptyIList<E>, A>;

/// Represents one of 2 possible values: [Valid] or [Invalid].
///
/// Validated is somewhat simililar to [Either] with the exception that
/// [Validated] does not form a [Monad] and thus does not have a flatMap
/// function. This gives [Validated] a unique power however in that it can
/// support error accumulation, specifically in the form of a [ValidatedNel].
///
/// Validated is right biased so function like [map] operate on the Valid value,
/// if present.
sealed class Validated<E, A> implements Functor<A> {
  /// Lifts the given value [e] into an [Invalid].
  static Validated<E, A> invalid<E, A>(E e) => Invalid(e);

  /// Lifts the given value [e] into an [Invalid] where the error type is
  /// wrapped in a [NonEmptyIList].
  static ValidatedNel<E, A> invalidNel<E, A>(E e) =>
      Invalid(NonEmptyIList.one(e));

  /// Lifts the given value [a] into a [Valid].
  static Validated<E, A> valid<E, A>(A a) => Valid(a);

  /// Lifts the given value [a] into a [Valid] where the error type is fixed
  /// to [NonEmptyIList]<E>.
  static ValidatedNel<E, A> validNel<E, A>(A a) => Valid(a);

  /// Returns the result of applying [fe] if this is an instance of [Invalid],
  /// otherwise the result of applying [fa] to this [Valid].
  B fold<B>(Function1<E, B> fe, Function1<A, B> fa);

  /// Creates a new Validated by applying [f] if this is a [Valid], otherwise
  /// returns the error value.
  Validated<E, B> andThen<B>(Function1<A, Validated<E, B>> f) =>
      fold(Validated.invalid, f);

  /// Returns a new Validated by applying [fe] or [fa] depending on if this
  /// instance is an [Invalid] or [Valid] respectively.
  Validated<EE, AA> bimap<EE, AA>(Function1<E, EE> fe, Function1<A, AA> fa) =>
      fold((e) => fe(e).invalid(), (a) => fa(a).valid());

  /// Tests if the valid value (if any) passes the given predicate [p]. If it
  /// fails, a new [Invalid] with a value of [onFailure] is returned, otherwise
  /// this instance is returned.
  Validated<E, A> ensure(Function1<A, bool> p, Function0<E> onFailure) =>
      fold((a) => this, (a) => p(a) ? this : Validated.invalid(onFailure()));

  /// Tests if the valid value (if any) passes the given predicate [p]. If it
  /// fails, a new [Invalid] with a value of [onFailure] is returned, otherwise
  /// this instance is returned.
  Validated<E, A> ensureOr(Function1<A, bool> p, Function1<A, E> onFailure) =>
      fold((a) => this, (a) => p(a) ? this : Validated.invalid(onFailure(a)));

  /// Returns true if this instance has a valid value to passes the given
  /// predicate [p].
  bool exists(Function1<A, bool> p) => fold((_) => false, p);

  /// Returns true if this instance has a valid value to passes the given
  /// predicate [p].
  bool forall(Function1<A, bool> p) => fold((_) => true, p);

  /// Applies the given side-effet [f] for every valid value this instance
  /// represents.
  void foreach(Function1<A, void> f) => fold((_) => Unit(), f);

  /// Returns the value of this instance if it is a [Valid], otherwise returns
  /// the result of evaluating [orElse].
  A getOrElse(Function0<A> orElse) => fold((_) => orElse(), id);

  /// Returns true if this instance is a [Valid], otherwise false is returned.
  bool get isValid => fold((_) => false, (_) => true);

  /// Returns true if this instance is a [Invalid], otherwise false is returned.
  bool get isInvalid => !isValid;

  /// Returns a new validated by applying [f] to the value of this instance if
  /// it is an [Invalid].
  Validated<EE, A> leftMap<EE>(Function1<E, EE> f) =>
      fold((e) => f(e).invalid(), (a) => a.valid());

  /// Returns a new validated by applying [f] to the value of this instance if
  /// it is a [Valid].
  @override
  Validated<E, B> map<B>(Function1<A, B> f) =>
      fold((e) => e.invalid(), (a) => f(a).valid());

  /// If this instance is a [Valid], this is returned. Otherwise, the result of
  /// evaluating [orElse] is returned.
  Validated<E, A> orElse(Function0<Validated<E, A>> orElse) =>
      fold((_) => orElse(), (_) => this);

  /// Returns a new Validated where the invalid and valid types are swapped.
  Validated<A, E> swap() => fold((e) => e.valid(), (a) => a.invalid());

  /// Returns a new [Either] where the left and right types correspond to the
  /// invalid and valid types respectively.
  Either<E, A> toEither() => fold((e) => e.asLeft(), (a) => a.asRight());

  /// Returns a new [IList] with the valid value of this instance, if any.
  /// If this instance is [Invalid], an empty [IList] is returned.
  IList<A> toIList() => fold((_) => nil(), (a) => IList.of([a]));

  /// Returns [None] if this instance is an [Invalid], otherwise a [Some] with
  /// the valid value.
  Option<A> toOption() => fold((_) => none(), (a) => Some(a));

  /// Converts this instance to a [ValidatedNel].
  ValidatedNel<E, A> toValidatedNel() =>
      fold(Validated.invalidNel, Validated.validNel);

  /// Alias for [fold].
  A valueOr(Function1<E, A> f) => fold(f, id);

  @override
  String toString() => fold((a) => 'Invalid($a)', (b) => 'Valid($b)');

  @override
  bool operator ==(Object other) => fold(
        (e) => other is Invalid<E, A> && other.value == e,
        (a) => other is Valid<E, A> && other.value == a,
      );

  @override
  int get hashCode => fold((e) => e.hashCode, (a) => a.hashCode);
}

/// A [Validated] that represents a successful, or valid value.
final class Valid<E, A> extends Validated<E, A> {
  final A value;

  Valid(this.value);

  @override
  B fold<B>(Function1<E, B> fe, Function1<A, B> fa) => fa(value);
}

/// A [Validated] that represents a failure, or invalid value.
final class Invalid<E, A> extends Validated<E, A> {
  final E value;

  Invalid(this.value);

  @override
  B fold<B>(Function1<E, B> fe, Function1<A, B> fa) => fe(value);
}

extension ValidatedNestedOps<E, A> on Validated<E, Validated<E, A>> {
  /// Extracts the nested [Validated] via [fold].
  Validated<E, A> flatten() => fold(
        (e) => e.invalid(),
        (va) => va.fold(
          (e) => e.invalid(),
          (a) => a.valid(),
        ),
      );
}

/// Functions that are unique to a [Validated] that has a [NonEmptyIList]<E>
/// for the invalid type.
extension ValidatedNelOps<E, A> on ValidatedNel<E, A> {
  /// Applies [f] to this value if both instance are [Valid]. Otherwise returns
  /// the error if either is [Invalid] or the accumulation of errors if both
  /// are [Invalid].
  ValidatedNel<E, B> ap<B>(ValidatedNel<E, Function1<A, B>> f) {
    return fold(
      (e) => f.fold(
        (ef) => e.concatNel(ef).invalid(),
        (af) => e.invalid(),
      ),
      (a) => f.fold(
        (ef) => ef.invalid(),
        (af) => af(a).validNel<E>(),
      ),
    );
  }

  /// Returns the product (tuple) of this validation and [that] if both
  /// instances are [Valid]. Otherwise returns the error if either is [Invalid]
  /// or the accumulation of errors if both are [Invalid].
  ValidatedNel<E, (A, B)> product<B>(ValidatedNel<E, B> that) {
    return fold(
      (e) => that.fold(
        (ef) => e.concatNel(ef).invalid(),
        (af) => e.invalid(),
      ),
      (a) => that.fold(
        (ef) => ef.invalid(),
        (af) => (a, af).validNel<E>(),
      ),
    );
  }
}
