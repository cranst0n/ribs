final class Caret {
  final int line;
  final int col;
  final int offset;

  const Caret(this.line, this.col, this.offset);

  static const start = Caret(0, 0, 0);
}
