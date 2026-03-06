part of '../parser.dart';

final class StartParser extends Parser0<Unit> {
  @override
  Unit? _parseMut(State state) {
    final offset = state.offset;

    if (offset != 0) {
      state.error = Eval.later(() => IChain.one(Expectation.startOfString(offset)));
    }

    return Unit();
  }
}
