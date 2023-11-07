import 'dart:math';
import 'dart:typed_data';

import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_binary/src/internal/byte_vector.dart';
import 'package:ribs_core/ribs_core.dart';

sealed class BitVector {
  const BitVector();

  factory BitVector.bit(bool high) => high ? one : zero;

  factory BitVector.bits(Iterable<bool> b) => IList.of(b)
      .zipWithIndex()
      .foldLeft(BitVector.low(b.length), (acc, b) => acc.update(b.$2, b.$1));

  factory BitVector.empty() => _toBytes(ByteVector.empty(), 0);

  factory BitVector.fill(int n, bool high) {
    final needed = _bytesNeededForBits(n);
    final bs = ByteVector.fill(needed, high ? -1 : 0);

    return _toBytes(bs, n);
  }

  factory BitVector.fromByteVector(ByteVector bs) => _toBytes(bs, bs.size * 8);

  static BitVector fromValidBinString(String s) => fromBinString(s).fold(
        (err) => throw Exception('Illegal binary string: $s ($err)'),
        id,
      );

  static Either<String, BitVector> fromBinString(String s) {
    return fromBinInternal(s).mapN((bytes, size) {
      final toDrop = switch (size) {
        0 => 0,
        _ when size % 8 == 0 => 0,
        _ => 8 - (size % 8),
      };

      return bytes.bits.drop(toDrop);
    });
  }

  factory BitVector.fromInt(
    int i, [
    int size = 64,
    Endian ordering = Endian.big,
  ]) {
    final bytes = Uint8List(8)..buffer.asByteData().setInt64(0, i);
    final relevantBits = ByteVector(bytes).bits.shiftLeft(64 - size).take(size);

    return ordering == Endian.big
        ? relevantBits
        : relevantBits.reverseByteOrder();
  }

  factory BitVector.high(int size) =>
      _toBytes(ByteVector.high(_bytesNeededForBits(size)), size);

  factory BitVector.low(int size) =>
      _toBytes(ByteVector.low(_bytesNeededForBits(size)), size);

  static final zero = _toBytes(ByteVector.fromList([0x00]), 1);

  static final one = _toBytes(ByteVector.fromList([0xff]), 1);

  static final lowByte = _toBytes(ByteVector.low(1), 8);

  static final highByte = _toBytes(ByteVector.high(1), 8);

  _Bytes align();

  bool call(int n) => get(n);

  BitVector concat(BitVector b2);

  bool containsSlice(BitVector slice) => indexOfSlice(slice).isDefined;

  BitVector drop(int n);

  bool get(int n);

  Byte getByte(int n);

  bool get head => get(0);

  int get size;

  bool sizeLessThan(int n);

  BitVector take(int n);

  ByteVector toByteVector();

  BitVector update(int n, bool high);

  BitVector append(bool bit) => concat(BitVector.bit(bit));

  Either<String, BitVector> acquire(int bits) => Either.cond(
        () => sizeGreaterThanOrEqual(bits),
        () => take(bits),
        () => 'Cannot acquire $bits bits from BitVector of size $size',
      );

  BitVector clear(int n) => update(n, false);

  BitVector dropRight(int n) {
    if (n <= 0) {
      return this;
    } else if (n >= size) {
      return BitVector.empty();
    } else {
      return take(size - n);
    }
  }

  BitVector dropWhile(Function1<bool, bool> f) {
    int toDrop(BitVector b, int ix) =>
        b.nonEmpty && f(b.head) ? toDrop(b.tail(), ix + 1) : ix;

    return drop(toDrop(this, 0));
  }

  bool endsWith(BitVector b) => takeRight(b.size) == b;

