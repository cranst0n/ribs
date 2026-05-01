import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_rill/src/pipes/base64.dart';
import 'package:ribs_rill/src/pipes/hex.dart';
import 'package:ribs_rill/src/pipes/lines.dart';
import 'package:ribs_rill/src/pipes/utf8.dart';

/// A convenience namespace grouping text-oriented pipes.
///
/// Obtained via [Pipes.text] or `TextPipes()`. Provides line splitting and
/// sub-namespaces for base64, hex, and UTF-8 operations.
///
/// ```dart
/// final lines = Rill.emit('hello\nworld')
///     .through(Pipes.text.lines);
/// ```
final class TextPipes {
  static final TextPipes _singleton = TextPipes._();

  factory TextPipes() => _singleton;

  TextPipes._();

  /// Splits a stream of strings into lines, handling `\r\n` and `\n`.
  Pipe<String, String> get lines => _linesPipes.lines;

  /// Like [lines] but rejects lines exceeding [maxLineLength] characters.
  Pipe<String, String> linesLimited(int maxLineLength) => _linesPipes.linesLimited(maxLineLength);

  /// Base64 encode/decode pipes.
  final base64 = Base64Pipes();

  /// Hexadecimal encode/decode pipes.
  final hex = HexPipes();
  final _linesPipes = LinesPipes();

  /// UTF-8 encode/decode pipes.
  final utf8 = Utf8Pipes();
}
