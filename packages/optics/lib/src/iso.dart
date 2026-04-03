import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_optics/src/lens.dart';
import 'package:ribs_optics/src/setter.dart';

/// A [PIso] where the source and target types are the same.
typedef Iso<S, A> = PIso<S, S, A, A>;

/// An optic representing a lossless, reversible conversion between types
/// [S] and [A].
///
/// A [PIso] is both a [PLens] and a [PPrism] — it can always extract [A]
/// from [S] and always construct [T] from [B]. It supports polymorphic
/// updates where the types may change.
class PIso<S, T, A, B> extends PLens<S, T, A, B> {
  /// Constructs a [T] from a [B] value (the reverse direction).
  final Function1<B, T> reverseGet;

  /// Creates a [PIso] from a forward [get] and a backward [reverseGet].
  PIso(Function1<S, A> get, this.reverseGet) : super(get, (b) => (_) => reverseGet(b));

  // @override
  // A get(S s) => _get(s);

  // @override
  // Function1<S, T> modify(Function1<A, B> f) => (s) => reverseGet(f(get(s)));

  /// Returns the reverse isomorphism, swapping the forward and backward
  /// directions.
  PIso<B, A, T, S> reverse() => PIso<B, A, T, S>(reverseGet, get);

  /// Composes this iso with [other], producing an iso that converts
  /// from [S] through [A] into [C].
  PIso<S, T, C, D> andThen<C, D>(PIso<A, B, C, D> other) => PIso<S, T, C, D>(
    (s) => other.get(get(s)),
    (d) => reverseGet(other.reverseGet(d)),
  );

  /// Views this [PIso] as a [PSetter].
  PSetter<S, T, A, B> asSetter() => this;
}
