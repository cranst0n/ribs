import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_optics/ribs_optics.dart';

/// A [POptional] where the source and target types are the same.
typedef Optional<S, A> = POptional<S, S, A, A>;

/// An optic that focuses on zero or one value of type [A] within a
/// structure [S], with the ability to read and modify.
///
/// [POptional] extends [PSetter] with the ability to attempt extraction
/// via [getOrModify]. It supports polymorphic updates where the focus
/// type may change from [A] to [B].
class POptional<S, T, A, B> extends PSetter<S, T, A, B> with Fold<S, A> {
  /// Attempts to extract the focus [A] from [S]. Returns [Right] with the
  /// value on success, or [Left] with the unmodified structure [T] if the
  /// focus is absent.
  final Function1<S, Either<T, A>> getOrModify;

  /// Creates a [POptional] from a [getOrModify] function and a [set]
  /// function.
  POptional(this.getOrModify, Function2C<B, S, T> set)
    : super((f) => (s) => getOrModify(s).fold(identity, (a) => set(f(a))(s)));

  /// Extracts the focus as an [Option], returning [None] if absent.
  Option<A> getOption(S s) => getOrModify(s).toOption();

  /// Like [modify], but returns [None] if the focus is absent instead of
  /// returning the structure unchanged.
  Function1<S, Option<T>> modifyOption(Function1<A, B> f) =>
      (s) => getOption(s).map((a) => replace(f(a))(s));

  /// Like [replace], but returns [None] if the focus is absent.
  Function1<S, Option<T>> replaceOption(B b) => modifyOption((_) => b);

  @override
  Function1<S, Option<A>> find(Function1<A, bool> p) => (s) => getOption(s).filter(p);

  /// Composes this optional with [other], producing an optional that
  /// focuses through [A] into [C].
  POptional<S, T, C, D> andThenO<C, D>(POptional<A, B, C, D> other) => POptional<S, T, C, D>(
    (s) =>
        getOrModify(s).flatMap((a) => other.getOrModify(a).bimap((b) => replace(b)(s), (c) => c)),
    (d) => modify(other.replace(d)),
  );
}
