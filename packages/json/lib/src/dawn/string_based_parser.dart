import 'package:ribs_json/src/dawn/fcontext.dart';
import 'package:ribs_json/src/dawn/parser.dart';

mixin StringBasedParser on Parser {
  final _buffer = StringBuffer();

  @override
  int parseString(int i, FContext ctxt) {
    final k = _parseStringSimple(i + 1, ctxt);

    if (k != -1) {
      ctxt.addStringAt(atRange(i + 1, k - 1), k);
      return k;
    } else {
      return _parseStringComplex(i, ctxt);
    }
  }

  int _parseStringSimple(int i, FContext ctxt) {
    var j = i;
    var c = at(j);

    while (c != '"') {
      if (c < ' ') {
        die(j, 'control char (${c.codeUnitAt(0)}) in string', chars: 1);
      }

      if (c == '\\') return -1;

      j += 1;
      c = at(j);
    }

    return j + 1;
  }

  /// Parse a string that is known to have escape sequences.
  int _parseStringComplex(int i, FContext ctxt) {
    int j = i + 1;
    final sb = _buffer;

    sb.clear();

    var c = at(j);

    while (c != '"') {
      if (c < ' ') {
        die(j, "control char (${c.codeUnitAt(0)}) in string", chars: 1);
      } else if (c == '\\') {
        switch (at(j + 1)) {
          case 'b':
            sb.write('\b');
            j += 2;
          case 'f':
            sb.write('\f');
            j += 2;
          case 'n':
            sb.write('\n');
            j += 2;
          case 'r':
            sb.write('\r');
            j += 2;
          case 't':
            sb.write('\t');
            j += 2;
          case '"':
            sb.write('"');
            j += 2;
          case '/':
            sb.write('/');
            j += 2;
          case '\\':
            sb.write('\\');
            j += 2;
          // if there's a problem then descape will explode
          case 'u':
            final jj = j + 2;
            sb.write(descape(jj, atRange(jj, jj + 4)));
            j += 6;
          default:
            die(j, 'illegal escape sequence (${at(j + 1)})', chars: 1);
        }
      } else {
        // this case is for "normal" code points that are just one Char.
        //
        // we don't have to worry about surrogate pairs, since those
        // will all be in the ranges D800–DBFF (high surrogates) or
        // DC00–DFFF (low surrogates).
        sb.write(c);
        j += 1;
      }

      j = reset(j);
      c = at(j);
    }

    j += 1;
    ctxt.addStringLimit(sb.toString(), i, j);

    return j;
  }
}
