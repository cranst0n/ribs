import 'package:ribs_core/ribs_core.dart';

class CompositeError extends IOError {
  final IOError head;
  final NonEmptyIList<IOError> tail;

  CompositeError(this.head, this.tail) : super(head.message, head.stackTrace);

  @override
  Object get message =>
      'Multiple errors were thrown (${tail.size + 1}), first ${head.message}';

  NonEmptyIList<IOError> get all => NonEmptyIList(head, tail.toIList());

  static CompositeError from(
    IOError first,
    IOError second, [
    IList<IOError> rest = const IList.nil(),
  ]) =>
      CompositeError(first, NonEmptyIList.of(second, rest.toList()));

  static IOError fromNel(NonEmptyIList<IOError> errors) =>
      errors.tail.headOption.fold(
        () => errors.head,
        (second) => from(errors.head, second, errors.tail.tail()),
      );

  static Option<IOError> fromIList(IList<IOError> errors) =>
      errors.uncons((x) => x.map((a) => fromNel(NonEmptyIList(a.$1, a.$2))));

  static Either<IOError, Unit> fromResults(
    Either<IOError, Unit> first,
    Either<IOError, Unit> second,
  ) =>
      first.fold(
        (err) => Left(second.fold((err1) => from(err, err1), (_) => err)),
        (_) => second,
      );
}
