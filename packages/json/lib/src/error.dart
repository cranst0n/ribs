import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

abstract class Error {
  const Error();
}

@immutable
class ParsingFailure extends Error {
  final String message;

  const ParsingFailure(this.message);

  @override
  String toString() => 'ParsingFailure($message)';
}

typedef DecodeResult<A> = Either<DecodingFailure, A>;

@immutable
class DecodingFailure extends Error {
  final Reason reason;
  final IList<CursorOp> history;

  const DecodingFailure(this.reason, this.history);

  static DecodingFailure fromString(String message, ACursor cursor) =>
      from(CustomReason(message), cursor);

  static DecodingFailure from(Reason reason, ACursor cursor) =>
      DecodingFailure(reason, cursor.history());

  Option<String> get pathToRootString => PathToRoot.fromHistory(history)
      .toOption()
      .filterNot((a) => a == PathToRoot.empty)
      .map((a) => a.asPathString());

  String message() {
    final r = reason;
    if (r is WrongTypeExpectation) {
      return 'Got value ${r.jsonValue} with wrong type. Expected ${r.expectedJsonFieldType}';
    } else if (r is MissingField) {
      return 'Missing required field';
    } else if (r is CustomReason) {
      return r.message;
    } else {
      return 'Unknown reason: $reason';
    }
  }

  @override
  String toString() => 'DecodingFailure($reason, $pathToRootString)';
}

abstract class Reason {}

class MissingField extends Reason {
  @override
  String toString() => 'MissingField';
}

class WrongTypeExpectation extends Reason {
  final String expectedJsonFieldType;
  final Json jsonValue;

  WrongTypeExpectation(this.expectedJsonFieldType, this.jsonValue);

  @override
  String toString() =>
      'WrongTypeExpectation: Expected $expectedJsonFieldType but found $jsonValue';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WrongTypeExpectation &&
          other.expectedJsonFieldType == expectedJsonFieldType &&
          other.jsonValue == jsonValue;

  @override
  int get hashCode => expectedJsonFieldType.hashCode * jsonValue.hashCode;
}

class CustomReason extends Reason {
  final String message;

  CustomReason(this.message);

  @override
  String toString() => 'CustomReason($message)';
}
