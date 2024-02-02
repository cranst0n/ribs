import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

extension IONonEmptyIListOps<A> on NonEmptyIList<A> {
  /// Applies [f] to each element of this list and collects the results into a
  /// new list. If an error or cancelation is encountered for any element,
  /// that result is returned and any additional elements will not be evaluated.
  IO<NonEmptyIList<B>> traverseIO<B>(Function1<A, IO<B>> f) => f(head)
      .flatMap((h) => tail().traverseIO(f).map((t) => NonEmptyIList(h, t)));

  /// Applies [f] to each element of this list, discarding any results. If an
  /// error or cancelation is encountered for any element, that result is
  /// returned and any additional elements will not be evaluated.
  IO<Unit> traverseIO_<B>(Function1<A, IO<B>> f) => toIList().traverseIO_(f);

  /// Applies [f] to each element of this list and collects the results into a
  /// new list that is flattened using concatenation. If an error or cancelation
  /// is encountered for any element, that result is returned and any additional
  /// elements will not be evaluated.
  IO<IList<B>> flatTraverseIO<B>(Function1<A, IO<IList<B>>> f) =>
      toIList().flatTraverseIO(f);

  /// Applies [f] to each element of this list and collects the results into a
  /// new list. Any results from [f] that are [None] are discarded from the
  /// resulting list. If an error or cancelation is encountered for any element,
  /// that result is returned and any additional elements will not be evaluated.
  IO<IList<B>> traverseFilterIO<B>(Function1<A, IO<Option<B>>> f) =>
      toIList().traverseFilterIO(f);

  /// **Asynchronously** applies [f] to each element of this list and collects
  /// the results into a new list. If an error or cancelation is encountered
  /// for any element, that result is returned and all other elements will be
  /// canceled if possible.
  IO<NonEmptyIList<B>> parTraverseIO<B>(Function1<A, IO<B>> f) => IO
      .both(f(head), tail().parTraverseIO(f))
      .map((t) => NonEmptyIList(t.$1, t.$2));

  /// **Asynchronously** applies [f] to each element of this list, discarding
  /// any results. If an error or cancelation is encountered for any element,
  /// that result is returned and all other elements will be canceled if
  /// possible.
  IO<Unit> parTraverseIO_<B>(Function1<A, IO<B>> f) =>
      toIList().parTraverseIO_(f);
}

/// Operations avaiable when [NonEmptyIList] elements are of type [IO].
extension NonEmptyIListIOOps<A> on NonEmptyIList<IO<A>> {
  /// Alias for `traverseIO`, using [identity] as the function parameter.
  IO<NonEmptyIList<A>> sequence() => traverseIO(identity);

  /// Alias for `traverseIO_`, using [identity] as the function parameter.
  IO<Unit> sequence_() => traverseIO_(identity);

  /// Alias for `parTraverseIO`, using [identity] as the function parameter.
  IO<NonEmptyIList<A>> parSequence() => parTraverseIO(identity);

  /// Alias for `parTraverseIO_`, using [identity] as the function parameter.
  IO<Unit> parSequence_() => parTraverseIO_(identity);
}
