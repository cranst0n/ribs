import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_parse/src/caret.dart';

/// Maps absolute character offsets within an input string to line/column
/// positions and vice-versa.
///
/// Lines are split on `\n` and numbered from zero. Columns are also
/// zero-based. The [Caret] type bundles all three coordinates together.
final class LocationMap {
  /// The original input string this map was built from.
  final String input;

  LocationMap(this.input);

  /// The number of lines in the input (always at least 1).
  int get lineCount => lines.length;

  /// Whether [offset] is a valid position in the input (0 ≤ offset ≤ length).
  bool isValidOffset(int offset) => 0 <= offset && offset <= input.length;

  /// Converts an absolute [offset] to a `(line, col)` pair.
  ///
  /// Returns [None] if [offset] is out of range.
  Option<(int, int)> toLineCol(int offset) {
    if (isValidOffset(offset)) {
      final caret = _toCaretUnsafeImpl(offset);
      return Some((caret.line, caret.col));
    } else {
      return none();
    }
  }

  /// Returns the source text of line [i] (zero-based), or [None] if [i] is
  /// out of range.
  Option<String> getLine(int i) {
    if (i >= 0 && i < lines.length) {
      return Some(lines[i]);
    } else {
      return none();
    }
  }

  /// Converts a `(line, col)` pair to an absolute offset.
  ///
  /// Returns [None] if [line] is out of range.
  Option<int> toOffset(int line, int col) {
    if ((line < 0) || (line > lines.length)) {
      return none();
    } else {
      return Some(_firstPos[line] + col);
    }
  }

  /// Converts an absolute [offset] to a [Caret].
  ///
  /// Returns [None] if [offset] is out of range.
  Option<Caret> toCaret(int offset) {
    if (isValidOffset(offset)) {
      return Some(_toCaretUnsafeImpl(offset));
    } else {
      return none();
    }
  }

  /// Converts an absolute [offset] to a [Caret] without bounds checking.
  ///
  /// Throws [ArgumentError] if [offset] is out of range. Prefer [toCaret]
  /// when the offset may be invalid.
  Caret toCaretUnsafe(int offset) {
    if (isValidOffset(offset)) {
      return _toCaretUnsafeImpl(offset);
    } else {
      throw ArgumentError('LocationMap.toCaretUnsafe: offset = $offset exceeds ${input.length}');
    }
  }

  late final IVector<String> lines = input.split('\n').toIVector();

  bool get _endsWithNewLine => input.isNotEmpty && input.last == '\n';

  late final List<int> _firstPos = _calcFirstPos();

  // This does not do bounds checking because we
  // don't want to check twice. Callers to this need to
  // do bounds check
  List<int> _calcFirstPos() {
    final it = lines.iterator.map((str) => str.length);

    final it2 = RIterator.unfold<(int, bool), RIterator<int>>(it, (it) {
      if (it.hasNext) {
        final hn = it.hasNext;
        final i = it.next();

        return Some(((i, hn), it));
      } else {
        return none();
      }
    });

    return it2
        // add one for newline
        .map((tuple) => tuple.$2 ? tuple.$1 + 1 : tuple.$1)
        .scanLeft(0, (a, b) => a + b)
        .toList();
  }

  Caret _toCaretUnsafeImpl(int offset) {
    if (offset == input.length) {
      // this is end of line
      if (offset == 0) {
        return Caret.Start;
      } else {
        final caret = _toCaretUnsafeImpl(offset - 1);

        if (_endsWithNewLine) {
          return Caret(caret.line + 1, 0, offset);
        } else {
          return Caret(caret.line, caret.col + 1, offset);
        }
      }
    } else {
      final idx = _insertionPoint(_firstPos, offset);

      if (idx < 0) {
        final line = idx > 0 ? idx : idx.abs() - 1;

        // so we are pointing into a line
        final lineStart = _firstPos[line];
        final col = offset - lineStart;

        return Caret(line, col, offset);
      } else {
        return Caret(idx, 0, offset);
      }
    }
  }

  // non-negative for element found, negative is the insertion point * -1
  int _insertionPoint(List<int> sortedList, int target) {
    int low = 0;
    int high = sortedList.length;

    while (low <= high) {
      final mid = low + (high - low) ~/ 2;

      if (sortedList[mid] < target) {
        low = mid + 1;
      } else if (sortedList[mid] > target) {
        high = mid - 1;
      } else {
        return mid;
      }
    }

    return -low;
  }
}
