part of '../parser.dart';

final class OneOf0<A> extends Parser0<A> {
  final IList<Parser0<A>> all;

  OneOf0(this.all) {
    if (all.size < 2) {
      throw ArgumentError('OneOf0 expected more than two items, found: ${all.size}');
    }
  }

  @override
  A? _parseMut(State state) => _oneOf(all, state);
}

final class OneOf<A> extends Parser<A> {
  final IList<Parser<A>> all;

  OneOf(this.all) {
    if (all.size < 2) {
      throw ArgumentError('OneOf expected more than two items, found: ${all.size}');
    }
  }

  @override
  A? _parseMut(State state) => _oneOf(all, state);
}

A? _oneOf<A>(IList<Parser0<A>> all, State state) {
  final offset = state.offset;
  // Initialise lazily: on the success path errs is never touched.
  Eval<IChain<Expectation>>? errs;

  var remaining = all;

  while (remaining.nonEmpty) {
    final res = remaining.head._parseMut(state);

    // Stop if no error, or if we consumed some input (committed).
    final err = state.error;

    if (err == null || state.offset != offset) {
      return res;
    } else {
      errs =
          errs == null
              ? err
              : errs.flatMap(
                (IChain<Expectation> e1) => err.map((IChain<Expectation> e2) => e1.concat(e2)),
              );
      state.error = null;
      remaining = remaining.tail;
    }
  }

  // All alternatives failed without consuming input.
  state.error = errs?.map((IChain<Expectation> e) => filterFails(offset, e));

  return null;
}

IChain<Expectation> filterFails(int offset, IChain<Expectation> fs) {
  final fs1 = fs.filter((exp) => exp is ExpectationFail && exp.offset == offset);
  return fs1.isEmpty ? IChain.one(Expectation.fail(offset)) : fs1;
}
