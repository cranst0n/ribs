part of '../parser.dart';

final class Peek extends Parser0<Unit> {
  final Parser0<Unit> under;

  Peek(this.under);

  @override
  Unit? _parseMut(State state) {
    final offset = state.offset;

    under._parseMut(state);

    if (state.error == null) state.offset = offset;

    return Unit();
  }
}
