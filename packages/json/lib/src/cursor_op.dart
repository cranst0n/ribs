import 'package:meta/meta.dart';

/// A single step recorded in an [ACursor]'s history.
///
/// The history is replayed by [PathToRoot] to produce human-readable paths for
/// [DecodingFailure] error messages. Each concrete subtype corresponds to one
/// cursor navigation operation.
@immutable
sealed class CursorOp {
  /// Whether this operation requires the cursor to be on a JSON object.
  final bool requiresObject;

  /// Whether this operation requires the cursor to be on a JSON array.
  final bool requiresArray;

  const CursorOp(this.requiresObject, this.requiresArray);

  /// Records a [DeleteGoParent] operation.
  static CursorOp deleteGoParent = DeleteGoParent();

  /// Records a [DownArray] operation.
  static CursorOp downArray = DownArray();

  /// Records a [DownField] operation for [k].
  static CursorOp downField(String k) => DownField(k);

  /// Records a [DownN] operation for index [n].
  static CursorOp downN(int n) => DownN(n);

  /// Records a [MoveLeft] operation.
  static CursorOp moveLeft = MoveLeft();

  /// Records a [MoveRight] operation.
  static CursorOp moveRight = MoveRight();

  /// Records a [MoveUp] operation.
  static CursorOp moveUp = MoveUp();

  /// Records a [Field] (sibling field) operation for [k].
  static CursorOp field(String k) => Field(k);
}

class _ObjectOp extends CursorOp {
  const _ObjectOp() : super(true, false);
}

class _ArrayOp extends CursorOp {
  const _ArrayOp() : super(false, true);
}

class _UnconstrainedOp extends CursorOp {
  const _UnconstrainedOp() : super(false, false);
}

/// Cursor moved left to the previous array element.
final class MoveLeft extends _UnconstrainedOp {
  @override
  String toString() => 'MoveLeft';

  @override
  int get hashCode => 0;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MoveLeft;
}

/// Cursor moved right to the next array element.
final class MoveRight extends _UnconstrainedOp {
  @override
  String toString() => 'MoveRight';

  @override
  int get hashCode => 0;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MoveRight;
}

/// Cursor moved up to the parent JSON value.
final class MoveUp extends _UnconstrainedOp {
  @override
  String toString() => 'MoveUp';

  @override
  int get hashCode => 0;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MoveUp;
}

/// Cursor moved to a sibling field [key] within the same JSON object.
final class Field extends _UnconstrainedOp {
  /// The key of the sibling field.
  final String key;

  const Field(this.key);

  @override
  String toString() => 'Field($key)';

  @override
  int get hashCode => key.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || (other is Field && key == other.key);
}

/// Cursor descended into field [key] of a JSON object.
final class DownField extends _ObjectOp {
  /// The field key that was navigated into.
  final String key;

  const DownField(this.key);

  @override
  String toString() => 'DownField($key)';

  @override
  int get hashCode => key.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is DownField && key == other.key);
}

/// Cursor descended into the first element of a JSON array.
final class DownArray extends _ArrayOp {
  @override
  String toString() => 'DownArray';

  @override
  int get hashCode => 0;

  @override
  bool operator ==(Object other) => identical(this, other) || other is DownArray;
}

/// Cursor descended into element [n] of a JSON array.
final class DownN extends _ArrayOp {
  /// The zero-based index that was navigated into.
  final int n;

  const DownN(this.n);

  @override
  String toString() => 'DownN($n)';

  @override
  int get hashCode => n.hashCode;

  @override
  bool operator ==(Object other) => identical(this, other) || (other is DownN && n == other.n);
}

/// The focused value was deleted and the cursor moved to the parent.
final class DeleteGoParent extends _UnconstrainedOp {
  @override
  String toString() => 'DeleteGoParent';

  @override
  int get hashCode => 0;

  @override
  bool operator ==(Object other) => identical(this, other) || other is DeleteGoParent;
}
