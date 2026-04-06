import 'dart:typed_data';

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';
import 'package:ribs_json/src/dawn/dawn.dart';
import 'package:ribs_json/src/dawn/fcontext.dart';

/// Thrown when the JSON input is syntactically invalid.
final class ParseException implements Exception {
  /// Human-readable description of what went wrong.
  final String message;

  /// Byte/character offset in the input where the error was detected.
  final int index;

  /// 1-based line number of the error location.
  final int line;

  /// 1-based column number of the error location.
  final int col;

  /// Creates a [ParseException] at the given [index], [line], and [col].
  ParseException(this.message, this.index, this.line, this.col);

  @override
  String toString() => 'ParseException: $message [index: $index, line: $line, col: $col]';
}

/// Thrown when the JSON input ends before a complete value has been parsed.
final class IncompleteParseException implements Exception {
  /// Human-readable description of the incomplete state.
  final String message;

  /// Creates an [IncompleteParseException] with the given [message].
  IncompleteParseException(this.message);

  @override
  String toString() => 'IncompleteParseException: $message';
}

/// Abstract base for all JSON parsers.
///
/// Subclasses provide the input-access primitives ([at], [atCodeUnit],
/// [atRange], [atEof]) and bookkeeping hooks ([reset], [checkpoint],
/// [newline], [close]). The recursive-descent parse logic is implemented here
/// and shared across all concrete parsers.
abstract class Parser {
  /// Parses [s] and returns the resulting [Json], throwing [ParseException]
  /// on invalid input.
  static Json parseUnsafe(String s) => StringParser(s).parse();

  /// Parses [s], returning `Right(json)` on success or `Left(failure)` if the
  /// input is not valid JSON.
  static Either<ParsingFailure, Json> parseFromString(String s) => Either.catching(
    () => parseUnsafe(s),
    (message, _) => ParsingFailure(message.toString()),
  );

  /// Parses [l] as UTF-8-encoded JSON bytes, returning `Right(json)` on
  /// success or `Left(failure)` on invalid input.
  static Either<ParsingFailure, Json> parseFromBytes(Uint8List l) => Either.catching(
    () => ByteDataParser(l).parse(),
    (message, _) => ParsingFailure(message.toString()),
  );

  /// Returns the character at position [i] as a single-character string.
  String at(int i);

  /// Returns the UTF-16 code unit at position [i].
  int atCodeUnit(int i);

  /// Returns the substring from [i] (inclusive) to [j] (exclusive).
  String atRange(int i, int j);

  /// Returns `true` if [i] is at or past the end of the input.
  bool atEof(int i);

  /// Called at the start of each parse step; may adjust [i] to account for
  /// buffer compaction (relevant for async parsers). Returns the adjusted
  /// position.
  int reset(int i);

  /// Saves the current parse state so that an async parser can resume if the
  /// buffer runs out mid-value.
  void checkpoint(
    int state,
    int i,
    FContext context,
    List<FContext> stack,
  );

  /// Called when parsing is finished; subclasses may release resources here.
  void close();

  /// Records that a newline was encountered at position [i].
  void newline(int i);

  /// Returns the current 0-based line number.
  int line();

  /// Returns the 0-based column of position [i].
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
    int c = atCodeUnit(j);
    int decIndex = -1;
    int expIndex = -1;

    if (c == 45) {
      // '-'
      j += 1;
      c = atCodeUnit(j);
    }

    if (c == 48) {
      // '0'
      j += 1;
      c = atCodeUnit(j);
    } else if (49 <= c && c <= 57) {
      // '1' - '9'
      do {
        j += 1;
        c = atCodeUnit(j);
      } while (48 <= c && c <= 57);
    } else {
      die(i, 'expected digit');
    }

    if (c == 46) {
      // '.'
      decIndex = j - i;
      j += 1;
      c = atCodeUnit(j);

      if (48 <= c && c <= 57) {
        do {
          j += 1;
          c = atCodeUnit(j);
        } while (48 <= c && c <= 57);
      } else {
        die(i, 'expected digit');
      }
    }

    if (c == 101 || c == 69) {
      // 'e' or 'E'
      expIndex = j - i;
      j += 1;
      c = atCodeUnit(j);

      if (c == 43 || c == 45) {
        // '+' or '-'
        j += 1;
        c = atCodeUnit(j);
      }
      if (48 <= c && c <= 57) {
        do {
          j += 1;
          c = atCodeUnit(j);
        } while (48 <= c && c <= 57);
      } else {
        die(i, 'expected digit');
      }
    }

    ctxt.addValueAt(_jnum(i, j, decIndex, expIndex), i);

