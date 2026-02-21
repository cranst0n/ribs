import 'dart:typed_data';

import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/src/dawn/byte_based_parser.dart';
import 'package:ribs_json/src/dawn/fcontext.dart';
import 'package:ribs_json/src/dawn/sync_parser.dart';

final class ByteDataParser extends SyncParser with ByteBasedParser {
  final Uint8List src;
  final int _start;
  final int _limit;

  int _lineState = 0;
  int _offset = 0;

  ByteDataParser(this.src)
    : _start = src.offsetInBytes,
      _limit = src.lengthInBytes - src.offsetInBytes;

  @override
  String at(int i) => String.fromCharCode(src[i + _start]);

  @override
  int atCodeUnit(int i) => src[i + _start];

  @override
  bool atEof(int i) => i >= _limit;

  @override
  String atRange(int i, int j) =>
      String.fromCharCodes(src.buffer.asUint8List().getRange(i + _start, j + _start));

  @override
  int byte(int i) => src[i + _start];

  @override
  void checkpoint(int state, int i, FContext context, IList<FContext> stack) {}

  @override
  void close() {}

  @override
  int column(int i) => i - _offset;

  @override
  int line() => _lineState;

  @override
  void newline(int i) {
    _lineState += 1;
    _offset = i + 1;
  }

  @override
  int reset(int i) => i;
}
