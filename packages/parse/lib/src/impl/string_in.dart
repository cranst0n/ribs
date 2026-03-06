part of '../parser.dart';

final class StringIn extends Parser<String> {
  final SplayTreeSet<String> sorted;
  final RadixNode tree;

  StringIn(this.sorted)
    : assert(sorted.length > 2, 'StringIn expected more than two items, found: ${sorted.length}'),
      assert(!sorted.contains(''), 'StringIn does not allow empty string'),
      tree = RadixNode.fromSortedStrings(NonEmptyIList.unsafe(sorted.toIList()));

  @override
  String? _parseMut(State state) => _stringIn(tree, sorted, state);
}

String? _stringIn(RadixNode radix, SplayTreeSet<String> all, State state) {
  final startOffset = state.offset;
  final matched = radix.matchAtOrNull(state.str, startOffset);

  if (matched == null) {
    state.error = Eval.later(() => IChain.one(Expectation.oneOfStr(startOffset, all.toIList())));
    return null;
  } else {
    state.offset = startOffset + matched.length;
    return matched;
  }
}
