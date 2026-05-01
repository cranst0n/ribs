import 'package:ribs_core/ribs_core.dart';

/// Aggregates two or more concurrent errors into a single throwable value.
///
/// Used internally when multiple finalizers or concurrent fibers fail at the
/// same time. Nested [CompositeFailure] instances are flattened so that [all]
/// always returns a flat, non-empty list of the original errors.
class CompositeFailure {
  /// The first error in this composite.
  final Object head;

  /// The remaining errors (at least one element).
  final NonEmptyIList<Object> tail;

  /// Creates a [CompositeFailure] from [first] and the non-empty [rest].
  ///
  /// Nested [CompositeFailure] instances in [first] or [rest] are flattened
  /// into a single level.
  factory CompositeFailure(Object first, NonEmptyIList<Object> rest) {
    NonEmptyIList<Object> flattenFailures(Object failure) => switch (failure) {
      final CompositeFailure cf => cf.all,
      _ => NonEmptyIList.one(failure),
    };

    return switch (first) {
      final CompositeFailure cf => CompositeFailure._(cf.head, cf.tail.concat(rest)),
      _ => CompositeFailure._(first, rest.flatMap(flattenFailures)),
    };
  }

  /// Creates a [CompositeFailure] from exactly two errors.
  factory CompositeFailure.of(Object first, Object second) => CompositeFailure(first, nel(second));

  const CompositeFailure._(this.head, this.tail);

  /// Returns a single error or a [CompositeFailure] for a non-empty error list.
  ///
  /// If [errors] contains exactly one element it is returned unwrapped;
  /// otherwise a [CompositeFailure] is returned.
  static Object fromNel(NonEmptyIList<Object> errors) => switch (errors) {
    _ when errors.size == 1 => errors.head,
    _ => CompositeFailure(errors.head, NonEmptyIList.unsafe(errors.tail)),
  };

  /// Returns [Some] error (or [CompositeFailure]) if [errors] is non-empty,
  /// or [none] if it is empty.
  static Option<Object> fromList(IList<Object> errors) => switch (errors) {
    _ when errors.isEmpty => none(),
    _ when errors.size == 1 => Some(errors.head),
    _ => Some(CompositeFailure(errors.head, NonEmptyIList.unsafe(errors.tail))),
  };

  /// Combines two [Either<Object, Unit>] outcomes.
  ///
  /// Both failures → [CompositeFailure]; one failure → that error; both
  /// successes → [Right].
  static Either<Object, Unit> fromResults(
    Either<Object, Unit> first,
    Either<Object, Unit> second,
  ) => first.fold(
    (err) => Left(second.fold((err1) => CompositeFailure._(err, nel(err1)), (_) => err)),
    (_) => second,
  );

  /// All errors in this composite (including [head]) as a flat non-empty list.
  NonEmptyIList<Object> get all => tail.prepended(head);

  @override
  String toString() => 'CompositeFailure(${all.mkString(sep: ', ')})';
}
