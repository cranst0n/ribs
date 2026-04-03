import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_optics/src/fold.dart';

/// A read-only optic that extracts exactly one value of type [A] from a
/// structure [S].
///
/// Unlike [Fold], a [Getter] always yields a value (never zero).
class Getter<S, A> extends Fold<S, A> {
  /// The extraction function from [S] to [A].
  final Function1<S, A> get;

  /// Creates a [Getter] with the given extraction function.
  Getter(this.get);

  @override
  Function1<S, Option<A>> find(Function1<A, bool> p) => (s) => Some(get(s)).filter(p);

  /// Composes this [Getter] with [other], producing a [Getter] that
  /// first extracts [A] from [S], then [B] from [A].
  Getter<S, B> andThenG<B>(Getter<A, B> other) => Getter((S s) => other.get(get(s)));
}
