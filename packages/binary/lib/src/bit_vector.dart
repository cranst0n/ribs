import 'dart:math';
import 'dart:typed_data';

import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_binary/src/internal/byte_vector.dart';
import 'package:ribs_core/ribs_core.dart';

sealed class BitVector implements Comparable<BitVector> {
  const BitVector();

  static final BitVector empty = _toBytes(ByteVector.empty, 0);

  static final zero = _toBytes(ByteVector.of(0x00), 1);

  static final one = _toBytes(ByteVector.of(0xff), 1);

  static final highByte = BitVector.high(8);

  static final lowByte = BitVector.low(8);

  factory BitVector.bit(bool high) => high ? one : zero;

  factory BitVector.bits(Iterable<bool> b) => IList.fromDart(
    b,
  ).zipWithIndex().foldLeft(BitVector.low(b.length), (acc, b) => acc.update(b.$2, b.$1));

  factory BitVector.byte(int byte) => _toBytes(ByteVector([byte]), 8);

  factory BitVector.concat(RIterableOnce<BitVector> bvs) =>
      bvs.iterator.foldLeft(BitVector.empty, (a, b) => a.concat(b));

  factory BitVector.concatDart(Iterable<BitVector> bvs) =>
      RIterator.fromDart(bvs.iterator).foldLeft(BitVector.empty, (a, b) => a.concat(b));

  factory BitVector.fill(int n, bool high) {
    final needed = _bytesNeededForBits(n);
    final bs = ByteVector.fill(needed, high ? -1 : 0);

    return _toBytes(bs, n);
  }

  factory BitVector.from(RIterableOnce<int> bs) => _toBytes(ByteVector.from(bs), bs.size * 8);

  factory BitVector.fromDart(Iterable<int> bs) => _toBytes(ByteVector.fromDart(bs), bs.length * 8);

  factory BitVector.high(int size) => BitVector.fill(size, true);

  factory BitVector.low(int size) => BitVector.fill(size, false);

  factory BitVector.fromByteVector(ByteVector bs) => _toBytes(bs, bs.size * 8);

  factory BitVector.view(Uint8List bs, {int? sizeInBits}) =>
      _toBytes(ByteVector.view(bs), sizeInBits ?? bs.length * 8);

  static BitVector unfold<S>(S s, Function1<S, Option<(BitVector, S)>> f) {
    return _Suspend(() {
      return f(s)
          .map<BitVector>((tuple) {
            final (h, t) = tuple;
            return _Append(h, unfold(t, f));
          })
          .getOrElse(() => BitVector.empty);
    });
  }

  static Option<BitVector> fromBin(
    String s, [
    BinaryAlphabet alphabet = Alphabets.binary,
  ]) => fromBinDescriptive(s, alphabet).toOption();

  static BitVector fromValidBin(
    String s, [
    BinaryAlphabet alphabet = Alphabets.binary,
  ]) => fromBinDescriptive(s, alphabet).fold((err) => throw ArgumentError(err), identity);

  static Either<String, BitVector> fromBinDescriptive(
    String s, [
    BinaryAlphabet alphabet = Alphabets.binary,
  ]) {
    return fromBinInternal(s, alphabet).mapN((bytes, size) {
      final toDrop = switch (size) {
        0 => 0,
        _ when size % 8 == 0 => 0,
        _ => 8 - (size % 8),
      };

      return bytes.bits.drop(toDrop);
    });
  }

  static Option<BitVector> fromHex(
    String s, [
    HexAlphabet alphabet = Alphabets.hexLower,
  ]) => fromHexDescriptive(s, alphabet).toOption();

  static BitVector fromValidHex(
    String s, [
    HexAlphabet alphabet = Alphabets.hexLower,
  ]) => fromHexDescriptive(s, alphabet).fold((err) => throw ArgumentError(err), identity);

  static Either<String, BitVector> fromHexDescriptive(
    String s, [
    HexAlphabet alphabet = Alphabets.hexLower,
  ]) => fromHexInternal(s, alphabet).mapN((bytes, count) => bytes.bits.drop(count.isEven ? 0 : 4));

  static Option<BitVector> fromBase32(
    String s, [
    Base32Alphabet alphabet = Alphabets.base32,
  ]) => fromBase32Descriptive(s, alphabet).toOption();

  static BitVector fromValidBase32(
    String s, [
    Base32Alphabet alphabet = Alphabets.base32,
  ]) => fromBase32Descriptive(s, alphabet).fold((err) => throw ArgumentError(err), identity);

  static Either<String, BitVector> fromBase32Descriptive(
    String str, [
    Base32Alphabet alphabet = Alphabets.base32,
  ]) => fromBase32Internal(str, alphabet).map((a) => a.$1.bits);

  static Option<BitVector> fromBase64(
    String s, [
    Base64Alphabet alphabet = Alphabets.base64,
  ]) => fromBase64Descriptive(s, alphabet).toOption();

  static BitVector fromValidBase64(
    String s, [
    Base64Alphabet alphabet = Alphabets.base64,
  ]) => fromBase64Descriptive(s, alphabet).fold((err) => throw ArgumentError(err), identity);

  static Either<String, BitVector> fromBase64Descriptive(
    String str, [
    Base64Alphabet alphabet = Alphabets.base64,
  ]) => fromBase64Internal(str, alphabet).map((a) => a.$1.bits);

  factory BitVector.fromInt(
    int i, {
    int size = 64,
    Endian ordering = Endian.big,
  }) {
    // TODO: Unsupported on web
    final bytes = Uint8List(8)..buffer.asByteData().setInt64(0, i);
    final relevantBits = ByteVector(bytes).bits.shiftLeft(64 - size).take(size);

    return ordering == Endian.big ? relevantBits : relevantBits.reverseByteOrder();
  }

