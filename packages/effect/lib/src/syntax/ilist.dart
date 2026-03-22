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
      result = IO.both(result, f(elem)).map((t) => t((acc, b) => acc.prepended(b)));
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
  IO<IList<B>> traverseFilterIO<B>(Function1<A, IO<Option<B>>> f) => traverseIO(f).map(
    (opts) => opts.foldLeft(
      IList.empty<B>(),
      (acc, elem) => elem.fold(() => acc, (elem) => acc.appended(elem)),
    ),
  );
}

extension IListConcurrencyOps<A> on IList<A> {
  /// Maps [f] over the list concurrently, running at most [n] tasks at a time.
  IO<IList<B>> parTraverseION<B>(int n, IO<B> Function(A) f) {
    if (n <= 0) throw ArgumentError("Concurrency limit 'n' must be > 0");

    return Semaphore.permits(
      n,
    ).flatMap((sem) => parTraverseIO((a) => sem.permit().use((_) => f(a))));
  }
}

/// Operations available when [IList] elements are of type [Resource].
extension IListResourceOps<A> on IList<Resource<A>> {
  /// Alias for `traverseResource`, using [identity] as the function parameter.
  Resource<IList<A>> sequence() => traverseResource(identity);

  /// Alias for `traverseResource_`, using [identity] as the function parameter.
  Resource<Unit> sequence_() => traverseResource_(identity);

  /// Alias for `parTraverseResource`, using [identity] as the function parameter.
  Resource<IList<A>> parSequence() => parTraverseResource(identity);

  /// Alias for `parTraverseResource_`, using [identity] as the function parameter.
  Resource<Unit> parSequence_() => parTraverseResource_(identity);
}

extension ResourceIListOps<A> on IList<A> {
  /// {@template ilist_parTraverseResource}
  /// **Asynchronously** applies [f] to each element of this list and collects
  /// the results into a new list. Resources are allocated in parallel; if any
  /// allocation fails, all others are released.
  /// {@endtemplate}
  Resource<IList<B>> parTraverseResource<B>(Function1<A, Resource<B>> f) {
    Resource<IList<B>> result = Resource.pure(nil());

    foreach((elem) {
      result = Resource.both(result, f(elem)).map((t) => t((acc, b) => acc.prepended(b)));
    });

    return result.map((a) => a.reverse());
  }

  /// {@template ilist_parTraverseResource_}
  /// **Asynchronously** applies [f] to each element of this list, discarding
  /// any results. Resources are allocated in parallel; if any allocation
  /// fails, all others are released.
  /// {@endtemplate}
  Resource<Unit> parTraverseResource_<B>(Function1<A, Resource<B>> f) {
    Resource<Unit> result = Resource.pure(Unit());

    foreach((elem) {
      result = Resource.both(result, f(elem)).map((t) => t((acc, b) => Unit()));
    });

    return result;
  }

  /// {@template ilist_traverseResource}
  /// Applies [f] to each element of this list and collects the results into a
  /// new list. Resources are allocated sequentially; if any allocation fails,
  /// previously allocated resources are released.
  /// {@endtemplate}
  Resource<IList<B>> traverseResource<B>(Function1<A, Resource<B>> f) {
    Resource<IList<B>> result = Resource.pure(nil());

    foreach((elem) {
      result = result.flatMap((l) => f(elem).map((b) => l.prepended(b)));
    });

    return result.map((a) => a.reverse());
  }

  /// {@template ilist_traverseResource_}
  /// Applies [f] to each element of this list, discarding any results.
  /// Resources are allocated sequentially; if any allocation fails, previously
  /// allocated resources are released.
  /// {@endtemplate}
  Resource<Unit> traverseResource_<B>(Function1<A, Resource<B>> f) {
    var result = Resource.pure(Unit());

    foreach((elem) {
      result = result.flatMap((_) => f(elem).voided());
    });

    return result;
  }

  /// Applies [f] to each element of this list and collects the results into a
  /// new list that is flattened using concatenation. Resources are allocated
  /// sequentially.
  Resource<IList<B>> flatTraverseResource<B>(Function1<A, Resource<IList<B>>> f) =>
      traverseResource(f).map((a) => a.flatten());

  /// {@template ilist_traverseFilterResource}
  /// Applies [f] to each element of this list and collects the results into a
  /// new list. Any results from [f] that are [None] are discarded from the
  /// resulting list. Resources are allocated sequentially.
  /// {@endtemplate}
  Resource<IList<B>> traverseFilterResource<B>(Function1<A, Resource<Option<B>>> f) =>
      traverseResource(f).map(
        (opts) => opts.foldLeft(
          IList.empty<B>(),
          (acc, elem) => elem.fold(() => acc, (elem) => acc.appended(elem)),
        ),
      );
}
