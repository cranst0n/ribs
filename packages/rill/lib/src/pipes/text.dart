import 'package:ribs_rill/ribs_rill.dart';
import 'package:ribs_rill/src/pipes/base64.dart';
import 'package:ribs_rill/src/pipes/hex.dart';
import 'package:ribs_rill/src/pipes/lines.dart';
import 'package:ribs_rill/src/pipes/utf8.dart';

final class TextPipes {
  static final TextPipes _singleton = TextPipes._();

  factory TextPipes() => _singleton;

  TextPipes._();

  Pipe<String, String> get lines => _linesPipes.lines;
  Pipe<String, String> linesLimited(int maxLineLength) => _linesPipes.linesLimited(maxLineLength);

  final base64 = Base64Pipes();
  final hex = HexPipes();
  final _linesPipes = LinesPipes();
  final utf8 = Utf8Pipes();
}
