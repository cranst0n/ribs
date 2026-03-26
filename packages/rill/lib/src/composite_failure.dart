import 'package:ribs_core/ribs_core.dart';

class CompositeFailure {
  final Object head;
  final NonEmptyIList<Object> tail;

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

  factory CompositeFailure.of(Object first, Object second) => CompositeFailure(first, nel(second));

  const CompositeFailure._(this.head, this.tail);

  static Object fromNel(NonEmptyIList<Object> errors) => switch (errors) {
    _ when errors.size == 1 => errors.head,
    _ => CompositeFailure(errors.head, NonEmptyIList.unsafe(errors.tail)),
  };

  static Option<Object> fromList(IList<Object> errors) => switch (errors) {
    _ when errors.isEmpty => none(),
    _ when errors.size == 1 => Some(errors.head),
    _ => Some(CompositeFailure(errors.head, NonEmptyIList.unsafe(errors.tail))),
  };

  static Either<Object, Unit> fromResults(
    Either<Object, Unit> first,
    Either<Object, Unit> second,
  ) => first.fold(
    (err) => Left(second.fold((err1) => CompositeFailure._(err, nel(err1)), (_) => err)),
    (_) => second,
  );

  NonEmptyIList<Object> get all => tail.prepended(head);

  @override
  String toString() => 'CompositeFailure(${all.mkString(sep: ', ')})';
}
