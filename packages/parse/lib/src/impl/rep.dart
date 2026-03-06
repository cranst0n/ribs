part of '../parser.dart';

final class Rep<A, B> extends Parser<B> {
  final Parser<A> p1;
  final int min;
  final int maxMinusOne;
  final Accumulator<A, B> acc;

  Rep(this.p1, this.min, this.maxMinusOne, this.acc);

  @override
  B? _parseMut(State state) {
    // first parse one, so we can initialize the appender with that value
    // then do the rest, with min -> min - 1 and
    // maxMinusOne -> maxMinusOne - 1 or Int.MaxValue as "forever" sentinel
    final head = p1._parseMut(state);

    final maxRemainingMinusOne =
        maxMinusOne == Integer.maxValue ? Integer.maxValue : maxMinusOne - 1;

    if (head == null) {
      return null;
    } else if (state.error != null) {
      return null;
    } else if (state.capture) {
      final app = acc.newAppender(head);

      if (_repCapture(p1, min - 1, maxRemainingMinusOne, state, app)) {
        return app.finish();
      } else {
        return null;
      }
    } else {
      _repNoCapture(p1, min - 1, maxRemainingMinusOne, state);

      return null;
    }
  }
}

bool _repCapture<A, B>(Parser<A> p, int min, int maxMinusOne, State state, Appender<A, B> append) {
  int offset = state.offset;
  int cnt = 0;

  // maxMinusOne == Int.MaxValue is a sentinel value meaning "forever"
  while (cnt <= maxMinusOne) {
    final a = p._parseMut(state);

    if (state.error == null && a != null) {
      // success — some parsers return null on failure, so check both
      cnt += 1;
      append.append(a);
      offset = state.offset;
    } else {
      // there has been an error (state.error != null or a == null)
      if ((state.offset == offset) && (cnt >= min)) {
        // we correctly read at least min items without a partial advance
        state.error = null;

        return true;
      } else {
        // partial advance, or not enough items accumulated
        return false;
      }
    }
  }
  return true;
}

void _repNoCapture<A>(Parser<A> p, int min, int maxMinusOne, State state) {
  var offset = state.offset;
  var cnt = 0;

  // maxMinusOne == Int.MaxValue is a sentinel value meaning "forever"
  while (cnt <= maxMinusOne) {
    final a = p._parseMut(state);

    if (state.error == null && a != null) {
      cnt += 1;
      offset = state.offset;
    } else {
      // there has been an error
      if ((state.offset == offset) && (cnt >= min)) {
        // we correctly read at least min items
        // reset the error to make the success
        state.error = null;
      }

      // else we did a partial read then failed
      // but didn't read at least min items
      return;
    }
  }
}
