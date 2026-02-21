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
    var c = atCodeUnit(j);

    while (c != 34) {
      // '"'
      if (c < 32) {
        // ' '
        die(j, 'control char ($c) in string', chars: 1);
      }

      if (c == 92) return -1; // '\\'

      j += 1;
      c = atCodeUnit(j);
    }

    return j + 1;
  }

  /// Parse a string that is known to have escape sequences.
  int _parseStringComplex(int i, FContext ctxt) {
    int j = i + 1;
    final sb = _buffer;

    sb.clear();

    var c = atCodeUnit(j);

    while (c != 34) {
      // '"'
      if (c < 32) {
        // ' '
        die(j, "control char ($c) in string", chars: 1);
      } else if (c == 92) {
        // '\\'
        switch (atCodeUnit(j + 1)) {
          case 98: // 'b'
            sb.write('\b');
            j += 2;
          case 102: // 'f'
            sb.write('\f');
            j += 2;
          case 110: // 'n'
            sb.write('\n');
            j += 2;
          case 114: // 'r'
            sb.write('\r');
            j += 2;
          case 116: // 't'
            sb.write('\t');
            j += 2;
          case 34: // '"'
            sb.write('"');
            j += 2;
          case 47: // '/'
            sb.write('/');
            j += 2;
          case 92: // '\\'
            sb.write('\\');
            j += 2;
          // if there's a problem then descape will explode
          case 117: // 'u'
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
        sb.writeCharCode(c);
        j += 1;
      }

      j = reset(j);
      c = atCodeUnit(j);
    }

    j += 1;
    ctxt.addStringLimit(sb.toString(), i, j);

    return j;
  }
}
