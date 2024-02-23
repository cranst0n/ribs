part of '../riterator.dart';

final class _UnfoldIterator<A, S> extends RIterator<A> {
  final Function1<S, Option<(A, S)>> f;

  late S _state;
  Option<(A, S)>? _nextResult;

  _UnfoldIterator(S init, this.f) : _state = init;

  @override
  bool get hasNext {
    _nextResult ??= f(_state);
    return _nextResult?.isDefined ?? false;
  }

  @override
  A next() {
    if (hasNext) {
      final (value, newState) =
          _nextResult!.getOrElse(() => throw 'unreachable');
      _state = newState;
      _nextResult = null;
      return value;
    } else {
      noSuchElement();
    }
  }
}
