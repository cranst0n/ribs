import 'package:ribs_core/ribs_core.dart';

/// A [PSetter] where the source and target types are the same.
typedef Setter<S, A> = PSetter<S, S, A, A>;

/// A write-only optic that can transform a focus [A] into [B] within a
/// structure [S], producing a new structure [T].
///
/// [PSetter] is the most general write-only optic. It supports polymorphic
/// updates where the focus type may change from [A] to [B].
class PSetter<S, T, A, B> {
  /// Applies a transformation [f] to every focus [A] within [S],
  /// producing a new structure [T].
  final Function2C<Function1<A, B>, S, T> modify;

  /// Creates a [PSetter] from a [modify] function.
  PSetter(this.modify);

  /// Replaces every focus with the constant value [b].
  Function1<S, T> replace(B b) => modify((_) => b);

  /// Composes this setter with [other], producing a setter that focuses
  /// through [A] into [C].
  PSetter<S, T, C, D> andThenS<C, D>(PSetter<A, B, C, D> other) {
    return PSetter<S, T, C, D>((f) => modify(other.modify(f)));
  }
}