  factory BitVector.fromBigInt(
    BigInt value, {
    Option<int> size = const None<int>(),
    Endian ordering = Endian.big,
  }) {
    final actualSize = size.getOrElse(() => value.bitLength + 1);
    final bits = BitVector.fromValidBin(value.toRadixString(2));

    late BitVector relevantBits;

    if (bits.size < actualSize) {
      relevantBits = BitVector.fill(actualSize - bits.size, false).concat(bits);
    } else {
      relevantBits = bits.takeRight(actualSize);
    }

    return ordering == Endian.big ? relevantBits : relevantBits.reverseByteOrder();
  }

  BitVector operator ~() => not;

  BitVector operator |(BitVector other) => or(other);

  BitVector operator ^(BitVector other) => xor(other);

  BitVector operator <<(int n) => shiftLeft(n);

  BitVector operator >>(int n) => shiftRight(n, true);

  BitVector operator >>>(int n) => shiftRight(n, false);

  /// Returns number of bits in this vector.
  int get size;

  /// Alias for [size].
  int get length => size;

  /// Returns true if this vector has no bits.
  bool get isEmpty => sizeLessThan(1);

  /// Returns true if this vector has a non-zero number of bits.
  bool get nonEmpty => !isEmpty;

  /// Returns `true` if the size of this `BitVector` is greater than `n`. Unlike `size`, this forces
  /// this `BitVector` from left to right, halting as soon as it has a definite answer.
  bool sizeGreaterThan(int n) => n < 0 || !sizeLessThanOrEqual(n);

  /// Returns `true` if the size of this `BitVector` is greater than or equal to `n`. Unlike `size`,
  /// this forces this `BitVector` from left to right, halting as soon as it has a definite answer.
  bool sizeGreaterThanOrEqual(int n) => n < 0 || !sizeLessThanOrEqual(n - 1);

  /// Returns `true` if the size of this `BitVector` is less than `n`. Unlike `size`, this forces
  /// this `BitVector` from left to right, halting as soon as it has a definite answer.
  bool sizeLessThan(int n);

  /// Returns `true` if the size of this `BitVector` is less than or equal to `n`. Unlike `size`,
  /// this forces this `BitVector` from left to right, halting as soon as it has a definite answer.
  bool sizeLessThanOrEqual(int n) => n == Integer.MaxValue || sizeLessThan(n + 1);

  /// Returns true if the `n`th bit is high, false otherwise.
  bool get(int n);

  /// Returns the `n`th byte, 0-indexed.
  int getByte(int n);

  /// Alias for [get].
  bool call(int n) => get(n);

  /// Returns `Some(true)` if the `n`th bit is high, `Some(false)` if low, and `None` if `n >=
  /// size`.
  Option<bool> lift(int n) => Option.when(() => sizeGreaterThan(n), () => get(n));

  BitVector get _unchunk => this;

  /// Returns a new bit vector with the `n`th bit high if `high` is true or low if `high` is false.
  BitVector update(int n, bool high);

  /// Returns a vector with the specified bit inserted at the specified index.
  BitVector insert(int idx, bool b) => take(idx).append(b).concat(drop(idx));

  /// Returns a vector with the specified bit vector inserted at the specified index.
  BitVector splice(int idx, BitVector b) => take(idx).concat(b).concat(drop(idx));

  /// Returns a vector with the specified bit vector replacing bits `[idx, idx + b.size]`.
  BitVector patch(int idx, BitVector b) => take(idx).concat(b).concat(drop(idx + b.size));

  /// Returns a new bit vector with the `n`th bit high (and all other bits unmodified).
  BitVector set(int n) => update(n, true);

  /// Returns a new bit vector with the `n`th bit low (and all other bits unmodified).
  BitVector clear(int n) => update(n, false);

  /// Returns a new bit vector representing this vector's contents followed by the specified
  /// vector's contents.
  BitVector concat(BitVector b2) {
    return isEmpty ? b2 : _Chunks(_Append(this, b2));
  }

  /// Returns a new vector with the specified bit prepended.
  BitVector prepend(bool b) => BitVector.bit(b).concat(this);

  /// Returns a new vector with the specified bit appended.
  BitVector append(bool b) => concat(BitVector.bit(b));

  /// Returns a vector of all bits in this vector except the first `n` bits.
  ///
  /// The resulting vector's size is `0 max (size - n)`.
  BitVector drop(int n);

  /// Returns a vector of all bits in this vector except the last `n` bits.
  ///
  /// The resulting vector's size is `0 max (size - n)`.
  BitVector dropRight(int n) {
    if (n <= 0) {
      return this;
    } else if (n >= size) {
      return BitVector.empty;
    } else {
      return take(size - n);
    }
  }

  BitVector dropWhile(Function1<bool, bool> f) {
    var toDrop = 0;

    while (toDrop < size && f(get(toDrop))) {
      toDrop += 1;
    }

    return drop(toDrop);
  }

  /// Returns a vector of the first `n` bits of this vector.
  ///
  /// The resulting vector's size is `n min size`.
  ///
  /// Note: if an `n`-bit vector is required, use the `acquire` method instead.
  BitVector take(int n);

  /// Returns a vector of the last `n` bits of this vector.
  ///
  /// The resulting vector's size is `n min size`.
  BitVector takeRight(int n) {
    if (n < 0) {
      throw ArgumentError('takeRight($n)');
    } else if (n >= size) {
      return this;
    } else {
      return drop(size - n);
    }
  }

  /// Returns a pair of vectors that is equal to `(take(n), drop(n))`.
  (BitVector, BitVector) splitAt(int n) => (take(n), drop(n));

  /// Returns a vector made up of the bits starting at index `from` up to index `until`, not
  /// including the index `until`.
  BitVector slice(int from, int until) => drop(from).take(until - max(from, 0));

