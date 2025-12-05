// ignore_for_file: avoid_print

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

// parsing-1

final Either<ParsingFailure, Json> json = Json.parse(
  '[ null, 1, true, "hi!", { "distance": 3.14 } ]',
);

// parsing-1

void notifyUserOfError(ParsingFailure failure) => throw UnimplementedError();
void proceedToUseValidJson(Json json) => throw UnimplementedError();

void parseData() {
  // parsing-2

  json.fold(
    (err) => notifyUserOfError(err),
    (json) => proceedToUseValidJson(json),
  );

  // parsing-2
}

// parsing-3
void printIt() {
  print(json);
  // Right(JArray([JNull, JNumber(1), JBoolean(true), JString("hi!"), JObject({ "distance": JNumber(3.14) })]))
}

// parsing-3

// parsing-4

// Removed the ',' between 1 and true...
final badJson = Json.parse('[ null, 1 true, "hi!", { "distance": 3.14 } ]');

// Left(ParsingFailure(ParseException: expected ] or , got 'true, ... (line 1, column 11) [index: 10, line: 1, col: 11]))

// parsing-4
