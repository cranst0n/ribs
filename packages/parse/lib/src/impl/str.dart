part of '../parser.dart';

final class Str extends Parser<Unit> {
  final String message;

  Str(this.message) {
    if (message.isEmpty) throw ArgumentError('Str requires a non-empty message');
  }

  @override
  Unit? _parseMut(State state) {
    final offset = state.offset;

    if (state.str.regionMatches(offset, message, 0, message.length)) {
      state.offset += message.length;
      return Unit();
    } else {
      state.error = Eval.later(() => IChain.one(Expectation.oneOfStr(offset, ilist([message]))));
      return Unit();
    }
  }
}

final class IgnoreCase extends Parser<Unit> {
  final String message;

  IgnoreCase(this.message) {
    if (message.isEmpty) throw ArgumentError('IgnoreCase requires a non-empty message');
  }

  @override
  Unit? _parseMut(State state) {
    final offset = state.offset;

    if (state.str.regionMatchesIgnoreCase(offset, message, 0, message.length)) {
      state.offset += message.length;
    } else {
      state.error = Eval.later(() => IChain.one(Expectation.oneOfStr(offset, ilist([message]))));
    }

    return Unit();
  }
}
