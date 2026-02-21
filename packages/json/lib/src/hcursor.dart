import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:ribs_json/src/cursor/array_cursor.dart';
import 'package:ribs_json/src/cursor/object_cursor.dart';
import 'package:ribs_json/src/cursor/top_cursor.dart';

abstract class HCursor extends ACursor {
  const HCursor(super.lastCursor, super.lastOp);

  static HCursor fromJson(Json json) => TopCursor(json, null, null);

  Json get value;

  HCursor replace(Json newValue, HCursor cursor, CursorOp? op);
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

    if (self is JObject) {
      if (!self.value.contains(key)) {
        return fail(CursorOp.downField(key));
      } else {
        return ObjectCursor(self.value, key, this, false, this, CursorOp.downField(key));
      }
    } else {
      return fail(CursorOp.downField(key));
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

  ACursor fail(CursorOp op) => FailedCursor(this, op);

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