    return j;
  }

  int _parseNumSlow(int i, FContext ctxt) {
    int j = i;
    int c = atCodeUnit(j);
    int decIndex = -1;
    int expIndex = -1;

    if (c == 45) {
      // '-'
      // any valid input will require at least one digit after -
      j += 1;
      c = atCodeUnit(j);
    }

    if (c == 48) {
      // '0'
      j += 1;
      if (atEof(j)) {
        ctxt.addValueAt(_jnum(i, j, decIndex, expIndex), i);
        return j;
      }
      c = atCodeUnit(j);
    } else if (49 <= c && c <= 57) {
      // '1' - '9'
      do {
        j += 1;

        if (atEof(j)) {
          ctxt.addValueAt(_jnum(i, j, decIndex, expIndex), i);
          return j;
        }

        c = atCodeUnit(j);
      } while (48 <= c && c <= 57);
    } else {
      die(i, 'expected digit');
    }

    if (c == 46) {
      // '.'
      // any valid input will require at least one digit after .
      decIndex = j - i;
      j += 1;
      c = atCodeUnit(j);

      if (48 <= c && c <= 57) {
        do {
          j += 1;

          if (atEof(j)) {
            ctxt.addValueAt(_jnum(i, j, decIndex, expIndex), i);
            return j;
          }
          c = atCodeUnit(j);
        } while (48 <= c && c <= 57);
      } else {
        die(i, 'expected digit');
      }
    }

    if (c == 101 || c == 69) {
      // 'e' or 'E'
      // any valid input will require at least one digit after e, e+, etc
      expIndex = j - i;
      j += 1;
      c = atCodeUnit(j);

      if (c == 43 || c == 45) {
        // '+' or '-'
        j += 1;
        c = atCodeUnit(j);
      }

      if (48 <= c && c <= 57) {
        do {
          j += 1;

          if (atEof(j)) {
            ctxt.addValueAt(_jnum(i, j, decIndex, expIndex), i);
            return j;
          }
          c = atCodeUnit(j);
        } while (48 <= c && c <= 57);
      } else {
        die(i, 'expected digit');
      }
    }

    ctxt.addValueAt(_jnum(i, j, decIndex, expIndex), i);

    return j;
  }

  String descape(int pos, String s) {
    int i = 0;
    int x = 0;

    while (i < 4) {
      final n = _hexChars[s.codeUnitAt(i)];

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
    if (atCodeUnit(i + 1) == 114 /* r */ &&
        atCodeUnit(i + 2) == 117 /* u */ &&
        atCodeUnit(i + 3) == 101 /* e */ ) {
      return Json.True;
    } else {
      die(i, 'expected true');
    }
  }

  Json _parseFalse(int i) {
    if (atCodeUnit(i + 1) == 97 /* a */ &&
        atCodeUnit(i + 2) == 108 /* l */ &&
        atCodeUnit(i + 3) == 115 /* s */ &&
        atCodeUnit(i + 4) == 101 /* e */ ) {
      return Json.False;
    } else {
      die(i, 'expected false');
    }
  }

  Json _parseNull(int i) {
    if (atCodeUnit(i + 1) == 117 /* u */ &&
        atCodeUnit(i + 2) == 108 /* l */ &&
        atCodeUnit(i + 3) == 108 /* l */ ) {
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
      switch (atCodeUnit(n)) {
        case 32: // ' '
        case 9: // '\t'
        case 13: // '\r'
          n += 1;
        case 10: // '\n'
          newline(i);
          n += 1;
        case 91: // '['
          return iparse(_ARRBEG, n + 1, FContext.array(n), []);
        case 123: // '{'
          return iparse(_OBJBEG, n + 1, FContext.object(n), []);
        case 45: // '-'
        case 48: // '0'
        case 49: // '1'
        case 50: // '2'
        case 51: // '3'
        case 52: // '4'
        case 53: // '5'
        case 54: // '6'
        case 55: // '7'
        case 56: // '8'
        case 57: // '9'
          {
            final ctxt = FContext.single(n);
            final j = _parseNumSlow(n, ctxt);
            return (ctxt.finishAt(n), j);
          }
        case 34: // '"'
          {
            final ctxt = FContext.single(n);
            final j = parseString(n, ctxt);
            return (ctxt.finishAt(n), j);
          }
        case 116: // 't'
          return (_parseTrue(n), n + 4);
        case 102: // 'f'
          return (_parseFalse(n), n + 5);
        case 110: // 'n'
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
    List<FContext> stack,
  ) {
    // No tail recursion so we must loop
    int iState = state;
    int iJ = j;
    FContext iContext = context;
    final iStack = stack;

    while (true) {
      final i = reset(iJ);
      checkpoint(iState, i, iContext, iStack);

      final c = atCodeUnit(i);

      if (iStack.length > _MaxDepth) {
        die(i, 'JSON max depth ($_MaxDepth) exceeded');
      }

      if (c == 10) {
        // '\n'
        newline(i);
        iJ = i + 1;
      } else if (c == 32 || c == 9 || c == 13) {
        // ' ', '\t', '\r'
        iJ = i + 1;
      } else if (iState == _DATA) {
        // we are inside an object or array expecting to see data
        if (c == 91) {
          // '['
          iState = _ARRBEG;
          iJ = i + 1;
          iStack.add(iContext);
          iContext = FContext.array(i);
        } else if (c == 123) {
          // '{'
          iState = _OBJBEG;
          iJ = i + 1;
          iStack.add(iContext);
          iContext = FContext.object(i);
        } else if ((c >= 48 && c <= 57) || c == 45) {
          // '0'-'9' or '-'
          iJ = _parseNum(i, iContext);
          iState = iContext.isObject ? _OBJEND : _ARREND;
        } else if (c == 34) {
          // '"'
          iJ = parseString(i, iContext);
          iState = iContext.isObject ? _OBJEND : _ARREND;
        } else if (c == 116) {
          // 't'
          iContext.addValueAt(_parseTrue(i), i);
          iState = iContext.isObject ? _OBJEND : _ARREND;
          iJ = i + 4;
        } else if (c == 102) {
          // 'f'
          iContext.addValueAt(_parseFalse(i), i);
          iState = iContext.isObject ? _OBJEND : _ARREND;
          iJ = i + 5;
        } else if (c == 110) {
          // 'n'
          iContext.addValueAt(_parseNull(i), i);
          iState = iContext.isObject ? _OBJEND : _ARREND;
          iJ = i + 4;
        } else {
          die(i, 'expected json value');
        }
      } else if ((c == 93 && (iState == _ARREND || iState == _ARRBEG)) || // ']'
          (c == 125 && (iState == _OBJEND || iState == _OBJBEG))) {
        // '}'
        // we are inside an array or object and have seen a key or a closing
        // brace, respectively.
        if (iStack.isEmpty) {
          return (iContext.finishAt(i), i + 1);
        } else {
          final ctxt2 = iStack.removeLast();
          ctxt2.addValueAt(iContext.finishAt(i), i);

          iState = ctxt2.isObject ? _OBJEND : _ARREND;
          iJ = i + 1;
          iContext = ctxt2;
        }
      } else if (iState == _KEY) {
        // we are in an object expecting to see a key.
        if (c == 34) {
          // '"'
          iJ = parseString(i, iContext);
          iState = _SEP;
        } else {
          die(i, 'expected "');
        }
      } else if (iState == _SEP) {
        // we are in an object just after a key, expecting to see a colon.
        if (c == 58) {
          // ':'
          iState = _DATA;
          iJ = i + 1;
        } else {
          die(i, 'expected :');
        }
      } else if (iState == _ARREND) {
        // we are in an array, expecting to see a comma (before more data).
        if (c == 44) {
          // ','
          iState = _DATA;
          iJ = i + 1;
        } else {
          die(i, 'expected ] or ,');
        }
      } else if (iState == _OBJEND) {
        // we are in an object, expecting to see a comma (before more data).
        if (c == 44) {
          // ','
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

  JNumber _jnum(int start, int end, int decIndex, int expIndex) {
    if (decIndex == -1 && expIndex == -1) {
      // Fast path: parse integer directly from code units, no substring allocation.
      final neg = atCodeUnit(start) == 45; // '-'
      var result = 0;
      for (var k = neg ? start + 1 : start; k < end; k++) {
        result = result * 10 + (atCodeUnit(k) - 48);
      }
      return JNumber(neg ? -result : result);
    }
    return JNumber(num.parse(atRange(start, end)));
  }

  static const _ARRBEG = 6;
  static const _OBJBEG = 7;
  static const _DATA = 1;
  static const _KEY = 2;
  static const _SEP = 3;
  static const _ARREND = 4;
  static const _OBJEND = 5;

  static final _hexChars = _genHexChars();

  static const _ErrorContext = 6;
  static const _MaxDepth = 10000;
}

/// Relational comparison operators for [String].
extension StringCompareOps on String {
  /// Returns `true` if this string is lexicographically less than [that].
  bool operator <(String that) => compareTo(that) < 0;

  /// Returns `true` if this string is lexicographically less than or equal to [that].
  bool operator <=(String that) => compareTo(that) <= 0;

  /// Returns `true` if this string is lexicographically greater than [that].
  bool operator >(String that) => compareTo(that) > 0;

  /// Returns `true` if this string is lexicographically greater than or equal to [that].
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
