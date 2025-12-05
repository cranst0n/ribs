import 'dart:math';
import 'dart:typed_data';

import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_binary/src/internal/byte_vector.dart';
import 'package:ribs_core/ribs_core.dart';

part 'at.dart';
part 'view.dart';

sealed class ByteVector {
  factory ByteVector(List<int> bytes) =>
      _Chunk(_View(At.array(Uint8List.fromList(bytes)), 0, bytes.length));

  ByteVector._();

  static final ByteVector empty = _Chunk(_View.empty());

  factory ByteVector.low(int size) => ByteVector.fill(size, 0x00);

  factory ByteVector.high(int size) => ByteVector.fill(size, 0xff);

  factory ByteVector.fill(int size, int byte) =>
      _Chunk(_View(At((i) => byte), 0, size));

  factory ByteVector.from(RIterableOnce<int> bs) => ByteVector(bs.toList());

  factory ByteVector.fromDart(Iterable<int> bs) => ByteVector(bs.toList());

  factory ByteVector.of(int byte) => ByteVector.fill(1, byte);

  factory ByteVector.view(Uint8List bytes) => ByteVector(bytes);

  factory ByteVector._viewAt(At at, int size) => _Chunk(_View(at, 0, size));

  factory ByteVector.concatAll(IList<ByteVector> bvs) =>
      bvs.foldLeft(ByteVector.empty, (acc, bv) => acc.concat(bv));

  static Option<ByteVector> fromBin(String s) =>
      fromBinDescriptive(s).toOption();

  static ByteVector fromValidBin(
    String s, [
    BinaryAlphabet alphabet = Alphabets.binary,
  ]) =>
      fromBinDescriptive(s, alphabet)
          .fold((err) => throw ArgumentError(err), identity);

  static Either<String, ByteVector> fromBinDescriptive(
    String str, [
    BinaryAlphabet alphabet = Alphabets.binary,
  ]) =>
      fromBinInternal(str, alphabet).map((a) => a.$1);

  static Option<ByteVector> fromHex(
    String s, [
    HexAlphabet alphabet = Alphabets.hexLower,
  ]) =>
      fromHexDescriptive(s, alphabet).toOption();

  static ByteVector fromValidHex(
    String s, [
    HexAlphabet alphabet = Alphabets.hexLower,
  ]) =>
      fromHexDescriptive(s, alphabet)
          .fold((err) => throw ArgumentError(err), identity);

  static Either<String, ByteVector> fromHexDescriptive(
    String str, [
    HexAlphabet alphabet = Alphabets.hexLower,
  ]) =>
      fromHexInternal(str, alphabet).map((a) => a.$1);

  static Option<ByteVector> fromBase32(
    String s, [
    Base32Alphabet alphabet = Alphabets.base32,
  ]) =>
      fromBase32Descriptive(s, alphabet).toOption();

  static ByteVector fromValidBase32(
    String s, [
    Base32Alphabet alphabet = Alphabets.base32,
  ]) =>
      fromBase32Descriptive(s, alphabet)
          .fold((err) => throw ArgumentError(err), identity);

  static Either<String, ByteVector> fromBase32Descriptive(
    String str, [
    Base32Alphabet alphabet = Alphabets.base32,
  ]) =>
      fromBase32Internal(str, alphabet).map((a) => a.$1);

  static Option<ByteVector> fromBase58(
    String s, [
    Base58Alphabet alphabet = Alphabets.base58,
  ]) =>
      fromBase58Descriptive(s, alphabet).toOption();

  static ByteVector fromValidBase58(
    String s, [
    Base58Alphabet alphabet = Alphabets.base58,
  ]) =>
      fromBase58Descriptive(s, alphabet)
          .fold((err) => throw ArgumentError(err), identity);

  static Either<String, ByteVector> fromBase58Descriptive(
    String str, [
    Base58Alphabet alphabet = Alphabets.base58,
  ]) {
    final zeroLength = str.takeWhile((c) => c == '1').length;
    final zeroes = ByteVector.fill(zeroLength, 0);
    final trim = str.splitAt(zeroLength).$2.split('').toIList();
    final RADIX = BigInt.from(58);

    try {
      final decoded = trim.foldLeft(BigInt.zero, (a, c) {
        try {
          return a * RADIX + BigInt.from(alphabet.toIndex(c));
        } catch (_) {
          final idx = trim.takeWhile((x) => x != c).length;

          throw "Invalid base 58 character '$c' at index $idx";
        }
      });

      if (trim.isEmpty) {
        return zeroes.asRight();
      } else {
        return zeroes
            .concat(ByteVector.fromValidBin(
                decoded.toRadixString(2).dropWhile((c) => c == '0')))
            .asRight();
      }
    } catch (e) {
      return e.toString().asLeft();
    }
  }

