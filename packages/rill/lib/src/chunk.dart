import 'dart:typed_data';
import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';

/// Convenience constructor — creates a [Chunk] from any [Iterable].
Chunk<O> chunk<O>(Iterable<O> as) => Chunk.fromDart(as);

/// A strictly strict, immutable sequence of values, optimized for indexed based access
/// and efficient concatenation.
sealed class Chunk<O> with RIterableOnce<O>, RIterable<O>, RSeq<O>, IndexedSeq<O> {
  const Chunk();

  /// Creates a [Chunk<int>] backed by a Uint8List.
  static Chunk<int> bytes(Uint8List bytes) =>
      bytes.isEmpty ? Chunk.empty() : _Uint8ListChunk(bytes);

  /// Creates a [Chunk<int>] backed by a [ByteVector].
  static Chunk<int> byteVector(ByteVector bv) => _ByteVectorChunk(bv);

  /// Creates a chunk of [n] copies of [a].
  static Chunk<O> constant<O>(int n, O a) => n <= 0 ? Chunk.empty() : _ConstantChunk(a, n);

  /// Creates an empty chunk.
  static Chunk<O> empty<O>() => _EmptyChunk<O>();

  /// Alias for [constant].
  static Chunk<O> fill<O>(int n, O a) => constant(n, a);

  /// Creates a [Chunk] from a [RIterableOnce].
  static Chunk<O> from<O>(RIterableOnce<O> iterable) => fromList(iterable.toList());

  /// Creates a [Chunk] from a Dart [Iterable].
  static Chunk<O> fromDart<O>(Iterable<O> iterable) => fromList(iterable.toList());

  /// Creates a [Chunk] from a Dart [List], copying the elements.
  static Chunk<O> fromList<O>(List<O> list) {
    if (list.isEmpty) return empty();
    return _BoxedChunk(List.of(list, growable: false));
  }

  /// Creates a single-element chunk.
  static Chunk<O> singleton<O>(O a) => _SingletonChunk(a);

  /// Creates a [Chunk] of [count] elements produced by [f].
  ///
  /// More efficient than [fromList] for generated sequences since a single
  /// fixed-size [List] is allocated with no intermediate copy.
  static Chunk<O> tabulate<O>(int count, Function1<int, O> f) {
    if (count <= 0) return empty();
    return _BoxedChunk(List<O>.generate(count, f, growable: false));
  }

  /// A pre-allocated singleton chunk containing [Unit].
  static final unit = Chunk.singleton(Unit());

  /// Returns the element at [idx]. Throws [RangeError] if out of bounds.
  @override
  O operator [](int idx);

  /// Concatenates two chunks. Alias for [concat].
  Chunk<O> operator +(Chunk<O> that) => concat(that);

  @override
  Chunk<O> appended(O elem) => concat(Chunk.singleton(elem));

  @override
  Chunk<O> appendedAll(RIterableOnce<O> suffix) => concat(Chunk.from(suffix));

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
  Chunk<B> flatMap<B>(Function1<O, RIterableOnce<B>> f) {
    final bldr = <B>[];

    foreach((a) => f(a).foreach(bldr.add));

    return bldr.isEmpty ? Chunk.empty() : _BoxedChunk(List.of(bldr, growable: false));
  }

  @override
  IMap<K, Chunk<O>> groupBy<K>(Function1<O, K> f) => super.groupBy(f).mapValues(Chunk.from);

  @override
  IMap<K, Chunk<B>> groupMap<K, B>(Function1<O, K> key, Function1<O, B> f) =>
      super.groupMap(key, f).mapValues(Chunk.from);

  @override
  RIterator<Chunk<O>> grouped(int size) => super.grouped(size).map(Chunk.from);

  @override
  Chunk<O> get init => isEmpty ? Chunk.empty() : take(size - 1);

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

  /// Maps each element while threading a state value [S] through the traversal.
  ///
  /// Returns the final accumulated state paired with the transformed chunk.
  (S, Chunk<B>) mapAccumulate<S, B>(S initial, Function2<S, O, (S, B)> f) {
    final bldr = <B>[];

    var s = initial;

    foreach((a) {
      final (s2, a2) = f(s, a);
      bldr.add(a2);
      s = s2;
    });

    if (bldr.isEmpty) {
      return (s, Chunk.empty());
    } else {
      return (s, _BoxedChunk(List.of(bldr, growable: false)));
    }
  }

