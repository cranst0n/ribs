import 'dart:math';
import 'dart:typed_data';

import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_binary/src/internal/byte_vector.dart';
import 'package:ribs_core/ribs_core.dart';

part 'at.dart';
part 'view.dart';

/// An immutable, indexable sequence of bytes with rich operations for
/// binary data manipulation.
///
/// `ByteVector` supports bitwise operations ([and], [or], [xor], [not]),
/// shifting, slicing ([take], [drop], [slice]), and conversion to and from
/// various base encodings (binary, hex, base32, base58, base64).
///
/// Internally represented as a persistent tree of byte chunks, enabling
/// efficient concatenation and buffered appends while maintaining
/// immutability.
///
/// ```dart
/// final bv = ByteVector.fromValidHex('deadbeef');
/// print(bv.size);    // 4
/// print(bv.toHex());  // 'deadbeef'
/// ```
///
/// See also:
/// - [BitVector], which operates at bit granularity.
sealed class ByteVector {
  /// Creates a [ByteVector] from a list of byte values.
  factory ByteVector(List<int> bytes) =>
      _Chunk(_View(At.array(Uint8List.fromList(bytes)), 0, bytes.length));

  ByteVector._();

  /// An empty byte vector containing zero bytes.
  static final ByteVector empty = _Chunk(_View.empty());

  /// Creates a [size]-byte vector with all bytes set to `0x00`.
  factory ByteVector.low(int size) => ByteVector.fill(size, 0x00);

  /// Creates a [size]-byte vector with all bytes set to `0xFF`.
  factory ByteVector.high(int size) => ByteVector.fill(size, 0xff);

  /// Creates a [size]-byte vector with every byte set to [byte].
  factory ByteVector.fill(int size, int byte) {
    assert(size >= 0, 'ByteVector.fill: size must be non-negative');
    return _Chunk(_View(At((i) => byte), 0, size));
  }

  /// Creates a byte vector from a sequence of bytes.
  factory ByteVector.from(RIterableOnce<int> bs) => ByteVector(bs.toList());

  /// Creates a byte vector from a Dart iterable of bytes.
  factory ByteVector.fromDart(Iterable<int> bs) => ByteVector(bs.toList());

  /// Creates a single-byte vector containing [byte].
  factory ByteVector.of(int byte) => ByteVector.fill(1, byte);

  /// Creates a byte vector backed by the given [Uint8List] without copying.
  factory ByteVector.view(Uint8List bytes) =>
      _Chunk(_View(At.array(Uint8List.view(bytes.buffer)), 0, bytes.length));

  /// Creates a byte vector backed by an [At] accessor with the given [size].
  factory ByteVector.viewAt(At at, int size) => _Chunk(_View(at, 0, size));

  /// Creates a byte vector by concatenating all vectors in [bvs].
  factory ByteVector.concatAll(IList<ByteVector> bvs) =>
      bvs.foldLeft(ByteVector.empty, (acc, bv) => acc.concat(bv));

  /// Decodes a binary string into a [ByteVector], returning [None] on failure.
  static Option<ByteVector> fromBin(String s) => fromBinDescriptive(s).toOption();

  /// Decodes a binary string into a [ByteVector], throwing on failure.
  static ByteVector fromValidBin(
    String s, [
    BinaryAlphabet alphabet = Alphabets.binary,
  ]) => fromBinDescriptive(s, alphabet).fold((err) => throw ArgumentError(err), identity);

  /// Decodes a binary string, returning a descriptive error on failure.
  static Either<String, ByteVector> fromBinDescriptive(
    String str, [
    BinaryAlphabet alphabet = Alphabets.binary,
  ]) => fromBinInternal(str, alphabet).map((a) => a.$1);

  /// Decodes a hex string into a [ByteVector], returning [None] on failure.
  static Option<ByteVector> fromHex(
    String s, [
    HexAlphabet alphabet = Alphabets.hexLower,
  ]) => fromHexDescriptive(s, alphabet).toOption();

  /// Decodes a hex string into a [ByteVector], throwing on failure.
  static ByteVector fromValidHex(
    String s, [
    HexAlphabet alphabet = Alphabets.hexLower,
  ]) => fromHexDescriptive(s, alphabet).fold((err) => throw ArgumentError(err), identity);

  /// Decodes a hex string, returning a descriptive error on failure.
  static Either<String, ByteVector> fromHexDescriptive(
    String str, [
    HexAlphabet alphabet = Alphabets.hexLower,
  ]) => fromHexInternal(str, alphabet).map((a) => a.$1);

