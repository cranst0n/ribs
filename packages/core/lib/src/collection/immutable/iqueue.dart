import 'package:ribs_core/ribs_core.dart';

IQueue<A> iqueue<A>(Iterable<A> as) => IQueue._(nil(), as.toIList());

final class IQueue<A> with RIterableOnce<A>, RIterable<A>, RSeq<A> {
  final IList<A> _in;
  final IList<A> _out;

  IQueue._(this._in, this._out);

  static IQueue<A> empty<A>() => IQueue._(nil(), nil());

  /// Creates an IQueue from the given Ribs [RIterableOnce].
  static IQueue<A> from<A>(RIterableOnce<A> elems) {
    if (elems is IQueue<A>) {
      return elems;
    } else {
      return IQueue._(nil(), elems.toIList());
    }
  }

  @override
  A operator [](int n) {
    Never indexOutOfRange() => throw RangeError('$n is out of bounds (min 0, max ${length - 1})');

    var index = 0;
    var curr = _out;

    while (index < n && curr.nonEmpty) {
      index += 1;
      curr = curr.tail;
    }

    if (index == n) {
      if (curr.nonEmpty) {
        return curr.head;
      } else if (_in.nonEmpty) {
        return _in.last;
      } else {
        indexOutOfRange();
      }
    } else {
      final indexFromBack = n - index;
      final inLength = _in.length;

      if (indexFromBack >= inLength) {
        indexOutOfRange();
      } else {
        return _in[inLength - indexFromBack - 1];
      }
    }
  }

  @override
  IQueue<A> appended(A elem) => enqueue(elem);

  @override
  IQueue<A> appendedAll(RIterableOnce<A> suffix) {
    late IList<A> newIn;

    if (suffix is IQueue<A>) {
      newIn = suffix._in.concat(suffix._out.reverse().prependedAll(_in));
    } else {
      var result = _in;
      final iter = suffix.iterator;

      while (iter.hasNext) {
        result = result.prepended(iter.next());
      }

      newIn = result;
    }

    if (newIn == _in) {
      return this;
    } else {
      return IQueue._(newIn, _out);
    }
  }

  @override
  IQueue<A> concat(RIterableOnce<A> suffix) => appendedAll(suffix);

  @override
  IQueue<A> drop(int n) => from(super.drop(n));

  @override
  IQueue<A> dropRight(int n) => from(super.dropRight(n));

  @override
  IQueue<A> dropWhile(Function1<A, bool> p) => from(super.dropWhile(p));

  (A, IQueue<A>) dequeue() {
    if (_out.isEmpty && _in.nonEmpty) {
      final rev = _in.reverse();
      return (rev.head, IQueue._(nil(), rev.tail));
    } else if (_out.nonEmpty) {
      return (_out.head, IQueue._(_in, _out.tail));
    } else {
      throw RangeError('dequeue on empty queue');
    }
  }

  Option<(A, IQueue<A>)> dequeueOption() => Option.when(() => nonEmpty, dequeue);

  IQueue<A> enqueue(A elem) => IQueue._(_in.prepended(elem), _out);

  IQueue<A> enqueueAll(RIterable<A> iter) => appendedAll(iter);

  @override
  bool exists(Function1<A, bool> p) => _in.exists(p) | _out.exists(p);

  @override
  IQueue<A> filter(Function1<A, bool> p) => from(super.filter(p));

  @override
  IQueue<A> filterNot(Function1<A, bool> p) => from(super.filterNot(p));

  @override
  IQueue<B> flatMap<B>(covariant Function1<A, RIterableOnce<B>> f) {
    var result = empty<B>();
    final it = iterator;

    while (it.hasNext) {
      result = result.concat(from(f(it.next())));
    }

    return result;
  }

  A get front => head;

  @override
  bool forall(Function1<A, bool> p) => _in.forall(p) && _out.forall(p);

  @override
  A get head {
    if (_out.nonEmpty) {
      return _out.head;
    } else if (_in.nonEmpty) {
      return _in.last;
    } else {
      throw RangeError('head on empty queue');
    }
  }

  @override
  IQueue<A> get init => dropRight(1);

  @override
  RIterator<IQueue<A>> get inits => super.inits.map(from);

  @override
  IQueue<A> intersect(RSeq<A> that) => from(super.intersect(that));