  /// Returns an iterator of fixed size slices of this vector, stepping the specified number of bits between consecutive elements.
  RIterator<BitVector> sliding(int n, [int step = 1]) {
    assert(n > 0 && step > 0, 'both n and step must be positive');

    RIterator<int> limit(RIterator<int> itr) =>
        (step < n) ? itr.take((size - n) + 1) : itr.takeWhile((i) => i < size);

    return limit(RIterator.iterate(0, (x) => x + step)).map((idx) => slice(idx, idx + n));
  }

  /// Returns a vector whose contents are the results of taking the first `n` bits of this vector.
  ///
  /// If this vector does not contain at least `n` bits, an error message is returned.
  Either<String, BitVector> acquire(int n) => Either.cond(
    () => sizeGreaterThanOrEqual(n),
    () => take(n),
    () => 'cannot acquire $n bits from a vector that contains $size bits',
  );

  /// Like `aquire`, but immediately consumes the `Either` via the pair of functions `err` and `f`.
  R acquireThen<R>(
    int n,
    Function1<String, R> err,
    Function1<BitVector, R> f,
  ) =>
      sizeGreaterThanOrEqual(n)
          ? f(take(n))
          : err('cannot acquire $n bits from a vector that contains $size bits');

  /// Consumes the first `n` bits of this vector and decodes them with the specified function,
  /// resulting in a vector of the remaining bits and the decoded value. If this vector does not
  /// have `n` bits or an error occurs while decoding, an error is returned instead.
  Either<String, (BitVector, A)> consume<A>(
    int n,
    Function1<BitVector, Either<String, A>> decode,
  ) => acquire(n).flatMap((toDecode) => decode(toDecode).map((decoded) => (drop(n), decoded)));

  /// If this vector has at least `n` bits, returns `f(take(n),drop(n))`, otherwise calls `err` with
  /// a meaningful error message. This function can be used to avoid intermediate allocations of
  /// `Either` objects when using `acquire` or `consume` directly.
  R consumeThen<R>(
    int n,
    Function1<String, R> err,
    Function2<BitVector, BitVector, R> f,
  ) {
    if (sizeGreaterThanOrEqual(n)) {
      return f(take(n), drop(n)); // todo unsafeTake, unsafeDrop
    } else {
      return err("cannot acquire $n bits from a vector that contains $size bits");
    }
  }

  /// Returns true if this bit vector starts with the specified vector.
  bool startsWith(BitVector b) => take(b.size) == b;

  /// Returns true if this bit vector ends with the specified vector.
  bool endsWith(BitVector b) => takeRight(b.size) == b;

  /// Finds the first index after `from` of the specified bit pattern in this vector.
  int indexOfSlice(BitVector slice, [int from = 0]) {
    int go(BitVector b, int idx) {
      var b2 = b;
      var idx2 = idx;

      while (true) {
        if (b2.startsWith(slice)) {
          return idx2;
        } else if (b2.isEmpty) {
          return -1;
        } else {
          b2 = b2.tail();
          idx2 += 1;
        }
      }
    }

    return go(drop(from), from);
  }

  /// Determines if the specified slice is in this vector.
  bool containsSlice(BitVector slice) => indexOfSlice(slice) >= 0;

  /// Returns the first bit of this vector or throws if vector is emtpy.
  bool get head => get(0);

  /// Returns the first bit of this vector or `None` if vector is emtpy.
  Option<bool> get headOption => lift(0);

  /// Returns a vector of all bits in this vector except the first bit.
  BitVector tail() => drop(1);

  /// Returns a vector of all bits in this vector except the last bit.
  BitVector init() => dropRight(1);

  /// Returns the last bit in this vector or throws if vector is empty.
  bool get last => get(size - 1);

  /// Returns the last bit in this vector or returns `None` if vector is empty.
  Option<bool> get lastOption => lift(size - 1);

  /// Alias for [padRight].
  BitVector padTo(int n) => padRight(n);

  /// Returns an `n`-bit vector whose contents are 0 or more low bits followed by this vector's
  /// contents.
  BitVector padRight(int n) => size < n ? concat(BitVector.low(n - size)) : this;

  /// Returns an `n`-bit vector whose contents are 0 or more low bits followed by this vector's
  /// contents.
  BitVector padLeft(int n) => size < n ? BitVector.low(n - size).concat(this) : this;

  BitVector get reverse => BitVector.fromByteVector(
    compact().underlying.reverse.map(_reverseBitsInByte),
  ).drop(8 - _validBitsInLastByte(size));

  /// Returns a new vector of the same size with the byte order reversed.
  ///
  /// Note that `reverseByteOrder.reverseByteOrder == identity` only when `size` is evenly divisble
  /// by 8. To invert `reverseByteOrder` for an arbitrary size, use `invertReverseByteOrder`.
  BitVector reverseByteOrder() {
    if (size % 8 == 0) {
      return _toBytes(compact().underlying.reverse, size);
    } else {
      final validFinalBits = _validBitsInLastByte(size);
      final last = take(validFinalBits).compact();
      final b = drop(validFinalBits).bytes.reverse;
      final init = _toBytes(b, size - last.size);

      return init.concat(last);
    }
  }

  /// Inverse of `reverseByteOrder`.
  BitVector invertReverseByteOrder() {
    if (size % 8 == 0) {
      return reverseByteOrder();
    } else {
      final validFinalBits = _validBitsInLastByte(size);
      final (init, last) = splitAt(size - validFinalBits);
      return last.concat(init.bytes.reverse.bits);
    }
  }

  /// Returns a new vector of the same size with the bit order reversed.
  BitVector reverseBitOrder() {
    final reversed = compact().underlying.map(_reverseBitsInByte);

    if (size % 8 == 0) {
      return BitVector.fromByteVector(reversed);
    } else {
      final lastIdx = reversed.size - 1;
      final toDrop = 8 - _validBitsInLastByte(size);

      return BitVector.fromByteVector(
        reversed.update(lastIdx, (reversed.get(lastIdx) << toDrop) & 0xff),
      ).dropRight(toDrop);
    }
  }

