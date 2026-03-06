part of '../parser.dart';

final class Map0<A, B> extends Parser0<B> {
  final Parser0<A> parser;
  final Function1<A, B> f;

  Map0(this.parser, this.f);

  Parser0<C> andThen<C>(Function1<B, C> g) => Map0(parser, (A x) => g(f(x)));

  @override
  B? _parseMut(State state) => _map(parser, f, state);
}

final class Map<A, B> extends Parser<B> {
  final Parser0<A> parser;
  final Function1<A, B> f;

  Map(this.parser, this.f);

  Parser<C> andThen<C>(Function1<B, C> g) => Map(parser, (A x) => g(f(x)));

  @override
  B? _parseMut(State state) => _map(parser, f, state);
}

B? _map<A, B>(Parser0<A> parser, Function1<A, B> f, State state) {
  final a = parser._parseMut(state);

  if (a != null && state.error == null && state.capture) {
    return f(a);
  } else {
    return null;
  }
}
