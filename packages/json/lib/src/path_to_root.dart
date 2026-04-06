import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

/// The sequence of [PathElem]s from the root of a [Json] tree to the cursor
/// position, used to render a human-readable location in [DecodingFailure]
/// messages.
@immutable
final class PathToRoot {
  /// The ordered list of path elements, from root to the focused position.
  final IList<PathElem> value;

  /// Creates a [PathToRoot] from a list of [PathElem]s.
  const PathToRoot(this.value);

  /// Returns this path as a dot/bracket string (e.g. `.user.addresses[0]`).
  String asPathString() => PathToRoot.toPathString(this);

  /// Returns a new [PathToRoot] with [elem] appended at the end.
  PathToRoot appendElem(PathElem elem) => PathToRoot(value.appended(elem));

  /// Returns a new [PathToRoot] with [elem] prepended at the beginning.
  PathToRoot prependElem(PathElem elem) => PathToRoot(value.prepended(elem));

  /// An empty [PathToRoot] representing the root position.
  static PathToRoot empty = PathToRoot(IList.empty());

  /// Renders [path] as a dot/bracket string.
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

  /// Reconstructs a [PathToRoot] by replaying [ops] (a cursor history).
  /// Returns `Right(path)` on success or `Left(message)` if the history is
  /// inconsistent.
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
          () => arrIx.index < Integer.maxValue,
          () => acc.appended(PathElem.arrayIndex(arrIx.index + 1)),
          () => 'Attempt to move to index > ${Integer.maxValue} in array.',
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

/// A single element in a [PathToRoot]: either an object key or an array index.
@immutable
sealed class PathElem {
  /// Creates a [PathElem] for an object field named [keyName].
  static PathElem objectKey(String keyName) => ObjectKey(keyName);

  /// Creates a [PathElem] for an array element at [index].
  static PathElem arrayIndex(int index) => ArrayIndex(index);

  /// Returns [Some] if this element is an [ObjectKey], otherwise [None].
  Option<ObjectKey> asObjectKey();

  /// Returns [Some] if this element is an [ArrayIndex], otherwise [None].
  Option<ArrayIndex> asArrayIndex();
}

/// A [PathElem] representing a JSON object field access.
final class ObjectKey extends PathElem {
  /// The field name.
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

/// A [PathElem] representing a JSON array element access.
final class ArrayIndex extends PathElem {
  /// The zero-based array index.
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
