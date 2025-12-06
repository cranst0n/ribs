import 'dart:math';

import 'package:ribs_core/ribs_core.dart';

extension StringOps on String {
  String drop(int n) => slice(min(n, length), length);

  String dropRight(int n) => take(length - max(n, 0));

  String dropWhile(Function1<String, bool> p) => switch (indexWhere((c) => !p(c))) {
    -1 => '',
    final x => substring(x),
  };

  bool exists(Function1<String, bool> p) => indexWhere(p) != -1;

  String filter(Function1<String, bool> p) {
    final buf = StringBuffer();
    var i = 0;

    while (i < length) {
      if (p(this[i])) buf.write(this[i]);
      i += 1;
    }

    return length == buf.length ? this : buf.toString();
  }

  String filterNot(Function1<String, bool> p) => filter((c) => !p(c));

  Option<String> find(Function1<String, bool> p) => switch (indexWhere(p)) {
    -1 => none(),
    final x => Some(this[x]),
  };

  void foreach(Function1<String, void> f) {
    var i = 0;

    while (i < length) {
      f(this[i]);
      i += 1;
    }
  }

  bool forall(Function1<String, bool> f) {
    var i = 0;

    while (i < length) {
      if (!f(this[i])) return false;
      i += 1;
    }

    return true;
  }

  String fold(String z, Function2<String, String, String> op) => foldLeft(z, op);

  B foldLeft<B>(B z, Function2<B, String, B> op) {
    var v = z;
    var i = 0;

    while (i < length) {
      v = op(v, this[i]);
      i += 1;
    }

    return v;
  }

  B foldRight<B>(B z, Function2<String, B, B> op) {
    var v = z;
    var i = length - 1;

    while (i < length) {
      v = op(this[i], v);
      i -= 1;
    }

    return v;
  }

  RIterator<String> grouped(int size) => _StringGroupedIterator(this, size);

  String get head => nonEmpty ? this[0] : throw RangeError('.head on empty string');

  Option<String> get headOption => nonEmpty ? Some(this[0]) : none();

  int indexWhere(Function1<String, bool> p, [int end = 2147483647]) {
    var i = 0;

    while (i < length) {
      if (p(this[i])) return i;
      i += 1;
    }

    return -1;
  }

  int lastIndexWhere(Function1<String, bool> p, [int end = 2147483647]) {
    var i = min(end, length - 1);

    while (i < length) {
      if (p(this[i])) return i;
      i -= 1;
    }

    return -1;
  }

  String init() => !isEmpty ? substring(0, length - 1) : this;

  RIterator<String> inits() => _iterateUntilEmpty((s) => s.init());

  String get last => nonEmpty ? this[length - 1] : throw RangeError('.last on empty string');

  Option<String> get lastOption => nonEmpty ? Some(this[length - 1]) : none();

  bool get nonEmpty => !isEmpty;

  (String, String) partition(Function1<String, bool> p) {
    final (res1, res2) = (StringBuffer(), StringBuffer());
    var i = 0;

    while (i < length) {
      p(this[i]) ? res1.write(this[i]) : res2.write(this[i]);
      i += 1;
    }

    return (res1.toString(), res2.toString());
  }

  RIterator<String> get riterator => RIterator.tabulate(length, (ix) => this[ix]);

  String slice(int from, int until) {
    final start = max(from, 0);
    final end = min(until, length);

    return start >= end ? '' : substring(start, end);
  }

  RIterator<String> sliding(int size, [int step = 1]) =>
      riterator.sliding(size, step).map((s) => s.mkString());

  (String, String) splitAt(int n) => (take(n), drop(n));

  (String, String) span(Function1<String, bool> p) => switch (indexWhere((c) => !p(c))) {
    -1 => (this, ''),
    final x => (substring(0, x), substring(x)),
  };

  String stripPrefix(String prefix) => startsWith(prefix) ? substring(prefix.length) : this;

  String stripSuffix(String suffix) =>
      endsWith(suffix) ? substring(0, length - suffix.length) : this;

  String tail() => nonEmpty ? substring(1, length) : throw RangeError('.tail on empty string');

  RIterator<String> tails() => _iterateUntilEmpty((s) => s.tail());

  String take(int n) => slice(0, min(n, length));

  String takeRight(int n) => drop(length - max(n, 0));

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
