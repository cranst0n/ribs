import 'package:ribs_json/ribs_json.dart';

final class TopCursor extends HCursor {
  @override
  final Json value;

  const TopCursor(this.value, super.lastCursor, super.lastOp);

  @override
  HCursor addOp(HCursor cursor, CursorOp op) => TopCursor(value, cursor, op);

  @override
  ACursor delete() => fail(CursorOp.deleteGoParent);

  @override
  ACursor field(String key) => fail(CursorOp.field(key));

  @override
  ACursor left() => fail(CursorOp.moveLeft);

  @override
  HCursor replace(Json newValue, HCursor cursor, CursorOp? op) => TopCursor(newValue, cursor, op);

  @override
  ACursor right() => fail(CursorOp.moveRight);

  @override
  ACursor up() => fail(CursorOp.moveUp);

  @override
  String toString() => 'TopCursor($value)';
}