  static Option<ByteVector> fromBase64(
    String s, [
    Base64Alphabet alphabet = Alphabets.base64,
  ]) =>
      fromBase64Descriptive(s, alphabet).toOption();

  static ByteVector fromValidBase64(
    String s, [
    Base64Alphabet alphabet = Alphabets.base64,
  ]) =>
      fromBase64Descriptive(s, alphabet)
          .fold((err) => throw ArgumentError(err), identity);

  static Either<String, ByteVector> fromBase64Descriptive(
    String str, [
    Base64Alphabet alphabet = Alphabets.base64,
  ]) =>
      fromBase64Internal(str, alphabet).map((a) => a.$1);

  factory ByteVector.fromInt(
    int i, {
    int size = 4,
    Endian ordering = Endian.big,
  }) =>
      BitVector.fromInt(i, size: size * 8, ordering: ordering).bytes;

  factory ByteVector.fromBigInt(
    BigInt value, {
    Option<int> size = const None<int>(),
    Endian ordering = Endian.big,
  }) =>
      BitVector.fromBigInt(value,
              size: size.map((s) => s * 8), ordering: ordering)
          .bytes;

  ByteVector operator &(ByteVector other) => and(other);

  ByteVector operator ~() => not;

  ByteVector operator |(ByteVector other) => or(other);

  ByteVector operator ^(ByteVector other) => xor(other);

  ByteVector operator <<(int n) => shiftLeft(n);

  ByteVector operator >>(int n) => shiftRight(n, true);

  ByteVector operator >>>(int n) => shiftRight(n, false);

  Either<String, ByteVector> acquire(int bytes) => Either.cond(
        () => size >= bytes,
        () => take(bytes),
        () => 'Cannot acquire $bytes bytes from ByteVector of size $size',
      );

  Either<String, (ByteVector, A)> consume<A>(
    int n,
    Function1<ByteVector, Either<String, A>> decode,
  ) =>
      acquire(n).flatMap(
          (toDecode) => decode(toDecode).map((decoded) => (drop(n), decoded)));

  A foldLeft<A>(A z, Function2<A, int, A> f) {
    var acc = z;
    _foreachS((b) => acc = f(acc, b));
    return acc;
  }

  A foldRight<A>(A init, Function2<int, A, A> f) =>
      reverse.foldLeft(init, (a, b) => f(b, a));

  int get size;

  int get length => size;

  bool get isEmpty => size == 0;

  bool get nonEmpty => !isEmpty;

  int get(int index) => _getImpl(index);

  int _getImpl(int index);

  ByteVector append(int byte) => concat(ByteVector.of(byte));

  ByteVector prepend(int byte) => ByteVector([byte]).concat(this);

  ByteVector patch(int ix, ByteVector b) =>
      take(ix).concat(b).concat(drop(ix + b.size));

  ByteVector splice(int ix, ByteVector b) =>
      take(ix).concat(b).concat(drop(ix));

  ByteVector update(int idx, int b) {
    _checkIndex(idx);
    return take(idx).append(b).concat(drop(idx + 1));
  }

  ByteVector insert(int idx, int b) => take(idx).append(b).concat(drop(idx));

  Option<int> lift(int ix) =>
      Option.when(() => 0 <= ix && ix < size, () => get(ix));

  int get head => get(0);

  Option<int> get headOption => size > 0 ? Some(head) : none();

  void foreach(Function1<int, void> f) => _foreachV((v) => v.foreach(f));

  ByteVector tail() => drop(1);

  ByteVector init() => dropRight(1);

  int get last => get(size - 1);

  Option<int> get lastOption => lift(size - 1);

