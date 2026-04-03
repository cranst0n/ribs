import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_optics/ribs_optics.dart';

/// A [PPrism] where the source and target types are the same.
typedef Prism<S, A> = PPrism<S, S, A, A>;

/// An optic that focuses on a value of type [A] that may or may not be
/// present within a sum type [S], with the ability to construct [T] from [B].
///
/// A [PPrism] combines partial extraction ([getOrModify]) with total
/// construction ([reverseGet]). It is the dual of a [PLens]: where a lens
/// always extracts but may not construct, a prism always constructs but may
/// not extract.
class PPrism<S, T, A, B> extends POptional<S, T, A, B> {
  /// Constructs a [T] from a [B] value.
  final Function1<B, T> reverseGet;

  /// Creates a [PPrism] from a [getOrModify] function and a [reverseGet]
  /// function.
  PPrism(Function1<S, Either<T, A>> getOrModify, this.reverseGet)
    : super(getOrModify, (b) => (_) => reverseGet(b));

  /// A [Getter] that applies [reverseGet], viewing the prism in reverse.
  Getter<B, T> get re => Getter(reverseGet);

  /// Composes this prism with [other], producing a prism that focuses
  /// through [A] into [C].
  PPrism<S, T, C, D> andThenP<C, D>(PPrism<A, B, C, D> other) => PPrism<S, T, C, D>(
    (s) =>
        getOrModify(s).flatMap((a) => other.getOrModify(a).bimap((b) => replace(b)(s), identity)),
    (d) => reverseGet(other.reverseGet(d)),
  );
}
