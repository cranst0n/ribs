part of '../parser.dart';

final class EndParser extends Parser0<Unit> {
  @override
  Unit? _parseMut(State state) {
    final offset = state.offset;

    if (offset != state.str.length) {
      state.error = Eval.later(() => IChain.one(Expectation.endOfString(offset, state.str.length)));
    }

    return Unit();
  }
}