  ByteVector drop(int n) {
    final n1 = max(min(n, size), 0);

    if (n1 == size) {
      return ByteVector.empty;
    } else if (n1 == 0) {
      return this;
    } else {
      // TODO: tailrec
      ByteVector go(ByteVector cur, int n1, IList<ByteVector> accR) {
        switch (cur) {
          case _Chunk(bytes: final bs):
            return accR.foldLeft(
                _Chunk(bs.drop(n1)), (a, b) => a.concat(b).unbuffer());
          case _Append(left: final l, right: final r):
            return n1 > l.size
                ? go(r, n1 - l.size, accR)
                : go(l, n1, accR.prepended(r));
          case final _Buffer b:
            return n1 > b.hd.size
                ? go(b.lastBytes, n1 - b.hd.size, accR)
                : go(b.hd, n1, accR.prepended(b.lastBytes));
          case final _Chunks c:
            return go(c.chunks, n1, accR);
        }
      }

      return go(this, n1, nil());
    }
  }

  ByteVector dropRight(int n) => take(size - max(0, n));

  ByteVector dropWhile(Function1<int, bool> p) {
    var toDrop = 0;
    _foreachSPartial((i) {
      final cont = p(i);
      if (cont) toDrop += 1;
      return cont;
    });

    return drop(toDrop);
  }

  ByteVector take(int n) {
    final n1 = max(min(n, size), 0);

    if (n1 == size) {
      return this;
    } else if (n1 == 0) {
      return ByteVector.empty;
    } else {
      // TODO: tailrec
      ByteVector go(ByteVector accL, ByteVector cur, int n1) {
        switch (cur) {
          case _Chunk(bytes: final bs):
            return accL.concat(_Chunk(bs.take(n1)));
          case _Append(left: final l, right: final r):
            if (n1 > l.size) {
              return go(accL.concat(l), r, n1 - l.size);
            } else {
              return go(accL, l, n1);
            }
          case final _Chunks c:
            return go(accL, c.chunks, n1);
          case final _Buffer b:
            return go(accL, b.unbuffer(), n1);
        }
      }

      return go(ByteVector.empty, this, n1);
    }
  }

  ByteVector takeRight(int n) => drop(size - n);

  ByteVector takeWhile(Function1<int, bool> p) {
    var toTake = 0;
    _foreachSPartial((i) {
      final cont = p(i);
      if (cont) toTake += 1;
      return cont;
    });

    return take(toTake);
  }

  (ByteVector, ByteVector) splitAt(int ix) => (take(ix), drop(ix));

  ByteVector slice(int from, int until) =>
      drop(from).take(until - max(0, from));

  RIterator<ByteVector> sliding(int n, [int step = 1]) {
    assert(n > 0 && step > 0, "both n and step must be positive");

    RIterator<int> limit(RIterator<int> itr) =>
        step < n ? itr.take((size - n) + 1) : itr.takeWhile((i) => i < size);

    return limit(RIterator.iterate(0, (x) => x + step))
        .map((idx) => slice(idx, idx + n));
  }

  ByteVector concat(ByteVector other) {
    if (isEmpty) {
      return other;
    } else if (other.isEmpty) {
      return this;
    } else {
      return _Chunks(_Append(this, other)).bufferBy(64);
    }
  }

  ByteVector zipWithI(ByteVector other, Function2<int, int, int> op) =>
      zipWith(other, (l, r) => op(l, r));

  ByteVector compact() {
    return switch (this) {
      final _Chunk _ => this,
      _ => copy(),
    };
  }

  ByteVector copy() {
    final sz = size;
    final arr = toByteArray();
    return _Chunk(_View(At.array(arr), 0, sz));
  }

  ByteVector get reverse =>
      ByteVector._viewAt(At((i) => get(size - i - 1)), size);

  ByteVector get not => _mapS((b) => ~b);

  ByteVector or(ByteVector other) => _zipWithS(other, (b, b2) => b | b2);

  ByteVector and(ByteVector other) => _zipWithS(other, (b, b2) => b & b2);

  ByteVector xor(ByteVector other) => _zipWithS(other, (b, b2) => b ^ b2);

  ByteVector shiftLeft(int n) => bits.shiftLeft(n).bytes;

  ByteVector shiftRight(int n, bool signExtension) =>
      bits.shiftRight(n, signExtension).bytes;

  ByteVector rotateLeft(int n) => bits.rotateLeft(n).bytes;

  ByteVector rotateRight(int n) => bits.rotateRight(n).bytes;

  ByteVector map(Function1<int, int> f) =>
      ByteVector._viewAt(At((i) => f(get(i))), size);

