import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

@immutable
final class PathToRoot {
  final IList<PathElem> value;

  const PathToRoot(this.value);

  String asPathString() => PathToRoot.toPathString(this);

  PathToRoot appendElem(PathElem elem) => PathToRoot(value.appended(elem));

  PathToRoot prependElem(PathElem elem) => PathToRoot(value.prepended(elem));

  static PathToRoot empty = PathToRoot(IList.empty());

  static String toPathString(PathToRoot path) {
    if (path.value.isEmpty) {
      return '';
    } else {
      return path.value.foldLeft(
        '',
        (acc, elem) => switch (elem) {
          final ObjectKey elem => '$acc.${elem.keyName}',
          final ArrayIndex elem => '$acc[${elem.index}]',
        },
      );
    }
  }

  static Either<String, PathToRoot> fromHistory(IList<CursorOp> ops) {
    final initial = Either.right<String, IList<PathElem>>(IList.empty());

    return ops
        .reverse()
        .foldLeft<Either<String, IList<PathElem>>>(
          initial,
          (acc, op) {
            return acc.flatMap((acc) {
              final result = _onMoveLeft(acc, op)
                  .orElse(() => _onMoveRight(acc, op))
                  .orElse(() => _onMoveUp(acc, op))
                  .orElse(() => _onField(acc, op))
                  .orElse(() => _onDownField(acc, op))
                  .orElse(() => _onDownArray(acc, op))
                  .orElse(() => _onDownN(acc, op))
                  .orElse(() => _onDeleteGoParent(acc, op));

              return result.fold(
                () => Left('Invalid cursor history state: $op'),
                (a) => a.fold((a) => a.asLeft(), (x) => x.asRight()),
              );
            });
          },
        )
        .map(PathToRoot.new);
  }

  static Option<Either<String, IList<PathElem>>> _onMoveLeft(
    IList<PathElem> acc,
    CursorOp op,
  ) {
    return Option.when(() => op is MoveLeft, () {
      return acc.lastOption.flatMap((lastOp) => lastOp.asArrayIndex()).map((arrIx) {
        return Either.cond(
          () => arrIx.index >= 0,
          () => acc.appended(PathElem.arrayIndex(arrIx.index - 1)),
          () => 'Attempt to move beyond beginning of array.',
        );
      });
    }).flatten();
  }

  static Option<Either<String, IList<PathElem>>> _onMoveRight(
    IList<PathElem> acc,
    CursorOp op,
  ) {
    return Option.when(() => op is MoveRight, () {
      return acc.lastOption.flatMap((lastOp) => lastOp.asArrayIndex()).map((arrIx) {
        return Either.cond(
          () => arrIx.index < Integer.MaxValue,
          () => acc.appended(PathElem.arrayIndex(arrIx.index + 1)),
          () => 'Attempt to move to index > ${Integer.MaxValue} in array.',
        );
      });
    }).flatten();
  }

  static Option<Either<String, IList<PathElem>>> _onMoveUp(
    IList<PathElem> acc,
    CursorOp op,
  ) {
    return Option.when(() => op is MoveUp, () {
      return Either.cond(
        () => acc.nonEmpty,
        () => acc,
        () => 'Attempt to move up above the root of the JSON.',
      );
    });
  }

  static Option<Either<String, IList<PathElem>>> _onField(
    IList<PathElem> acc,
    CursorOp op,
  ) {
    return Option.when(() => op is Field, () {
      return Either.cond(
        () => acc.lastOption.exists((pe) => pe is ObjectKey),
        () => acc.appended(PathElem.objectKey((op as Field).key)),
        () =>
            'Attempt to move to sibling field, but cursor history didnt indicate we were in an object.',
      );
    });
  }

  static Option<Either<String, IList<PathElem>>> _onDownField(
    IList<PathElem> acc,
    CursorOp op,
  ) {
    return Option.when(() => op is DownField, () {
      return Right(acc.appended(PathElem.objectKey((op as DownField).key)));
    });
  }

  static Option<Either<String, IList<PathElem>>> _onDownArray(
    IList<PathElem> acc,
    CursorOp op,
  ) {
    return Option.when(() => op is DownArray, () {
      return Right(acc.appended(PathElem.arrayIndex(0)));
    });
  }

  static Option<Either<String, IList<PathElem>>> _onDownN(
    IList<PathElem> acc,
    CursorOp op,
  ) {
    return Option.when(() => op is DownN, () {
      return Right(acc.appended(PathElem.arrayIndex((op as DownN).n)));
    });
  }

  static Option<Either<String, IList<PathElem>>> _onDeleteGoParent(
    IList<PathElem> acc,
    CursorOp op,
  ) {
    return Option.when(() => op is DeleteGoParent, () {
      return Either.cond(
        () => acc.nonEmpty,
        () => acc,
        () => 'Attempt to move up above the root of the JSON.',
      );
    });
  }

  @override
  String toString() => 'PathToRoot(${toPathString(this)})';

  @override
  bool operator ==(Object other) => other is PathToRoot && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

@immutable
sealed class PathElem {
  static PathElem objectKey(String keyName) => ObjectKey(keyName);
  static PathElem arrayIndex(int index) => ArrayIndex(index);

  Option<ObjectKey> asObjectKey();

  Option<ArrayIndex> asArrayIndex();
}

final class ObjectKey extends PathElem {
  final String keyName;

  ObjectKey(this.keyName);

  @override
  Option<ObjectKey> asObjectKey() => Some(this);

  @override
  Option<ArrayIndex> asArrayIndex() => const None();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is ObjectKey && other.keyName == keyName);

  @override
  int get hashCode => keyName.hashCode;
}

final class ArrayIndex extends PathElem {
  final int index;

  ArrayIndex(this.index);

  @override
  Option<ObjectKey> asObjectKey() => const None();

  @override
  Option<ArrayIndex> asArrayIndex() => Some(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is ArrayIndex && other.index == index);

  @override
  int get hashCode => index.hashCode;
}
