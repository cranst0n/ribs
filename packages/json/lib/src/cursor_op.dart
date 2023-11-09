import 'package:meta/meta.dart';

@immutable
sealed class CursorOp {
  final bool requiresObject;
  final bool requiresArray;

  const CursorOp(this.requiresObject, this.requiresArray);

  static CursorOp deleteGoParent = DeleteGoParent();
  static CursorOp downArray = DownArray();
  static CursorOp downField(String k) => DownField(k);
  static CursorOp downN(int n) => DownN(n);
  static CursorOp moveLeft = MoveLeft();
  static CursorOp moveRight = MoveRight();
  static CursorOp moveUp = MoveUp();
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

final class MoveLeft extends _UnconstrainedOp {
  @override
  String toString() => 'MoveLeft';

  @override
  int get hashCode => 0;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MoveLeft;
}

final class MoveRight extends _UnconstrainedOp {
  @override
  String toString() => 'MoveRight';

  @override
  int get hashCode => 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is MoveRight;
}

final class MoveUp extends _UnconstrainedOp {
  @override
  String toString() => 'MoveUp';

  @override
  int get hashCode => 0;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MoveUp;
}

final class Field extends _UnconstrainedOp {
  final String key;

  const Field(this.key);

  @override
  String toString() => 'Field($key)';

  @override
  int get hashCode => key.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Field && key == other.key);
}

final class DownField extends _ObjectOp {
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

final class DownArray extends _ArrayOp {
  @override
  String toString() => 'DownArray';

  @override
  int get hashCode => 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is DownArray;
}

final class DownN extends _ArrayOp {
  final int n;

  const DownN(this.n);

  @override
  String toString() => 'DownN($n)';

  @override
  int get hashCode => n.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is DownN && n == other.n);
}

final class DeleteGoParent extends _UnconstrainedOp {
  @override
  String toString() => 'DeleteGoParent';

  @override
  int get hashCode => 0;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is DeleteGoParent;
}
