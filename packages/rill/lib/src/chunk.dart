import 'dart:typed_data';
import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';

Chunk<O> chunk<O>(Iterable<O> as) => Chunk.fromDart(as);

/// A strictly strict, immutable sequence of values, optimized for indexed based access
/// and efficient concatenation.
///
/// TODO: Many functions inherited from RSeq, IndexedSeq, etc. can probably be optimized.
sealed class Chunk<O> with RIterableOnce<O>, RIterable<O>, RSeq<O>, IndexedSeq<O> {
  const Chunk();

  /// Creates a [Chunk<int>] backed by a Uint8List.
  static Chunk<int> bytes(Uint8List bytes) =>
      bytes.isEmpty ? Chunk.empty() : _Uint8ListChunk(bytes);

  static Chunk<int> byteVector(ByteVector bv) => _ByteVectorChunk(bv);

  /// Creates a chunk of [n] copies of [a].
  static Chunk<O> constant<O>(int n, O a) => n <= 0 ? Chunk.empty() : _ConstantChunk(a, n);

  static Chunk<O> empty<O>() => _EmptyChunk<O>();

  static Chunk<O> fill<O>(int n, O a) => constant(n, a);

  static Chunk<O> from<O>(RIterableOnce<O> iterable) => fromList(iterable.toList());

  static Chunk<O> fromDart<O>(Iterable<O> iterable) => fromList(iterable.toList());

  static Chunk<O> fromList<O>(List<O> list) {
    if (list.isEmpty) return empty();
    return _BoxedChunk(List.of(list, growable: false));
  }

  static Chunk<O> singleton<O>(O a) => _SingletonChunk(a);

  static final unit = Chunk.singleton(Unit());

  @override
  O operator [](int idx);

  Chunk<O> operator +(Chunk<O> that) => concat(that);

  @override
  Chunk<O> appended(O elem) => from(super.appended(elem));

  @override
  Chunk<O> appendedAll(RIterableOnce<O> suffix) => from(super.appendedAll(suffix));

  @override
  Chunk<B> collect<B>(Function1<O, Option<B>> f) => from(super.collect(f));

  @override
  RIterator<Chunk<O>> combinations(int n) => super.combinations(n).map(Chunk.from);

  /// Efficiently converts this chunk to a single compact chunk.
  ///
  /// If this is already compact (e.g. Boxed or Uint8List), returns this.
  /// If this is a ConcatChunk, it allocates a single array and copies elements.
  Chunk<O> compact() => isCompact ? this : _BoxedChunk(toDartList());

  /// Concatenates this chunk with [that].
  @override
  Chunk<O> concat(Chunk<O> that) {
    if (isEmpty) {
      return that;
    } else if (that.isEmpty) {
      return this;
    } else {
      return _ConcatChunk(this, that);
    }
  }

  @override
  Chunk<O> diff(RSeq<O> that) => from(super.diff(that));

  @override
  Chunk<O> distinct() => from(super.distinct());

  @override
  Chunk<O> distinctBy<B>(Function1<O, B> f) => from(super.distinctBy(f));

  @override
  Chunk<O> drop(int n) => switch (n) {
    final n when n <= 0 => this,
    final n when n > size => Chunk.empty(),
    _ => _SliceChunk(this, n, size - n),
  };

  @override
  Chunk<O> dropRight(int n) => switch (n) {
    final n when n <= 0 => this,
    final n when n >= size => Chunk.empty(),
    _ => take(size - n),
  };

  @override
  Chunk<O> dropWhile(Function1<O, bool> p) => from(super.dropWhile(p));

  @override
  Chunk<O> filter(Function1<O, bool> p) => from(super.filter(p));

  @override
  Chunk<O> filterNot(Function1<O, bool> p) => from(super.filterNot(p));

  @override
  Chunk<B> flatMap<B>(Function1<O, RIterableOnce<B>> f) => from(super.flatMap(f));

  @override
  IMap<K, Chunk<O>> groupBy<K>(Function1<O, K> f) => super.groupBy(f).mapValues(Chunk.from);

  @override
  IMap<K, Chunk<B>> groupMap<K, B>(Function1<O, K> key, Function1<O, B> f) =>
      super.groupMap(key, f).mapValues(Chunk.from);

  @override
  RIterator<Chunk<O>> grouped(int size) => super.grouped(size).map(Chunk.from);

  @override
  Chunk<O> get init => from(super.init);

  @override
  RIterator<Chunk<O>> get inits => super.inits.map(Chunk.from);

  @override
  Chunk<O> intersect(RSeq<O> that) => from(super.intersect(that));

  @override
  Chunk<O> intersperse(O x) => from(super.intersperse(x));

  bool get isCompact => true;

  @override
  RIterator<O> get iterator => _ChunkIterator(this);

  @override
  int get knownSize => size;

  @override
  int get length => size;

  @override
  Chunk<B> map<B>(Function1<O, B> f) => from(super.map(f));