  /// Returns the number of bits that are high.
  int populationCount() {
    var count = 0;
    var ix = 0;

    while (ix < size) {
      if (get(ix)) count++;
      ix++;
    }

    return count;
  }

  /// Returns a bitwise complement of this BitVector.
  BitVector get not => _mapBytes((b) => b.not);

  /// Returns a bitwise AND of this BitVector with the specified BitVector.
  BitVector and(BitVector other) => _zipBytesWith(other, (a, b) => a & b);

  /// Returns a bitwise OR of this BitVector with the specified BitVector.
  BitVector or(BitVector other) => _zipBytesWith(other, (a, b) => a | b);

  /// Returns a bitwise XOR of this BitVector with the specified BitVector.
  BitVector xor(BitVector other) => _zipBytesWith(other, (a, b) => a ^ b);

  /// Returns a BitVector of the same size with each bit shifted to the left `n` bits.
  BitVector shiftLeft(int n) {
    if (n <= 0) {
      return this;
    } else if (n >= size) {
      return BitVector.low(size);
    } else {
      return drop(n).concat(BitVector.low(n));
    }
  }

  /// Returns a BitVector of the same size with each bit shifted to the right `n` bits.
  BitVector shiftRight(int n, bool signExtension) {
    if (isEmpty || n <= 0) {
      return this;
    } else {
      final extensionHigh = signExtension && get(0);

      if (n >= size) {
        return extensionHigh ? BitVector.high(size) : BitVector.low(size);
      } else {
        return (extensionHigh ? BitVector.high(n) : BitVector.low(n)).concat(dropRight(n));
      }
    }
  }

  /// Returns a BitVector of the same size with each bit circularly shifted to the left `n` bits.
  BitVector rotateLeft(int n) {
    if (n <= 0 || isEmpty) {
      return this;
    } else {
      final n0 = n % size;
      return n0 == 0 ? this : drop(n0).concat(take(n0));
    }
  }

  /// Returns a BitVector of the same size with each bit circularly shifted to the right `n` bits.
  BitVector rotateRight(int n) {
    if (n <= 0 || isEmpty) {
      return this;
    } else {
      final n0 = n % size;
      return n0 == 0 ? this : takeRight(n0).concat(dropRight(n0));
    }
  }

  _Bytes compact() {
    if (_bytesNeededForBits(size) > Integer.MaxValue) {
      throw ArgumentError('cannot compact bit vector of size ${size.toDouble() / 8 / 1e9} GB');
    }

    // TODO: tailrec
    IVector<_Bytes> go(IList<BitVector> b, IVector<_Bytes> acc) {
      if (b.nonEmpty) {
        final rem = b.tail;

        return switch (b.head) {
          final _Suspend s => go(rem.prepended(s.underlying), acc),
          final _Bytes b => go(rem, acc.appended(b)),
          final _Drop d => go(rem, acc.appended(d.interpretDrop())),
          _Append(left: final l, right: final r) => go(rem.prepended(r).prepended(l), acc),
          final _Chunks c => go(rem.prepended(c.chunks.right).prepended(c.chunks.left), acc),
        };
      } else {
        return acc;
      }
    }

    switch (this) {
      case final _Bytes bs:
        final b2 = bs.underlying.compact();
        return b2 == bs.underlying ? bs : _Bytes(b2, bs.size);
      case final _Drop d:
        final bs = d.interpretDrop();
        final b2 = bs.underlying.compact();
        return b2 == bs.underlying ? bs : _Bytes(b2, bs.size);
      default:
        final balanced = _reduceBalanced(
          go(ilist([this]), IVector.empty()),
          (bv) => bv.size,
          (x, y) => x.combine(y),
        );

        return _Bytes(balanced.underlying.compact(), balanced.size);
    }
  }

  /// Produce a single flat `Bytes` by interpreting any non-byte-aligned appends or drops. Unlike
  /// `compact`, the underlying `ByteVector` is not necessarily copied.
  _Bytes align();

  /// Return a `BitVector` with the same contents as `this`, but based off a single flat
  /// `ByteVector`. This function is guaranteed to copy all the bytes in this `BitVector`, unlike
  /// `compact`, which may no-op if this `BitVector` already consists of a single `ByteVector`
  /// chunk.
  _Bytes copy() => switch (this) {
    final _Bytes b => _Bytes(b.underlying.copy(), b.size),
    _ => compact(),
  };

  /// Forces any `Suspend` nodes in this `BitVector` and ensures the tree is balanced.
  BitVector force() {
    // TODO: tailrec
    BitVector go(IVector<BitVector> cont) {
      if (cont.nonEmpty) {
        final cur = cont.head;
        final tail = cont.tail;

        return switch (cur) {
          final _Bytes b => tail.foldLeft(b, (a, b) => a.concat(b)),
          _Append(left: final l, right: final r) => go(tail.prepended(r).prepended(l)),
          final _Drop d => tail.foldLeft(d, (a, b) => a.concat(b)),
          final _Suspend s => go(tail.prepended(s.underlying)),
          final _Chunks c => go(tail.prepended(c.chunks)),
        };
      } else {
        return cont.foldLeft(BitVector.empty, (a, b) => a.concat(b));
      }
    }

    return go(ivec([this]));
  }

  Uint8List toByteArray() => bytes.toByteArray();

  ByteVector get bytes => toByteVector();

  ByteVector toByteVector() => _clearUnneededBits(size, compact().underlying);

  IList<bool> toIList() => IList.tabulate(size, (ix) => get(ix));

  String toBin([BinaryAlphabet alphabet = Alphabets.binary]) =>
      bytes.toBin(alphabet).substring(0, size);

  String toHex([HexAlphabet alphabet = Alphabets.hexLower]) {
    final full = bytes.toHex(alphabet);

    if (size % 8 == 0) {
      return full;
    } else if (size % 8 <= 4) {
      return full.init();
    } else {
      return full;
    }
  }

