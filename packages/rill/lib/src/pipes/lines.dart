import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_rill/ribs_rill.dart';

/// Pipes for splitting a stream of strings into individual lines.
///
/// Lines are delimited by `\n`, `\r`, or `\r\n`. The line terminators
/// themselves are not included in the emitted strings.
///
/// ```dart
/// // Split a text stream into lines:
/// stringRill.through(Pipes.text.lines)
///
/// // With a maximum line length guard:
/// stringRill.through(Pipes.text.linesLimited(4096))
/// ```
final class LinesPipes {
  static final LinesPipes _singleton = LinesPipes._();

  factory LinesPipes() => _singleton;

  LinesPipes._();

  /// A [Pipe] that splits incoming string chunks into individual lines.
  ///
  /// Handles `\n`, `\r`, and `\r\n` line endings, including cases where a
  /// `\r\n` sequence is split across two chunks. Line terminators are
  /// stripped from the output. A trailing line without a terminator is still
  /// emitted.
  Pipe<String, String> get lines => _linesImpl();

  /// A [Pipe] that splits incoming string chunks into individual lines,
  /// raising an error if any single line exceeds [maxLineLength] characters.
  ///
  /// Behaves identically to [lines] except that an error is emitted when
  /// the internal line buffer grows beyond [maxLineLength] before a line
  /// terminator is found. This guards against unbounded memory usage when
  /// processing untrusted input.
  Pipe<String, String> linesLimited(int maxLineLength) => _linesImpl(maxLineLength: maxLineLength);

  // Shared implementation for [lines] and [linesLimited].
  //
  // Incoming string chunks are scanned character-by-character for newline
  // sequences. Complete lines are collected into a buffer and emitted as
  // output chunks. A [StringBuffer] accumulates partial lines that span
  // chunk boundaries. The [_BoolWrapper] tracks whether a leading `\n`
  // should be ignored (for `\r\n` sequences split across chunks).
  Pipe<String, String> _linesImpl({int? maxLineLength}) {
    void fillBuffers(
      StringBuffer stringBuffer,
      List<String> linesBuffer,
      String string,
      _BoolWrapper ignoreFirstCharNewLine,
    ) {
      int i;

      if (ignoreFirstCharNewLine.value) {
        ignoreFirstCharNewLine.value = false;

        if (string.nonEmpty && string[0] == '\n') {
          i = 1;
        } else {
          i = 0;
        }
      } else {
        i = 0;
      }

      final stringSize = string.length;

      while (i < stringSize) {
        final idx = _indexForNl(string, stringSize, i);

        if (idx < 0) {
          stringBuffer.write(string.substring(i, stringSize));
          i = stringSize;
        } else {
          if (stringBuffer.isEmpty) {
            linesBuffer.add(string.substring(i, idx));
          } else {
            stringBuffer.write(string.substring(i, idx));
            linesBuffer.add(stringBuffer.toString());
            stringBuffer.clear();
          }

          i = idx + 1;

          if (string[i - 1] == '\r') {
            if (i < stringSize) {
              if (string[i] == '\n') {
                i += 1;
              }
            } else {
              ignoreFirstCharNewLine.value = true;
            }
          }
        }
      }
    }

    Pull<String, Unit> go(
      Rill<String> rill,
      StringBuffer stringBuffer,
      _BoolWrapper ignoreFirstCharNewLine,
      bool first,
    ) {
      return rill.pull.uncons.flatMap((hdtl) {
        return hdtl.foldN(
          () {
            if (first) {
              return Pull.done;
            } else {
              final result = stringBuffer.toString();

              if (result.isNotEmpty && result.last == '\r') {
                return Pull.output(chunk([result.dropRight(1), '']));
              } else {
                return Pull.output1(result);
              }
            }
          },
          (hd, tl) {
            final linesBuffer = <String>[];

            hd.foreach((string) {
              fillBuffers(stringBuffer, linesBuffer, string, ignoreFirstCharNewLine);
            });

            return Option(maxLineLength)
                .filter((maxLen) => stringBuffer.length > maxLen)
                .fold(
                  () => Pull.output(
                    Chunk.fromDart(linesBuffer),
                  ).append(() => go(tl, stringBuffer, ignoreFirstCharNewLine, false)),
                  (maxLen) => Pull.raiseError(
                    'LineTooLong: ${stringBuffer.length} is greater than $maxLen',
                  ),
                );
          },
        );
      });
    }

    return (rill) =>
        Rill.suspend(() => go(rill, StringBuffer(), _BoolWrapper(false), true).rillNoScope);
  }

  // Returns the index of the first `\n` or `\r` in [string] starting at
  // [begin], or -1 if none is found before [stringSize].
  @pragma('vm:prefer-inline')
  int _indexForNl(String string, int stringSize, int begin) {
    int i = begin;

    while (i < stringSize) {
      switch (string[i]) {
        case '\n':
        case '\r':
          return i;
        default:
          i += 1;
      }
    }

    return -1;
  }
}

class _BoolWrapper {
  bool value;

  _BoolWrapper(this.value);
}
