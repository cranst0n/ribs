part of '../parser.dart';

final class Prod0<A, B> extends Parser0<(A, B)> {
  final Parser0<A> first;
  final Parser0<B> second;

  Prod0(this.first, this.second);

  @override
  (A, B)? _parseMut(State state) => _prod(first, second, state);
}

final class Prod<A, B> extends Parser<(A, B)> {
  final Parser0<A> first;
  final Parser0<B> second;

  Prod(this.first, this.second)
    : assert(
        first is Parser || second is Parser,
        'Prod should have at least one Parser, both were Parser0',
      );

  @override
  (A, B)? _parseMut(State state) => _prod(first, second, state);
}

(A, B)? _prod<A, B>(Parser0<A> pa, Parser0<B> pb, State state) {
  final a = pa._parseMut(state);

  if (state.error == null) {
    final b = pb._parseMut(state);

    if (state.capture && (state.error == null)) {
      return (a!, b!);
    } else {
      return null;
    }
  } else {
    return null;
  }
}
