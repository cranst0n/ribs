import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

@immutable
class PathToRoot {
  final IList<PathElem> value;

  const PathToRoot(this.value);

  String asPathString() => PathToRoot.toPathString(this);

  PathToRoot appendElem(PathElem elem) => PathToRoot(value.append(elem));

  PathToRoot prependElem(PathElem elem) => PathToRoot(value.prepend(elem));

  static PathToRoot empty = PathToRoot(IList.empty());

  static String toPathString(PathToRoot path) {
    if (path.value.isEmpty) {
      return '';
    } else {
      return path.value.foldLeft('', (acc, elem) {
        if (elem is ObjectKey) {
          return '$acc.${elem.keyName}';
        } else if (elem is ArrayIndex) {
          return '$acc[${elem.index}]';
        } else {
          throw Exception('Unknown path elem: $elem');
        }
      });
    }
  }

  static Either<String, PathToRoot> fromHistory(IList<CursorOp> ops) {
    final initial = Either.right<String, IList<PathElem>>(IList.empty());
    const moveUpErrStr =
        'Attempt to move to sibling field, but cursor history didnt indicate we were in an object.';

    return ops.reverse().foldLeft<Either<String, IList<PathElem>>>(initial,
        (acc, op) {
      return acc.flatMap((acc) {
        final lastOp = acc.lastOption;

        if (lastOp is Some<ArrayIndex> && op is MoveLeft) {
          // MoveLeft
          return Either.cond(
            () => lastOp.value.index >= 0,
            () => acc.append(PathElem.arrayIndex(lastOp.value.index - 1)),
            () =>
                'Attempt to move beyond beginning of array in cursor history.',
          );
          // MoveRight
        } else if (lastOp is Some<ArrayIndex> && op is MoveRight) {
          return Either.cond(
            () => lastOp.value.index < 4294967296,
            () => acc.append(PathElem.arrayIndex(lastOp.value.index)),
            () =>
                'Attepmt to move to index > 4294967296 in array in cursor history',
          );
        } else if (op is MoveUp) {
          // MoveUp
          return Either.cond(
            () => acc.nonEmpty,
            () => acc,
            () => 'Attempt to move up above the root of the JSON.',
          );
        } else if (op is Field) {
          // Field
          return Either.cond(
            () => acc.lastOption.exists((pe) => pe is ObjectKey),
            () => acc.append(PathElem.objectKey(op.key)),
            () => moveUpErrStr,
          );
        } else if (op is DownField) {
          // DownField
          return Right(acc.append(PathElem.objectKey(op.key)));
        } else if (op is DownArray) {
          // DownArray
          return Right(acc.append(PathElem.arrayIndex(0)));
        } else if (op is DownN) {
          // DownN
          return Right(acc.append(PathElem.arrayIndex(op.n)));
        } else if (op is DeleteGoParent) {
          return Either.cond(
            () => acc.nonEmpty,
            () => acc,
            () => moveUpErrStr,
          );
        } else {
          return Left('Invalid cursor history state: $op');
        }
      });
    }).map(PathToRoot.new);
  }

  @override
  String toString() => 'PathToRoot(${toPathString(this)})';

  @override
  bool operator ==(Object other) => other is PathToRoot && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

@immutable
abstract class PathElem {
  static PathElem objectKey(String keyName) => ObjectKey(keyName);
  static PathElem arrayIndex(int index) => ArrayIndex(index);
}

class ObjectKey extends PathElem {
  final String keyName;

  ObjectKey(this.keyName);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ObjectKey && other.keyName == keyName);

  @override
  int get hashCode => keyName.hashCode;
}

class ArrayIndex extends PathElem {
  final int index;

  ArrayIndex(this.index);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is ArrayIndex && other.index == index);

  @override
  int get hashCode => index.hashCode;
}
