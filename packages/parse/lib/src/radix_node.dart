import 'dart:math';

import 'package:ribs_core/ribs_core.dart';

/// A node in a compressed radix (Patricia) trie used to match one of a fixed
/// set of string literals efficiently.
///
/// Each node stores a [bitMask] derived from the lowest bits of the next
/// character's code unit. That mask is used to index into [prefixes] and
/// [children] without iterating over every branch. If the indexed prefix
/// matches the input at the current offset, the match continues into the
/// corresponding child; otherwise the longest match found so far ([matched])
/// is returned.
///
/// Use [RadixNode.fromSortedStrings] to build a trie from a set of literals,
/// then call [matchAt] or [matchAtOrNull] to run a match against input.
final class RadixNode {
  /// The string that terminates at this node, or `null` if no string ends here.
  final String? matched;

  /// Bitmask applied to the next character's code unit to compute the branch
  /// index. The array size is `bitMask + 1`.
  final int bitMask;

  /// The prefix strings stored at each branch index. A `null` entry means no
  /// branch exists for that index.
  final Array<String> prefixes;

  /// The child nodes corresponding to each entry in [prefixes].
  final Array<RadixNode> children;

  RadixNode(
    this.matched,
    this.bitMask,
    this.prefixes,
    this.children,
  );

  /// Builds a [RadixNode] trie from a non-empty list of strings.
  ///
  /// Duplicate strings are removed before construction. The strings do not
  /// need to be sorted — [fromSortedStrings] handles deduplication internally.
  factory RadixNode.fromSortedStrings(NonEmptyIList<String> strings) =>
      _fromTree(null, '', strings.toIList().distinct());

  /// Returns all strings that this trie can match, in the order they are
  /// stored (root [matched] first, then children depth-first).
  IList<String> get allStrings {
    final rest = children.iterator.flatMap(
      (node) => node == null ? nil<String>() : node.allStrings,
    );

    if (matched == null) {
      return rest.toIList();
    } else {
      return rest.filterNot((str) => str == matched).toIList().prepended(matched!);
    }
  }

  /// Attempts to match at position [off] in [str].
  ///
  /// Returns the end offset (exclusive) of the matched string on success, or
  /// `-1` if no string in the trie matches at [off].
  int matchAt(String str, int off) => switch (matchAtOrNull(str, off)) {
    null => -1,
    final nonNull => off + nonNull.length,
  };

  /// Attempts to match at position [offset] in [str].
  ///
  /// Returns the matched string on success, or `null` if no string in the
  /// trie matches at [offset]. Returns `null` for out-of-range offsets.
  String? matchAtOrNull(String str, int offset) {
    if (offset < 0 || str.length < offset) {
      return null;
    } else {
      return matchAtOrNullLoop(str, offset);
    }
  }

  /// Inner matching loop — assumes [offset] is in bounds.
  ///
  /// Walks the trie iteratively, following branches whose prefix matches the
  /// input, and returns the longest [matched] value reached before the trie
  /// can no longer advance.
  String? matchAtOrNullLoop(String str, int offset) {
    var node = this;
    var off = offset;

    while (true) {
      if (off < str.length) {
        final c = str.codeUnitAt(off);
        // this is a hash of c
        final idx = c & node.bitMask;
        final prefix = node.prefixes[idx];

        if (prefix != null) {
          // this prefix *may* match here, but may not
          // note we only know that c & bitMask matches
          // what the prefix has to be, it could differ
          // on other bits.
          final plen = prefix.length;

          if (str.regionMatches(off, prefix, 0, plen)) {
            off += plen;
            node = node.children[idx]!;
          } else {
            return node.matched;
          }
        } else {
          return node.matched;
        }
      } else {
        // this is only the case where offset == str.length
        // due to our invariant
        return node.matched;
      }
    }
  }

  // Note: _fromTree is tree-recursive (recurses inside a foreach closure), not
  // tail-recursive. Stack depth is bounded by the length of the longest string.
  static RadixNode _fromTree(String? prevMatch, String prefix, IList<String> rest) {
    final (nonEmpties, empties) = rest.partition((str) => str.nonEmpty);

    // If rest contains the empty string, we have a valid prefix
    final thisPrefix = empties.nonEmpty ? prefix : prevMatch;

    if (nonEmpties.isEmpty) {
      return RadixNode(thisPrefix, 0, Array.ofDim(1), Array.ofDim(1));
    } else {
      final headKeys = nonEmpties.iterator.map((str) => str.head).toISet();
      // The idea here is to use b lowest bits of the char
      // as an index into the array, with the smallest
      // number b such that all the keys are unique & b
      int findBitMask(int b) {
        var mask = b;

        while (true) {
          if (mask == 0xffff) return mask; // biggest it can be

          final hs = headKeys.size;

          final allDistinct =
              // they can't all be distinct if the size isn't as big as the headKeys size
              ((mask + 1) >= hs) &&
              (headKeys.iterator.map((c) => c.codeUnitAt(0) & mask).toISet().size == hs);

          if (allDistinct) {
            return mask;
          }

          mask = (mask << 1) | 1;
        }
      }

      final bitMask = findBitMask(0);
      final branching = bitMask + 1;
      final prefixes = Array.ofDim<String>(branching);
      final children = Array.ofDim<RadixNode>(branching);

      nonEmpties.groupBy((s) => s.head.codeUnitAt(0) & bitMask).foreach((tuple) {
        final (idx, strings) = tuple;

        // strings is a non-empty List[String] which all start with the same char
        final prefix1 = strings.reduce((a, b) => commonPrefixCombine(a, b));

        // note prefix1.length >= 1 because they all match on the first character
        prefixes[idx] = prefix1;

        children[idx] = _fromTree(
          thisPrefix,
          prefix + prefix1,
          strings.map((str) => str.drop(prefix1.length)),
        );
      });

      return RadixNode(thisPrefix, bitMask, prefixes, children);
    }
  }

  /// Returns the longest common prefix of [x] and [y], or `""` if they share
  /// no common prefix.
  static String commonPrefixCombine(String x, String y) {
    final l = commonPrefixLength(x, y);

    if (l == 0) {
      return "";
    } else if (l == x.length) {
      return x;
    } else if (l == y.length) {
      return y;
    } else {
      return x.take(l);
    }
  }

  /// Returns the length of the common prefix shared by [s1] and [s2].
  static int commonPrefixLength(String s1, String s2) {
    final len = min(s1.length, s2.length);
    var idx = 0;

    while (idx < len) {
      if (s1.codeUnitAt(idx) != s2.codeUnitAt(idx)) {
        return idx;
      } else {
        idx = idx + 1;
      }
    }

    return idx;
  }
}
