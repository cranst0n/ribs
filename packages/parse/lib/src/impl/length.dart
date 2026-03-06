part of '../parser.dart';

final class Length extends Parser<String> {
  final int len;

  Length(this.len);

  @override
  String? _parseMut(State state) {
    final offset = state.offset;
    final end = offset + len;

    if (end <= state.str.length) {
      final res = state.capture ? state.str.substring(offset, end) : null;
      state.offset = end;

      return res;
    } else {
      state.error = Eval.later(
        () => IChain.one(Expectation.length(offset, len, state.str.length - offset)),
      );

      return null;
    }
  }
}