  (S, Chunk<B>) mapAccumulate<S, B>(S initial, Function2<S, O, (S, B)> f) {
    final bldr = <B>[];

    var s = initial;

    foreach((a) {
      final (s2, a2) = f(s, a);
      bldr.add(a2);
      s = s2;
    });

    return (s, chunk(bldr));
  }

  @override
  Chunk<O> padTo(int len, O elem) => from(super.padTo(len, elem));

  @override
  (Chunk<O>, Chunk<O>) partition(Function1<O, bool> p) {
    final (a, b) = super.partition(p);
    return (from(a), from(b));
  }

  @override
  (Chunk<A1>, Chunk<A2>) partitionMap<A1, A2>(Function1<O, Either<A1, A2>> f) {
    final (a, b) = super.partitionMap(f);
    return (from(a), from(b));
  }

  @override
  Chunk<O> patch(int from, RIterableOnce<O> other, int replaced) =>
      Chunk.from(super.patch(from, other, replaced));

  @override
  RIterator<IndexedSeq<O>> permutations() => super.permutations().map(Chunk.from);

  @override
  Chunk<O> prepended(O elem) => from(super.prepended(elem));

  @override
  Chunk<O> prependedAll(RIterableOnce<O> prefix) => from(super.prependedAll(prefix));

  @override
  Chunk<O> removeAt(int idx) => from(super.removeAt(idx));

  @override
  Chunk<O> removeFirst(Function1<O, bool> p) => from(super.removeFirst(p));

  @override
  Chunk<O> reverse() => fromDart(toDartList().reversed);

  @override
  Chunk<B> scan<B>(B z, Function2<B, O, B> op) => from(super.scan(z, op));

  @override
  Chunk<B> scanLeft<B>(B z, Function2<B, O, B> op) => from(super.scanLeft(z, op));

  @override
  Chunk<B> scanRight<B>(B z, Function2<O, B, B> op) => from(super.scanRight(z, op));

  (Chunk<B>, B) scanLeftCarry<B>(B initial, Function2<B, O, B> op) => _scanLeft(initial, op, false);

  (Chunk<B>, B) _scanLeft<B>(B initial, Function2<B, O, B> op, bool emitZero) {
    final bldr = <B>[];
    var acc = initial;

    if (emitZero) bldr.add(acc);

    foreach((a) {
      acc = op(acc, a);
      bldr.add(acc);
    });

    return (chunk(bldr), acc);
  }

  @override
  Chunk<O> slice(int from, int until) => Chunk.from(super.slice(from, until));

  @override
  RIterator<Chunk<O>> sliding(int size, [int step = 1]) =>
      super.sliding(size, step).map(Chunk.from);

  @override
  Chunk<O> sorted(Order<O> order) => from(super.sorted(order));

  @override
  Chunk<O> sortBy<B>(Order<B> order, Function1<O, B> f) => from(super.sortBy(order, f));

  @override
  Chunk<O> sortWith(Function2<O, O, bool> lt) => from(super.sortWith(lt));

  @override
  (Chunk<O>, Chunk<O>) span(Function1<O, bool> p) {
    final (a, b) = super.span(p);
    return (from(a), from(b));
  }

  @override
  (Chunk<O>, Chunk<O>) splitAt(int n) {
    final (a, b) = super.splitAt(n);
    return (from(a), from(b));
  }

  @override
  Chunk<O> get tail => drop(1);

  @override
  RIterator<Chunk<O>> get tails => super.tails.map(Chunk.from);

  @override
  Chunk<O> take(int n) => switch (n) {
    final n when n <= 0 => Chunk.empty(),
    final n when n >= size => this,
    _ => _SliceChunk(this, 0, n),
  };

  @override
  Chunk<O> takeRight(int n) => switch (n) {
    final n when n <= 0 => Chunk.empty(),
    final n when n >= size => this,
    _ => drop(size - n),
  };

  @override
  Chunk<O> takeWhile(Function1<O, bool> p) => from(super.takeWhile(p));

  @override
  Chunk<O> tapEach<U>(Function1<O, U> f) => from(super.tapEach(f));

  @override
  Either<B, Chunk<C>> traverseEither<B, C>(Function1<O, Either<B, C>> f) =>
      super.traverseEither(f).map(Chunk.from);

  @override
  Option<Chunk<B>> traverseOption<B>(Function1<O, Option<B>> f) =>
      super.traverseOption(f).map(Chunk.from);

  /// Copies the elements of this chunk into a standard Dart List.
  List<O> toDartList();

  @override
  String toString() => "Chunk(${toDartList().join(', ')})";

  @override
  Chunk<O> updated(int index, O elem) => from(super.updated(index, elem));

  @override
  Chunk<(O, B)> zip<B>(RIterableOnce<B> that) => from(super.zip(that));

  @override
  Chunk<(O, B)> zipAll<B>(RIterableOnce<B> that, O thisElem, B thatElem) =>
      from(super.zipAll(that, thisElem, thatElem));

  @override
  Chunk<(O, int)> zipWithIndex() => from(super.zipWithIndex());

