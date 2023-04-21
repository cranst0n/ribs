import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';

@immutable
sealed class Either<A, B> implements Monad<B>, Foldable<B> {
  const Either();

  static Either<A, B> left<A, B>(A a) => Left<A, B>(a);

  static Either<A, B> right<A, B>(B b) => Right<A, B>(b);

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

  static Either<A, B> cond<A, B>(
    Function0<bool> test,
    Function0<B> ifTrue,
    Function0<A> ifFalse,
  ) =>
      test() ? right(ifTrue()) : left(ifFalse());

  static Either<A, B> pure<A, B>(B b) => Right(b);

  C fold<C>(Function1<A, C> fa, Function1<B, C> fb);

  @override
  Either<A, C> ap<C>(Either<A, Function1<B, C>> f) => fold((a) => left<A, C>(a),
      (b) => f.fold((a) => left<A, C>(a), (f) => right(f(b))));

  Either<C, D> bimap<C, D>(Function1<A, C> fa, Function1<B, D> fb) =>
      fold((a) => left<C, D>(fa(a)), (b) => right(fb(b)));

  bool contains(B elem) => fold((_) => false, (b) => elem == b);

  Either<A, B> ensure(Function1<B, bool> p, Function0<A> onFailure) =>
      fold((_) => this, (b) => p(b) ? this : left(onFailure()));

  Either<A, B> filterOrElse(Function1<B, bool> p, Function0<A> zero) =>
      fold((_) => left<A, B>(zero()), (b) => p(b) ? this : left(zero()));

  @override
  Either<A, C> flatMap<C>(covariant Function1<B, Either<A, C>> f) =>
      fold(left<A, C>, f);

  @override
  R2 foldLeft<R2>(R2 init, Function2<R2, B, R2> op) =>
      fold((_) => init, (r) => op(init, r));

  @override
  R2 foldRight<R2>(R2 init, Function2<B, R2, R2> op) =>
      fold((_) => init, (r) => op(r, init));

  B getOrElse(Function0<B> orElse) => fold((_) => orElse(), id);

  bool get isLeft => fold((_) => true, (_) => false);

  bool get isRight => !isLeft;

  Either<C, B> leftMap<C>(Function1<A, C> f) =>
      fold((a) => left<C, B>(f(a)), (b) => right<C, B>(b));

  @override
  Either<A, C> map<C>(Function1<B, C> f) =>
      fold(left<A, C>, (r) => Right(f(r)));

  Either<A, B> orElse(Function0<Either<A, B>> or) =>
      fold((a) => or(), (b) => this);

  Either<A, (B, C)> product<C>(Either<A, C> other) => (this, other).sequence();

  Either<B, A> swap() => fold((a) => right<B, A>(a), (b) => left(b));

  IList<B> toIList() => fold((_) => nil<B>(), (b) => IList.pure(b));

  Option<B> toOption() => fold((_) => none<B>(), Some.new);

  Validated<A, B> toValidated() => fold((a) => a.invalid(), (b) => b.valid());

  @override
  String toString() => fold((a) => 'Left($a)', (b) => 'Right($b)');

  @override
  bool operator ==(Object other) => fold((a) => other is Left && a == other.a,
      (b) => other is Right && b == other.b);

  @override
  int get hashCode => fold((a) => a.hashCode, (b) => b.hashCode);
}

final class Left<A, B> extends Either<A, B> {
  final A a;

  const Left(this.a);

  @override
  C fold<C>(Function1<A, C> fa, Function1<B, C> fb) => fa(a);
}

final class Right<A, B> extends Either<A, B> {
  final B b;

  const Right(this.b);

  @override
  C fold<C>(Function1<A, C> fa, Function1<B, C> fb) => fb(b);
}

extension EitherNestedOps<A, B> on Either<A, Either<A, B>> {
  Either<A, B> flatten() => fold((a) => Either.left<A, B>(a), id);
}
