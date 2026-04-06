import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

/// An [HCursor] positioned at an element within a [JArray].
///
/// Tracks the full array, the current [indexValue], and whether any element
/// has been modified so that [up] can propagate changes to the parent cursor.
final class ArrayCursor extends HCursor {
  /// All elements of the array being navigated.
  final IList<Json> arrayValues;

  /// The index of the currently focused element.
  final int indexValue;

  /// The cursor that was used to enter this array.
  final HCursor parent;

  /// Whether any element in [arrayValues] has been modified since this cursor
  /// was created.
  final bool changed;

  const ArrayCursor(
    this.arrayValues,
    this.indexValue,
    this.parent,
    this.changed,
    super.lastCursor,
    super.lastOp,
  );

  @override
  Json get value => arrayValues[indexValue];

  @override
  Option<int> get index => Some(indexValue);

  @override
  Option<String> get key => none();

  @override
  HCursor addOp(HCursor cursor, CursorOp op) =>
      ArrayCursor(arrayValues, indexValue, parent, changed, cursor, op);

  @override
  ACursor delete() => parent.replace(Json.arrI(_valuesExcept), this, CursorOp.deleteGoParent);

  @override
  ACursor field(String key) => fail(CursorOp.field(key));

  @override
  ACursor left() =>
      indexValue == 0
          ? fail(CursorOp.moveLeft)
          : ArrayCursor(arrayValues, indexValue - 1, parent, changed, this, CursorOp.moveLeft);

  @override
  HCursor replace(Json newValue, HCursor cursor, CursorOp? op) =>
      ArrayCursor(arrayValues.updated(indexValue, newValue), indexValue, parent, true, cursor, op);

  @override
  ACursor right() =>
      indexValue == arrayValues.size - 1
          ? fail(CursorOp.moveRight)
          : ArrayCursor(arrayValues, indexValue + 1, parent, changed, this, CursorOp.moveRight);

  @override
  ACursor up() =>
      changed
          ? parent.replace(Json.arrI(arrayValues), this, CursorOp.moveUp)
          : parent.addOp(this, CursorOp.moveUp);

  IList<Json> get _valuesExcept =>
      arrayValues.take(indexValue).concat(arrayValues.drop(indexValue + 1));

  @override
  String toString() => 'ArrayCursor($value, $indexValue, $lastOp)';
}
