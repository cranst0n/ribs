part of '../parser.dart';

final class AnyChar extends Parser<String> {
  @override
  String? _parseMut(State state) {
    final offset = state.offset;

    if (offset < state.str.length) {
      final char = state.str[offset];
      state.offset += 1;
      return char;
    } else {
      state.error = Eval.later(
        () => IChain.one(Expectation.inRange(offset, Char(0), Char(state.str.length))),
      );
      return '\u0000';
    }
  }
}
