part of '../parser.dart';

final class Void0<A> extends Parser0<Unit> {
  final Parser0<A> parser;

  Void0(this.parser);

  @override
  Unit? _parseMut(State state) => _voided(parser, state);
}

final class Void<A> extends Parser<Unit> {
  final Parser<A> parser;

  Void(this.parser);

  @override
  Unit? _parseMut(State state) => _voided(parser, state);
}

Unit _voided(Parser0<dynamic> pa, State state) {
  final s0 = state.capture;

  state.capture = false;
  pa._parseMut(state);
  state.capture = s0;

  return Unit();
}
