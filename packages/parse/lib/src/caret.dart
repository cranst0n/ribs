import 'package:ribs_core/ribs_core.dart';

/// A position within a source string, expressed as a (line, column, offset)
/// triple.
///
/// Lines and columns are zero-based. [offset] is the absolute character offset
/// from the start of the input.
final class Caret {
  /// Zero-based line number.
  final int line;

  /// Zero-based column number within [line].
  final int col;

  /// Absolute character offset from the start of the input.
  final int offset;

  const Caret(this.line, this.col, this.offset);

  /// The position at the very beginning of the input (line 0, col 0, offset 0).
  static const Start = Caret(0, 0, 0);

  /// An [Order] that compares carets by line, then column, then offset.
  static final order = Order<Caret>.from((left, right) {
    final c0 = left.line.compareTo(right.line);

    if (c0 != 0) {
      return c0;
    } else {
      final c1 = left.col.compareTo(right.col);

      if (c1 != 0) {
        return c1;
      } else {
        return left.offset.compareTo(right.offset);
      }
    }
  });
}
