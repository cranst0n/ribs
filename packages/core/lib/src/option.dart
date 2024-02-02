import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';

/// Creates a [None] with the given type parameter.
Option<A> none<A>() => None<A>();

/// Represents optional values.
///
/// Instances of `Option` are either a [Some] or [None]. At first glance,
/// [Option] may seem just like a nullabled type (e.g. Option<int> <-> int?),
/// but [Option] provide far more combinators to give greater power and
/// flexibility. There are also conversions to move between optional and
/// nullable types.
@immutable
sealed class Option<A> implements Monad<A> {
  /// Creates an [Option] from the nullable value. If the value is null, a
  /// [None] will be returned. If the value is non-null, a [Some] will be
  /// returned.
  factory Option(A? a) => a == null ? none<A>() : Some(a);

  const Option._();

  /// Creates an Option (i.e. [Some]) from the given non-null value.
  factory Option.pure(A a) => Some(a);

  /// Evaluates the given condition and returns [None] when the condition
  /// is true, or a [Some] with a value of the result of given function.
  factory Option.unless(Function0<bool> condition, Function0<A> a) =>
      condition() ? None<A>() : Some(a());

  /// Evaluates the given condition and returns [None] when the condition
  /// is false, or a [Some] with a value of the result of given function.
  factory Option.when(Function0<bool> condition, Function0<A> a) =>
      condition() ? Some(a()) : None<A>();

  /// Returns the result of applying `f` to this [Option] value if non-empty.
  B fold<B>(Function0<B> ifEmpty, Function1<A, B> f);

  /// Applies the optional function provided if both the function and this
  /// [Option] are both defined. Otherwise, [None] is returned.
  @override
  Option<B> ap<B>(Option<Function1<A, B>> f) =>
      flatMap((a) => f.map((f) => f(a)));

  /// Returns true if this Option is a [Some], false if it's a [None].
  bool get isDefined => fold(() => false, (_) => true);

  /// Returns true if this Option is a [None], false if it's a [Some].
  bool get isEmpty => !isDefined;

  bool exists(Function1<A, bool> p) =>
      foldLeft(false, (acc, elem) => acc || p(elem));

  bool forall(Function1<A, bool> p) =>
      foldLeft(true, (acc, elem) => acc && p(elem));

  /// Returns a [Some] if this Option is non-empty **and** if applying the value
  /// of this [Option] to the given predicate returns true.
  Option<A> filter(Function1<A, bool> p) =>
      fold(() => this, (a) => p(a) ? this : none<A>());

  /// Returns a [Some] if this Option is non-empty **and** if applying the value
  /// of this [Option] to the given predicate returns false.
  Option<A> filterNot(Function1<A, bool> p) => filter((a) => !p(a));

  /// Returns the result of applying [f] to the value of this [Option] if
  /// non-empty.
  @override
  Option<B> flatMap<B>(covariant Function1<A, Option<B>> f) =>
      fold(() => none<B>(), f);

  /// Applies the given binary operator to the start value and all values of
  /// this [Foldable], moving left to right.
  B foldLeft<B>(B init, Function2<B, A, B> op) =>
      fold(() => init, (a) => op(init, a));

  B foldRight<B>(B init, Function2<A, B, B> op) =>
      fold(() => init, (a) => op(a, init));

  /// Returns the value if this is a [Some] or the value returned from
  /// evaluating [ifEmpty].
  A getOrElse(Function0<A> ifEmpty) => fold(() => ifEmpty(), identity);

  /// If this is a [Some], the side-effect [ifSome] is evaluated by passing the
  /// value.
  void foreach(Function1<A, void> ifSome) {
    if (this is Some<A>) {
      ifSome((this as Some<A>).value);
    }
  }

  /// If this is a [Some], returns a new [Some] with the result of applying [f]
  /// to the value. Otherwise, [None] is returned.
  @override
  Option<B> map<B>(Function1<A, B> f) => flatMap((a) => Some(f(a)));

  /// Return true if this is a [Some], otherwise false is returned;
  bool get nonEmpty => isDefined;

  /// If this is a [Some], this is returned, otherwise the result of evaluating
  /// [orElse] is returned.
  Option<A> orElse(Function0<Option<A>> orElse) =>
      fold(() => orElse(), (_) => this);

  /// Returns a single element [IList] if this is a [Some]. Otherwise an empty
  /// [IList] is returned.
  IList<A> toIList() => fold(() => nil<A>(), (a) => ilist([a]));

  /// If this is a [Some] a [Left] is returned with the value. It this is a
  /// [None], a [Right] is returned with the result of evaluating [ifEmpty].
  Either<A, X> toLeft<X>(Function0<X> ifEmpty) =>
      fold(() => Either.right<A, X>(ifEmpty()), (x) => Either.left<A, X>(x));

  /// If this is a [Some] a [Right] is returned with the value. It this is a
  /// [None], a [Left] is returned with the result of evaluating [ifEmpty].
  Either<X, A> toRight<X>(Function0<X> ifEmpty) =>
      fold(() => Either.left<X, A>(ifEmpty()), (x) => Either.right<X, A>(x));

  /// Returns a nullable value, which is the value itself if this is a [Some],
  /// or null if this is a [None].
  A? toNullable() => fold(() => null, identity);

  @override
  String toString() => fold(() => 'None', (a) => 'Some($a)');

  @override
  bool operator ==(Object other) => fold(
        () => other is None,
        (value) => other is Some<A> && value == other.value,
      );

  @override
  int get hashCode => fold(() => 0, (a) => a.hashCode);
}

/// An [Option] that signifies the presence of a value.
final class Some<A> extends Option<A> {
  final A value;

  const Some(this.value) : super._();

  @override
  B fold<B>(Function0<B> ifEmpty, Function1<A, B> f) => f(value);
}

/// An [Option] that signifies the absence of a value.
final class None<A> extends Option<A> {
  const None() : super._();

  @override
  B fold<B>(Function0<B> ifEmpty, Function1<A, B> f) => ifEmpty();
}

/// Additional functions that can be called on a nested [Option].
extension OptionNestedOps<A> on Option<Option<A>> {
  /// If this is a [Some], the value is returned, otherwise [None] is returned.
  Option<A> flatten() => fold(() => none<A>(), identity);
}
