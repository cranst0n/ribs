import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_rill/ribs_rill.dart';

final class LinesPipes {
  static final LinesPipes _singleton = LinesPipes._();

  factory LinesPipes() => _singleton;

  LinesPipes._();

  Pipe<String, String> get lines => _linesImpl();
  Pipe<String, String> linesLimited(int maxLineLength) => _linesImpl(maxLineLength: maxLineLength);

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
