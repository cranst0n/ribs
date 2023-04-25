import 'package:meta/meta.dart';
import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

sealed class Error {
  const Error();
}

@immutable
final class ParsingFailure extends Error {
  final String message;

  const ParsingFailure(this.message);

  @override
  String toString() => 'ParsingFailure($message)';
}

typedef DecodeResult<A> = Either<DecodingFailure, A>;

@immutable
final class DecodingFailure extends Error {
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

  String message() => switch (reason) {
        final WrongTypeExpectation r =>
          'Got value ${r.jsonValue} with wrong type. Expected ${r.expectedJsonFieldType}',
        MissingField _ => 'Missing required field',
        final CustomReason r => r.message,
      };

  @override
  String toString() => 'DecodingFailure($reason, $pathToRootString)';
}

sealed class Reason {}

final class MissingField extends Reason {
  @override
  String toString() => 'MissingField';
}

final class WrongTypeExpectation extends Reason {
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