  /// Decodes a base-32 string into a [ByteVector], returning [None] on failure.
  static Option<ByteVector> fromBase32(
    String s, [
    Base32Alphabet alphabet = Alphabets.base32,
  ]) => fromBase32Descriptive(s, alphabet).toOption();

  /// Decodes a base-32 string into a [ByteVector], throwing on failure.
  static ByteVector fromValidBase32(
    String s, [
    Base32Alphabet alphabet = Alphabets.base32,
  ]) => fromBase32Descriptive(s, alphabet).fold((err) => throw ArgumentError(err), identity);

  /// Decodes a base-32 string, returning a descriptive error on failure.
  static Either<String, ByteVector> fromBase32Descriptive(
    String str, [
    Base32Alphabet alphabet = Alphabets.base32,
  ]) => fromBase32Internal(str, alphabet).map((a) => a.$1);

  /// Decodes a base-58 string into a [ByteVector], returning [None] on failure.
  static Option<ByteVector> fromBase58(
    String s, [
    Base58Alphabet alphabet = Alphabets.base58,
  ]) => fromBase58Descriptive(s, alphabet).toOption();

  /// Decodes a base-58 string into a [ByteVector], throwing on failure.
  static ByteVector fromValidBase58(
    String s, [
    Base58Alphabet alphabet = Alphabets.base58,
  ]) => fromBase58Descriptive(s, alphabet).fold((err) => throw ArgumentError(err), identity);

  /// Decodes a base-58 string, returning a descriptive error on failure.
  static Either<String, ByteVector> fromBase58Descriptive(
    String str, [
    Base58Alphabet alphabet = Alphabets.base58,
  ]) {
    final zeroLength = str.takeWhile((c) => c == '1').length;
    final zeroes = ByteVector.fill(zeroLength, 0);
    final trim = str.splitAt(zeroLength).$2.split('').toIList();
    final radix = BigInt.from(58);

    try {
      final decoded = trim.foldLeft(BigInt.zero, (a, c) {
        try {
          return a * radix + BigInt.from(alphabet.toIndex(c));
        } catch (_) {
          final idx = trim.takeWhile((x) => x != c).length;

          throw ArgumentError("Invalid base 58 character '$c' at index $idx");
        }
      });

      if (trim.isEmpty) {
        return zeroes.asRight();
      } else {
        return zeroes
            .concat(ByteVector.fromValidBin(decoded.toRadixString(2).dropWhile((c) => c == '0')))
            .asRight();
      }
    } catch (e) {
      return e.toString().asLeft();
    }
  }

  /// Decodes a base-64 string into a [ByteVector], returning [None] on failure.
  static Option<ByteVector> fromBase64(
    String s, [
    Base64Alphabet alphabet = Alphabets.base64,
  ]) => fromBase64Descriptive(s, alphabet).toOption();

  /// Decodes a base-64 string into a [ByteVector], throwing on failure.
  static ByteVector fromValidBase64(
    String s, [
    Base64Alphabet alphabet = Alphabets.base64,
  ]) => fromBase64Descriptive(s, alphabet).fold((err) => throw ArgumentError(err), identity);

  /// Decodes a base-64 string, returning a descriptive error on failure.
  static Either<String, ByteVector> fromBase64Descriptive(
    String str, [
    Base64Alphabet alphabet = Alphabets.base64,
  ]) => fromBase64Internal(str, alphabet).map((a) => a.$1);

  /// Creates a byte vector from an integer value.
  ///
  /// The result has [size] bytes (default 4). Use [ordering] to specify
  /// byte order (`Endian.big` by default).
  factory ByteVector.fromInt(
    int i, {
    int size = 4,
    Endian ordering = Endian.big,
  }) => BitVector.fromInt(i, size: size * 8, ordering: ordering).bytes;

  /// Creates a byte vector from a [BigInt] value.
  ///
  /// If [size] is provided, the result is exactly that many bytes.
  /// Use [ordering] to specify byte order (`Endian.big` by default).
  factory ByteVector.fromBigInt(
    BigInt value, {
    Option<int> size = const None(),
    Endian ordering = Endian.big,
  }) => BitVector.fromBigInt(value, size: size.map((s) => s * 8), ordering: ordering).bytes;

  /// Returns the byte at [idx].
  int operator [](int idx) => _getImpl(idx);

  /// Bitwise AND of this vector and [other].
  ByteVector operator &(ByteVector other) => and(other);

  /// Bitwise NOT. Returns the complement of this vector.
  ByteVector operator ~() => not;