  int getBigEndianInt(int start, int bits, bool signed) {
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

  Option<bool> get headOption => lift(0);

  Option<int> indexOfSlice(BitVector slice, [int from = 0]) {
    Option<int> go(BitVector b, int ix) {
      if (b.isEmpty) {
        return none();
      } else if (b.startsWith(slice)) {
        return Some(ix);
      } else {
        return go(b.tail(), ix + 1);
      }
    }

    return go(drop(from), 0);
  }

  BitVector init() => dropRight(1);

  bool get last => call(size - 1);

  Option<bool> get lastOption => lift(size - 1);

  BitVector invertReverseByteOrder() {
    if (size % 8 == 0) {
      return reverseByteOrder();
    } else {
      final validFinalBits = _validBitsInLastByte(size);
      final (init, last) = splitAt(size - validFinalBits);

      return last.concat(init.toByteVector().reverse().bits);
    }
  }

  bool get isEmpty => sizeLessThan(1);

  Option<bool> lift(int n) =>
      Option.when(() => sizeGreaterThan(n), () => get(n));

  bool get nonEmpty => !isEmpty;

  BitVector splice(int ix, BitVector b) => take(ix).concat(b).concat(drop(ix));

  BitVector padLeft(int n) =>
      size < n ? BitVector.low(n - size).concat(this) : this;

  BitVector padRight(int n) =>
      size < n ? concat(BitVector.low(n - size)) : this;

  BitVector padTo(int n) => padRight(n);

  BitVector patch(int ix, BitVector b) =>
      take(ix).concat(b).concat(drop(ix + b.size));

  BitVector prepend(bool bit) => BitVector.bit(bit).concat(this);

  int populationCount() {
    var count = 0;
    var ix = 0;

    while (ix < size) {
      if (get(ix)) count++;
      ix++;
    }

    return count;
  }

  BitVector reverseByteOrder() {
    if (size % 8 == 0) {
      return BitVector.fromByteVector(toByteVector().reverse());
    } else {
      final validFinalBits = _validBitsInLastByte(size);
      final last = take(validFinalBits);
      final b = drop(validFinalBits).toByteVector().reverse();
      final init = _toBytes(b, size - last.size);

      return init.concat(last);
    }
  }

  BitVector rotateLeft(int n) {
    if (n <= 0 || isEmpty) {
      return this;
    } else {
      final n0 = n % size;
      return n0 == 0 ? this : drop(n0).concat(take(n0));
    }
  }

  BitVector rotateRight(int n) {
    if (n <= 0 || isEmpty) {
      return this;
    } else {
      final n0 = n % size;
      return n0 == 0 ? this : takeRight(n0).concat(dropRight(n0));
    }
  }

  BitVector set(int n) => update(n, true);

  bool sizeLessThanOrEqual(int n) => sizeLessThan(n + 1);

  bool sizeGreaterThan(int n) => n < 0 || !sizeLessThanOrEqual(n);

  bool sizeGreaterThanOrEqual(int n) => n < 0 || !sizeLessThanOrEqual(n - 1);

  BitVector shiftLeft(int n) {
    if (n <= 0) {
      return this;
    } else if (n >= size) {
      return BitVector.low(size);
    } else {
      return drop(n).concat(BitVector.low(n));
    }
  }

  BitVector shiftRight(int n, bool signExtension) {
    if (isEmpty || n <= 0) {
      return this;
    } else {
      final extensionHigh = signExtension && get(0);

      if (n >= size) {
        return extensionHigh ? BitVector.high(size) : BitVector.low(size);
      } else {
        return (extensionHigh ? BitVector.high(n) : BitVector.low(n))
            .concat(dropRight(n));
      }
    }
  }

  BitVector slice(int from, int until) => drop(from).take(until - max(from, 0));

  (BitVector, BitVector) splitAt(int n) => (take(n), drop(n));

  bool startsWith(BitVector b) => take(b.size) == b;

  BitVector tail() => drop(1);

  BitVector takeRight(int n) => n >= size ? this : drop(size - n);

  Uint8List toByteArray() => toByteVector().toByteArray();

  int toInt(bool signed, [Endian ordering = Endian.big]) => switch (this) {
        final _Bytes _ => ordering == Endian.little
            ? invertReverseByteOrder().toInt(signed)
            : getBigEndianInt(0, size, signed),
        _ => ordering == Endian.little
            ? invertReverseByteOrder().toInt(signed)
            : getBigEndianInt(0, size, signed),
      };

  String toBinString() => toByteVector().toBinString().substring(0, size);

  String toHexString() => toByteVector().toHexString();

  @override
  String toString() => toByteVector().toHexString();

  @override
  bool operator ==(Object other) {
    if (other is! BitVector) {
      return false;
    } else if (other.size != size) {
      return false;
    } else {
      const chunkSize = 8 * 1024 * 64;

      bool go(BitVector x, BitVector y) {
        if (x.isEmpty) {
          return y.isEmpty;
        } else {
          final chunkX = x.take(chunkSize);
          final chunkY = y.take(chunkSize);

          return chunkX.toByteVector() == chunkY.toByteVector() &&
              go(x.drop(chunkSize), y.drop(chunkSize));
        }
      }

      return go(this, other);
    }
  }

  @override
  int get hashCode => Object.hash(size, toByteVector());

  static int topNBits(int n) => -1 << (8 - n);

  static int _validBitsInLastByte(int size) {
    final mod = size % 8;
    return mod == 0 ? 8 : mod;
  }

  static int _bytesNeededForBits(int size) => (size + 7) ~/ 8;

  static ByteVector _clearUnneededBits(int size, ByteVector bytes) {
    final valid = _validBitsInLastByte(size);

    if (bytes.nonEmpty && valid < 8) {
      final idx = bytes.size - 1;
      final last = bytes.get(idx);

      return bytes.update(idx, last & topNBits(valid));
    } else {
      return bytes;
    }
  }

  static bool _getBit(Byte byte, int n) => ((0x00000080 >> n) & byte) != 0;

  static int _setBit(int byte, int n, bool high) =>
      high ? (0x00000080 >> n) | byte : (~(0x00000080 >> n)) & byte;

  static _Bytes _toBytes(ByteVector bs, int sizeInBits) {
    final needed = _bytesNeededForBits(sizeInBits);
    final b = bs.size > needed ? bs.take(needed) : bs;

    return _Bytes(b, sizeInBits);
  }
}

final class _Bytes extends BitVector {
  final ByteVector _underlying;

