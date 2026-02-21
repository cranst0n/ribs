import 'package:ribs_json/ribs_json.dart';
import 'package:ribs_json/src/dawn/parser.dart';

abstract class SyncParser extends Parser {
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
