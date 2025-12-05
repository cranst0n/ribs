import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

final class ObjectCursor extends HCursor {
  final JsonObject obj;
  final String keyValue;
  final HCursor parent;
  final bool changed;

  const ObjectCursor(
    this.obj,
    this.keyValue,
    this.parent,
    this.changed,
    super.lastCursor,
    super.lastOp,
  );

  @override
  Json get value => obj.getUnsafe(keyValue);

  @override
  Option<int> get index => none();

  @override
  Option<String> get key => Some(keyValue);

  @override
  HCursor addOp(HCursor cursor, CursorOp op) =>
      ObjectCursor(obj, keyValue, parent, changed, cursor, op);

  @override
  ACursor delete() =>
      parent.replace(Json.fromJsonObject(obj.remove(keyValue)), this, CursorOp.deleteGoParent);

  @override
  ACursor field(String key) => obj.contains(key)
      ? ObjectCursor(obj, key, parent, changed, this, CursorOp.field(key))
      : fail(CursorOp.field(key));

  @override
  ACursor left() => fail(CursorOp.moveLeft);

  @override
  HCursor replace(Json newValue, HCursor cursor, CursorOp? op) =>
      ObjectCursor(obj.add(keyValue, newValue), keyValue, parent, true, cursor, op);

  @override
  ACursor right() => fail(CursorOp.moveRight);

  @override
  ACursor up() => changed
      ? parent.replace(Json.fromJsonObject(obj), this, CursorOp.moveUp)
      : parent.addOp(this, CursorOp.moveUp);

  @override
  String toString() => 'ObjectCursor($pathString, $focus)';
}
