import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_optics/ribs_optics.dart';

/// A [PLens] where the source and target types are the same.
typedef Lens<S, A> = PLens<S, S, A, A>;

/// An optic that focuses on exactly one value of type [A] within a
/// structure [S], with the ability to both read and modify.
///
/// A [PLens] is like a [POptional] that always succeeds — the focus is
/// guaranteed to exist. It supports polymorphic updates where the focus
/// type may change from [A] to [B].
class PLens<S, T, A, B> extends POptional<S, T, A, B> with Fold<S, A> {
  /// Extracts the focus [A] from [S]. Unlike [POptional.getOrModify],
  /// this always succeeds.
  final Function1<S, A> get;

  /// Creates a [PLens] from a [get] function and a [set] function.
  PLens(this.get, Function2C<B, S, T> set) : super((s) => get(s).asRight(), set);

  /// Composes this lens with a [Getter], producing a [Getter] that
  /// focuses through [A] into [C].
  Getter<S, C> andThenG<C>(Getter<A, C> other) => Getter((S s) => other.get(get(s)));

  /// Composes this lens with [other], producing a lens that focuses
  /// through [A] into [C].
  PLens<S, T, C, D> andThenL<C, D>(PLens<A, B, C, D> other) => PLens<S, T, C, D>(
    (s) => other.get(get(s)),
    (d) => modify(other.replace(d)),
  );
}
