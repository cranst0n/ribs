import 'dart:typed_data';

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:ribs_json/src/dawn/dawn.dart';
import 'package:ribs_json/src/dawn/fcontext.dart';

final class ParseException implements Exception {
  final String message;
  final int index;
  final int line;
  final int col;

  ParseException(this.message, this.index, this.line, this.col);

  @override
  String toString() =>
      'ParseException: $message [index: $index, line: $line, col: $col]';
}

final class IncompleteParseException implements Exception {
  final String message;

  IncompleteParseException(this.message);

  @override
  String toString() => 'IncompleteParseException: $message';
}

abstract class Parser {
  static Json parseUnsafe(String s) => StringParser(s).parse();

  static Either<ParsingFailure, Json> parseFromString(String s) =>
      Either.catching(
        () => parseUnsafe(s),
        (message, _) => ParsingFailure(message.toString()),
      );

  static Either<ParsingFailure, Json> parseFromBytes(Uint8List l) =>
      Either.catching(
        () => ByteDataParser(l).parse(),
        (message, _) => ParsingFailure(message.toString()),
      );

  String at(int i);

  String atRange(int i, int j);

  bool atEof(int i);

  int reset(int i);

  void checkpoint(
    int state,
    int i,
    FContext context,
    IList<FContext> stack,
  );

  void close();

  void newline(int i);
  int line();
  int column(int i);

  String _safeAt(int i, int j) {
    int jj = j;

    while (true) {
      if (jj <= i) {
        return '';
      } else {
        try {
          return atRange(i, jj);
        } catch (_) {
          jj -= 1;
        }
      }
    }
  }

  Never die(int i, String msg, {int chars = _ErrorContext}) {
    final y = line() + 1;
    final x = column(i) + 1;

    final String got;

    if (atEof(i)) {
      got = 'eof';
    } else {
      int offset = 0;

      while (offset < chars && !atEof(i + offset)) {
        offset += 1;
      }

      final txt = _safeAt(i, i + offset);

      if (atEof(i + offset)) {
        got = "'$txt'";
      } else {
        got = "'$txt...";
      }
    }

    throw ParseException('$msg got $got (line $y, column $x)', i, y, x);
  }

  int _parseNum(int i, FContext ctxt) {
    int j = i;
    String c = at(j);
    int decIndex = -1;
    int expIndex = -1;

    if (c == '-') {
      j += 1;
      c = at(j);
    }

    if (c == '0') {
      j += 1;
      c = at(j);
    } else if ('1' <= c && c <= '9') {
      do {
        j += 1;
        c = at(j);
      } while ('0' <= c && c <= '9');
    } else {
      die(i, 'expected digit');
    }

    if (c == '.') {
      decIndex = j - i;
      j += 1;
      c = at(j);

      if ('0' <= c && c <= '9') {
        do {
          j += 1;
          c = at(j);
        } while ('0' <= c && c <= '9');
      } else {
        die(i, 'expected digit');
      }
    }

    if (c == 'e' || c == 'E') {
      expIndex = j - i;
      j += 1;
      c = at(j);

      if (c == '+' || c == '-') {
        j += 1;
        c = at(j);
      }
      if ('0' <= c && c <= '9') {
        do {
          j += 1;
          c = at(j);
        } while ('0' <= c && c <= '9');
      } else {
        die(i, 'expected digit');
      }
    }

    ctxt.addValueAt(_jnum(atRange(i, j), decIndex, expIndex), i);

    return j;
  }

