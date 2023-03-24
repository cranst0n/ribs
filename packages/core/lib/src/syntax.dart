import 'package:ribs_core/ribs_core.dart';

extension EitherSyntaxOps<A> on A {
  Either<A, B> asLeft<B>() => Either.left(this);
  Either<B, A> asRight<B>() => Either.right(this);
}

extension IterableOps<A> on Iterable<A> {
  IList<A> toIList() => ilist(toList());

  IO<List<B>> parTraverseIO<B>(Function1<A, IO<B>> f) => fold(
        IO.pure(List<B>.empty(growable: true)),
        (acc, elem) => IO.both(acc, f(elem)).map((t) => t.$1..add(t.$2)),
      );
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

extension Tuple2IOOps<A, B> on Tuple2<IO<A>, IO<B>> {
  IO<C> mapN<C>(Function2<A, B, C> fn) => IO.map2($1, $2, fn);

  IO<C> parMapN<C>(Function2<A, B, C> fn) => IO.parMap2($1, $2, fn);
}

extension Tuple3IOOps<A, B, C> on Tuple3<IO<A>, IO<B>, IO<C>> {
  IO<D> mapN<D>(Function3<A, B, C, D> fn) => IO.map3($1, $2, $3, fn);

  IO<D> parMapN<D>(Function3<A, B, C, D> fn) => IO.parMap3($1, $2, $3, fn);
}
