import 'package:ribs_json/src/dawn/fcontext.dart';
import 'package:ribs_json/src/dawn/string_based_parser.dart';
import 'package:ribs_json/src/dawn/sync_parser.dart';

/// A synchronous [Parser] that reads from a Dart [String].
///
/// Used by [Parser.parseUnsafe] and [Parser.parseFromString].
class StringParser extends SyncParser with StringBasedParser {
  /// The JSON source string.
  final String s;
  int _line = 0;
  int _offset = 0;

  StringParser(this.s);

  @override
  String at(int i) => s.substring(i, i + 1);

  @override
  int atCodeUnit(int i) => s.codeUnitAt(i);

  @override
  bool atEof(int i) => i == s.length;

  @override
  String atRange(int i, int j) => s.substring(i, j);

  @override
  void checkpoint(int state, int i, FContext context, List<FContext> stack) {}

  @override
  void close() {}

  @override
  int column(int i) => i - _offset;

  @override
  void newline(int i) {
    _line += 1;
    _offset = i + 1;
  }

  @override
  int line() => _line;

  @override
  int reset(int i) => i;
}
