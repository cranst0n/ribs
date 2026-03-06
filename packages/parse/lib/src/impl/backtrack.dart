part of '../parser.dart';

final class Backtrack0<A> extends Parser0<A> {
  final Parser0<A> parser;

  Backtrack0(this.parser);

  @override
  A? _parseMut(State state) => _backtrack(parser, state);
}

final class Backtrack<A> extends Parser<A> {
  final Parser<A> parser;

  Backtrack(this.parser);

  @override
  A? _parseMut(State state) => _backtrack(parser, state);
}

A? _backtrack<A>(Parser0<A> pa, State state) {
  final offset = state.offset;
  final a = pa._parseMut(state);

  if (state.error != null) state.offset = offset;

  return a;
}
