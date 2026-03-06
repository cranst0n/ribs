part of '../parser.dart';

final class GetCaret extends Parser0<Caret> {
  @override
  Caret? _parseMut(State state) {
    // safe because the offset can never go too far
    return state.locationMap.toCaretUnsafe(state.offset);
  }
}