  String toHexDump() => HexDumpFormat.NoAnsi.renderBits(this);

  String toHexDumpColorized() => HexDumpFormat.Default.renderBits(this);

  void printHexDump() => HexDumpFormat.Default.printBits(this);

  String toBase16([HexAlphabet alphabet = Alphabets.hexLower]) => toHex(alphabet);

  String toBase32([Base32Alphabet alphabet = Alphabets.base32]) => bytes.toBase32(alphabet);

  String toBase64([Base64Alphabet alphabet = Alphabets.base64]) => bytes.toBase64(alphabet);

  String toBase64NoPad() => toBase64(Alphabets.base64NoPad);

  String toBase64Url() => toBase64(Alphabets.base64Url);

  String toBase64UrlNoPad() => toBase64(Alphabets.base64UrlNoPad);

  int toInt({bool signed = true, Endian ordering = Endian.big}) {
    return switch (this) {
      final _Bytes bytes => switch (size) {
        32 when signed => ByteData.sublistView(
          bytes.underlying.toByteArray(),
        ).getInt32(0, ordering),
        32 when !signed => ByteData.sublistView(
          bytes.underlying.toByteArray(),
        ).getUint32(0, ordering),
        16 when signed => ByteData.sublistView(
          bytes.underlying.toByteArray(),
        ).getInt16(0, ordering),
        16 when !signed => ByteData.sublistView(
          bytes.underlying.toByteArray(),
        ).getUint16(0, ordering),
        8 when signed => ByteData.sublistView(bytes.underlying.toByteArray()).getInt8(0),
        8 when !signed => ByteData.sublistView(bytes.underlying.toByteArray()).getUint8(0),
        _ =>
          ordering == Endian.little
              ? invertReverseByteOrder().toInt(signed: signed)
              : _getBigEndianInt(0, size, signed),
      },
      _ =>
        ordering == Endian.little
            ? invertReverseByteOrder().toInt(signed: signed)
            : _getBigEndianInt(0, size, signed),
    };
  }

  int _getBigEndianInt(int start, int bits, bool signed) {
    final mod = bits % 8;
    var result = 0;
    final bytesNeeded = _bytesNeededForBits(bits);
    final base = start ~/ 8;

    var i = 0;

    while (i < bytesNeeded) {
      result = (result << 8) | (0x0ff & getByte(base + i));
      i++;
    }

    if (mod != 0) {
      result = result >>> (8 - mod);
    }

    return signed ? result.toSigned(bits) : result;
  }

  BigInt toBigInt({bool signed = true, Endian ordering = Endian.big}) =>
      ordering == Endian.little
          ? invertReverseByteOrder().toBigInt(signed: signed)
          : _getBigEndianBigInt(0, size, signed);

  BigInt _getBigEndianBigInt(int start, int bits, bool signed) {
    if (bits == 0) {
      return BigInt.zero;
    } else {
      final firstBit = get(start);
      final signBit = signed && firstBit;

      // Include an explicit sign bit of 0 when we're unsigned and the first bit is high
      final explicitZeroSignBit = !signed && firstBit;
      final explicitZeroSign = explicitZeroSignBit ? BitVector.zero : BitVector.empty;
      final mod = (bits + explicitZeroSign.size) % 8;
      final pad = mod == 0 ? BitVector.empty : BitVector.fill(8 - mod, signBit);

      final bytes =
          explicitZeroSign.concat(pad).concat(slice(start, start + bits)).bytes.toByteArray();

      if (signBit) {
        for (int i = 0; i < bytes.length; i++) {
          bytes[i] = (~bytes[i]) & 0xff;
        }

        int carry = 1;

        for (int i = bytes.length - 1; i >= 0 && carry > 0; i--) {
          final sum = bytes[i] + carry;
          bytes[i] = sum & 0xff;
          carry = sum >> 8;
        }
      }

      BigInt result = BigInt.zero;

      for (int i = 0; i < bytes.length; i++) {
        result = (result << 8) | BigInt.from(bytes[i]);
      }

      return signBit ? -result : result;
    }
  }

  @override
  String toString() {
    if (isEmpty) {
      return 'BitVector.empty';
    } else if (sizeLessThan(513)) {
      return 'BitVector(${toHex()})';
    } else {
      return 'BitVector($size, $hashCode)';
    }
  }

  @override
  int get hashCode => Object.hash(size, bytes);

  @override
  bool operator ==(Object other) {
    if (other is! BitVector) {
      return false;
    } else if (other.size != size) {
      return false;
    } else {
      const chunkSize = 8 * 1024 * 64;

      var x = this;
      var y = other;

      while (true) {
        if (x.isEmpty) {
          return y.isEmpty;
        } else {
          final chunkX = x.take(chunkSize);
          final chunkY = y.take(chunkSize);

          if (chunkX.bytes != chunkY.bytes) {
            return false;
          } else {
            x = x.drop(chunkSize);
            y = y.drop(chunkSize);
          }
        }
      }
    }
  }

  @override
  int compareTo(BitVector that) {
    if (this == that) {
      return 0;
    } else {
      final thisLength = length;
      final thatLength = that.length;
      final commonLength = min(thisLength, thatLength);
      var i = 0;

      while (i < commonLength) {
        final thisI = get(i);

        final cmp =
            thisI == that.get(i)
                ? 0
                : thisI
                ? 1
                : -1;

        if (cmp != 0) return cmp;

        i = i + 1;
      }

      if (thisLength < thatLength) {
        return -1;
      } else if (thisLength > thatLength) {
        return 1;
      } else {
        return 0;
      }
    }
  }