  /// Bitwise OR of this vector and [other].
  ByteVector operator |(ByteVector other) => or(other);

  /// Bitwise XOR of this vector and [other].
  ByteVector operator ^(ByteVector other) => xor(other);

  /// Left shift by [n] bits.
  ByteVector operator <<(int n) => shiftLeft(n);

  /// Arithmetic right shift by [n] bits (sign-extending).
  ByteVector operator >>(int n) => shiftRight(n, true);

  /// Logical right shift by [n] bits (zero-filling).
  ByteVector operator >>>(int n) => shiftRight(n, false);

  /// Returns the first [bytes] from this vector, or an error if there
  /// are fewer than [bytes] available.
  Either<String, ByteVector> acquire(int bytes) => Either.cond(
    () => size >= bytes,
    () => take(bytes),
    () => 'Cannot acquire $bytes bytes from ByteVector of size $size',
  );

  /// Consumes the first [n] bytes, decoding them with [decode] and
  /// returning the remaining bytes paired with the decoded value.
  Either<String, (ByteVector, A)> consume<A>(
    int n,
    Function1<ByteVector, Either<String, A>> decode,
  ) => acquire(n).flatMap((toDecode) => decode(toDecode).map((decoded) => (drop(n), decoded)));

  /// Left-folds over each byte, accumulating from [z] using [f].
  A foldLeft<A>(A z, Function2<A, int, A> f) {
    var acc = z;
    _foreachS((b) => acc = f(acc, b));
    return acc;
  }

  /// Right-folds over each byte, accumulating from [init] using [f].
  A foldRight<A>(A init, Function2<int, A, A> f) => reverse.foldLeft(init, (a, b) => f(b, a));

  /// The number of bytes in this vector.
  int get size;

  /// Alias for [size].
  int get length => size;

  /// Returns `true` if this vector contains no bytes.
  bool get isEmpty => size == 0;

  /// Returns `true` if this vector contains at least one byte.
  bool get nonEmpty => !isEmpty;

  /// Returns the byte at [index].
  int get(int index) => _getImpl(index);

  int _getImpl(int index);

  /// Returns a new vector with [byte] appended.
  ByteVector append(int byte) => concat(ByteVector.of(byte));

  /// Returns a new vector with [byte] prepended.
  ByteVector prepend(int byte) => ByteVector([byte]).concat(this);

  /// Replaces bytes at position [ix] with the contents of [b].
  ByteVector patch(int ix, ByteVector b) => take(ix).concat(b).concat(drop(ix + b.size));

  /// Inserts [b] at position [ix] without removing existing bytes.
  ByteVector splice(int ix, ByteVector b) => take(ix).concat(b).concat(drop(ix));

  /// Returns a new vector with the byte at [idx] replaced by [b].
  ByteVector update(int idx, int b) {
    _checkIndex(idx);
    return take(idx).append(b).concat(drop(idx + 1));
  }

  /// Inserts byte [b] at position [idx].
  ByteVector insert(int idx, int b) => take(idx).append(b).concat(drop(idx));

  /// Returns `Some(get(ix))` if [ix] is in bounds, otherwise [None].
  Option<int> lift(int ix) => Option.when(() => 0 <= ix && ix < size, () => get(ix));

  /// Returns the first byte, or throws if empty.
  int get head => get(0);

  /// Returns `Some(head)` if non-empty, otherwise [None].
  Option<int> get headOption => size > 0 ? Some(head) : none();

  /// Invokes [f] for each byte in order.
  void foreach(Function1<int, void> f) => _foreachV((v) => v.foreach(f));

  /// Returns all bytes except the first.
  ByteVector get tail => drop(1);

  /// Returns all bytes except the last.
  ByteVector get init => dropRight(1);

  /// Returns the last byte, or throws if empty.
  int get last => get(size - 1);

  /// Returns `Some(last)` if non-empty, otherwise [None].
  Option<int> get lastOption => lift(size - 1);

  /// Returns a vector of all bytes except the first [n].
  ByteVector drop(int n) {
    final n1 = max(min(n, size), 0);

    if (n1 == size) {
      return ByteVector.empty;
    } else if (n1 == 0) {
      return this;
    } else {
      ByteVector go(ByteVector cur, int n1) {
        var currentCur = cur;
        var currentN1 = n1;
        final stack = <ByteVector>[];

        while (true) {
          switch (currentCur) {
            case _Chunk(bytes: final bs):
              var result = _Chunk(bs.drop(currentN1)) as ByteVector;
              for (int i = stack.length - 1; i >= 0; i--) {
                result = result.concat(stack[i]).unbuffer();
              }
              return result;
            case _Append(left: final l, right: final r):
              if (currentN1 > l.size) {
                currentCur = r;
                currentN1 -= l.size;
              } else {
                currentCur = l;
                stack.add(r);
              }
            case final _Buffer b:
              if (currentN1 > b.hd.size) {
                currentCur = b.lastBytes;
                currentN1 -= b.hd.size;
              } else {
                currentCur = b.hd;
                stack.add(b.lastBytes);
              }
            case final _Chunks c:
              currentCur = c.chunks;
          }
        }
      }

      return go(this, n1);
    }
  }