  bool startsWith(ByteVector b) => take(b.size) == b;

  bool endsWith(ByteVector b) => takeRight(b.size) == b;

  Option<int> indexOfSlice(ByteVector slice, [int from = 0]) {
    var b = this;
    var idx = from;

    while (true) {
      if (b.startsWith(slice)) {
        return Some(idx);
      } else if (b.isEmpty) {
        return none();
      } else {
        b = b.tail();
        idx += 1;
      }
    }
  }

  bool containsSlice(ByteVector slice) => indexOfSlice(slice).isDefined;

  RIterator<ByteVector> grouped(int chunkSize) {
    if (isEmpty) {
      return RIterator.empty();
    } else if (size <= chunkSize) {
      return RIterator.single(this);
    } else {
      return RIterator.single(take(chunkSize))
          .concat(drop(chunkSize).grouped(chunkSize));
    }
  }

  ByteVector padLeft(int n) {
    if (n < size) {
      throw ArgumentError('ByteVector.padLeft($n)');
    } else {
      return ByteVector.low(n - size).concat(this);
    }
  }

  ByteVector padRight(int n) {
    if (n < size) {
      throw ArgumentError('ByteVector.padRight($n)');
    } else {
      return concat(ByteVector.low(n - size));
    }
  }

  ByteVector padTo(int n) => padRight(n);

  ByteVector zipWith(ByteVector other, Function2<int, int, int> f) =>
      _zipWithS(other, f);

  ByteVector bufferBy([int chunkSize = 1024]) {
    switch (this) {
      case final _Buffer b:
        if (b.lastChunk.length >= chunkSize) {
          return b;
        } else {
          return b.rebuffer(chunkSize);
        }
      default:
        return _Buffer(this, Uint8List(chunkSize), 0);
    }
  }

  ByteVector unbuffer() => this;

  Uint8List toByteArray() {
    final buf = Uint8List(size);
    copyToArray(buf, 0);
    return buf;
  }

  IList<int> toIList() => IList.fromDart(toByteArray());

  BitVector get bits => toBitVector();

  BitVector toBitVector() => BitVector.fromByteVector(this);

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

  String toHexDump() => HexDumpFormat.NoAnsi.renderBytes(this);

  String toHexDumpColorized() => HexDumpFormat.Default.renderBytes(this);

  void printHexDump() => HexDumpFormat.Default.printBytes(this);

  String toBase16([HexAlphabet alphabet = Alphabets.hexLower]) =>
      toHex(alphabet);

  void copyToArray(Uint8List xs, int start) {
    var i = start;

    _foreachV((v) {
      v.copyToArray(xs, i);
      i += v.size;
    });
  }

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
          (((bytes.length + bitsPerChar - 1) ~/ bitsPerChar * bitsPerChar) -
                  bytes.length) *
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

