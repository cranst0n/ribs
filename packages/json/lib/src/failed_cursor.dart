import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

/// An [ACursor] representing a failed navigation step.
///
/// All navigation methods on a [FailedCursor] are no-ops that return `this`,
/// allowing errors to propagate to the point where [ACursor.decode] is called
/// rather than requiring explicit error checking at each step.
@immutable
final class FailedCursor extends ACursor {
  const FailedCursor(super.lastCursor, super.lastOp);

  /// Returns `true` if the last operation required a JSON object or array but
  /// the cursor was not focused on one (wrong type, not a missing field).
  bool get incorrectFocus =>
      ((lastOp?.requiresObject ?? false) && !(lastCursor?.value.isObject ?? false)) ||
      ((lastOp?.requiresArray ?? false) && !(lastCursor?.value.isArray ?? false));

  /// Returns `true` if the failure was caused by navigating to a field that
  /// did not exist (as opposed to a type mismatch).
  bool get missingField => Option(lastOp).exists((a) => a is Field || a is DownField);

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