  int _parseNumSlow(int i, FContext ctxt) {
    int j = i;
    String c = at(j);
    int decIndex = -1;
    int expIndex = -1;

    if (c == '-') {
      // any valid input will require at least one digit after -
      j += 1;
      c = at(j);
    }

    if (c == '0') {
      j += 1;
      if (atEof(j)) {
        ctxt.addValueAt(_jnum(atRange(i, j), decIndex, expIndex), i);
        return j;
      }
      c = at(j);
    } else if ('1' <= c && c <= '9') {
      do {
        j += 1;

        if (atEof(j)) {
          ctxt.addValueAt(_jnum(atRange(i, j), decIndex, expIndex), i);
          return j;
        }

        c = at(j);
      } while ('0' <= c && c <= '9');
    } else {
      die(i, 'expected digit');
    }

    if (c == '.') {
      // any valid input will require at least one digit after .
      decIndex = j - i;
      j += 1;
      c = at(j);

      if ('0' <= c && c <= '9') {
        do {
          j += 1;

          if (atEof(j)) {
            ctxt.addValueAt(_jnum(atRange(i, j), decIndex, expIndex), i);
            return j;
          }
          c = at(j);
        } while ('0' <= c && c <= '9');
      } else {
        die(i, 'expected digit');
      }
    }

    if (c == 'e' || c == 'E') {
      // any valid input will require at least one digit after e, e+, etc
      expIndex = j - i;
      j += 1;
      c = at(j);

      if (c == '+' || c == '-') {
        j += 1;
        c = at(j);
      }

      if ('0' <= c && c <= '9') {
        do {
          j += 1;

          if (atEof(j)) {
            ctxt.addValueAt(_jnum(atRange(i, j), decIndex, expIndex), i);
            return j;
          }
          c = at(j);
        } while ('0' <= c && c <= '9');
      } else {
        die(i, 'expected digit');
      }
    }

    ctxt.addValueAt(_jnum(atRange(i, j), decIndex, expIndex), i);

    return j;
  }

  String descape(int pos, String s) {
    int i = 0;
    int x = 0;

    while (i < 4) {
      final n = _HexChars[s.codeUnitAt(i)];

      if (n < 0) {
        die(pos, 'expected valid unicode escape');
      }

      x = (x << 4) | n;
      i += 1;
    }

    return String.fromCharCode(x);
  }

  int parseString(int i, FContext ctxt);

  Json _parseTrue(int i) {
    if (at(i + 1) == 'r' && at(i + 2) == 'u' && at(i + 3) == 'e') {
      return Json.True;
    } else {
      die(i, 'expected true');
    }
  }

  Json _parseFalse(int i) {
    if (at(i + 1) == 'a' &&
        at(i + 2) == 'l' &&
        at(i + 3) == 's' &&
        at(i + 4) == 'e') {
      return Json.False;
    } else {
      die(i, 'expected false');
    }
  }

  Json _parseNull(int i) {
    if (at(i + 1) == 'u' && at(i + 2) == 'l' && at(i + 3) == 'l') {
      return Json.Null;
    } else {
      die(i, 'expected null');
    }
  }

  (Json, int) parseAt(int i) {
    try {
      return _parseTop(i);
      // ignore: avoid_catching_errors
    } on RangeError {
      throw IncompleteParseException('exhausted input');
    }
  }

  (Json, int) _parseTop(int i) {
    int n = i;

    while (true) {
      switch (at(n)) {
        case ' ':
        case '\t':
        case '\r':
          n += 1;
        case '\n':
          newline(i);
          n += 1;
        case '[':
          return iparse(_ARRBEG, n + 1, FContext.array(n), nil());
        case '{':
          return iparse(_OBJBEG, n + 1, FContext.object(n), nil());
        case '-':
        case '0':
        case '1':
        case '2':
        case '3':
        case '4':
        case '5':
        case '6':
        case '7':
        case '8':
        case '9':
          {
            final ctxt = FContext.single(n);
            final j = _parseNumSlow(n, ctxt);
            return (ctxt.finishAt(n), j);
          }
        case '"':
          {
            final ctxt = FContext.single(n);
            final j = parseString(n, ctxt);
            return (ctxt.finishAt(n), j);
          }
        case 't':
          return (_parseTrue(n), n + 4);
        case 'f':
          return (_parseFalse(n), n + 5);
        case 'n':
          return (_parseNull(n), n + 4);
        default:
          die(n, 'expected json value');
      }
    }
  }

