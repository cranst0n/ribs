import 'dart:math';
import 'dart:typed_data';

import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';

abstract class BitVector {
  const BitVector();

  factory BitVector.empty() => _toBytes(ByteVector.empty(), 0);

  factory BitVector.fromByteVector(ByteVector bs) => _toBytes(bs, bs.size * 8);

  factory BitVector.low(int size) =>
      _toBytes(ByteVector.low(_bytesNeededForBits(size)), size);

  factory BitVector.high(int size) =>
      _toBytes(ByteVector.high(_bytesNeededForBits(size)), size);

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

  // Abstract members

  Bytes align();

  BitVector concat(BitVector b2);

  BitVector drop(int n);

  bool get(int n);

  Byte getByte(int n);

  bool get head => get(0);

  int get size;

  bool sizeLessThan(int n);

  BitVector take(int n);

  ByteVector toByteVector();

  //////////////////////

  bool get isEmpty => sizeLessThan(1);

  bool get nonEmpty => !isEmpty;

  bool sizeLessThanOrEqual(int n) => sizeLessThan(n + 1);

  bool sizeGreaterThan(int n) => n < 0 || !sizeLessThanOrEqual(n);

  bool sizeGreaterThanOrEqual(int n) => n < 0 || !sizeLessThanOrEqual(n - 1);

  BitVector dropRight(int n) {
    if (n <= 0) {
      return this;
    } else if (n >= size) {
      return BitVector.empty();
    } else {
      return take(size - n);
    }
  }

  Tuple2<BitVector, BitVector> splitAt(int n) => Tuple2(take(n), drop(n));

  BitVector padTo(int n) => size < n ? concat(BitVector.low(n - size)) : this;

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

  BitVector takeRight(int n) => n >= size ? this : drop(size - n);

  Uint8List toByteArray() => toByteVector().toByteArray();

  int toInt(bool signed, [Endian ordering = Endian.big]) {
    if (this is Bytes) {
      return ordering == Endian.little
          ? invertReverseByteOrder().toInt(signed)
          : getBigEndianInt(0, size, signed);
    } else {
      if (ordering == Endian.little) {
        return invertReverseByteOrder().toInt(signed);
      } else {
        return getBigEndianInt(0, size, signed);
      }
    }
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

  BitVector invertReverseByteOrder() {
    if (size % 8 == 0) {
      return reverseByteOrder();
    } else {
      final validFinalBits = _validBitsInLastByte(size);
      final initAndLast = splitAt(size - validFinalBits);

      return initAndLast.$2
          .concat(initAndLast.$1.toByteVector().reverse().bits);
    }
  }

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

  Either<String, BitVector> aquire(int bits) => Either.cond(
        () => sizeGreaterThanOrEqual(bits),
        () => take(bits),
        () => 'Cannot acquire $bits bits from BitVector of size $size',
      );

  String toBinString() => toByteVector().toBinString().substring(0, size);

  String toHexString() => toByteVector().toHexString();

  @override
  String toString() => toByteVector().toHexString();

  @override
  bool operator ==(Object other) =>
      other is BitVector &&
      other.size == size &&
      other.toByteVector() == toByteVector();

  @override
  int get hashCode => Object.hashAll([size, toByteVector()]);

  ////////////////////
  // Static members //
  ////////////////////

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

  static Bytes _toBytes(ByteVector bs, int sizeInBits) {
    final needed = _bytesNeededForBits(sizeInBits);
    final b = bs.size > needed ? bs.take(needed) : bs;

    return Bytes(b, sizeInBits);
  }
}

class Bytes extends BitVector {
  final ByteVector _underlying;

  @override
  final int size;

  const Bytes(this._underlying, this.size);

  int invalidBits() => 8 - BitVector._validBitsInLastByte(size);

  @override
  Bytes align() => this;

  @override
  bool get(int n) => BitVector._getBit(_underlying.get(n ~/ 8), n % 8);

  @override
  Byte getByte(int n) {
    if (n < _underlying.size - 1) {
      return _underlying.get(n);
    } else {
      final valid = 8 - invalidBits();

      return _underlying.get(n) & BitVector.topNBits(valid);
    }
  }

  @override
  Bytes take(int n) => BitVector._toBytes(_underlying, max(0, min(size, n)));

  @override
  BitVector drop(int n) {
    if (n >= size) {
      return BitVector.empty();
    } else if (n <= 0) {
      return this;
    } else if (n % 8 == 0) {
      return Bytes(_underlying.drop(n ~/ 8), size - n);
    } else {
      return Drop(this, n);
    }
  }

  @override
  bool sizeLessThan(int n) => size < n;

  @override
  BitVector concat(BitVector b2) {
    if (isEmpty) {
      return b2;
    } else if (b2 is Bytes) {
      return combine(b2);
    } else if (b2 is Drop) {
      return concat(b2.interpretDrop());
    } else {
      throw UnsupportedError('BitVector.concat(???)');
    }
  }

  @override
  ByteVector toByteVector() => _underlying;

  Bytes combine(Bytes other) {
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
}

class Drop extends BitVector {
  final Bytes _underlying;
  final int offset;

  const Drop(this._underlying, this.offset);

  @override
  int get size => max(0, _underlying.size - offset);

  @override
  bool sizeLessThan(int n) => size < n;

  @override
  Bytes align() => interpretDrop();

  @override
  bool get(int n) => _underlying.get(n);

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
  BitVector drop(int n) {
    if (n >= size) {
      return BitVector.empty();
    } else if (n <= 0) {
      return this;
    } else {
      final nm = n + offset;
      final d = Drop(_underlying, nm);
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
  ByteVector toByteVector() => interpretDrop().toByteVector();

  @override
  Byte getByte(int n) => drop(n * 8).take(8).align().getByte(0);

  Bytes interpretDrop() {
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
}
