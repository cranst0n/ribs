// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:typed_data';

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

// #region parsing-1
final Either<ParsingFailure, Json> json = Json.parse(
  '[ null, 1, true, "hi!", { "distance": 3.14 } ]',
);
// #endregion parsing-1

void notifyUserOfError(ParsingFailure failure) => throw UnimplementedError();
void proceedToUseValidJson(Json json) => throw UnimplementedError();

void parseData() {
  // #region parsing-2
  json.fold(
    (err) => notifyUserOfError(err),
    (json) => proceedToUseValidJson(json),
  );
  // #endregion parsing-2
}

// #region parsing-3
void printIt() {
  print(json);
  // Right(JArray([JNull, JNumber(1), JBoolean(true), JString("hi!"), JObject({ "distance": JNumber(3.14) })]))
}
// #endregion parsing-3

// #region parsing-4
// Removed the ',' between 1 and true...
final badJson = Json.parse('[ null, 1 true, "hi!", { "distance": 3.14 } ]');

// Left(ParsingFailure(ParseException: expected ] or , got 'true, ... (line 1, column 11) [index: 10, line: 1, col: 11]))
// #endregion parsing-4

// #region parsing-5
// parseBytes accepts a Uint8List — the format returned by HTTP clients and
// file reads — without requiring a String conversion first.
final rawBytes = Uint8List.fromList(utf8.encode('[1, 2, 3]'));
final Either<ParsingFailure, Json> fromBytes = Json.parseBytes(rawBytes);
// Right(JArray([JNumber(1), JNumber(2), JNumber(3)]))
// #endregion parsing-5

// #region parsing-6
// ParsingFailure.message carries the full error description including the
// line and column numbers — useful when surfacing errors in a UI or log.
void showParsingFailure() {
  final result = Json.parse('{"broken": }');

  result.fold(
    (failure) => print(failure.message),
    // ParseException: expected field name got '}' (line 1, column 12)
    //   [index: 11, line: 1, col: 12]
    (json) => print(json),
  );
}
// #endregion parsing-6

// #region parsing-7
// Json.decode parses and decodes in a single step, returning Either<Error, A>.
// Error is a sealed type covering both ParsingFailure and DecodingFailure,
// so a single fold handles all failure modes.
final Either<Error, IList<int>> numbers = Json.decode(
  '[1, 2, 3]',
  Decoder.ilist(Decoder.integer),
);
// Right(IList(1, 2, 3))

// decodeBytes does the same from a Uint8List
final Either<Error, IList<int>> numbersFromBytes = Json.decodeBytes(
  Uint8List.fromList(utf8.encode('[1, 2, 3]')),
  Decoder.ilist(Decoder.integer),
);
// #endregion parsing-7