  /// Returns all bytes except the last [n].
  ByteVector dropRight(int n) => take(size - max(0, n));

  /// Drops the longest prefix of bytes satisfying [p].
  ByteVector dropWhile(Function1<int, bool> p) {
    var toDrop = 0;
    _foreachSPartial((i) {
      final cont = p(i);
      if (cont) toDrop += 1;
      return cont;
    });

    return drop(toDrop);
  }

  /// Returns the first [n] bytes of this vector.
  ByteVector take(int n) {
    final n1 = max(min(n, size), 0);

    if (n1 == size) {
      return this;
    } else if (n1 == 0) {
      return ByteVector.empty;
    } else {
      ByteVector go(ByteVector accL, ByteVector cur, int n1) {
        var currentAccL = accL;
        var currentCur = cur;
        var currentN1 = n1;

        while (true) {
          switch (currentCur) {
            case _Chunk(bytes: final bs):
              return currentAccL.concat(_Chunk(bs.take(currentN1)));
            case _Append(left: final l, right: final r):
              if (currentN1 > l.size) {
                currentAccL = currentAccL.concat(l);
                currentCur = r;
                currentN1 -= l.size;
              } else {
                currentCur = l;
              }
            case final _Chunks c:
              currentCur = c.chunks;
            case final _Buffer b:
              currentCur = b.unbuffer();
          }
        }
      }

      return go(ByteVector.empty, this, n1);
    }
  }

  /// Returns the last [n] bytes of this vector.
  ByteVector takeRight(int n) => drop(size - n);

  /// Takes the longest prefix of bytes satisfying [p].
  ByteVector takeWhile(Function1<int, bool> p) {
    var toTake = 0;
    _foreachSPartial((i) {
      final cont = p(i);
      if (cont) toTake += 1;
      return cont;
    });

    return take(toTake);
  }

  /// Splits this vector at [ix], returning `(take(ix), drop(ix))`.
  (ByteVector, ByteVector) splitAt(int ix) => (take(ix), drop(ix));

  /// Returns bytes from index [from] up to (but not including) [until].
  ByteVector slice(int from, int until) => drop(from).take(until - max(0, from));

  /// Returns an iterator of [n]-byte sliding windows, advancing [step]
  /// bytes between consecutive windows.
  RIterator<ByteVector> sliding(int n, [int step = 1]) {
    assert(n > 0 && step > 0, "both n and step must be positive");

    RIterator<int> limit(RIterator<int> itr) =>
        step < n ? itr.take((size - n) + 1) : itr.takeWhile((i) => i < size);

    return limit(RIterator.iterate(0, (x) => x + step)).map((idx) => slice(idx, idx + n));
  }

  /// Concatenates [other] to the end of this vector.
  ByteVector concat(ByteVector other) {
    if (isEmpty) {
      return other;
    } else if (other.isEmpty) {
      return this;
    } else {
      return _Chunks(_Append(this, other)).bufferBy(64);
    }
  }

  /// Zips this vector with [other] element-wise using [op].
  ByteVector zipWithI(ByteVector other, Function2<int, int, int> op) =>
      zipWith(other, (l, r) => op(l, r));

  /// Returns a single-chunk copy of this vector if not already compacted.
  ByteVector compact() {
    return switch (this) {
      final _Chunk _ => this,
      _ => copy(),
    };
  }

  /// Returns a guaranteed fresh copy of this vector's bytes.
  ByteVector copy() {
    final sz = size;
    final arr = toByteArray();
    return _Chunk(_View(At.array(arr), 0, sz));
  }

  /// Returns a vector with bytes in reverse order.
  ByteVector get reverse => ByteVector.viewAt(At((i) => get(size - i - 1)), size);

  /// Returns the bitwise complement of this vector.
  ByteVector get not => _mapS((b) => ~b);

  /// Returns a bitwise OR of this vector and [other].
  ByteVector or(ByteVector other) => _zipWithS(other, (b, b2) => b | b2);

