import 'package:ribs_json/src/dawn/fcontext.dart';
import 'package:ribs_json/src/dawn/parser.dart';

mixin ByteBasedParser on Parser {
  int byte(int i);

  int parseStringSimple(int i, FContext ctxt) {
    int j = i;
    int c = byte(j) & 0xff;

    while (c != 34) {
      if (c < 32) die(j, 'control char ($c) in string', chars: 1);
      if (c == 92) return -1;

      j += 1;
      c = byte(j) & 0xff;
    }
    return j + 1;
  }

  @override
  int parseString(int i, FContext ctxt) {
    final k = parseStringSimple(i + 1, ctxt);

    if (k != -1) {
      ctxt.addStringLimit(atRange(i + 1, k - 1), i, k);
      return k;
    }

    int j = i + 1;
    final sb = StringBuffer();

    int c = byte(j) & 0xff;

    while (c != 34) {
      if (c == 92) {
        final b = byte(j + 1);

        switch (b) {
          case 98:
            sb.write('\b');
            j += 2;
          case 102:
            sb.write('\f');
            j += 2;
          case 110:
            sb.write('\n');
            j += 2;
          case 114:
            sb.write('\r');
            j += 2;
          case 116:
            sb.write('\t');
            j += 2;

          case 34:
            sb.write('"');
            j += 2;
          case 47:
            sb.write('/');
            j += 2;
          case 92:
            sb.write('\\');
            j += 2;

          // if there's a problem then descape will explode
          case 117:
            final jj = j + 2;
            sb.write(descape(jj, atRange(jj, jj + 4)));
            j += 6;

          default:
            die(
              j,
              'invalid escape sequence (\\${String.fromCharCode(b)})',
              chars: 1,
            );
        }
      } else if (c < 32) {
        die(j, "control char ($c) in string", chars: 1);
      } else if (c < 128) {
        // 1-byte UTF-8 sequence
        sb.write(String.fromCharCode(c));
        j += 1;
      } else if ((c & 224) == 192) {
        // 2-byte UTF-8 sequence
        sb.write(atRange(j, j + 2));
        j += 2;
      } else if ((c & 240) == 224) {
        // 3-byte UTF-8 sequence
        sb.write(atRange(j, j + 3));
        j += 3;
      } else if ((c & 248) == 240) {
        // 4-byte UTF-8 sequence
        sb.write(atRange(j, j + 4));
        j += 4;
      } else {
        die(j, "invalid UTF-8 encoding");
      }

      c = byte(j) & 0xff;
    }

    j += 1;

    ctxt.addStringLimit(sb.toString(), i, j);
    return j;
  }
}
