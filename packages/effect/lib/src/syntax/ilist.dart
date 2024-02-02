import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_effect/ribs_effect.dart';

/// Operations avaiable when [IList] elements are of type [IO].
extension IListIOOps<A> on IList<IO<A>> {
  /// Alias for `traverseIO`, using [identity] as the function parameter.
  IO<IList<A>> sequence() => traverseIO(identity);

  /// Alias for `traverseIO_`, using [identity] as the function parameter.
  IO<Unit> sequence_() => traverseIO_(identity);

  /// Alias for `parTraverseIO`, using [identity] as the function parameter.
  IO<IList<A>> parSequence() => parTraverseIO(identity);

  /// Alias for `parTraverseIO_`, using [identity] as the function parameter.
  IO<Unit> parSequence_() => parTraverseIO_(identity);
}

extension IOIListOps<A> on IList<A> {
  /// {@template ilist_parTraverseIO}
  /// **Asynchronously** applies [f] to each element of this list and collects
  /// the results into a new list. If an error or cancelation is encountered
  /// for any element, that result is returned and all other elements will be
  /// canceled if possible.
  /// {@endtemplate}
  IO<IList<B>> parTraverseIO<B>(Function1<A, IO<B>> f) {
    IO<IList<B>> result = IO.pure(nil());

    foreach((elem) {
      result =
          IO.both(result, f(elem)).map((t) => t((acc, b) => acc.prepended(b)));
    });

    return result.map((a) => a.reverse());
  }

  /// {@template ilist_parTraverseIO_}
  /// **Asynchronously** applies [f] to each element of this list, discarding
  /// any results. If an error or cancelation is encountered for any element,
  /// that result is returned and all other elements will be canceled if
  /// possible.
  /// {@endtemplate}
  IO<Unit> parTraverseIO_<B>(Function1<A, IO<B>> f) {
    IO<Unit> result = IO.pure(Unit());

    foreach((elem) {
      result = IO.both(result, f(elem)).map((t) => t((acc, b) => Unit()));
    });

    return result;
  }

  /// {@template ilist_traverseIO}
  /// Applies [f] to each element of this list and collects the results into a
  /// new list. If an error or cancelation is encountered for any element,
  /// that result is returned and any additional elements will not be evaluated.
  /// {@endtemplate}
  IO<IList<B>> traverseIO<B>(Function1<A, IO<B>> f) {
    IO<IList<B>> result = IO.pure(nil());

    foreach((elem) {
      result = result.flatMap((l) => f(elem).map((b) => l.prepended(b)));
    });

    return result.map((a) => a.reverse());
  }

  /// {@template ilist_traverseIO_}
  /// Applies [f] to each element of this list, discarding any results. If an
  /// error or cancelation is encountered for any element, that result is
  /// returned and any additional elements will not be evaluated.
  /// {@endtemplate}
  IO<Unit> traverseIO_<B>(Function1<A, IO<B>> f) {
    var result = IO.pure(Unit());

    foreach((elem) {
      result = result.flatMap((l) => f(elem).map((b) => Unit()));
    });

    return result;
  }

  /// Applies [f] to each element of this list and collects the results into a
  /// new list that is flattened using concatenation. If an error or cancelation
  /// is encountered for any element, that result is returned and any additional
  /// elements will not be evaluated.
  IO<IList<B>> flatTraverseIO<B>(Function1<A, IO<IList<B>>> f) =>
      traverseIO(f).map((a) => a.flatten());

  /// {@template ilist_traverseFilterIO}
  /// Applies [f] to each element of this list and collects the results into a
  /// new list. Any results from [f] that are [None] are discarded from the
  /// resulting list. If an error or cancelation is encountered for any element,
  /// that result is returned and any additional elements will not be evaluated.
  /// {@endtemplate}
  IO<IList<B>> traverseFilterIO<B>(Function1<A, IO<Option<B>>> f) =>
      traverseIO(f).map((opts) => opts.foldLeft(IList.empty<B>(),
          (acc, elem) => elem.fold(() => acc, (elem) => acc.appended(elem))));
}