  /// Returns a bitwise AND of this vector and [other].
  ByteVector and(ByteVector other) => _zipWithS(other, (b, b2) => b & b2);

  /// Returns a bitwise XOR of this vector and [other].
  ByteVector xor(ByteVector other) => _zipWithS(other, (b, b2) => b ^ b2);

  /// Left shifts the bits of this vector by [n] positions.
  ByteVector shiftLeft(int n) => bits.shiftLeft(n).bytes;

  /// Right shifts the bits by [n] positions, with optional [signExtension].
  ByteVector shiftRight(int n, bool signExtension) => bits.shiftRight(n, signExtension).bytes;

  /// Circularly shifts bits left by [n] positions.
  ByteVector rotateLeft(int n) => bits.rotateLeft(n).bytes;

  /// Circularly shifts bits right by [n] positions.
  ByteVector rotateRight(int n) => bits.rotateRight(n).bytes;

  /// Returns a new vector with [f] applied to each byte.
  ByteVector map(Function1<int, int> f) => ByteVector.viewAt(At((i) => f(get(i))), size);

  /// Returns `true` if this vector starts with [b].
  bool startsWith(ByteVector b) => take(b.size) == b;

  /// Returns `true` if this vector ends with [b].
  bool endsWith(ByteVector b) => takeRight(b.size) == b;

  /// Returns the index of the first occurrence of [slice] at or after
  /// [from], or [None] if not found.
  Option<int> indexOfSlice(ByteVector slice, [int from = 0]) {
    var b = this;
    var idx = from;

    while (true) {
      if (b.startsWith(slice)) {
        return Some(idx);
      } else if (b.isEmpty) {
        return none();
      } else {
        b = b.tail;
        idx += 1;
      }
    }
  }

  /// Returns `true` if this vector contains [slice] as a contiguous subsequence.
  bool containsSlice(ByteVector slice) => indexOfSlice(slice).isDefined;

  /// Partitions this vector into an iterator of non-overlapping chunks
  /// of [chunkSize] bytes. The last chunk may be smaller.
  RIterator<ByteVector> grouped(int chunkSize) {
    if (isEmpty) {
      return RIterator.empty();
    } else if (size <= chunkSize) {
      return RIterator.single(this);
    } else {
      return RIterator.single(take(chunkSize)).concat(drop(chunkSize).grouped(chunkSize));
    }
  }

  /// Left-pads this vector with zero bytes to a total length of [n].
  ///
  /// Throws [ArgumentError] if [n] is less than [size].
  ByteVector padLeft(int n) {
    if (n < size) {
      throw ArgumentError('ByteVector.padLeft($n)');
    } else {
      return ByteVector.low(n - size).concat(this);
    }
  }

  /// Right-pads this vector with zero bytes to a total length of [n].
  ///
  /// Throws [ArgumentError] if [n] is less than [size].
  ByteVector padRight(int n) {
    if (n < size) {
      throw ArgumentError('ByteVector.padRight($n)');
    } else {
      return concat(ByteVector.low(n - size));
    }
  }

  /// Alias for [padRight].
  ByteVector padTo(int n) => padRight(n);

  /// Zips this vector with [other] element-wise, combining bytes with [f].
  ByteVector zipWith(ByteVector other, Function2<int, int, int> f) => _zipWithS(other, f);

  /// Returns a buffered version that amortizes appends by collecting
  /// them into internal chunks of [chunkSize] bytes.
  ByteVector bufferBy([int chunkSize = 1024]) {
    switch (this) {
      case final _Buffer b:
        if (b.lastChunk.length >= chunkSize) {
          return b;
        } else {
          return b.unbuffer().bufferBy(chunkSize);
        }
      default:
        return _Buffer(this, Uint8List(chunkSize), 0, _BufferState(0));
    }
  }

  /// Materializes any buffered appends.
  ByteVector unbuffer() => this;

  /// Returns the contents as a [Uint8List].
  Uint8List toByteArray() {
    final buf = Uint8List(size);
    copyToArray(buf, 0);
    return buf;
  }

  /// Returns the contents as an [IList] of byte values.
  IList<int> toIList() => IList.fromDart(toByteArray());

  /// Returns a [BitVector] view of these bytes.
  BitVector get bits => toBitVector();

  /// Converts this byte vector to a [BitVector].
  BitVector toBitVector() => BitVector.fromByteVector(this);

