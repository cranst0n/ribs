import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';

Option<A> none<A>() => None<A>();

@immutable
sealed class Option<A> implements Monad<A>, Foldable<A> {
  const Option();

  factory Option.of(A? a) => a == null ? none<A>() : Some(a);

  factory Option.pure(A a) => Some(a);

  factory Option.unless(Function0<bool> condition, Function0<A> a) =>
      condition() ? None<A>() : Some(a());

  factory Option.when(Function0<bool> condition, Function0<A> a) =>
      condition() ? Some(a()) : None<A>();

  B fold<B>(Function0<B> ifEmpty, Function1<A, B> f);

  @override
  Option<B> ap<B>(Option<Function1<A, B>> f) =>
      flatMap((a) => f.map((f) => f(a)));

  bool get isDefined => fold(() => false, (_) => true);

  bool get isEmpty => !isDefined;

  Option<A> filter(Function1<A, bool> p) =>
      fold(() => this, (a) => p(a) ? this : const None());

  Option<A> filterNot(Function1<A, bool> p) => filter((a) => !p(a));

  @override
  Option<B> flatMap<B>(covariant Function1<A, Option<B>> f) =>
      fold(() => none<B>(), f);

  @override
  B foldLeft<B>(B init, Function2<B, A, B> op) =>
      fold(() => init, (a) => op(init, a));

  @override
  B foldRight<B>(B init, Function2<A, B, B> op) =>
      fold(() => init, (a) => op(a, init));

  A getOrElse(Function0<A> ifEmpty) => fold(() => ifEmpty(), id);

  void forEach(Function1<A, void> ifSome) {
    if (this is Some<A>) {
      ifSome((this as Some<A>).value);
    }
  }

  @override
  Option<B> map<B>(Function1<A, B> f) => flatMap((a) => Some(f(a)));

  bool get nonEmpty => isDefined;

  Option<A> orElse(Function0<Option<A>> orElse) =>
      fold(() => orElse(), (_) => this);

  IList<A> toIList() => fold(() => nil<A>(), (a) => ilist([a]));

  Either<A, X> toLeft<X>(Function0<X> ifEmpty) =>
      fold(() => Either.right<A, X>(ifEmpty()), (x) => Either.left<A, X>(x));

  Either<X, A> toRight<X>(Function0<X> ifEmpty) =>
      fold(() => Either.left<X, A>(ifEmpty()), (x) => Either.right<X, A>(x));

  A? toNullable() => fold(() => null, id);

  @override
  String toString() => fold(() => 'None', (a) => 'Some($a)');

  IO<Option<B>> traverseIO<B>(Function1<A, IO<B>> f) =>
      fold(() => IO.none(), (a) => f(a).map((a) => a.some));

  @override
  bool operator ==(Object other) => fold(
        () => other is None,
        (value) => other is Some<A> && value == other.value,
      );

  @override
  int get hashCode => fold(() => 0, (a) => a.hashCode);
}

final class Some<A> extends Option<A> {
  final A value;

  const Some(this.value);

  @override
  B fold<B>(Function0<B> ifEmpty, Function1<A, B> f) => f(value);
}

final class None<A> extends Option<A> {
  const None();

  @override
  B fold<B>(Function0<B> ifEmpty, Function1<A, B> f) => ifEmpty();
}

extension OptionNestedOps<A> on Option<Option<A>> {
  Option<A> flatten() => fold(() => none<A>(), id);
}
