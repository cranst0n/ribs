part of '../parser.dart';

final class WithStringP0<A> extends Parser0<(A, String)> {
  final Parser0<A> parser;

  WithStringP0(this.parser);

  @override
  (A, String)? _parseMut(State state) => withString0(parser, state);
}

final class WithStringP<A> extends Parser<(A, String)> {
  final Parser<A> parser;

  WithStringP(this.parser);

  @override
  (A, String)? _parseMut(State state) => withString0(parser, state);
}

(A, String)? withString0<A>(Parser0<A> pa, State state) {
  final init = state.offset;
  final a = pa._parseMut(state);

  if (a != null && state.error == null) {
    return (a, state.str.substring(init, state.offset));
  } else {
    return null;
  }
}