  @override
  final int size;

  const _Bytes(this._underlying, this.size);

  @override
  _Bytes align() => this;

  _Bytes combine(_Bytes other) {
    final nInvalidBits = invalidBits();

    if (isEmpty) {
      return other;
    } else if (other.isEmpty) {
      return this;
    } else if (nInvalidBits == 0) {
      return BitVector._toBytes(
          _underlying.concat(other._underlying), size + other.size);
    } else {
      final bytesCleared = BitVector._clearUnneededBits(size, _underlying);

      final hi = bytesCleared.get(bytesCleared.size - 1);
      final lo = ((other._underlying.head & BitVector.topNBits(nInvalidBits)) &
              0x000000ff) >>>
          BitVector._validBitsInLastByte(size);

      final updatedOurBytes =
          bytesCleared.update(bytesCleared.size - 1, hi | lo);
      final updatedOtherBytes = other.drop(nInvalidBits).toByteVector();

      return BitVector._toBytes(
          updatedOurBytes.concat(updatedOtherBytes), size + other.size);
    }
  }

  @override
  BitVector concat(BitVector b2) {
    if (isEmpty) {
      return b2;
    } else {
      return switch (b2) {
        final _Bytes _ => combine(b2),
        final _Drop drop => concat(drop.interpretDrop()),
      };
    }
  }

  @override
  BitVector drop(int n) {
    if (n >= size) {
      return BitVector.empty();
    } else if (n <= 0) {
      return this;
    } else if (n % 8 == 0) {
      return _Bytes(_underlying.drop(n ~/ 8), size - n);
    } else {
      return _Drop(this, n);
    }
  }

  @override
  bool get(int n) {
    checkBounds(n);
    return BitVector._getBit(_underlying.get(n ~/ 8), n % 8);
  }

