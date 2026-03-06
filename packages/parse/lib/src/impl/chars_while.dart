part of '../parser.dart';

/// Scans forward while [predicate] holds on each successive code unit, then
/// returns the matched substring in one call.  This avoids the per-character
/// virtual-dispatch + BitSet-lookup overhead of `charIn(set).rep().string`.
///
/// Fails (sets [State.error]) if no characters match.
final class CharsWhile extends Parser<String> {
  final bool Function(Char) predicate;

  CharsWhile(this.predicate);

  @override
  String? _parseMut(State state) {
    final str = state.str;
    final start = state.offset;
    final len = str.length;

    var offset = start;

    while (offset < len && predicate(Char(str.codeUnitAt(offset)))) {
      offset++;
    }

    if (offset > start) {
      state.offset = offset;
      if (state.capture) return str.substring(start, offset);
      return '';
    } else {
      state.error = Eval.later(() => IChain.one(Expectation.fail(start)));
      return null;
    }
  }
}

/// Like [CharsWhile] but succeeds with an empty string when no characters
/// match (zero-or-more).
final class CharsWhile0 extends Parser0<String> {
  final bool Function(Char) predicate;

  CharsWhile0(this.predicate);

  @override
  String? _parseMut(State state) {
    final str = state.str;
    final start = state.offset;
    final len = str.length;

    var offset = start;

    while (offset < len && predicate(Char(str.codeUnitAt(offset)))) {
      offset++;
    }

    state.offset = offset;

    if (state.capture) {
      return str.substring(start, offset);
    } else {
      return '';
    }
  }
}
