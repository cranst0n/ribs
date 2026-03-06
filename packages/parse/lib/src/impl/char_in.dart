part of '../parser.dart';

final class CharIn extends Parser<String> {
  final BitSet bitset;
  final NonEmptyIList<CharsRange> ranges;

  CharIn(this.bitset, this.ranges);

  factory CharIn.fromRanges(NonEmptyIList<CharsRange> ranges) {
    final all = ranges.toIList();
    final min = all.foldLeft(ranges.head.start, (Char acc, r) => r.start < acc ? r.start : acc);
    final max = all.foldLeft(ranges.head.end, (Char acc, r) => r.end > acc ? r.end : acc);

    return CharIn(
      BitSet.ofRanges(
        min.codeUnit,
        max.codeUnit,
        all.map((r) => (r.start.codeUnit, r.end.codeUnit)),
      ),
      ranges,
    );
  }

  @override
  String? _parseMut(State state) {
    final offset = state.offset;

    if (offset < state.str.length) {
      final code = Char(state.str.codeUnitAt(offset));

      if (bitset.isSet(code.codeUnit)) {
        state.offset = offset + 1;
        // Avoid allocating a single-char String when the result will be
        // discarded (e.g. inside .string or .voided).
        if (state.capture) return state.str[offset];
        return '';
      }
    }

    state.error = Eval.later(() => makeError(offset));
    return '\u0000';
  }

  IChain<Expectation> makeError(int offset) {
    var result = IChain.empty<Expectation>();
    var aux = ranges.toIList();

    while (aux.nonEmpty) {
      final range = aux.head;
      result = result.appended(Expectation.inRange(offset, range.start, range.end));
      aux = aux.tail;
    }

    return result;
  }
}