  /// Encodes as a binary string using the given [alphabet].
  String toBin([BinaryAlphabet alphabet = Alphabets.binary]) {
    final bldr = StringBuffer();

    foreach((b) {
      var n = 7;

      while (n >= 0) {
        final idx = 1 & (b >> n);
        bldr.write(alphabet.toChar(idx));
        n -= 1;
      }
    });

    return bldr.toString();
  }

  /// Encodes as a hexadecimal string using the given [alphabet].
  String toHex([HexAlphabet alphabet = Alphabets.hexLower]) {
    final out = List.filled(size * 2, '');
    var i = 0;

    foreach((b) {
      out[i] = alphabet.toChar(b >> 4 & 0x0f);
      out[i + 1] = alphabet.toChar(b & 0x0f);
      i += 2;
    });

    return out.join();
  }

  /// Returns a plain-text hex dump (no ANSI colors).
  String toHexDump() => HexDumpFormat.noAnsi.renderBytes(this);

  /// Returns a colorized hex dump.
  String toHexDumpColorized() => HexDumpFormat.defaultFormat.renderBytes(this);

  /// Prints a colorized hex dump to stdout.
  void printHexDump() => HexDumpFormat.defaultFormat.printBytes(this);

  /// Alias for [toHex].
  String toBase16([HexAlphabet alphabet = Alphabets.hexLower]) => toHex(alphabet);

  /// Copies the bytes into [xs] starting at offset [start].
  void copyToArray(Uint8List xs, int start) {
    var i = start;

    _foreachV((v) {
      v.copyToArray(xs, i);
      i += v.size;
    });
  }

  /// Encodes as a base-32 string using the given [alphabet].
  String toBase32([Base32Alphabet alphabet = Alphabets.base32]) {
    const bitsPerChar = 5;

    final bytes = toByteArray();
    final bldr = StringBuffer();

    int bidx = 0;
    while ((bidx ~/ 8) < bytes.length) {
      final char = alphabet.toChar(_bitsAtOffset(bytes, bidx, bitsPerChar));
      bldr.write(char);
      bidx += bitsPerChar;
    }

    if (alphabet.pad != '0') {
      final padLen =
          (((bytes.length + bitsPerChar - 1) ~/ bitsPerChar * bitsPerChar) - bytes.length) *
          8 ~/
          bitsPerChar;

      var i = 0;

      while (i < padLen) {
        bldr.write(alphabet.pad);
        i += 1;
      }
    }

    return bldr.toString();
  }

  /// Encodes as a base-58 string using the given [alphabet].
  String toBase58([Base58Alphabet alphabet = Alphabets.base58]) {
    if (isEmpty) {
      return '';
    } else {
      var value = toBigInt(signed: false);
      var chars = IList.empty<String>();

      final radix = BigInt.from(58);
      final ones = IList.fill(takeWhile((b) => b == 0).length, '1');

      while (true) {
        if (value == BigInt.zero) {
          return ones.concat(chars).mkString();
        } else {
          final div = value ~/ radix;
          final rem = value % radix;

          value = div;
          chars = chars.prepended(alphabet.toChar(rem.toInt()));
        }
      }
    }
  }

  /// Encodes as a base-64 string using the given [alphabet].
  String toBase64([Base64Alphabet alphabet = Alphabets.base64]) {
    final bytes = toByteArray();
    final bldr = StringBuffer();

    var idx = 0;
    final mod = bytes.length % 3;

    while (idx < bytes.length - mod) {
      var buffer =
          ((bytes[idx] & 0x0ff) << 16) | ((bytes[idx + 1] & 0x0ff) << 8) | (bytes[idx + 2] & 0x0ff);

      final fourth = buffer & 0x3f;
      buffer = buffer >> 6;

      final third = buffer & 0x3f;
      buffer = buffer >> 6;

      final second = buffer & 0x3f;
      buffer = buffer >> 6;

      final first = buffer;

      bldr
        ..write(alphabet.toChar(first))
        ..write(alphabet.toChar(second))
        ..write(alphabet.toChar(third))
        ..write(alphabet.toChar(fourth));

      idx += 3;
    }

    if (mod == 1) {
      var buffer = (bytes[idx] & 0x0ff) << 4;
      final second = buffer & 0x3f;
      buffer = buffer >> 6;
      final first = buffer;

      bldr
        ..write(alphabet.toChar(first))
        ..write(alphabet.toChar(second));

      if (alphabet.pad != '0') {
        bldr
          ..write(alphabet.pad)
          ..write(alphabet.pad);
      }
    } else if (mod == 2) {
      var buffer = ((bytes[idx] & 0x0ff) << 10) | ((bytes[idx + 1] & 0x0ff) << 2);
      final third = buffer & 0x3f;
      buffer = buffer >> 6;
      final second = buffer & 0x3f;
      buffer = buffer >> 6;
      final first = buffer;

      bldr
        ..write(alphabet.toChar(first))
        ..write(alphabet.toChar(second))
        ..write(alphabet.toChar(third));

      if (alphabet.pad != '0') {
        bldr.write(alphabet.pad);
      }
    }

    return bldr.toString();
  }

