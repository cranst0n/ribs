import 'package:ribs_core/src/effect/io.dart';
import 'package:ribs_core/src/function.dart';
import 'package:ribs_core/src/tuple.dart';

extension Tuple2IOOps<A, B> on Tuple2<IO<A>, IO<B>> {
  IO<C> mapN<C>(Function2<A, B, C> fn) => IO.map2($1, $2, fn);
  IO<C> parMapN<C>(Function2<A, B, C> fn) => IO.parMap2($1, $2, fn);

  IO<Tuple2<A, B>> sequence() => IO.tupled2($1, $2);
  IO<Tuple2<A, B>> parSequence() => IO.parTupled2($1, $2);
}

extension Tuple3IOOps<A, B, C> on Tuple3<IO<A>, IO<B>, IO<C>> {
  IO<D> mapN<D>(Function3<A, B, C, D> fn) => IO.map3($1, $2, $3, fn);
  IO<D> parMapN<D>(Function3<A, B, C, D> fn) => IO.parMap3($1, $2, $3, fn);

  IO<Tuple3<A, B, C>> sequence() => IO.tupled3($1, $2, $3);
  IO<Tuple3<A, B, C>> parSequence() => IO.parTupled3($1, $2, $3);
}

extension Tuple4IOOps<A, B, C, D> on Tuple4<IO<A>, IO<B>, IO<C>, IO<D>> {
  IO<E> mapN<E>(Function4<A, B, C, D, E> fn) => IO.map4($1, $2, $3, $4, fn);
  IO<E> parMapN<E>(Function4<A, B, C, D, E> fn) =>
      IO.parMap4($1, $2, $3, $4, fn);

  IO<Tuple4<A, B, C, D>> sequence() => IO.tupled4($1, $2, $3, $4);
  IO<Tuple4<A, B, C, D>> parSequence() => IO.parTupled4($1, $2, $3, $4);
}

extension Tuple5IOOps<A, B, C, D, E>
    on Tuple5<IO<A>, IO<B>, IO<C>, IO<D>, IO<E>> {
  IO<F> mapN<F>(Function5<A, B, C, D, E, F> fn) =>
      IO.map5($1, $2, $3, $4, $5, fn);
  IO<F> parMapN<F>(Function5<A, B, C, D, E, F> fn) =>
      IO.parMap5($1, $2, $3, $4, $5, fn);

  IO<Tuple5<A, B, C, D, E>> sequence() => IO.tupled5($1, $2, $3, $4, $5);
  IO<Tuple5<A, B, C, D, E>> parSequence() => IO.parTupled5($1, $2, $3, $4, $5);
}
