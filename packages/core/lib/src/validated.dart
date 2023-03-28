import 'package:ribs_core/ribs_core.dart';

typedef ValidatedNel<E, A> = Validated<NonEmptyIList<E>, A>;

abstract class Validated<E, A> implements Functor<A> {
  static Validated<E, A> invalid<E, A>(E e) => Invalid(e);

  static Validated<E, A> valid<E, A>(A a) => Valid(a);

  B fold<B>(Function1<E, B> fe, Function1<A, B> fa);

  Validated<EE, AA> bimap<EE, AA>(Function1<E, EE> fe, Function1<A, AA> fa) =>
      fold((e) => fe(e).invalid(), (a) => fa(a).valid());

  bool exists(Function1<A, bool> p) => fold((_) => false, p);

  bool forall(Function1<A, bool> p) => fold((_) => true, p);

  A getOrElse(Function0<A> orElse) => fold((_) => orElse(), id);

  bool get isValid => fold((_) => false, (_) => true);

  bool get isInvalid => !isValid;

  Validated<EE, A> leftMap<EE>(Function1<E, EE> f) =>
      fold((e) => f(e).invalid(), (a) => a.valid());

  @override
  Validated<E, B> map<B>(Function1<A, B> f) =>
      fold((e) => e.invalid(), (a) => f(a).valid());

  Validated<E, A> orElse(Function0<Validated<E, A>> orElse) =>
      fold((_) => orElse(), (a) => this);

  Validated<A, E> swap() => fold((e) => e.valid(), (a) => a.invalid());

  Either<E, A> toEither() => fold((e) => e.asLeft(), (a) => a.asRight());

  IList<A> toIList() => fold((_) => nil(), (a) => IList.of([a]));

  Option<A> toOption() => fold((_) => none(), (a) => a.some);

  A valueOr(Function1<E, A> f) => fold(f, id);

  @override
  String toString() => fold((a) => 'Left($a)', (b) => 'Right($b)');

  @override
  bool operator ==(Object other) => fold(
        (e) => other is Invalid<E, A> && other.value == e,
        (a) => other is Valid<E, A> && other.value == a,
      );

  @override
  int get hashCode => fold((e) => e.hashCode, (a) => a.hashCode);
}

class Valid<E, A> extends Validated<E, A> {
  final A value;

  Valid(this.value);

  @override
  B fold<B>(Function1<E, B> fe, Function1<A, B> fa) => fa(value);
}

class Invalid<E, A> extends Validated<E, A> {
  final E value;

  Invalid(this.value);

  @override
  B fold<B>(Function1<E, B> fe, Function1<A, B> fa) => fe(value);
}

extension ValidatedNelOps<E, A> on ValidatedNel<E, A> {
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

  ValidatedNel<E, Tuple2<A, B>> product<B>(ValidatedNel<E, B> f) {
    return fold(
      (e) => f.fold(
        (ef) => e.concatNel(ef).invalid(),
        (af) => e.invalid(),
      ),
      (a) => f.fold(
        (ef) => ef.invalid(),
        (af) => Tuple2(a, af).validNel<E>(),
      ),
    );
  }
}