  String toBase64([Base64Alphabet alphabet = Alphabets.base64]) {
    final bytes = toByteArray();
    final bldr = StringBuffer();

    var idx = 0;
    final mod = bytes.length % 3;

    while (idx < bytes.length - mod) {
      var buffer = ((bytes[idx] & 0x0ff) << 16) |
          ((bytes[idx + 1] & 0x0ff) << 8) |
          (bytes[idx + 2] & 0x0ff);

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
      var buffer =
          ((bytes[idx] & 0x0ff) << 10) | ((bytes[idx + 1] & 0x0ff) << 2);
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

  String toBase64NoPad() => toBase64(Alphabets.base64NoPad);

  String toBase64Url() => toBase64(Alphabets.base64Url);

  String toBase64UrlNoPad() => toBase64(Alphabets.base64UrlNoPad);

  int toInt({Endian ordering = Endian.big}) => bits.toInt(ordering: ordering);

  int toUnsignedInt({Endian ordering = Endian.big}) =>
      bits.toInt(signed: false, ordering: ordering);

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
        bytes = bytes.drop(chunkSize);
        h = MurmurHash3.mix(h, MurmurHash3.bytesHash(bytes.toByteArray()));
        iter += 1;
      }
    }
  }

  ByteVector _mapS(Function1<int, int> f) =>
      ByteVector._viewAt(At((i) => f(get(i))), size);

  ByteVector _zipWithS(ByteVector other, Function2<int, int, int> f) {
    return _Chunk(_View(
      At((i) => f(get(i), other.get(i))),
      0,
      min(size, other.size),
    ));
  }

  void _foreachS(Function1<int, void> f) => _foreachV((v) => v.foreach(f));

  void _foreachSPartial(Function1<int, bool> f) =>
      _foreachVPartial((v) => v.foreachPartial(f));

  void _foreachV(Function1<_View, void> f) {
    void go(IList<ByteVector> rem) {
      if (!rem.isEmpty) {
        switch (rem.head) {
          case _Chunk(bytes: final bs):
            f(bs);
            go(rem.tail());
          case _Append(left: final l, right: final r):
            go(rem.tail().prepended(r).prepended(l));
          case final _Buffer b:
            go(rem.tail().prepended(b.unbuffer()));
          case final _Chunks c:
            go(rem.tail().prepended(c.chunks.right).prepended(c.chunks.left));
        }
      }
    }

    return go(ilist([this]));
  }

  bool _foreachVPartial(Function1<_View, bool> f) {
    bool go(IList<ByteVector> rem) {
      if (!rem.isEmpty) {
        switch (rem.head) {
          case _Chunk(bytes: final bs):
            return f(bs) && go(rem.tail());
          case _Append(left: final l, right: final r):
            return go(rem.tail().prepended(r).prepended(l));
          case final _Buffer b:
            return go(rem.tail().prepended(b.unbuffer()));
          case final _Chunks c:
            return go(
              rem.tail().prepended(c.chunks.right).prepended(c.chunks.left),
            );
        }
      } else {
        return true;
      }
    }

    return go(ilist([this]));
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
      // TODO: tailrec
      ByteVector go(_Append chunks, ByteVector last) {
        final lastN = last.size;

        if (lastN >= chunks.size || lastN * 2 <= chunks.right.size) {
          return _Chunks(_Append(chunks, last));
        } else {
          switch (chunks.left) {
            case final _Append left:
              return go(left, _Append(chunks.right, last));
            default:
              return _Chunks(_Append(chunks, last));
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

  _Buffer(this.hd, this.lastChunk, this.lastSize) : super._();

  @override
  int _getImpl(int index) =>
      index < hd.size ? hd._getImpl(index) : lastChunk[index - hd.size] & 0xff;

  @override
  int get size => hd.size + lastSize;

  @override
  ByteVector take(int n) =>
      n <= hd.size ? hd.take(n) : hd.concat(lastBytes.take(n - hd.size));

  @override
  ByteVector drop(int n) => n <= hd.size
      ? _Buffer(hd.drop(n), lastChunk, lastSize)
      : unbuffer().drop(n).bufferBy(lastChunk.length);

  @override
  ByteVector append(int byte) {
    if (lastSize < lastChunk.length) {
      lastChunk[lastSize] = byte;
      return _Buffer(hd, lastChunk, lastSize + 1);
    } else {
      return _Buffer(unbuffer(), Uint8List(lastChunk.length), 0).append(byte);
    }
  }

  @override
  ByteVector concat(ByteVector other) {
    if (other.isEmpty) {
      return this;
    } else if (isEmpty) {
      return other;
    } else {
      if (lastChunk.length - lastSize > other.size) {
        other.copyToArray(lastChunk, lastSize);
        return _Buffer(hd, lastChunk, lastSize + other.size);
      } else if (lastSize == 0) {
        return _Buffer(hd.concat(other).unbuffer(), lastChunk, lastSize);
      } else {
        return _Buffer(unbuffer(), Uint8List(lastChunk.length), 0)
            .concat(other);
      }
    }
  }

  ByteVector get lastBytes => ByteVector(lastChunk).take(lastSize);

  @override
  ByteVector unbuffer() {
    if (lastSize * 2 < lastChunk.length) {
      return hd.concat(lastBytes.copy());
    } else {
      return hd.concat(lastBytes);
    }
  }

  ByteVector rebuffer(int chunkSize) {
    assert(chunkSize > lastChunk.length);

    final lastChunk2 = Uint8List(chunkSize);
    lastChunk2.setRange(0, lastChunk.length, lastChunk);

    // TODO: scala implementation has bug?
    return _Buffer(hd, lastChunk2, lastSize);
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
      full =
          half | ((bytes[i + 1] & ((mask << (8 - off)) & 0xff)) >>> (8 - off));
    }

    return full >>> (8 - length);
  }
}