  BitVector _mapBytes(Function1<ByteVector, ByteVector> f) {
    return switch (this) {
      final _Bytes b => _toBytes(f(b.underlying), b.size),
      _Append(left: final l, right: final r) => _Append(l._mapBytes(f), r._mapBytes(f)),
      final _Drop d => _Drop(d.underlying._mapBytes(f).compact(), d.offset),
      final _Suspend s => _Suspend(() => s.underlying._mapBytes(f)),
      final _Chunks c => _Chunks(_Append(c.chunks.left._mapBytes(f), c.chunks.right._mapBytes(f))),
    };
  }

  BitVector _zipBytesWith(BitVector other, Function2<int, int, int> op) => _toBytes(
    compact().underlying.zipWithI(other.compact().underlying, op),
    min(size, other.size),
  );
}

final class _Append extends BitVector {
  final BitVector left;
  final BitVector right;

  late int _knownSize;
  late int _sizeLowerBound;

  _Append(this.left, this.right)
    : _knownSize = switch (right) {
        _Suspend _ => -1,
        _ => left.size + right.size,
      },
      _sizeLowerBound = left.size;

  @override
  bool get(int n) => n < left.size ? left.get(n) : right.get(n - left.size);

  @override
  int getByte(int n) {
    if (n < left.size ~/ 8) {
      return left.getByte(n);
    } else if (left.size % 8 == 0 && n > left.size ~/ 8) {
      return right.getByte(n - left.size ~/ 8);
    } else {
      return drop(n * 8).take(8).align().getByte(0);
    }
  }

  @override
  BitVector update(int n, bool high) =>
      n < left.size
          ? _Append(left.update(n, high), right)
          : _Append(left, right.update(n - left.size, high));

  @override
  _Bytes align() => left.align().combine(right.align());

  @override
  int get size {
    if (_knownSize != -1) {
      return _knownSize;
    } else {
      // TODO: tailrec
      int go(IList<BitVector> rem, int acc) {
        if (rem.nonEmpty) {
          final tl = rem.tail;

          return switch (rem.head) {
            _Append(left: final left, right: final right) => go(
              tl.prepended(right).prepended(left),
              acc,
            ),
            _Chunks(chunks: final chunks) => go(
              tl.prepended(chunks.right).prepended(chunks.left),
              acc,
            ),
            final _Suspend s => go(tl.prepended(s.underlying), acc),
            final h => go(tl, acc + h.size),
          };
        } else {
          return acc;
        }
      }

      final sz = go(ilist([left, right]), 0);
      _knownSize = sz;

      return sz;
    }
  }

  @override
  BitVector take(int n) {
    final npos = max(0, n);

    if (npos == 0) {
      return BitVector.empty;
    } else if (npos <= left.size) {
      return left.take(npos);
    } else {
      // TODO: tailrec
      BitVector go(BitVector accL, BitVector cur, int n) {
        return switch (cur) {
          _Append(left: final left, right: final right) =>
            n <= left.size
                ? accL.concat(left.take(n))
                : go(accL.concat(left), right, n - left.size),
          final _Suspend s => go(accL, s.underlying, n),
          _ => accL.concat(cur.take(n)),
        };
      }

      return go(left, right, npos - left.size);
    }
  }

  @override
  BitVector drop(int n) {
    final npos = max(0, n);

    if (npos == 0) {
      return this;
    } else {
      // TODO: tailrec
      BitVector go(BitVector cur, int n) {
        return switch (cur) {
          _Append(left: final left, right: final right) =>
            n >= left.size ? go(right, n - left.size) : _Append(left.drop(n), right),
          final _Suspend s => go(s.underlying, n),
          _ => cur.drop(n),
        };
      }

      if (npos >= left.size) {
        return go(right, npos - left.size);
      } else {
        return _Append(left.drop(npos), right);
      }
    }
  }

  @override
  bool sizeLessThan(int n) {
    if (_knownSize != -1) {
      return _knownSize < n;
    } else if (_sizeLowerBound >= n) {
      return false;
    } else {
      // TODO: tailrec
      bool go(BitVector cur, int n, int seen) {
        switch (cur) {
          case _Append(left: final l, right: final r):
            if (l.size >= n) {
              _sizeLowerBound = max(seen + l.size, _sizeLowerBound);
              return false;
            } else {
              return go(r, n - l.size, seen + l.size);
            }
          case final _Suspend s:
            return go(s.underlying, n, seen);
          default:
            _sizeLowerBound = max(seen, _sizeLowerBound);
            return cur.size < n;
        }
      }

      return go(this, n, 0);
    }
  }
}

final class _Bytes extends BitVector {
  final ByteVector underlying;

  @override
  final int size;

  _Bytes(this.underlying, this.size);

  @override
  _Bytes align() => this;

  _Bytes combine(_Bytes other) {
    final nInvalidBits = invalidBits();

    if (isEmpty) {
      return other;
    } else if (other.isEmpty) {
      return this;
    } else if (nInvalidBits == 0) {
      return _toBytes(underlying.concat(other.underlying), size + other.size);
    } else {
      final bytesCleared = _clearUnneededBits(size, underlying);

      final hi = bytesCleared.get(bytesCleared.size - 1);
      final lo =
          (((other.underlying.head & _topNBits(nInvalidBits)) & 0x000000ff) >>>
              _validBitsInLastByte(size)) &
          0xff;

      final updatedOurBytes = bytesCleared.update(bytesCleared.size - 1, (hi | lo) & 0xff);
      final updatedOtherBytes = other.drop(nInvalidBits).bytes;

      return _toBytes(
        updatedOurBytes.concat(updatedOtherBytes),
        size + other.size,
      );
    }
  }

  @override
  BitVector drop(int n) {
    if (n >= size) {
      return BitVector.empty;
    } else if (n <= 0) {
      return this;
    } else if (n % 8 == 0) {
      return _Bytes(underlying.drop(n ~/ 8), size - n);
    } else {
      return _Drop(this, n);
    }
  }

  @override
  bool get(int n) {
    checkBounds(n);
    return _getBit(underlying.get(n ~/ 8), n % 8);
  }

