import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

/// An [HCursor] positioned at a value within a [JObject].
///
/// Tracks the full [JsonObject], the [keyValue] of the focused field, and
/// whether any field has been modified so that [up] can propagate changes to
/// the parent cursor.
final class ObjectCursor extends HCursor {
  /// The JSON object being navigated.
  final JsonObject obj;

  /// The key of the currently focused field.
  final String keyValue;

  /// The cursor that was used to enter this object.
  final HCursor parent;

  /// Whether any field in [obj] has been modified since this cursor was
  /// created.
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
  ACursor field(String key) =>
      obj.contains(key)
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
  ACursor up() =>
      changed
          ? parent.replace(Json.fromJsonObject(obj), this, CursorOp.moveUp)
          : parent.addOp(this, CursorOp.moveUp);

  @override
  String toString() => 'ObjectCursor($pathString, $focus)';
}
