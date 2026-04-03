import 'package:ribs_core/ribs_core.dart';

/// An optic that can find zero or more focus values of type [A] within a
/// structure [S].
///
/// [Fold] is the most general read-only optic. It cannot modify the
/// structure — use [Setter] or a more specific optic for that.
abstract mixin class Fold<S, A> {
  /// Returns a predicate on [S] that is `true` when at least one focus
  /// satisfies [p].
  Function1<S, bool> exists(Function1<A, bool> p) => (s) => find(p)(s).isDefined;

  /// Returns a function that finds the first focus in [S] satisfying [p],
  /// or [None] if no match exists.
  Function1<S, Option<A>> find(Function1<A, bool> p);
}
