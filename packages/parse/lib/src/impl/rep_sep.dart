part of '../parser.dart';

/// A direct, loop-based implementation of `repSep` (one-or-more with separator).
///
/// Equivalent to the combinator expression
/// `p1.product(sep.voided.with1.soft.productR(p1).rep0()).map(...)`,
/// but avoids the virtual-dispatch overhead of the intermediate parser objects
/// and the per-iteration allocation from `rep0 = OneOf0([Rep, pure(nil)])`.
///
/// Semantics preserved:
///   • Sep fails without consuming → clean end of list.
///   • Sep partially consumes then fails → propagate error.
///   • Sep succeeds, p1 fails without consuming → soft-rewind to before sep,
///     clean end of list.
///   • Sep succeeds, p1 partially consumes then fails → propagate error.
final class RepSep<A> extends Parser<NonEmptyIList<A>> {
  final Parser<A> p1;
  final Parser0<dynamic> sep;

  RepSep(this.p1, this.sep);

  @override
  NonEmptyIList<A>? _parseMut(State state) {
    // Parse the mandatory first element.
    final head = p1._parseMut(state);
    if (state.error != null) return null;

    // Only allocate a tail builder when the caller wants the values.
    final List<A>? tail = state.capture ? <A>[] : null;

    while (true) {
      final savedOffset = state.offset;

      // Run sep, always discarding its value.
      final s0 = state.capture;
      state.capture = false;
      sep._parseMut(state);
      state.capture = s0;

      if (state.error != null) {
        if (state.offset == savedOffset) {
          // Sep failed without consuming → clean end of list.
          state.error = null;
          break;
        }

        // Sep partially consumed then failed → propagate.
        return null;
      }

      final afterSepOffset = state.offset;

      // Run p1 with soft semantics: if it fails without consuming after sep,
      // rewind to before sep and treat as a clean end.
      final next = p1._parseMut(state);

      if (state.error != null) {
        if (state.offset == afterSepOffset) {
          // p1 failed without consuming → soft rewind.
          state.offset = savedOffset;
          state.error = null;
          break;
        }

        // p1 partially consumed then failed → propagate.
        return null;
      }

      if (tail != null && next != null) tail.add(next);
    }

    if (state.capture) {
      // head is non-null here: Parser<A> returns non-null on success with
      // capture=true.  Use an explicit null check so flow analysis widens A?→A
      // without the `!` operator (which the linter flags on type parameters).
      final h = head;
      if (h == null) {
        return null;
      } else {
        return NonEmptyIList(h, IList.fromDart(tail!));
      }
    } else {
      return null;
    }
  }
}
