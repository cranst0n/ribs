import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:ribs_json/src/cursor/array_cursor.dart';
import 'package:ribs_json/src/cursor/object_cursor.dart';
import 'package:ribs_json/src/cursor/top_cursor.dart';

/// A successful [ACursor] positioned at a [Json] value.
///
/// [HCursor] is the working cursor type for navigation and modification.
/// Concrete subtypes are [TopCursor] (root), [ArrayCursor] (inside an array),
/// and [ObjectCursor] (inside an object).
abstract class HCursor extends ACursor {
  const HCursor(super.lastCursor, super.lastOp);

  /// Creates an [HCursor] positioned at the root of [json].
  static HCursor fromJson(Json json) => TopCursor(json, null, null);

  /// The [Json] value currently in focus.
  Json get value;

  /// Returns a new cursor with the focus replaced by [newValue], recording
  /// [cursor] as the previous cursor and [op] as the operation.
  HCursor replace(Json newValue, HCursor cursor, CursorOp? op);

  /// Returns a new cursor with the same focus but with [cursor]/[op] appended
  /// to the history.
  HCursor addOp(HCursor cursor, CursorOp op);

  @override
  HCursor withFocus(Function1<Json, Json> f) => replace(f(value), this, null);

  @override
  bool get succeeded => true;

  @override
  Option<HCursor> success() => Some(this);

  @override
  Option<Json> focus() => Some(value);

  @override
  Option<IList<Json>> get values =>
      Option.when(() => value is JArray, () => (value as JArray).value);

  @override
  Option<IList<String>> get keys =>
      Option.when(() => value is JObject, () => (value as JObject).value.keys);

  @override
  Option<Json> top() => Some(root().value);

  @override
  HCursor root() => this is TopCursor ? this : (up() as HCursor).root();

  @override
  ACursor downArray() {
    final self = value;

    if (self is JArray && self.value.nonEmpty) {
      return ArrayCursor(self.value, 0, this, false, this, CursorOp.downArray);
    } else {
      return fail(CursorOp.downArray);
    }
  }

  @override
  ACursor downField(String key) {
    final self = value;
    final op = CursorOp.downField(key);

    if (self is JObject) {
      return self.value.contains(key)
          ? ObjectCursor(self.value, key, this, false, this, op)
          : fail(op);
    } else {
      return fail(op);
    }
  }

  @override
  ACursor downN(int n) {
    final self = value;

    if (self is JArray && 0 <= n && n < self.value.size) {
      return ArrayCursor(self.value, n, this, false, this, CursorOp.downN(n));
    } else {
      return fail(CursorOp.downN(n));
    }
  }

  /// Returns a [FailedCursor] recording that [op] failed from this cursor.
  ACursor fail(CursorOp op) => FailedCursor(this, op);

  /// Moves right through array siblings until [p] returns `true` for the
  /// focused value, or returns a [FailedCursor] if no element matches.
  ACursor find(Function1<Json, bool> p) {
    var current = this as ACursor;

    while (current is HCursor) {
      if (p(current.value)) return current;
      current = current.right();
    }
    return current;
  }

  @override
  String toString() => 'HCursor($lastCursor, $lastOp, $value)';
}
