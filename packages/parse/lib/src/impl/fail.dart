part of '../parser.dart';

final class Fail<A> extends Parser<A> {
  @override
  A? _parseMut(State state) {
    final offset = state.offset;
    state.error = Eval.later(() => IChain.one(Expectation.fail(offset)));

    return null;
  }

  Parser<B> widen<B>() => Fail();
}

final class FailWith<A> extends Parser<A> {
  final String message;

  FailWith(this.message);

  @override
  A? _parseMut(State state) {
    final offset = state.offset;
    state.error = Eval.later(() => IChain.one(Expectation.failWith(offset, message)));

    return null;
  }

  Parser<B> widen<B>() => FailWith(message);
}
