import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_parse/ribs_parse.dart';

/// This is a class to convert linear offset in a string into lines, or the
/// column and line numbers.
///
/// This is useful for display to humans who in text editors think in terms of
/// line and column numbers
final class LocationMap {
  final String input;

  final List<String> _lines;
  final bool _endsWithNewLine;

  /// The position of the first element of the ith line
  late final List<int> _firstPos = _calcFirstPos(_lines);

  LocationMap(this.input)
      : _lines = input.split('\n'),
        _endsWithNewLine = input.isNotEmpty && input.endsWith('\n');

  List<int> _calcFirstPos(List<String> lines) => ilist(lines)
      .zipWithIndex()
      .mapN((line, ix) => ix < line.length - 1 ? line.length : line.length)
      .scanLeft(0, (a, b) => a + b)
      .toList();

  int get lineCount => _lines.length;

  bool isValidOffset(int offset) => 0 <= offset && offset <= input.length;

  /// Given a string offset return the line and column If input.length is given
  /// (EOF) we return the same value as if the string were one character longer
  /// (i.e. if we have appended a non-newline character at the EOF)

  Option<(int, int)> toLineCol(int offset) => Option.when(
        () => isValidOffset(offset),
        () {
          final caret = toCaretUnsafeImpl(offset);
          return (caret.line, caret.col);
        },
      );

  // This does not do bounds checking because we
  // don't want to check twice. Callers to this need to
  // do bounds check
  Caret toCaretUnsafeImpl(int offset) {
    if (offset == input.length) {
      // end of the line
      if (offset == 0) {
        return Caret.start;
      } else {
        final caret = toCaretUnsafeImpl(offset - 1);
        if (_endsWithNewLine) {
          return Caret(caret.line + 1, 0, offset);
        } else {
          return Caret(caret.line, caret.col + 1, offset);
        }
      }
    } else {
      final idx = _firstPos.indexOf(offset);

      if (idx < 0) {
        // idx = (~(insertion pos) - 1)
        // The insertion point is defined as the point at which the key would be
        // inserted into the array: the index of the first element greater than
        // the key, or a.length if all elements in the array are less than the specified key.
        //
        // so insertion pos = ~(idx + 1)
        final line = ~(idx + 1);
        // so we are pointing into a line
        final lineStart = _firstPos[line];
        final col = offset - lineStart;
        return Caret(line, col, offset);
      } else {
        // idx is exactly the right value because offset is beginning of a line
        return Caret(idx, 0, offset);
      }
    }
  }

  Caret toCaretUnsafe(int offset) {
    if (isValidOffset(offset)) {
      return toCaretUnsafeImpl(offset);
    } else {
      throw Exception('offset = $offset exceeds ${input.length}');
    }
  }

  Option<Caret> toCaret(int offset) =>
      Option.when(() => isValidOffset(offset), () => toCaretUnsafeImpl(offset));

  /// return the line without a newline
  Option<String> getLine(int i) =>
      Option.when(() => 0 <= i && i < _lines.length, () => _lines[i]);

  /// Return the offset for a given line/col. if we return Some(input.length)
  /// this means EOF if we return Some(i) for 0 <= i < input.length it is a
  /// valid item else offset < 0 or offset > input.length we return None
  Option<int> toOffset(int line, int col) => Option.when(
      () => 0 <= line && line < _lines.length, () => _firstPos[line] + col);
}