  /// Encodes as base-64 without padding.
  String toBase64NoPad() => toBase64(Alphabets.base64NoPad);

  /// Encodes as URL-safe base-64.
  String toBase64Url() => toBase64(Alphabets.base64Url);

  /// Encodes as URL-safe base-64 without padding.
  String toBase64UrlNoPad() => toBase64(Alphabets.base64UrlNoPad);

  /// Converts to a signed Dart [int] using the given byte [ordering].
  int toInt({Endian ordering = Endian.big}) => bits.toInt(ordering: ordering);

  /// Converts to an unsigned Dart [int] using the given byte [ordering].
  int toUnsignedInt({Endian ordering = Endian.big}) =>
      bits.toInt(signed: false, ordering: ordering);

  /// Converts to a [BigInt] using the given sign and byte [ordering].
  BigInt toBigInt({bool signed = true, Endian ordering = Endian.big}) =>
      bits.toBigInt(signed: signed, ordering: ordering);

  @override
  String toString() {
    if (isEmpty) {
      return 'ByteVector.empty';
    } else if (size < 512) {
      return 'ByteVector(${toHex()})';
    } else {
      return 'ByteVector($size, $hashCode)';
    }
  }

  @override
  bool operator ==(Object other) {
    if (other is ByteVector) {
      if (identical(this, other)) {
        return true;
      } else {
        final s = size;

        if (s != other.size) {
          return false;
        } else {
          var i = 0;

          while (i < s) {
            if (get(i) == other.get(i)) {
              i += 1;
            } else {
              return false;
            }
          }

          return true;
        }
      }
    } else {
      return false;
    }
  }

  @override
  int get hashCode {
    const chunkSize = 1024 * 64;

    var bytes = this;
    var h = MurmurHash3.stringHash('ByteVector');
    var iter = 1;

    while (true) {
      if (bytes.isEmpty) {
        return MurmurHash3.finalizeHash(h, iter);
      } else {
        final chunk = bytes.take(chunkSize);
        bytes = bytes.drop(chunkSize);
        h = MurmurHash3.mix(h, MurmurHash3.bytesHash(chunk.toByteArray()));
        iter += 1;
      }
    }
  }

  ByteVector _mapS(Function1<int, int> f) => ByteVector.viewAt(At((i) => f(get(i))), size);

  ByteVector _zipWithS(ByteVector other, Function2<int, int, int> f) {
    return _Chunk(
      _View(
        At((i) => f(get(i), other.get(i))),
        0,
        min(size, other.size),
      ),
    );
  }

  void _foreachS(Function1<int, void> f) => _foreachV((v) => v.foreach(f));

  void _foreachSPartial(Function1<int, bool> f) => _foreachVPartial((v) => v.foreachPartial(f));

  void _foreachV(Function1<_View, void> f) {
    final stack = <ByteVector>[this];

    while (stack.isNotEmpty) {
      final cur = stack.removeLast();

      switch (cur) {
        case _Chunk(:final bytes):
          f(bytes);
        case _Append(:final left, :final right):
          stack.add(right);
          stack.add(left);
        case final _Buffer b:
          stack.add(b.unbuffer());
        case final _Chunks c:
          stack.add(c.chunks.right);
          stack.add(c.chunks.left);
      }
    }
  }

  bool _foreachVPartial(Function1<_View, bool> f) {
    final stack = <ByteVector>[this];

    while (stack.isNotEmpty) {
      final cur = stack.removeLast();

      switch (cur) {
        case _Chunk(:final bytes):
          if (!f(bytes)) return false;
        case _Append(:final left, :final right):
          stack.add(right);
          stack.add(left);
        case final _Buffer b:
          stack.add(b.unbuffer());
        case final _Chunks c:
          stack.add(c.chunks.right);
          stack.add(c.chunks.left);
      }
    }

    return true;
  }

  void _checkIndex(int n) {
    if (n < 0 || n >= size) {
      throw RangeError.index(n, this, 'invalid index: $n for size $size');
    }
  }
}

final class _Chunk extends ByteVector {
  final _View bytes;

  _Chunk(this.bytes) : super._();