  @override
  IQueue<A> intersperse(A x) => from(super.intersperse(x));

  @override
  bool get isEmpty => _in.isEmpty && _out.isEmpty;

  @override
  RIterator<A> get iterator => _out.iterator.concat(_in.reverse());

  @override
  A get last {
    if (_in.nonEmpty) {
      return _in.head;
    } else if (_out.nonEmpty) {
      return _out.last;
    } else {
      throw RangeError('last on empty queue');
    }
  }

  @override
  int get length => _in.length + _out.length;

  @override
  IQueue<B> map<B>(covariant Function1<A, B> f) => IQueue._(_in.map(f), _out.map(f));

  @override
  IQueue<A> padTo(int len, A elem) => from(super.padTo(len, elem));

  @override
  (IQueue<A>, IQueue<A>) partition(Function1<A, bool> p) {
    final (a, b) = super.partition(p);
    return (from(a), from(b));
  }

  @override
  (RSeq<A1>, RSeq<A2>) partitionMap<A1, A2>(Function1<A, Either<A1, A2>> f) {
    final (a, b) = super.partitionMap(f);
    return (from(a), from(b));
  }

  @override
  IQueue<A> patch(int from, RIterableOnce<A> other, int replaced) =>
      IQueue.from(super.patch(from, other, replaced));

  @override
  IQueue<A> prepended(A elem) => IQueue._(_in, _out.prepended(elem));

  @override
  IQueue<A> prependedAll(RIterableOnce<A> prefix) => IQueue._(_in, _out.prependedAll(prefix));

  @override
  IQueue<A> removeAt(int idx) => from(super.removeAt(idx));

  @override
  IQueue<A> removeFirst(Function1<A, bool> p) => from(super.removeFirst(p));

  @override
  IQueue<A> reverse() => IQueue._(_out, _in);

  @override
  IQueue<B> scan<B>(B z, Function2<B, A, B> op) => from(super.scan(z, op));

  @override
  IQueue<B> scanLeft<B>(B z, Function2<B, A, B> op) => from(super.scanLeft(z, op));

  @override
  IQueue<B> scanRight<B>(B z, Function2<A, B, B> op) => from(super.scanRight(z, op));

  @override
  IQueue<A> sortBy<B>(Order<B> order, Function1<A, B> f) => from(super.sortBy(order, f));

  @override
  IQueue<A> sorted(Order<A> order) => from(super.sorted(order));

  @override
  IQueue<A> sortWith(Function2<A, A, bool> lt) => from(super.sortWith(lt));

  @override
  (IQueue<A>, IQueue<A>) span(Function1<A, bool> p) {
    final (a, b) = super.span(p);
    return (from(a), from(b));
  }

  @override
  (IQueue<A>, IQueue<A>) splitAt(int n) {
    final (a, b) = super.splitAt(n);
    return (from(a), from(b));
  }

  @override
  IQueue<A> get tail {
    if (_out.nonEmpty) {
      return IQueue._(_in, _out.tail);
    } else if (_in.nonEmpty) {
      return IQueue._(nil<A>(), _in.reverse().tail);
    } else {
      throw RangeError("tail on empty queue");
    }
  }

  @override
  IQueue<A> take(int n) => from(super.take(n));

  @override
  IQueue<A> takeRight(int n) => from(super.takeRight(n));

  @override
  IQueue<A> takeWhile(Function1<A, bool> p) => from(super.takeWhile(p));

  @override
  IQueue<A> tapEach<U>(Function1<A, U> f) {
    foreach(f);
    return this;
  }

  @override
  IQueue<A> updated(int index, A elem) => from(super.updated(index, elem));

  @override
  IQueue<(A, B)> zip<B>(RIterableOnce<B> that) => from(super.zip(that));

  @override
  IQueue<(A, B)> zipAll<B>(RIterableOnce<B> that, A thisElem, B thatElem) =>
      from(super.zipAll(that, thisElem, thatElem));

  @override
  IQueue<(A, int)> zipWithIndex() => from(super.zipWithIndex());

  @override
  int get hashCode => MurmurHash3.seqHash(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    } else if (other is IQueue<A>) {
      return sameElements(other);
    } else {
      return super == other;
    }
  }
}
