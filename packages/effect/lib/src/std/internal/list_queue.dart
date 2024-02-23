import 'package:ribs_core/ribs_core.dart';

class ListQueue<A> {
  final IList<A> _list;

  ListQueue._(this._list);

  static ListQueue<A> empty<A>() => ListQueue._(nil());

  ListQueue<A> concat(ListQueue<A> suffix) =>
      ListQueue._(_list.concat(suffix._list));

  (A, ListQueue<A>) dequeue() => _list.uncons(
        (hdtl) => hdtl.foldN(
          () => throw StateError('Called dequeue on an empty Queue'),
          (hd, tl) => (hd, ListQueue._(tl)),
        ),
      );

  Option<(A, ListQueue<A>)> dequeueOption() =>
      Option.when(() => nonEmpty, () => dequeue());

  ListQueue<A> enqueue(A elem) => ListQueue._(_list.appended(elem));

  ListQueue<A> enqueueAll(RIterableOnce<A> elems) =>
      ListQueue._(_list.concat(elems));

  ListQueue<A> filter(Function1<A, bool> p) => ListQueue._(_list.filter(p));

  B foldLeft<B>(B init, Function2<B, A, B> f) => _list.foldLeft(init, f);

  bool get isEmpty => _list.isEmpty;

  bool get nonEmpty => _list.nonEmpty;

  IList<A> toList() => _list;

  @override
  String toString() => isEmpty
      ? 'Empty'
      : _list.mkString(start: 'ListQueue(', sep: ',', end: ')');

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is ListQueue<A> && _list == other._list);

  @override
  int get hashCode => _list.hashCode;
}
