import 'package:ribs_core/ribs_core.dart';

extension ISetNestedOps<A> on ISet<ISet<A>> {
  /// Combines all nested set into one set using concatenation.
  ISet<A> flatten() => fold(iset({}), (z, a) => z.concat(a.toIList()));
}

// Until lambda destructuring arrives, this will provide a little bit
// of convenience: https://github.com/dart-lang/language/issues/3001
extension ISetTuple2Ops<A, B> on ISet<(A, B)> {
  ISet<(A, B)> filterN(Function2<A, B, bool> p) => filter(p.tupled);

  ISet<(A, B)> filterNotN(Function2<A, B, bool> p) => filterNot(p.tupled);

  ISet<C> mapN<C>(Function2<A, B, C> f) => map(f.tupled);

  IMap<A, B> toIMap() => IMap.fromIList(toIList());

  Map<A, B> toMap() => Map.fromEntries(mapN((k, v) => MapEntry(k, v)).toList());
}