  @override
  int get hashCode {
    var h = MurmurHash3.stringHash('Chunk');

    foreach((o) => h = MurmurHash3.mix(h, o.hashCode));

    return MurmurHash3.finalizeHash(h, size);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    } else if (other is Chunk<O>) {
      return sameElements(other);
    } else {
      return super == other;
    }
  }
}

extension ChunkByteOps on Chunk<int> {
  BitVector get toBitVector => toByteVector.bits;

  ByteVector get toByteVector => ByteVector.viewAt(At((i) => this[i]), size);

  Uint8List get asUint8List {
    return switch (this) {
      final _ByteVectorChunk bv => bv.asUint8List,
      final _Uint8ListChunk ch => ch.asUint8List,
      final _BoxedChunk<int> boxed => Uint8List.fromList(boxed._values),
      _ => Uint8List.fromList(toDartList()),
    };
  }
}

class _EmptyChunk<O> extends Chunk<O> {
  const _EmptyChunk();

  @override
  O operator [](int index) => throw RangeError.index(index, this);

  @override
  int get size => 0;

  @override
  List<O> toDartList() => const [];

  @override
  Chunk<O> compact() => this;
}

class _SingletonChunk<O> extends Chunk<O> {
  final O value;
  const _SingletonChunk(this.value);

  @override
  O operator [](int index) => index == 0 ? value : throw RangeError.index(index, this);

  @override
  int get size => 1;

  @override
  List<O> toDartList() => [value];
}

class _BoxedChunk<O> extends Chunk<O> {
  final List<O> _values;

  const _BoxedChunk(this._values);

  @override
  O operator [](int index) => _values[index];

  @override
  int get size => _values.length;

  @override
  List<O> toDartList() => List.of(_values);
}

class _ConstantChunk<O> extends Chunk<O> {
  final O value;

  final int _length;

  const _ConstantChunk(this.value, this._length);

  @override
  O operator [](int index) {
    if (index >= 0 && index < _length) return value;
    throw RangeError.index(index, this);
  }

  @override
  int get size => _length;

  @override
  List<O> toDartList() => List.filled(_length, value);
}

class _Uint8ListChunk extends Chunk<int> {
  final Uint8List _bytes;

  const _Uint8ListChunk(this._bytes);

  @override
  int operator [](int index) => _bytes[index];

  @override
  int get size => _bytes.length;

  @override
  List<int> toDartList() => _bytes.toList();

  Uint8List get asUint8List => _bytes;
}

class _ByteVectorChunk extends Chunk<int> {
  final ByteVector bv;

  const _ByteVectorChunk(this.bv);

  @override
  int operator [](int idx) => bv[idx];

  @override
  Chunk<int> drop(int n) {
    if (n <= 0) {
      return this;
    } else if (n >= size) {
      return Chunk.empty();
    } else {
      return _ByteVectorChunk(bv.drop(n));
    }
  }

  @override
  int get size => bv.size;

  @override
  Chunk<int> take(int n) {
    if (n <= 0) {
      return Chunk.empty();
    } else if (n >= size) {
      return this;
    } else {
      return _ByteVectorChunk(bv.take(n));
    }
  }

  @override
  List<int> toDartList() => bv.toByteArray();
}

/// A view into another chunk, avoiding copy during slicing.
class _SliceChunk<A> extends Chunk<A> {
  final Chunk<A> underlying;
  final int offset;
  final int _length;

  const _SliceChunk(this.underlying, this.offset, this._length);

  @override
  A operator [](int index) {
    if (index < 0 || index >= _length) throw RangeError.index(index, this);
    return underlying[offset + index];
  }

  @override
  int get size => _length;

  @override
  bool get isCompact => false;

  @override
  List<A> toDartList() {
    // If underlying is a Dart-backed chunk, use efficient range copy
    if (underlying is _BoxedChunk<A>) {
      return (underlying as _BoxedChunk<A>)._values.sublist(offset, offset + _length);
    } else {
      return List.generate(_length, (i) => this[i]);
    }
  }
}

/// Represents the concatenation of two chunks.
/// Optimized for O(1) append. Access is O(log N) if balanced.
class _ConcatChunk<A> extends Chunk<A> {
  final Chunk<A> left;
  final Chunk<A> right;
  final int _size;

  _ConcatChunk(this.left, this.right) : _size = left.size + right.size;

  @override
  int get size => _size;

  @override
  bool get isCompact => false;

  @override
  A operator [](int index) {
    if (index < 0 || index >= _size) {
      throw RangeError.index(index, this);
    } else if (index < left.size) {
      return left[index];
    } else {
      return right[index - left.size];
    }
  }

  @override
  List<A> toDartList() {
    final list = left.toDartList();
    list.addAll(right.toDartList());
    return list;
  }
}

final class _ChunkIterator<A> extends RIterator<A> {
  final Chunk<A> chunk;
  var _i = 0;

  _ChunkIterator(this.chunk);

  @override
  bool get hasNext => _i < chunk.size;

  @override
  A next() {
    final res = chunk[_i];
    _i += 1;
    return res;
  }
}
