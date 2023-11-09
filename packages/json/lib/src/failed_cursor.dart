import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

@immutable
final class FailedCursor extends ACursor {
  const FailedCursor(super.lastCursor, super.lastOp);

  bool get incorrectFocus =>
      ((lastOp?.requiresObject ?? false) &&
          !(lastCursor?.value.isObject ?? false)) ||
      ((lastOp?.requiresArray ?? false) &&
          !(lastCursor?.value.isArray ?? false));

  bool get missingField =>
      Option(lastOp).exists((a) => a is Field || a is DownField);

  @override
  Option<Json> focus() => none();

  @override
  bool get succeeded => false;

  @override
  Option<HCursor> success() => none();

  @override
  Option<Json> top() => none();

  @override
  HCursor? root() => lastCursor?.root();

  @override
  ACursor delete() => this;

  @override
  ACursor downArray() => this;

  @override
  ACursor downField(String key) => this;

  @override
  ACursor downN(int n) => this;

  @override
  ACursor field(String key) => this;

  @override
  Option<IList<String>> get keys => none();

  @override
  ACursor left() => this;

  @override
  ACursor right() => this;

  @override
  ACursor up() => this;

  @override
  Option<IList<Json>> get values => none();

  @override
  ACursor withFocus(Function1<Json, Json> f) => this;

  @override
  String toString() => 'FailedCursor($lastCursor, $lastOp)';
}
