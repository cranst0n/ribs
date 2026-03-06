import 'dart:typed_data';

import 'package:ribs_core/ribs_core.dart';

/// BitSet with 64-bit word packing.
///
/// Safe on Dart native (VM), where [int] is a signed 64-bit integer and
/// bitwise operations preserve all 64 bits. [Int64List] stores values at
/// the VM's native word width with no boxing overhead. Bit 63 sets the sign
/// bit (1 << 63 == minInt64), but the != 0 test still works correctly in
/// two's-complement arithmetic.
final class BitSet {
  final int min;
  final Int64List _words;

  BitSet._(this.min, this._words);

  /// Builds a [BitSet] covering the range [[min], [max]], setting a bit for
  /// every integer that falls within one of the [ranges] (inclusive on both
  /// ends).
  factory BitSet.ofRanges(int min, int max, IList<(int, int)> ranges) {
    // Each Int64 holds 64 bits (2^6 = 64), so word index = offset >> 6,
    // and bit position within that word = offset & 63.
    final len = ((max - min) >> 6) + 1;
    final words = Int64List(len);

    var aux = ranges;

    while (aux.nonEmpty) {
      final (start, end) = aux.head;

      for (var c = start; c <= end; c++) {
        final offset = c - min;
        words[offset >> 6] |= 1 << (offset & 63);
      }

      aux = aux.tail;
    }

    return BitSet._(min, words);
  }

  /// Builds a [BitSet] from a sorted array of single characters, setting a
  /// bit for each character's code unit. [charArray] must be non-empty and
  /// sorted ascending.
  factory BitSet.bitSetFor(Iterable<String> charArray) {
    final min = charArray.first.codeUnitAt(0);
    final max = charArray.last.codeUnitAt(0);
    final len = ((max - min) >> 6) + 1;
    final words = Int64List(len);

    for (final c in charArray) {
      final offset = c.codeUnitAt(0) - min;
      words[offset >> 6] |= 1 << (offset & 63);
    }

    return BitSet._(min, words);
  }

  /// Returns true iff [value] is represented in this set.
  bool isSet(int value) {
    final idx = value - min;

    if (idx < 0) {
      return false;
    } else {
      final word = idx >> 6;
      if (word >= _words.length) {
        return false;
      } else {
        return (_words[word] & (1 << (idx & 63))) != 0;
      }
    }
  }
}