  @override
  Byte getByte(int n) {
    if (n < _underlying.size - 1) {
      return _underlying.get(n);
    } else {
      final valid = 8 - invalidBits();

      return _underlying.get(n) & BitVector.topNBits(valid);
    }
  }

  int invalidBits() => 8 - BitVector._validBitsInLastByte(size);

  @override
  bool sizeLessThan(int n) => size < n;

  @override
  _Bytes take(int n) => BitVector._toBytes(_underlying, max(0, min(size, n)));

  @override
  ByteVector toByteVector() => BitVector._clearUnneededBits(size, _underlying);

  @override
  _Bytes update(int n, bool high) {
    checkBounds(n);

    final b2 = _underlying.update(
        n ~/ 8,
        _underlying
            .lift(n ~/ 8)
            .map((a) => BitVector._setBit(a, n % 8, high))
            .getOrElse(() => outOfBounds(n)));

    return _Bytes(b2, size);
  }

  void checkBounds(int n) {
    if (!sizeGreaterThan(n)) outOfBounds(n);
  }

  Never outOfBounds(int n) => throw RangeError('invalid index: $n of $size');
}

final class _Drop extends BitVector {
  final _Bytes _underlying;
  final int offset;

  const _Drop(this._underlying, this.offset);

  @override
  _Bytes align() => interpretDrop();

  @override
  bool get(int n) => _underlying.get(offset + n);

  @override
  BitVector drop(int n) {
    if (n >= size) {
      return BitVector.empty();
    } else if (n <= 0) {
      return this;
    } else {
      final nm = n + offset;
      final d = _Drop(_underlying, nm);
      return nm > 32768 && nm & 8 == 0 ? d.interpretDrop() : d;
    }
  }

  @override
  BitVector concat(BitVector b2) {
    if (isEmpty) {
      return b2;
    } else {
      return interpretDrop().concat(b2);
    }
  }

  @override
  Byte getByte(int n) => drop(n * 8).take(8).align().getByte(0);

  _Bytes interpretDrop() {
    final low = max(0, offset);
    final newSize = size;

    if (newSize == 0) {
      return BitVector.empty().align();
    } else {
      final lowByte = low ~/ 8;
      final shiftedWholeBytes = _underlying._underlying
          .slice(lowByte, lowByte + BitVector._bytesNeededForBits(newSize) + 1);

      final bitsToShiftEachByte = low % 8;

      var newBytes = shiftedWholeBytes;

      if (bitsToShiftEachByte != 0) {
        final a = shiftedWholeBytes;
        final b = shiftedWholeBytes.drop(1).append(0);

        final result = List<Byte>.empty(growable: true);

        final aIt = a.toByteArray().iterator;
        final bIt = b.toByteArray().iterator;

        while (aIt.moveNext() && bIt.moveNext()) {
          final hi = aIt.current << bitsToShiftEachByte;
          final low = ((bIt.current & BitVector.topNBits(bitsToShiftEachByte)) &
                  0x000000ff) >>>
              (8 - bitsToShiftEachByte);

          result.add(hi | low);
        }

        newBytes = ByteVector.fromList(result);
      }

      if (newSize <= (newBytes.size - 1) * 8) {
        return BitVector._toBytes(newBytes.dropRight(1), newSize);
      } else {
        return BitVector._toBytes(newBytes, newSize);
      }
    }
  }

  @override
  int get size => max(0, _underlying.size - offset);

  @override
  bool sizeLessThan(int n) => size < n;

  @override
  BitVector take(int n) {
    if (n >= size) {
      return this;
    } else if (n <= 0) {
      return BitVector.empty();
    } else {
      return _underlying.take(offset + n).drop(offset);
    }
  }

  @override
  ByteVector toByteVector() => interpretDrop().toByteVector();

  @override
  BitVector update(int n, bool high) =>
      _Drop(_underlying.update(offset + n, high), offset);
}
