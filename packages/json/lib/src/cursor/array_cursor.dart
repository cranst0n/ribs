import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

final class ArrayCursor extends HCursor {
  final IList<Json> arrayValues;
  final int indexValue;
  final HCursor parent;
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
  ACursor delete() =>
      parent.replace(Json.arrI(_valuesExcept), this, CursorOp.deleteGoParent);

  @override
  ACursor field(String key) => fail(CursorOp.field(key));

  @override
  ACursor left() => indexValue == 0
      ? fail(CursorOp.moveLeft)
      : ArrayCursor(arrayValues, indexValue - 1, parent, changed, this,
          CursorOp.moveLeft);

  @override
  HCursor replace(Json newValue, HCursor cursor, CursorOp? op) => ArrayCursor(
      arrayValues.updated(indexValue, newValue),
      indexValue,
      parent,
      true,
      cursor,
      op);

  @override
  ACursor right() => indexValue == arrayValues.size - 1
      ? fail(CursorOp.moveRight)
      : ArrayCursor(arrayValues, indexValue + 1, parent, changed, this,
          CursorOp.moveRight);

  @override
  ACursor up() => changed
      ? parent.replace(Json.arrI(arrayValues), this, CursorOp.moveUp)
      : parent.addOp(this, CursorOp.moveUp);

  IList<Json> get _valuesExcept =>
      arrayValues.take(indexValue).concat(arrayValues.drop(indexValue + 1));

  @override
  String toString() => 'ArrayCursor($value, $indexValue, $lastOp)';
}
