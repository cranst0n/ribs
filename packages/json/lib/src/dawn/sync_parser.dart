import 'package:ribs_json/ribs_json.dart';
import 'package:ribs_json/src/dawn/parser.dart';

/// A [Parser] that synchronously consumes a complete input and returns one
/// [Json] value. Throws [ParseException] if the input is invalid, or
/// [IncompleteParseException] if it ends before a complete value is read.
abstract class SyncParser extends Parser {
  /// Parses the full input and returns the resulting [Json].
  Json parse() {
    final (value, i) = parseAt(0);

    int j = i;

    while (!atEof(j)) {
      switch (atCodeUnit(j)) {
        case 10: // '\n'
          newline(j);
          j += 1;
        case 32: // ' '
        case 9: // '\t'
        case 13: // '\r'
          j += 1;
        default:
          die(j, 'expected whitespace or eof');
      }
    }

    if (!atEof(j)) {
      die(j, 'expected eof');
    }

    close();

    return value;
  }
}
