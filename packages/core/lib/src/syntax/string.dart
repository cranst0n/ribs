import 'dart:math';

import 'package:ribs_core/ribs_core.dart';

/// Scala-style string operations, treating a [String] as a sequence of
/// single-character strings.
extension StringOps on String {
  /// Returns all characters after the first [n], or an empty string if
  /// [n] >= [length].
  String drop(int n) => slice(min(n, length), length);

  /// Returns all characters except the last [n], or an empty string if
  /// [n] >= [length].
  String dropRight(int n) => take(length - max(n, 0));

  /// Drops the longest prefix of characters satisfying [p] and returns the
  /// remainder.
  String dropWhile(Function1<String, bool> p) => switch (indexWhere((c) => !p(c))) {
    -1 => '',
    final x => substring(x),
  };

  /// Returns `true` if at least one character satisfies [p].
  bool exists(Function1<String, bool> p) => indexWhere(p) != -1;

  /// Returns a new string containing only the characters satisfying [p].
  String filter(Function1<String, bool> p) {
    final buf = StringBuffer();
    var i = 0;

    while (i < length) {
      if (p(this[i])) buf.write(this[i]);
      i += 1;
    }

    return length == buf.length ? this : buf.toString();
  }

  /// Returns a new string containing only the characters not satisfying [p].
  String filterNot(Function1<String, bool> p) => filter((c) => !p(c));

  /// Returns the first character satisfying [p] as [Some], or [None] if no
  /// character satisfies [p].
  Option<String> find(Function1<String, bool> p) => switch (indexWhere(p)) {
    -1 => none(),
    final x => Some(this[x]),
  };

  /// Applies [f] to each character.
  void foreach(Function1<String, void> f) {
    var i = 0;

    while (i < length) {
      f(this[i]);
      i += 1;
    }
  }

  /// Returns `true` if all characters satisfy [f].
  bool forall(Function1<String, bool> f) {
    var i = 0;

    while (i < length) {
      if (!f(this[i])) return false;
      i += 1;
    }

    return true;
  }

  /// Folds characters left-to-right using [op], starting from [z].
  String fold(String z, Function2<String, String, String> op) => foldLeft(z, op);

  /// Left-associative fold over characters, starting from [z].
  B foldLeft<B>(B z, Function2<B, String, B> op) {
    var v = z;
    var i = 0;

    while (i < length) {
      v = op(v, this[i]);
      i += 1;
    }

    return v;
  }

  /// Right-associative fold over characters, starting from [z].
  B foldRight<B>(B z, Function2<String, B, B> op) {
    var v = z;
    var i = length - 1;

    while (i >= 0) {
      v = op(this[i], v);
      i -= 1;
    }

    return v;
  }

  /// Returns an iterator that yields non-overlapping substrings of length
  /// [size]. The last group may be shorter than [size] if the string length
  /// is not a multiple of [size].
  RIterator<String> grouped(int size) => _StringGroupedIterator(this, size);

  /// The first character. Throws [RangeError] if the string is empty.
  String get head => nonEmpty ? this[0] : throw RangeError('.head on empty string');

  /// The first character as [Some], or [None] if the string is empty.
  Option<String> get headOption => nonEmpty ? Some(this[0]) : none();

  /// Returns the index of the first character satisfying [p], or -1 if none
  /// does.
  int indexWhere(Function1<String, bool> p, [int end = 2147483647]) {
    var i = 0;

    while (i < length) {
      if (p(this[i])) return i;
      i += 1;
    }

    return -1;
  }

  /// Returns the index of the last character satisfying [p], or -1 if none
  /// does.
  int lastIndexWhere(Function1<String, bool> p, [int end = 2147483647]) {
    var i = min(end, length - 1);

    while (i >= 0) {
      if (p(this[i])) return i;
      i -= 1;
    }

    return -1;
  }

  /// All characters except the last. Returns an empty string if already empty.
  String get init => !isEmpty ? substring(0, length - 1) : this;

  /// An iterator over successive [init] prefixes, from longest to shortest,
  /// ending with an empty string.
  RIterator<String> get inits => _iterateUntilEmpty((s) => s.init);

  /// The last character. Throws [RangeError] if the string is empty.
  String get last => nonEmpty ? this[length - 1] : throw RangeError('.last on empty string');

  /// The last character as [Some], or [None] if the string is empty.
  Option<String> get lastOption => nonEmpty ? Some(this[length - 1]) : none();

