part of '../parser.dart';

final class Select0<A, B, C> extends Parser0<Either<(A, C), B>> {
  final Parser0<Either<A, B>> pab;
  final Parser0<C> pc;

  Select0(this.pab, this.pc);

  @override
  Either<(A, C), B>? _parseMut(State state) => _select(pab, pc, state);
}

final class Select<A, B, C> extends Parser<Either<(A, C), B>> {
  final Parser<Either<A, B>> pab;
  final Parser0<C> pc;

  Select(this.pab, this.pc);

  @override
  Either<(A, C), B>? _parseMut(State state) => _select(pab, pc, state);
}

Either<(A, C), B>? _select<A, B, C>(Parser0<Either<A, B>> pab, Parser0<C> pc, State state) {
  final cap = state.capture;
  state.capture = true;

  final either = pab._parseMut(state);
  state.capture = cap;

  if (state.error == null) {
    return either!.fold(
      (a) {
        final c = pc._parseMut(state);

        if (cap && state.error == null) {
          return Left((a, c!));
        } else {
          return null;
        }
      },
      (b) => Right(b),
    );
  } else {
    return null;
  }
}