  @override
  int getByte(int n) {
    if (n < underlying.size - 1) {
      return underlying.get(n);
    } else {
      // last byte may have some garbage bits, clear these out
      final valid = 8 - invalidBits();

      return (underlying.get(n) & _topNBits(valid)) & 0xff;
    }
  }

  @override
  bool sizeLessThan(int n) => size < n;

  @override
  BitVector take(int n) => _toBytes(underlying, max(0, min(size, n)));

  @override
  BitVector update(int n, bool high) {
    checkBounds(n);

    final b2 = underlying.update(
      n ~/ 8,
      underlying.lift(n ~/ 8).map((a) => _setBit(a, n % 8, high)).getOrElse(() => outOfBounds(n)),
    );

    return _Bytes(b2, size);
  }

  int invalidBits() => 8 - _validBitsInLastByte(size);

  void checkBounds(int n) {
    if (!sizeGreaterThan(n)) outOfBounds(n);
  }

  Never outOfBounds(int n) => throw RangeError('invalid index: $n of $size');
}

final class _Chunks extends BitVector {
  final _Append chunks;

  _Chunks(this.chunks);

  @override
  BitVector get _unchunk => _Append(chunks.left, chunks.right._unchunk);

  @override
  _Bytes align() => chunks.align();

  @override
  BitVector take(int n) => chunks.take(n);

  @override
  BitVector drop(int n) => chunks.drop(n);

  @override
  BitVector concat(BitVector b) {
    if (b.isEmpty) {
      return this;
    } else if (isEmpty) {
      return b;
    } else {
      BitVector go(_Append chunks, BitVector last) {
        final lastN = last.size;

        if (lastN >= chunks.size || lastN * 2 <= chunks.right.size) {
          return _Chunks(_Append(chunks, last));
        } else {
          switch (chunks.left) {
            case final _Append left:
              final rN = chunks.right.size;
              final aligned = (lastN % 8) + (rN % 8) == 0;

              if (rN <= 256 && aligned) {
                return go(left, chunks.right.align().combine(last.align()));
              } else {
                return go(left, _Append(chunks.right, last));
              }
            default:
              return _Chunks(_Append(chunks, last));
          }
        }
      }

      return go(chunks, b._unchunk);
    }
  }

  @override
  int get size => chunks.size;

  @override
  bool sizeLessThan(int n) => chunks.sizeLessThan(n);

  @override
  BitVector update(int n, bool high) => chunks.update(n, high);

  @override
  bool get(int n) => chunks.get(n);

  @override
  int getByte(int n) => chunks.getByte(n);
}

final class _Drop extends BitVector {
  final _Bytes underlying;
  final int offset;

  _Drop(this.underlying, this.offset);

  @override
  _Bytes align() => interpretDrop();

  @override
  BitVector drop(int n) {
    if (n >= size) {
      return BitVector.empty;
    } else if (n <= 0) {
      return this;
    } else {
      final nm = n + offset;
      final d = _Drop(underlying, nm);
      return nm > 32768 && nm & 8 == 0 ? d.interpretDrop() : d;
    }
  }

  @override
  bool get(int n) => underlying.get(offset + n);

  @override
  int getByte(int n) => drop(n * 8).take(8).align().getByte(0);

  @override
  int get size => max(0, underlying.size - offset);

  @override
  bool sizeLessThan(int n) => size < n;

  @override
  BitVector take(int n) {
    if (n >= size) {
      return this;
    } else if (n <= 0) {
      return BitVector.empty;
    } else {
      return underlying.take(offset + n).drop(offset);
    }
  }

  @override
  BitVector update(int n, bool high) =>
      _Drop(underlying.update(offset + n, high).compact(), offset);

  _Bytes interpretDrop() {
    final low = max(offset, 0);
    final newSize = size;

    if (newSize == 0) {
      return BitVector.empty.align();
    } else {
      final lowByte = low ~/ 8;
      final shiftedWholeBytes = underlying.underlying.slice(
        lowByte,
        lowByte + _bytesNeededForBits(newSize) + 1,
      );

      final bitsToShiftEachByte = low % 8;

      late ByteVector newBytes;

      if (bitsToShiftEachByte == 0) {
        newBytes = shiftedWholeBytes;
      } else {
        newBytes = shiftedWholeBytes.zipWithI(
          shiftedWholeBytes.drop(1).append(0),
          (a, b) {
            final hi = a << bitsToShiftEachByte;
            final low =
                ((b & _topNBits(bitsToShiftEachByte)) & 0x000000ff) >>> (8 - bitsToShiftEachByte);

            return hi | low;
          },
        );
      }

      if (newSize <= (newBytes.size - 1) * 8) {
        return _toBytes(newBytes.dropRight(1), newSize);
      } else {
        return _toBytes(newBytes, newSize);
      }
    }
  }
}

final class _Suspend extends BitVector {
  final Function0<BitVector> thunk;
  late final BitVector underlying = thunk();

  _Suspend(this.thunk);

  @override
  _Bytes align() => underlying.align();

  @override
  BitVector drop(int n) => underlying.drop(n);

  @override
  bool get(int n) => underlying.get(n);

  @override
  int getByte(int n) => underlying.getByte(n);

  @override
  int get size => underlying.size;

  @override
  bool sizeLessThan(int n) => underlying.sizeGreaterThan(n);

  @override
  BitVector take(int n) => underlying.take(n);

  @override
  BitVector update(int n, bool high) => underlying.update(n, high);
}

int _topNBits(int n) => (-1 << (8 - n)) & 0xff;

int _validBitsInLastByte(int size) {
  final mod = size % 8;
  return mod == 0 ? 8 : mod;
}

int _bytesNeededForBits(int size) => (size + 7) ~/ 8;

