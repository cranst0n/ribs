import 'package:ribs_core/ribs_core.dart';

/// Until lambda destructuring arrives, this will provide a little bit
/// of convenience: https://github.com/dart-lang/language/issues/3001
extension FoldableTuple2Ops<A, B> on Foldable<(A, B)> {
  /// {@macro foldable_count}
  int countN(Function2<A, B, bool> f) => count(f.tupled);

  /// {@macro foldable_exists}
  bool existsN(Function2<A, B, bool> f) => exists(f.tupled);

  /// {@macro foldable_forall}
  bool forallN(Function2<A, B, bool> f) => forall(f.tupled);
}

/// Until lambda destructuring arrives, this will provide a little bit
/// of convenience: https://github.com/dart-lang/language/issues/3001
extension FoldableTuple3Ops<A, B, C> on Foldable<(A, B, C)> {
  /// {@macro foldable_count}
  int countN(Function3<A, B, C, bool> f) => count(f.tupled);

  /// {@macro foldable_exists}
  bool existsN(Function3<A, B, C, bool> f) => exists(f.tupled);

  /// {@macro foldable_forall}
  bool forallN(Function3<A, B, C, bool> f) => forall(f.tupled);
}
