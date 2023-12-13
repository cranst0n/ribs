import 'package:ribs_core/ribs_core.dart';

/// A [Foldable] is a type that can be folded into a symmary value. For a [List]
/// that would entail combining all of the elements in the list together,
/// resulting in a single value.
abstract class Foldable<A> {
  /// Applies the given binary operator to the start value and all values of
  /// this [Foldable], moving left to right.
  B foldLeft<B>(B init, Function2<B, A, B> op);

  /// Applies the given binary operator to the start value and all values of
  /// this [Foldable], moving right to left.
  B foldRight<B>(B init, Function2<A, B, B> op);
}

extension FoldableOps<A> on Foldable<A> {
  /// {@template foldable_count}
  /// Return the number of elements in this [Foldable] that satisfy the given
  /// predicate.
  /// {@endtemplate}
  int count(Function1<A, bool> p) =>
      foldLeft(0, (count, elem) => count + (p(elem) ? 1 : 0));

  /// {@template foldable_forall}
  /// Returns true if **all** elements of this [Foldable] satisfy the given
  /// predicate, false if any elements do not.
  /// {@endtemplate}
  bool forall(Function1<A, bool> p) =>
      foldLeft(true, (acc, elem) => acc && p(elem));

  /// {@template foldable_exists}
  /// Returns true if **any** element of this [Foldable] satisfies the given
  /// predicate, false if no elements satisfy it.
  /// {@endtemplate}
  bool exists(Function1<A, bool> p) =>
      foldLeft(false, (acc, elem) => acc || p(elem));

  /// Returns true if this [Foldable] contains no elements, otherwise false.
  bool get isEmpty => size == 0;

  /// Returns true if this [Foldable] contains at least one element, otherwise
  /// false.
  bool get nonEmpty => size > 0;

  /// Returns the total number of elements this [Foldable] contains.
  int get size => foldLeft(0, (acc, _) => acc + 1);
}