ByteVector _clearUnneededBits(int size, ByteVector bytes) {
  final valid = _validBitsInLastByte(size);

  if (bytes.nonEmpty && valid < 8) {
    final idx = bytes.size - 1;
    final last = bytes.get(idx);

    return bytes.update(idx, (last & _topNBits(valid)) & 0xff);
  } else {
    return bytes;
  }
}

bool _getBit(int byte, int n) => ((0x00000080 >> n) & byte) != 0;

int _setBit(int byte, int n, bool high) =>
    (high ? (0x00000080 >> n) | byte : (~(0x00000080 >> n)) & byte) & 0xff;

_Bytes _toBytes(ByteVector bs, int sizeInBits) {
  final needed = _bytesNeededForBits(sizeInBits);
  final b = bs.size > needed ? bs.take(needed) : bs;
  return _Bytes(b, sizeInBits);
}

A _reduceBalanced<A>(
  RIterable<A> v,
  Function1<A, int> size,
  Function2<A, A, A> f,
) {
  // TODO: tailrec
  IList<(A, int)> fixup(IList<(A, int)> stack) {
    if (stack.size >= 2) {
      final (h2, n) = stack[0];
      final (h, m) = stack[1];

      if (n > m / 2) {
        return fixup(stack.drop(2).prepended((f(h, h2), m + n)));
      } else {
        return stack;
      }
    } else {
      return stack;
    }
  }

  return v
      .foldLeft(IList.empty<(A, int)>(), (stack, a) => fixup(stack.prepended((a, size(a)))))
      .reverse()
      .map((t) => t.$1)
      .reduceLeft(f);
}

int _reverseBitsInByte(int b) => _bitReversalTable[b & 0xff]!;

final _bitReversalTable = arr([
  0x00,
  0x80,
  0x40,
  0xc0,
  0x20,
  0xa0,
  0x60,
  0xe0,
  0x10,
  0x90,
  0x50,
  0xd0,
  0x30,
  0xb0,
  0x70,
  0xf0,
  0x08,
  0x88,
  0x48,
  0xc8,
  0x28,
  0xa8,
  0x68,
  0xe8,
  0x18,
  0x98,
  0x58,
  0xd8,
  0x38,
  0xb8,
  0x78,
  0xf8,
  0x04,
  0x84,
  0x44,
  0xc4,
  0x24,
  0xa4,
  0x64,
  0xe4,
  0x14,
  0x94,
  0x54,
  0xd4,
  0x34,
  0xb4,
  0x74,
  0xf4,
  0x0c,
  0x8c,
  0x4c,
  0xcc,
  0x2c,
  0xac,
  0x6c,
  0xec,
  0x1c,
  0x9c,
  0x5c,
  0xdc,
  0x3c,
  0xbc,
  0x7c,
  0xfc,
  0x02,
  0x82,
  0x42,
  0xc2,
  0x22,
  0xa2,
  0x62,
  0xe2,
  0x12,
  0x92,
  0x52,
  0xd2,
  0x32,
  0xb2,
  0x72,
  0xf2,
  0x0a,
  0x8a,
  0x4a,
  0xca,
  0x2a,
  0xaa,
  0x6a,
  0xea,
  0x1a,
  0x9a,
  0x5a,
  0xda,
  0x3a,
  0xba,
  0x7a,
  0xfa,
  0x06,
  0x86,
  0x46,
  0xc6,
  0x26,
  0xa6,
  0x66,
  0xe6,
  0x16,
  0x96,
  0x56,
  0xd6,
  0x36,
  0xb6,
  0x76,
  0xf6,
  0x0e,
  0x8e,
  0x4e,
  0xce,
  0x2e,
  0xae,
  0x6e,
  0xee,
  0x1e,
  0x9e,
  0x5e,
  0xde,
  0x3e,
  0xbe,
  0x7e,
  0xfe,
  0x01,
  0x81,
  0x41,
  0xc1,
  0x21,
  0xa1,
  0x61,
  0xe1,
  0x11,
  0x91,
  0x51,
  0xd1,
  0x31,
  0xb1,
  0x71,
  0xf1,
  0x09,
  0x89,
  0x49,
  0xc9,
  0x29,
  0xa9,
  0x69,
  0xe9,
  0x19,
  0x99,
  0x59,
  0xd9,
  0x39,
  0xb9,
  0x79,
  0xf9,
  0x05,
  0x85,
  0x45,
  0xc5,
  0x25,
  0xa5,
  0x65,
  0xe5,
  0x15,
  0x95,
  0x55,
  0xd5,
  0x35,
  0xb5,
  0x75,
  0xf5,
  0x0d,
  0x8d,
  0x4d,
  0xcd,
  0x2d,
  0xad,
  0x6d,
  0xed,
  0x1d,
  0x9d,
  0x5d,
  0xdd,
  0x3d,
  0xbd,
  0x7d,
  0xfd,
  0x03,
  0x83,
  0x43,
  0xc3,
  0x23,
  0xa3,
  0x63,
  0xe3,
  0x13,
  0x93,
  0x53,
  0xd3,
  0x33,
  0xb3,
  0x73,
  0xf3,
  0x0b,
  0x8b,
  0x4b,
  0xcb,
  0x2b,
  0xab,
  0x6b,
  0xeb,
  0x1b,
  0x9b,
  0x5b,
  0xdb,
  0x3b,
  0xbb,
  0x7b,
  0xfb,
  0x07,
  0x87,
  0x47,
  0xc7,
  0x27,
  0xa7,
  0x67,
  0xe7,
  0x17,
  0x97,
  0x57,
  0xd7,
  0x37,
  0xb7,
  0x77,
  0xf7,
  0x0f,
  0x8f,
  0x4f,
  0xcf,
  0x2f,
  0xaf,
  0x6f,
  0xef,
  0x1f,
  0x9f,
  0x5f,
  0xdf,
  0x3f,
  0xbf,
  0x7f,
  0xff,
]);
