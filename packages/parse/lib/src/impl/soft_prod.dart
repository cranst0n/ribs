part of '../parser.dart';

final class SoftProd0<A, B> extends Parser0<(A, B)> {
  final Parser0<A> first;
  final Parser0<B> second;

  SoftProd0(this.first, this.second);

  @override
  (A, B)? _parseMut(State state) => _softProd(first, second, state);
}

final class SoftProd<A, B> extends Parser<(A, B)> {
  final Parser0<A> first;
  final Parser0<B> second;

  SoftProd(this.first, this.second)
    : assert(
        first is Parser || second is Parser,
        'SoftProd should have at least one Parser, both were Parser0',
      );

  @override
  (A, B)? _parseMut(State state) => _softProd(first, second, state);
}

(A, B)? _softProd<A, B>(Parser0<A> pa, Parser0<B> pb, State state) {
  final offset = state.offset;
  final a = pa._parseMut(state);

  if (state.error == null) {
    final offsetA = state.offset;
    final b = pb._parseMut(state);

    // pa passed, if pb fails without consuming, rewind to offset
    if (state.error != null) {
      if (state.offset == offsetA) {
        state.offset = offset;
      }

      // else partial parse of b, don't rewind
      return null;
    } else if (state.capture) {
      return (a!, b!);
    } else {
      return null;
    }
  } else {
    return null;
  }
}
