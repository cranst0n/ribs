part of '../parser.dart';

final class StringP0<A> extends Parser0<String> {
  final Parser0<A> parser;

  StringP0(this.parser);

  @override
  String? _parseMut(State state) => _string0(parser, state);
}

final class StringP<A> extends Parser<String> {
  final Parser<A> parser;

  StringP(this.parser);

  @override
  String? _parseMut(State state) => _string0(parser, state);
}

String? _string0(Parser0<dynamic> pa, State state) {
  final s0 = state.capture;
  state.capture = false;
  final init = state.offset;

  pa._parseMut(state);

  state.capture = s0;

  if (state.error == null) {
    return state.str.substring(init, state.offset);
  } else {
    return null;
  }
}
