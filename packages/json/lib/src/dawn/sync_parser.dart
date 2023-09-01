import 'package:ribs_json/ribs_json.dart';
import 'package:ribs_json/src/dawn/parser.dart';

abstract class SyncParser extends Parser {
  Json parse() {
    final (value, i) = parseAt(0);

    int j = i;

    while (!atEof(j)) {
      switch (at(j)) {
        case '\n':
          newline(j);
          j += 1;
        case ' ':
        case '\t':
        case '\r':
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