  @override
  Chunk<O> padTo(int len, O elem) => from(super.padTo(len, elem));

  @override
  (Chunk<O>, Chunk<O>) partition(Function1<O, bool> p) {
    final yes = <O>[];
    final no = <O>[];

    foreach((a) {
      if (p(a)) {
        yes.add(a);
      } else {
        no.add(a);
      }
    });

    return (
      yes.isEmpty ? Chunk.empty() : _BoxedChunk(List.of(yes, growable: false)),
      no.isEmpty ? Chunk.empty() : _BoxedChunk(List.of(no, growable: false)),
    );
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
  Chunk<O> prepended(O elem) => Chunk.singleton(elem).concat(this);

  @override
  Chunk<O> prependedAll(RIterableOnce<O> prefix) => Chunk.from(prefix).concat(this);

  @override
  Chunk<O> removeAt(int idx) => from(super.removeAt(idx));

  /// Removes the first element for which [p] returns `true`, returning this
  /// chunk unchanged if no element matches.
  Chunk<O> removeFirst(Function1<O, bool> p) => indexWhere(p).fold(() => this, removeAt);

  @override
  Chunk<O> reverse() => fromDart(toDartList().reversed);

  @override
  Chunk<B> scan<B>(B z, Function2<B, O, B> op) => from(super.scan(z, op));

  @override
  Chunk<B> scanLeft<B>(B z, Function2<B, O, B> op) => from(super.scanLeft(z, op));

  @override
  Chunk<B> scanRight<B>(B z, Function2<O, B, B> op) => from(super.scanRight(z, op));

  /// Like [scanLeft] but omits the initial accumulator from the output chunk
  /// and instead returns it as the second element of the pair.
  ///
  /// Useful for channel consumers that need the carry-over state without
  /// re-emitting the seed value.
  (Chunk<B>, B) scanLeftCarry<B>(B initial, Function2<B, O, B> op) => _scanLeft(initial, op, false);

  (Chunk<B>, B) _scanLeft<B>(B initial, Function2<B, O, B> op, bool emitZero) {
    final bldr = <B>[];
    var acc = initial;

    if (emitZero) bldr.add(acc);

    foreach((a) {
      acc = op(acc, a);
      bldr.add(acc);
    });

    if (bldr.isEmpty) {
      return (Chunk.empty(), acc);
    } else {
      return (_BoxedChunk(List.of(bldr, growable: false)), acc);
    }
  }

  @override
  Chunk<O> slice(int from, int until) {
    final lo = from < 0 ? 0 : from;
    final hi = until > size ? size : until;

    if (lo >= hi) {
      return Chunk.empty();
    } else {
      return drop(lo).take(hi - lo);
    }
  }

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

/// Byte-oriented operations for [Chunk<int>].
extension ChunkByteOps on Chunk<int> {
  /// Interprets this byte chunk as a [BitVector].
  BitVector get toBitVector => toByteVector.bits;

  /// Wraps this chunk as a zero-copy [ByteVector] view.
  ByteVector get toByteVector => ByteVector.viewAt(At((i) => this[i]), size);

  /// Returns a [Uint8List] view of this chunk's bytes.
  ///
  /// Returns the underlying array directly when the backing representation
  /// already is a [Uint8List]; otherwise copies.
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
  Chunk<B> collect<B>(Function1<O, Option<B>> f) {
    final result = <B>[];

    for (var i = 0; i < _values.length; i++) {
      final opt = f(_values[i]);
      if (opt is Some<B>) result.add(opt.value);
    }

    if (result.isEmpty) {
      return Chunk.empty();
    } else {
      return _BoxedChunk(List.of(result, growable: false));
    }
  }

  @override
  Chunk<O> dropWhile(Function1<O, bool> p) {
    var i = 0;

    while (i < _values.length && p(_values[i])) {
      i++;
    }

    if (i == _values.length) {
      return Chunk.empty();
    } else if (i == 0) {
      return this;
    } else {
      return _SliceChunk(this, i, _values.length - i);
    }
  }

  @override
  Chunk<O> filter(Function1<O, bool> p) {
    final result = <O>[];

    for (var i = 0; i < _values.length; i++) {
      if (p(_values[i])) result.add(_values[i]);
    }

    if (result.isEmpty) {
      return Chunk.empty();
    } else if (result.length == _values.length) {
      return this; // All elements passed - avoid redundant copy.
    } else {
      return _BoxedChunk(List.of(result, growable: false));
    }
  }

  @override
  B foldLeft<B>(B z, Function2<B, O, B> f) {
    var acc = z;

    for (var i = 0; i < _values.length; i++) {
      acc = f(acc, _values[i]);
    }

    return acc;
  }

  @override
  void foreach<U>(Function1<O, U> f) {
    for (var i = 0; i < _values.length; i++) {
      f(_values[i]);
    }
  }

  @override
  RIterator<O> get iterator => _BoxedChunkIterator(_values);

  @override
  Chunk<B> map<B>(Function1<O, B> f) {
    if (_values.isEmpty) {
      return Chunk.empty();
    } else {
      return _BoxedChunk(
        List<B>.generate(_values.length, (i) => f(_values[i]), growable: false),
      );
    }
  }

  @override
  int get size => _values.length;

  @override
  (Chunk<O>, Chunk<O>) span(Function1<O, bool> p) {
    var i = 0;

    while (i < _values.length && p(_values[i])) {
      i++;
    }

    if (i == 0) {
      return (Chunk.empty(), this);
    } else if (i == _values.length) {
      return (this, Chunk.empty());
    } else {
      return (_SliceChunk(this, 0, i), _SliceChunk(this, i, _values.length - i));
    }
  }

  @override
  (Chunk<O>, Chunk<O>) splitAt(int n) {
    if (n <= 0) {
      return (Chunk.empty(), this);
    } else if (n >= _values.length) {
      return (this, Chunk.empty());
    } else {
      return (_SliceChunk(this, 0, n), _SliceChunk(this, n, _values.length - n));
    }
  }

  @override
  Chunk<O> takeWhile(Function1<O, bool> p) {
    var i = 0;

    while (i < _values.length && p(_values[i])) {
      i++;
    }

    if (i == 0) {
      return Chunk.empty();
    } else if (i == _values.length) {
      return this;
    } else {
      return _SliceChunk(this, 0, i);
    }
  }

  @override
  (Chunk<B>, B) _scanLeft<B>(B initial, Function2<B, O, B> op, bool emitZero) {
    final outLen = _values.length + (emitZero ? 1 : 0);

    if (outLen == 0) {
      return (Chunk.empty(), initial);
    } else {
      final out = List<B>.filled(outLen, initial);
      var acc = initial;
      var j = 0;

      if (emitZero) out[j++] = acc;

      for (var i = 0; i < _values.length; i++) {
        acc = op(acc, _values[i]);
        out[j++] = acc;
      }

      return (_BoxedChunk(out), acc);
    }
  }

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
  Chunk<int> drop(int n) => switch (n) {
    final n when n <= 0 => this,
    final n when n >= size => Chunk.empty(),
    _ => _ByteVectorChunk(bv.drop(n)),
  };

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
  Chunk<A> drop(int n) => switch (n) {
    final n when n <= 0 => this,
    final n when n >= size => Chunk.empty(),
    _ => _SliceChunk(underlying, offset + n, size - n),
  };

  @override
  void foreach<U>(Function1<A, U> f) {
    if (underlying is _BoxedChunk<A>) {
      final src = (underlying as _BoxedChunk<A>)._values;

      for (var i = 0; i < _length; i++) {
        f(src[offset + i]);
      }
    } else {
      compact().foreach(f);
    }
  }

  @override
  B foldLeft<B>(B z, Function2<B, A, B> f) {
    if (underlying is _BoxedChunk<A>) {
      final src = (underlying as _BoxedChunk<A>)._values;
      var acc = z;

      for (var i = 0; i < _length; i++) {
        acc = f(acc, src[offset + i]);
      }

      return acc;
    } else {
      return compact().foldLeft(z, f);
    }
  }

  @override
  Chunk<A> filter(Function1<A, bool> p) {
    if (underlying is _BoxedChunk<A>) {
      final result = <A>[];

      final src = (underlying as _BoxedChunk<A>)._values;

      for (var i = 0; i < _length; i++) {
        final v = src[offset + i];
        if (p(v)) result.add(v);
      }

      if (result.isEmpty) {
        return Chunk.empty();
      } else {
        return _BoxedChunk(List.of(result, growable: false));
      }
    } else {
      return compact().filter(p);
    }
  }

  @override
  bool get isCompact => false;

  @override
  Chunk<B> map<B>(Function1<A, B> f) {
    if (underlying is _BoxedChunk<A>) {
      final src = (underlying as _BoxedChunk<A>)._values;
      return _BoxedChunk(
        List<B>.generate(_length, (i) => f(src[offset + i]), growable: false),
      );
    } else {
      return compact().map(f);
    }
  }

  @override
  (Chunk<A>, Chunk<A>) splitAt(int n) {
    if (n <= 0) {
      return (Chunk.empty(), this);
    } else if (n >= _length) {
      return (this, Chunk.empty());
    } else {
      return (take(n), drop(n));
    }
  }

  @override
  (Chunk<A>, Chunk<A>) span(Function1<A, bool> p) {
    var count = 0;
    var found = false;

    foreach((a) {
      if (!found) {
        if (p(a)) {
          count++;
        } else {
          found = true;
        }
      }
    });

    return splitAt(count);
  }

  @override
  Chunk<A> takeWhile(Function1<A, bool> p) => span(p).$1;

  @override
  Chunk<A> dropWhile(Function1<A, bool> p) => span(p).$2;

  @override
  int get size => _length;

  @override
  Chunk<A> take(int n) => switch (n) {
    final n when n <= 0 => Chunk.empty(),
    final n when n >= size => this,
    _ => _SliceChunk(underlying, offset, n),
  };

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
  void foreach<U>(Function1<A, U> f) {
    left.foreach(f);
    right.foreach(f);
  }

  @override
  B foldLeft<B>(B z, Function2<B, A, B> f) => right.foldLeft(left.foldLeft(z, f), f);

  @override
  Chunk<B> map<B>(Function1<A, B> f) => _ConcatChunk(left.map(f), right.map(f));

  @override
  Chunk<B> collect<B>(Function1<A, Option<B>> f) => left.collect(f).concat(right.collect(f));

  @override
  Chunk<A> filter(Function1<A, bool> p) => left.filter(p).concat(right.filter(p));

  @override
  (Chunk<A>, Chunk<A>) splitAt(int n) {
    if (n <= 0) {
      return (Chunk.empty(), this);
    } else if (n >= _size) {
      return (this, Chunk.empty());
    } else if (n == left.size) {
      return (left, right);
    } else if (n < left.size) {
      final (ll, lr) = left.splitAt(n);
      return (ll, lr.concat(right));
    } else {
      final (rl, rr) = right.splitAt(n - left.size);
      return (left.concat(rl), rr);
    }
  }

  @override
  (Chunk<A>, Chunk<A>) span(Function1<A, bool> p) {
    final (ll, lr) = left.span(p);

    if (lr.isEmpty) {
      final (rl, rr) = right.span(p);
      return (left.concat(rl), rr);
    } else {
      return (ll, lr.concat(right));
    }
  }

  @override
  Chunk<A> takeWhile(Function1<A, bool> p) {
    final (ll, lr) = left.span(p);

    if (lr.isEmpty) {
      return left.concat(right.takeWhile(p));
    } else {
      return ll;
    }
  }

  @override
  Chunk<A> dropWhile(Function1<A, bool> p) {
    final (_, lr) = left.span(p);

    if (lr.isEmpty) {
      return right.dropWhile(p);
    } else {
      return lr.concat(right);
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

final class _BoxedChunkIterator<A> extends RIterator<A> {
  final List<A> _values;
  var _i = 0;

  _BoxedChunkIterator(this._values);

  @override
  bool get hasNext => _i < _values.length;

  @override
  A next() => _values[_i++];
}
