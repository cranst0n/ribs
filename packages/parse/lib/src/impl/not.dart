part of '../parser.dart';

final class Not extends Parser0<Unit> {
  final Parser0<Unit> under;

  Not(this.under);

  @override
  Unit? _parseMut(State state) {
    final offset = state.offset;

    under._parseMut(state);

    if (state.error != null) {
      // under failed, so we succeed
      state.error = null;
    } else {
      // under succeeded but we expected failure here
      // record the current offset before it changes
      // in a potential operation
      final offsetErr = state.offset;

      // we don't reset the offset, so if the underlying parser
      // advanced it will fail in a OneOf
      state.error = Eval.later(() {
        // put as much as possible here, but cannot reference
        // mutable vars
        final matchedStr = state.str.substring(offset, offsetErr);
        return IChain.one(Expectation.expectedFailureAt(offset, matchedStr));
      });
    }

    state.offset = offset;

    return Unit();
  }
}