  @override
  int _getImpl(int index) => bytes.get(index);

  @override
  int get size => bytes.size;
}

final class _Append extends ByteVector {
  final ByteVector left;
  final ByteVector right;

  _Append(this.left, this.right) : super._();

  @override
  int _getImpl(int index) {
    if (index < left.size) {
      return left._getImpl(index);
    } else {
      return right._getImpl(index - left.size);
    }
  }

  @override
  int get size => left.size + right.size;
}

final class _Chunks extends ByteVector {
  final _Append chunks;

  _Chunks(this.chunks) : super._();

  @override
  int _getImpl(int index) => chunks._getImpl(index);

  @override
  int get size => chunks.size;

  @override
  ByteVector concat(ByteVector other) {
    if (other.isEmpty) {
      return this;
    } else if (isEmpty) {
      return other;
    } else {
      ByteVector go(_Append chunks, ByteVector last) {
        var currentChunks = chunks;
        var currentLast = last;

        while (true) {
          final lastN = currentLast.size;

          if (lastN >= currentChunks.size || lastN * 2 <= currentChunks.right.size) {
            return _Chunks(_Append(currentChunks, currentLast));
          } else {
            switch (currentChunks.left) {
              case final _Append left:
                final right = currentChunks.right;
                currentChunks = left;
                currentLast = _Append(right, currentLast);
              default:
                return _Chunks(_Append(currentChunks, currentLast));
            }
          }
        }
      }

      return go(chunks, other.unbuffer());
    }
  }
}

final class _Buffer extends ByteVector {
  final ByteVector hd;
  final Uint8List lastChunk;
  final int lastSize;
  final _BufferState state;

  _Buffer(this.hd, this.lastChunk, this.lastSize, this.state) : super._();

  @override
  int _getImpl(int index) =>
      index < hd.size ? hd._getImpl(index) : lastChunk[index - hd.size] & 0xff;

  @override
  int get size => hd.size + lastSize;

  @override
  ByteVector take(int n) => n <= hd.size ? hd.take(n) : hd.concat(lastBytes.take(n - hd.size));

  @override
  ByteVector drop(int n) =>
      n <= hd.size
          ? _Buffer(hd.drop(n), lastChunk, lastSize, state)
          : unbuffer().drop(n).bufferBy(lastChunk.length);

  @override
  ByteVector append(int byte) {
    // Do we own the last chunk? Guard against double mutation.
    if (lastSize == state.frontierSize && lastSize < lastChunk.length) {
      lastChunk[lastSize] = byte;
      state.frontierSize += 1;
      return _Buffer(hd, lastChunk, lastSize + 1, state);
    } else {
      return _Buffer(unbuffer(), Uint8List(lastChunk.length), 0, _BufferState(0)).append(byte);
    }
  }

  @override
  ByteVector concat(ByteVector other) {
    if (other.isEmpty) {
      return this;
    } else if (isEmpty) {
      return other;
    } else {
      // Do we own the last chunk? Guard against double mutation.
      if (lastSize == state.frontierSize && lastChunk.length - lastSize > other.size) {
        other.copyToArray(lastChunk, lastSize);
        state.frontierSize += other.size;
        return _Buffer(hd, lastChunk, lastSize + other.size, state);
      } else if (lastSize == 0) {
        return _Buffer(hd.concat(other).unbuffer(), lastChunk, lastSize, state);
      } else {
        return _Buffer(unbuffer(), Uint8List(lastChunk.length), 0, _BufferState(0)).concat(other);
      }
    }
  }

  ByteVector get lastBytes => ByteVector.view(Uint8List.sublistView(lastChunk, 0, lastSize));

  @override
  ByteVector unbuffer() {
    if (lastSize * 2 < lastChunk.length) {
      return hd.concat(lastBytes.copy());
    } else {
      return hd.concat(lastBytes);
    }
  }
}

int _bitsAtOffset(Uint8List bytes, int bitIndex, int length) {
  final i = bitIndex ~/ 8;

  if (i >= bytes.length) {
    return 0;
  } else {
    final off = bitIndex - (i * 8);
    final mask = ((1 << length) - 1) << (8 - length);
    final half = (bytes[i] << off) & mask;

    final int full;

    if (off + length <= 8 || i + 1 >= bytes.length) {
      full = half;
    } else {
      full = half | ((bytes[i + 1] & ((mask << (8 - off)) & 0xff)) >>> (8 - off));
    }

    return full >>> (8 - length);
  }
}

class _BufferState {
  int frontierSize;

  _BufferState(this.frontierSize);
}
