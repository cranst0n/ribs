import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';

/// Represents one of two possible values (a disjoint union).
///
/// Instances of `Either` are a [Left] or a [Right]. Eithers are primarily
/// used as an alternative to an [Option] where a "missing" value is provided
/// rather than a [None]. It is also useful to return from functions that may
/// fail, providing an indication for the failure reason in the Left value
/// or the success value in the Right value.
///
/// Either is right-biased so functions like [map], [flatMap], etc. operate on
/// the Right value, if present. If the Either has a Left value, the original
/// Either is returned.
@immutable
sealed class Either<A, B> implements Monad<B>, Foldable<B> {
  const Either();

  /// Lifts the given value into a [Left].
  static Either<A, B> left<A, B>(A a) => Left<A, B>(a);

  /// Lifts the given value into a [Right].
  static Either<A, B> right<A, B>(B b) => Right<A, B>(b);

  /// Something of a FP interface between try/catch blocks. The provided
  /// [body] function will be called and if successful, a [Right] is returned.
  /// If the function throws, a [Left] will be returned holding the result of
  /// applying the error and stack trace to the provided [onError] function.
  static Either<A, B> catching<A, B>(
    Function0<B> body,
    Function2<Object, StackTrace, A> onError,
  ) {
    try {
      return right(body());
    } catch (err, stack) {
      return left(onError(err, stack));
    }
  }

  /// Returns the result of [ifTrue] wrapped in a [Right], when the given [test]
  /// evaluates to true or the result of [ifFalse] wrapped in a [Left].
  static Either<A, B> cond<A, B>(
    Function0<bool> test,
    Function0<B> ifTrue,
    Function0<A> ifFalse,
  ) =>
      test() ? right(ifTrue()) : left(ifFalse());

  /// Lifts the given value into a [Right].
  static Either<A, B> pure<A, B>(B b) => Right(b);

  /// Applies `fa` if this is a [Left], or `fb` if this is a [Right].
  C fold<C>(Function1<A, C> fa, Function1<B, C> fb);

  /// Applies the value of [f] to the value of this instance if both are a
  /// [Right]. If either this or [f] is a [Left], that value is returned, in
  /// that order.
  @override
  Either<A, C> ap<C>(Either<A, Function1<B, C>> f) => fold((a) => left<A, C>(a),
      (b) => f.fold((a) => left<A, C>(a), (f) => right(f(b))));

  /// Applies the appropriate function [fa] or [fb] to the value of this
  /// instance depending on if this is a [Left] or [Right].
  Either<C, D> bimap<C, D>(Function1<A, C> fa, Function1<B, D> fb) =>
      fold((a) => left<C, D>(fa(a)), (b) => right(fb(b)));

  /// Returns true if this instance is a [Right] and the value equals [elem].
  bool contains(B elem) => fold((_) => false, (b) => elem == b);

  /// Checks if the value of this [Right] satisfies the given predicate [p].
  /// If this is a [Left], then this is returned. If this is a [Right] but the
  /// value doesn't pass the test, the result of evaluating [onFailure]
  /// is returned.
  Either<A, B> ensure(Function1<B, bool> p, Function0<A> onFailure) =>
      fold((_) => this, (b) => p(b) ? this : left(onFailure()));

  /// Checks if the value of this [Right] satisfies the given predicate [p].
  /// If this is a [Left] or if the [Right] value does not satisfy [p], then
  /// the value is replaced by the result of evaluating [zero].
  Either<A, B> filterOrElse(Function1<B, bool> p, Function0<A> zero) =>
      fold((_) => left<A, B>(zero()), (b) => p(b) ? this : left(zero()));

  /// Applies [f] to this value is this is a [Right]. If this is a [Left], then
  /// the original value is returned.
  @override
  Either<A, C> flatMap<C>(covariant Function1<B, Either<A, C>> f) =>
      fold(left<A, C>, f);

  /// Applies [op] to [init] and this value if this is a [Right]. If this is
  /// a [Left], [init] is returned.
  @override
  R2 foldLeft<R2>(R2 init, Function2<R2, B, R2> op) =>
      fold((_) => init, (r) => op(init, r));

  /// Applies [op] to this value and [init] if this is a [Right]. If this is
  /// a [Left], [init] is returned.
  @override
  R2 foldRight<R2>(R2 init, Function2<B, R2, R2> op) =>
      fold((_) => init, (r) => op(r, init));

  /// Returns thes value if this is a [Right], otherwise, the result of
  /// evaluating [orElse] is returned.
  B getOrElse(Function0<B> orElse) => fold((_) => orElse(), identity);

  /// Returns true if this is a [Left], otherwise false is returned.
  bool get isLeft => fold((_) => true, (_) => false);

  /// Returns true if this is a [Right], otherwise false is returned.
  bool get isRight => !isLeft;

  /// Returns a new Either by applying [f] to the value of this instance if
  /// it is a [Left].
  Either<C, B> leftMap<C>(Function1<A, C> f) =>
      fold((a) => left<C, B>(f(a)), (b) => right<C, B>(b));

  /// Returns a new Either by applying [f] to the value of this instance if
  /// it is a [Right].
  @override
  Either<A, C> map<C>(Function1<B, C> f) =>
      fold(left<A, C>, (r) => Right(f(r)));

  /// If this instance is a [Right], this is returned. Otherwise, the result of
  /// evaluating [orElse] is returned.
  Either<A, B> orElse(Function0<Either<A, B>> or) =>
      fold((a) => or(), (b) => this);

  /// Tuples the values of this Either and [other] if both are instances of
  /// [Right]. Otherwise, the first [Left] value is returned, this or [other]
  /// in that order.
  Either<A, (B, C)> product<C>(Either<A, C> other) => (this, other).tupled();

  /// Returns a new Either where the left and right types are swapped.
  Either<B, A> swap() => fold((a) => right<B, A>(a), (b) => left(b));

  /// Converts this Either to an [IList] with one element if this instance is
  /// a [Right] or an empty [IList] if this is a [Left].
  IList<B> toIList() => fold((_) => nil<B>(), (b) => IList.fromDart([b]));

  /// Converts this Either to an [Option]. If this instance is a [Right], the
  /// value will be returned as a [Some]. If this instance is a [Left], [None]
  /// will be returned.
  Option<B> toOption() => fold((_) => none<B>(), Some.new);

  /// Converts this Either to a [Validated], either an [Invalid] or [Valid]
  /// depending on whether this instance is a [Left] or [Right] respectively.
  Validated<A, B> toValidated() => fold((a) => a.invalid(), (b) => b.valid());

  @override
  String toString() => fold((a) => 'Left($a)', (b) => 'Right($b)');

  @override
  bool operator ==(Object other) => fold((a) => other is Left && a == other.a,
      (b) => other is Right && b == other.b);

  @override
  int get hashCode => fold((a) => a.hashCode, (b) => b.hashCode);
}

/// One of two possible instances of [Either], generally used to indicate
/// and error, or failure of some kind.
final class Left<A, B> extends Either<A, B> {
  final A a;

  const Left(this.a);

  @override
  C fold<C>(Function1<A, C> fa, Function1<B, C> fb) => fa(a);
}

/// One of two possible instances of [Either], generally used to indicate
/// a successful value.
final class Right<A, B> extends Either<A, B> {
  final B b;

  const Right(this.b);

  @override
  C fold<C>(Function1<A, C> fa, Function1<B, C> fb) => fb(b);
}

extension EitherNestedOps<A, B> on Either<A, Either<A, B>> {
  /// Extracts the nested [Either] via [fold].
  Either<A, B> flatten() => fold((a) => Either.left<A, B>(a), identity);
}
