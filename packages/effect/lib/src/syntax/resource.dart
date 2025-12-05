import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

/// Until lambda destructuring arrives, this will provide a little bit
/// of convenience: https://github.com/dart-lang/language/issues/3001
extension ResourceTuple2Ops<A, B> on Resource<(A, B)> {
  Resource<C> evalMapN<C>(Function2<A, B, IO<C>> f) => evalMap(f.tupled);

  Resource<(A, B)> evalTapN<C>(Function2<A, B, IO<C>> f) => evalTap(f.tupled);

  Resource<C> flatMapN<C>(Function2<A, B, Resource<C>> f) => flatMap(f.tupled);

  Resource<C> mapN<C>(Function2<A, B, C> f) => map(f.tupled);

  IO<C> useN<C>(Function2<A, B, IO<C>> f) => use(f.tupled);
}

/// Until lambda destructuring arrives, this will provide a little bit
/// of convenience: https://github.com/dart-lang/language/issues/3001
extension ResourceTuple3Ops<A, B, C> on Resource<(A, B, C)> {
  Resource<D> evalMapN<D>(Function3<A, B, C, IO<D>> f) => evalMap(f.tupled);

  Resource<(A, B, C)> evalTapN<D>(Function3<A, B, C, IO<D>> f) => evalTap(f.tupled);

  Resource<D> flatMapN<D>(Function3<A, B, C, Resource<D>> f) => flatMap(f.tupled);

  Resource<D> mapN<D>(Function3<A, B, C, D> f) => map(f.tupled);

  IO<D> useN<D>(Function3<A, B, C, IO<D>> f) => use(f.tupled);
}

/// {@template resource_tuple_ops}
/// Functions available on a tuple of [Resource]s.
/// {@endtemplate}
extension Tuple2ResourceOps<A, B> on (Resource<A>, Resource<B>) {
  /// {@template resource_mapN}
  /// TODO:
  /// {@endtemplate}
  Resource<C> mapN<C>(Function2<A, B, C> fn) => tupled().map(fn.tupled);

  /// {@template resource_parMapN}
  /// TODO:
  /// {@endtemplate}
  Resource<C> parMapN<C>(Function2<A, B, C> fn) => parTupled().map(fn.tupled);

  /// {@template resource_tupled}
  /// TODO:
  /// {@endtemplate}
  Resource<(A, B)> tupled() => $1.flatMap((a) => $2.map((b) => (a, b)));

  /// {@template resource_parTupled}
  /// TODO:
  /// {@endtemplate}
  Resource<(A, B)> parTupled() => Resource.both($1, $2);
}

/// {@macro resource_tuple_ops}
extension Tuple3ResourceOps<A, B, C> on (Resource<A>, Resource<B>, Resource<C>) {
  /// {@macro resource_mapN}
  Resource<D> mapN<D>(Function3<A, B, C, D> fn) => tupled().map(fn.tupled);

  /// {@macro resource_parMapN}
  Resource<D> parMapN<D>(Function3<A, B, C, D> fn) => parTupled().map(fn.tupled);

  /// {@macro resource_tupled}
  Resource<(A, B, C)> tupled() => init().tupled().flatMap((x) => last.map((a) => x.append(a)));

  /// {@macro resource_parTupled}
  Resource<(A, B, C)> parTupled() =>
      Resource.both(init().parTupled(), last).map((t) => t.$1.append(t.$2));
}

/// {@macro resource_tuple_ops}
extension Tuple4ResourceOps<A, B, C, D> on (Resource<A>, Resource<B>, Resource<C>, Resource<D>) {
  /// {@macro resource_mapN}
  Resource<E> mapN<E>(Function4<A, B, C, D, E> fn) => tupled().map(fn.tupled);

  /// {@macro resource_parMapN}
  Resource<E> parMapN<E>(Function4<A, B, C, D, E> fn) => parTupled().map(fn.tupled);

  /// {@macro resource_tupled}
  Resource<(A, B, C, D)> tupled() => init().tupled().flatMap((x) => last.map((a) => x.append(a)));

  /// {@macro resource_parTupled}
  Resource<(A, B, C, D)> parTupled() =>
      Resource.both(init().parTupled(), last).map((t) => t.$1.append(t.$2));
}

/// {@macro resource_tuple_ops}
extension Tuple5ResourceOps<A, B, C, D, E> on (
  Resource<A>,
  Resource<B>,
  Resource<C>,
  Resource<D>,
  Resource<E>
) {
  /// {@macro resource_mapN}
  Resource<F> mapN<F>(Function5<A, B, C, D, E, F> fn) => tupled().map(fn.tupled);

  /// {@macro resource_parMapN}
  Resource<F> parMapN<F>(Function5<A, B, C, D, E, F> fn) => parTupled().map(fn.tupled);

  /// {@macro resource_tupled}
  Resource<(A, B, C, D, E)> tupled() =>
      init().tupled().flatMap((x) => last.map((a) => x.append(a)));

  /// {@macro resource_parTupled}
  Resource<(A, B, C, D, E)> parTupled() =>
      Resource.both(init().parTupled(), last).map((t) => t.$1.append(t.$2));
}
