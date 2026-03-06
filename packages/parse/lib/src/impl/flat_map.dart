part of '../parser.dart';

final class FlatMap0<A, B> extends Parser0<B> {
  final Parser0<A> parser;
  final Function1<A, Parser0<B>> f;

  FlatMap0(this.parser, this.f);

  @override
  B? _parseMut(State state) => _flatMap(parser, f, state);
}

// at least one of the parsers needs to be a Parser
final class FlatMap<A, B> extends Parser<B> {
  final Parser0<A> parser;
  final Function1<A, Parser0<B>> f;

  FlatMap(this.parser, this.f);

  @override
  B? _parseMut(State state) => _flatMap(parser, f, state);
}

B? _flatMap<A, B>(Parser0<A> parser, Function1<A, Parser0<B>> f, State state) {
  final cap = state.capture;
  state.capture = true;

  final a = parser._parseMut(state);
  state.capture = cap;

  if (a != null && state.error == null) {
    return f(a)._parseMut(state);
  } else {
    return null;
  }
}
