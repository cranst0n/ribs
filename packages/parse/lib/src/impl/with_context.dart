part of '../parser.dart';

final class WithContextP0<A> extends Parser0<A> {
  final String context;
  final Parser0<A> under;

  WithContextP0(this.context, this.under);

  @override
  A? _parseMut(State state) {
    final a = under._parseMut(state);

    if (state.error != null) {
      state.error = state.error!.map(
        (err) => err.map((expectation) => Expectation.withContext(context, expectation)),
      );
    }

    return a;
  }
}

final class WithContextP<A> extends Parser<A> {
  final String context;
  final Parser<A> under;

  WithContextP(this.context, this.under);

  @override
  A? _parseMut(State state) {
    final a = under._parseMut(state);

    if (state.error != null) {
      state.error = state.error!.map(
        (err) => err.map((expectation) => Expectation.withContext(context, expectation)),
      );
    }

    return a;
  }
}
