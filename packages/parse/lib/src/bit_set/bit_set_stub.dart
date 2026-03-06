import 'dart:typed_data';

import 'package:ribs_core/ribs_core.dart';

/// BitSet with 32-bit word packing.
///
/// Used on Dart web (and as a fallback). [Uint32List] maps directly to a JS
/// `Uint32Array`, giving native typed-array performance. 32-bit packing is
/// required on web because JavaScript truncates bitwise operations to 32 bits,
/// making 64-bit packing unsafe.
final class BitSet {
  final int min;
  final Uint32List _words;

  BitSet._(this.min, this._words);

  /// Builds a [BitSet] covering the range [[min], [max]], setting a bit for
  /// every integer that falls within one of the [ranges] (inclusive on both
  /// ends).
  factory BitSet.ofRanges(int min, int max, IList<(int, int)> ranges) {
    // Each Uint32 holds 32 bits (2^5 = 32), so word index = offset >> 5,
    // and bit position within that word = offset & 31.
    final len = ((max - min) >> 5) + 1;
    final words = Uint32List(len);

    var aux = ranges;

    while (aux.nonEmpty) {
      final (start, end) = aux.head;

      for (var c = start; c <= end; c++) {
        final offset = c - min;
        words[offset >> 5] |= 1 << (offset & 31);
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
    final len = ((max - min) >> 5) + 1;
    final words = Uint32List(len);

    for (final c in charArray) {
      final offset = c.codeUnitAt(0) - min;
      words[offset >> 5] |= 1 << (offset & 31);
    }

    return BitSet._(min, words);
  }

  /// Returns true iff [value] is represented in this set.
  bool isSet(int value) {
    final idx = value - min;
    if (idx < 0) {
      return false;
    } else {
      final word = idx >> 5;

      if (word >= _words.length) {
        return false;
      } else {
        return (_words[word] & (1 << (idx & 31))) != 0;
      }
    }
  }
}
