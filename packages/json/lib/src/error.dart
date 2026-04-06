import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

/// Base type for all JSON errors. Subtypes are [ParsingFailure] and
/// [DecodingFailure].
sealed class Error {
  const Error();
}

/// An error produced when the JSON input is syntactically invalid.
@immutable
final class ParsingFailure extends Error {
  /// Human-readable description of the parse error.
  final String message;

  /// Creates a [ParsingFailure] with the given [message].
  const ParsingFailure(this.message);

  @override
  String toString() => 'ParsingFailure($message)';
}

/// The result of a [Decoder]: either a [DecodingFailure] or a value of [A].
typedef DecodeResult<A> = Either<DecodingFailure, A>;

/// An error produced when a [Decoder] cannot produce a value from the focused
/// [Json].
///
/// Carries a [Reason] describing why decoding failed, and an [IList] of
/// [CursorOp]s (the cursor's history) for constructing a human-readable
/// path to the failure site.
@immutable
final class DecodingFailure extends Error {
  /// The reason this failure occurred.
  final Reason reason;

  /// The cursor operations leading to the failure, used to reconstruct a path.
  final IList<CursorOp> history;

  /// Creates a [DecodingFailure] with the given [reason] and cursor [history].
  const DecodingFailure(this.reason, this.history);

  /// Creates a [DecodingFailure] with a [CustomReason] message, deriving the
  /// history from [cursor].
  static DecodingFailure fromString(String message, ACursor cursor) =>
      from(CustomReason(message), cursor);

  /// Creates a [DecodingFailure] with [reason], deriving the history from
  /// [cursor].
  static DecodingFailure from(Reason reason, ACursor cursor) =>
      DecodingFailure(reason, cursor.history());

  /// Returns a dot/bracket path string (e.g. `.user.address[0]`) for the
  /// failure location, or [None] if the cursor was at the root.
  Option<String> get pathToRootString => PathToRoot.fromHistory(
    history,
  ).toOption().filterNot((a) => a == PathToRoot.empty).map((a) => a.asPathString());

  /// Returns a human-readable description of the failure.
  String message() => switch (reason) {
    final WrongTypeExpectation r =>
      'Got value ${r.jsonValue} with wrong type. Expected ${r.expectedJsonFieldType}',
    MissingField _ => 'Missing required field',
    final CustomReason r => r.message,
  };

  @override
  String toString() => 'DecodingFailure($reason, $pathToRootString)';
}

/// Sealed base for the reason a [DecodingFailure] occurred.
sealed class Reason {}

/// Indicates that a required field was absent from the JSON object.
final class MissingField extends Reason {
  @override
  String toString() => 'MissingField';
}

/// Indicates that the focused [Json] value was not of the expected type.
final class WrongTypeExpectation extends Reason {
  /// The JSON type name that was expected (e.g. `'string'`, `'object'`).
  final String expectedJsonFieldType;

  /// The actual [Json] value that was encountered.
  final Json jsonValue;

  /// Creates a [WrongTypeExpectation] for [expectedJsonFieldType] vs [jsonValue].
  WrongTypeExpectation(this.expectedJsonFieldType, this.jsonValue);

  @override
  String toString() => 'WrongTypeExpectation: Expected $expectedJsonFieldType but found $jsonValue';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WrongTypeExpectation &&
          other.expectedJsonFieldType == expectedJsonFieldType &&
          other.jsonValue == jsonValue;

  @override
  int get hashCode => expectedJsonFieldType.hashCode * jsonValue.hashCode;
}

/// A free-form failure reason supplied by [Decoder.emap] or [Decoder.ensure].
class CustomReason extends Reason {
  /// The failure message.
  final String message;

  /// Creates a [CustomReason] with [message].
  CustomReason(this.message);

  @override
  String toString() => 'CustomReason($message)';
}
