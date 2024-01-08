import 'package:ribs_core/ribs_core.dart';

final class Array<A>
    with IterableOnce<A?>, RibsIterable<A?>, Seq<A?>, IndexedSeq<A?> {
  final List<A?> _list;

  Array(int len) : this._(List.filled(len, null));

  Array._(this._list);

  static Array<A> empty<A>() => Array(0);

  static Array<A> fill<A>(int len, A? elem) => Array._(List.filled(len, elem));

  static Array<A> tabulate<A>(int n, Function1<int, A?> f) =>
      Array._(List.generate(n, f));

  static Array<A> from<A>(IterableOnce<A?> elems) =>
      fromDart(elems.toList(growable: false));

  static Array<A> fromDart<A>(Iterable<A?> elems) {
    return Array._(elems.toList(growable: false));
  }

  @override
  A? operator [](int idx) => _list[idx];

  void operator []=(int index, A? value) => _list[index] = value;

  @override
  Array<A?> appended(A? elem) {
    final dest = copyAs(this, length + 1);
    dest[length] = elem;
    return dest;
  }

  @override
  RibsIterator<A?> get iterator => RibsIterator.fromDart(_list.iterator);

  @override
  int get length => _list.length;

  @override
  Array<A?> reverse() => Array.fromDart(_list.reversed);

  static void arraycopy<A>(
    Array<A> src,
    int srcPos,
    Array<A> dest,
    int destPos,
    int length,
  ) =>
      dest._list.setRange(
        destPos,
        destPos + length,
        src._list.getRange(srcPos, srcPos + length),
      );

  static Array<A> copyAs<A>(Array<A> original, int newLength) =>
      Array._(List.of(original._list, growable: false));

  static Array<A> copyOf<A>(Array<A> original, int newLength) {
    if (newLength == original.length) {
      return from(original);
    } else {
      final copy = Array<A>(newLength);
      arraycopy(original, 0, copy, 0, newLength);
      return copy;
    }
  }

  static Array<A> copyOfRange<A>(Array<A> original, int from, int to) =>
      Array.fromDart(original._list.getRange(from, to));

  static bool equals<A>(Array<A> a, Array<A> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;

    for (int idx = 0; idx < a.length; idx++) {
      if (a[idx] != b[idx]) return false;
    }

    return true;
  }
}
