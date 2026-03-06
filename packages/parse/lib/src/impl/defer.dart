part of '../parser.dart';

final class Defer0<A> extends Parser0<A> {
  final Function0<Parser0<A>> f;
  Parser0<A>? _computed;

  Defer0(this.f);

  @override
  A? _parseMut(State state) {
    if (_computed != null) {
      return _computed!._parseMut(state);
    } else {
      final res = _compute0(f);
      _computed = res;

      return res._parseMut(state);
    }
  }
}

final class Defer<A> extends Parser<A> {
  final Function0<Parser<A>> f;
  Parser<A>? _computed;

  Defer(this.f);

  @override
  A? _parseMut(State state) {
    if (_computed != null) {
      return _computed!._parseMut(state);
    } else {
      final res = _compute(f);
      _computed = res;

      return res._parseMut(state);
    }
  }
}

Parser0<A> _compute0<A>(Function0<Parser0<A>> fn) {
  Parser0<A> current = fn();

  while (true) {
    switch (current) {
      case Defer0<A>(:final f):
        current = f();
      case Defer<A>(:final f):
        current = f();
      default:
        return current;
    }
  }
}

Parser<A> _compute<A>(Function0<Parser<A>> fn) {
  Parser<A> current = fn();

  while (true) {
    switch (current) {
      case Defer<A>(:final f):
        current = f();
      default:
        return current;
    }
  }
}