  (Json, int) iparse(
    int state,
    int j,
    FContext context,
    IList<FContext> stack,
  ) {
    // No tail recursion so we must loop
    int iState = state;
    int iJ = j;
    FContext iContext = context;
    IList<FContext> iStack = stack;

    while (true) {
      final i = reset(iJ);
      checkpoint(iState, i, iContext, iStack);

      final c = at(i);

      if (iStack.size > _MaxDepth) {
        die(i, 'JSON max depth ($_MaxDepth) exceeded');
      }

      if (c == '\n') {
        newline(i);
        iJ = i + 1;
      } else if (c == ' ' || c == '\t' || c == '\r') {
        iJ = i + 1;
      } else if (iState == _DATA) {
        // we are inside an object or array expecting to see data
        if (c == '[') {
          iState = _ARRBEG;
          iJ = i + 1;
          iStack = iStack.prepend(iContext);
          iContext = FContext.array(i);
        } else if (c == '{') {
          iState = _OBJBEG;
          iJ = i + 1;
          iStack = iStack.prepend(iContext);
          iContext = FContext.object(i);
        } else if ((c >= '0' && c <= '9') || c == '-') {
          iJ = _parseNum(i, iContext);
          iState = iContext.isObject ? _OBJEND : _ARREND;
        } else if (c == '"') {
          iJ = parseString(i, iContext);
          iState = iContext.isObject ? _OBJEND : _ARREND;
        } else if (c == 't') {
          iContext.addValueAt(_parseTrue(i), i);
          iState = iContext.isObject ? _OBJEND : _ARREND;
          iJ = i + 4;
        } else if (c == 'f') {
          iContext.addValueAt(_parseFalse(i), i);
          iState = iContext.isObject ? _OBJEND : _ARREND;
          iJ = i + 5;
        } else if (c == 'n') {
          iContext.addValueAt(_parseNull(i), i);
          iState = iContext.isObject ? _OBJEND : _ARREND;
          iJ = i + 4;
        } else {
          die(i, 'expected json value');
        }
      } else if ((c == ']' && (iState == _ARREND || iState == _ARRBEG)) ||
          (c == '}' && (iState == _OBJEND || iState == _OBJBEG))) {
        // we are inside an array or object and have seen a key or a closing
        // brace, respectively.
        if (iStack.isEmpty) {
          return (iContext.finishAt(i), i + 1);
        } else {
          final ctxt2 = iStack[0];
          ctxt2.addValueAt(iContext.finishAt(i), i);

          iState = ctxt2.isObject ? _OBJEND : _ARREND;
          iJ = i + 1;
          iContext = ctxt2;
          iStack = iStack.tail();
        }
      } else if (iState == _KEY) {
        // we are in an object expecting to see a key.
        if (c == '"') {
          iJ = parseString(i, iContext);
          iState = _SEP;
        } else {
          die(i, 'expected "');
        }
      } else if (iState == _SEP) {
        // we are in an object just after a key, expecting to see a colon.
        if (c == ':') {
          iState = _DATA;
          iJ = i + 1;
        } else {
          die(i, 'expected :');
        }
      } else if (iState == _ARREND) {
        // we are in an array, expecting to see a comma (before more data).
        if (c == ',') {
          iState = _DATA;
          iJ = i + 1;
        } else {
          die(i, 'expected ] or ,');
        }
      } else if (iState == _OBJEND) {
        // we are in an object, expecting to see a comma (before more data).
        if (c == ',') {
          iState = _KEY;
          iJ = i + 1;
        } else {
          die(i, 'expected } or ,');
        }
      } else if (iState == _ARRBEG) {
        // we are starting an array, expecting to see data or a closing bracket.
        iState = _DATA;
        iJ = i;
      } else {
        // we are starting an object, expecting to see a key or a closing brace.
        iState = _KEY;
        iJ = i;
      }
    }
  }

  JNumber _jnum(String s, int decIndex, int expIndex) => JNumber(num.parse(s));

  static const _ARRBEG = 6;
  static const _OBJBEG = 7;
  static const _DATA = 1;
  static const _KEY = 2;
  static const _SEP = 3;
  static const _ARREND = 4;
  static const _OBJEND = 5;

  static final _HexChars = _genHexChars();

  static const _ErrorContext = 6;
  static const _MaxDepth = 10000;
}

extension StringCompareOps on String {
  bool operator <(String that) => compareTo(that) < 0;
  bool operator <=(String that) => compareTo(that) <= 0;
  bool operator >(String that) => compareTo(that) > 0;
  bool operator >=(String that) => compareTo(that) >= 0;
}

List<int> _genHexChars() {
  final l = List.filled(128, -1);

  int i = 0;

  while (i < 10) {
    l[i + '0'.codeUnitAt(0)] = i;
    i += 1;
  }

  i = 0;

  while (i < 6) {
    l[i + 'a'.codeUnitAt(0)] = 10 + i;
    l[i + 'A'.codeUnitAt(0)] = 10 + i;
    i += 1;
  }

  return l;
}