  /// Returns `true` if the string is not empty.
  bool get nonEmpty => !isEmpty;

  /// Splits characters into two strings: those satisfying [p] (first) and
  /// those not satisfying [p] (second).
  (String, String) partition(Function1<String, bool> p) {
    final (res1, res2) = (StringBuffer(), StringBuffer());
    var i = 0;

    while (i < length) {
      p(this[i]) ? res1.write(this[i]) : res2.write(this[i]);
      i += 1;
    }

    return (res1.toString(), res2.toString());
  }

  /// Returns `true` if the specified subregion of this string matches the
  /// specified subregion of [other]. Returns `false` if any index is out of
  /// bounds.
  bool regionMatches(int toffset, String other, int ooffset, int len) {
    if (toffset < 0 || ooffset < 0 || toffset + len > length || ooffset + len > other.length) {
      return false;
    } else {
      return substring(toffset, toffset + len) == other.substring(ooffset, ooffset + len);
    }
  }

  /// Case-insensitive variant of [regionMatches]. Returns `false` if any index
  /// is out of bounds.
  bool regionMatchesIgnoreCase(int toffset, String other, int ooffset, int len) {
    if (toffset < 0 || ooffset < 0 || toffset + len > length || ooffset + len > other.length) {
      return false;
    } else {
      return substring(toffset, toffset + len).toLowerCase() ==
          other.substring(ooffset, ooffset + len).toLowerCase();
    }
  }

  /// An [RIterator] over the individual characters of this string.
  RIterator<String> get riterator => RIterator.tabulate(length, (ix) => this[ix]);

  /// Returns the substring from index [from] (inclusive) to [until]
  /// (exclusive), clamped to valid bounds.
  String slice(int from, int until) {
    final start = max(from, 0);
    final end = min(until, length);

    return start >= end ? '' : substring(start, end);
  }

  /// Returns an iterator of overlapping substrings of length [size], advancing
  /// by [step] characters each time.
  RIterator<String> sliding(int size, [int step = 1]) =>
      riterator.sliding(size, step).map((s) => s.mkString());

  /// Splits the string at index [n], returning `(take(n), drop(n))`.
  (String, String) splitAt(int n) => (take(n), drop(n));

  /// Returns the longest prefix of characters satisfying [p] paired with the
  /// remainder.
  (String, String) span(Function1<String, bool> p) => switch (indexWhere((c) => !p(c))) {
    -1 => (this, ''),
    final x => (substring(0, x), substring(x)),
  };

  /// Removes [prefix] from the start of this string if present; otherwise
  /// returns this string unchanged.
  String stripPrefix(String prefix) => startsWith(prefix) ? substring(prefix.length) : this;

  /// Removes [suffix] from the end of this string if present; otherwise
  /// returns this string unchanged.
  String stripSuffix(String suffix) =>
      endsWith(suffix) ? substring(0, length - suffix.length) : this;

  /// All characters except the first. Throws [RangeError] if the string is
  /// empty.
  String get tail => nonEmpty ? substring(1, length) : throw RangeError('.tail on empty string');

  /// An iterator over successive [tail] suffixes, from longest to shortest,
  /// ending with an empty string.
  RIterator<String> get tails => _iterateUntilEmpty((s) => s.tail);

  /// Returns the first [n] characters, or the whole string if [n] >= [length].
  String take(int n) => slice(0, min(n, length));

  /// Returns the last [n] characters, or the whole string if [n] >= [length].
  String takeRight(int n) => drop(length - max(n, 0));

  /// Returns the longest prefix of characters satisfying [p].
  String takeWhile(Function1<String, bool> p) => switch (indexWhere((c) => !p(c))) {
    -1 => this,
    final x => substring(0, x),
  };

  RIterator<String> _iterateUntilEmpty(Function1<String, String> f) =>
      RIterator.iterate(this, f).takeWhile((s) => s.nonEmpty).concat(RIterator.single(''));
}

class _StringGroupedIterator extends RIterator<String> {
  final String s;
  final int groupSize;

  var _pos = 0;

  _StringGroupedIterator(this.s, this.groupSize);

  @override
  bool get hasNext => _pos < s.length;

  @override
  String next() {
    if (_pos >= s.length) {
      return RIterator.empty<String>().next();
    } else {
      final r = s.slice(_pos, _pos + groupSize);
      _pos += groupSize;
      return r;
    }
  }
}
