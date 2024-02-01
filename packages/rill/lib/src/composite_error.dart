import 'package:ribs_core/ribs_core.dart';

class CompositeError extends RuntimeException {
  final RuntimeException head;
  final NonEmptyIList<RuntimeException> tail;

  CompositeError(this.head, this.tail) : super(head.message, head.stackTrace);

  @override
  Object get message =>
      'Multiple errors were thrown (${tail.size + 1}), first ${head.message}';

  NonEmptyIList<RuntimeException> get all =>
      NonEmptyIList(head, tail.toIList());

  static CompositeError from(
    RuntimeException first,
    RuntimeException second, [
    IList<RuntimeException> rest = const Nil(),
  ]) =>
      CompositeError(first, nel(second, rest.toList()));

  static RuntimeException fromNel(NonEmptyIList<RuntimeException> errors) =>
      errors.tail().headOption.fold(
            () => errors.head,
            (second) => from(errors.head, second, errors.tail().tail()),
          );

  static Option<RuntimeException> fromIList(IList<RuntimeException> errors) =>
      errors.uncons((x) => x.map((a) => fromNel(NonEmptyIList(a.$1, a.$2))));

  static Either<RuntimeException, Unit> fromResults(
    Either<RuntimeException, Unit> first,
    Either<RuntimeException, Unit> second,
  ) =>
      first.fold(
        (err) => Left(second.fold((err1) => from(err, err1), (_) => err)),
        (_) => second,
      );
}
