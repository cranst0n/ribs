import 'dart:math';
import 'dart:typed_data';

import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_binary/src/internal/byte_vector.dart';
import 'package:ribs_core/ribs_core.dart';

typedef Byte = int;

final class ByteVector {
  final Uint8List _underlying;

  const ByteVector(this._underlying);

  factory ByteVector.empty() => ByteVector(Uint8List(0));

  factory ByteVector.low(int size) => ByteVector(Uint8List(size));

  factory ByteVector.high(int size) => ByteVector.fill(size, 0xff);

  factory ByteVector.fill(int size, int byte) =>
      ByteVector(Uint8List.fromList(List.filled(size, byte)));

  static ByteVector concatAll(IList<ByteVector> bvs) =>
      bvs.foldLeft(ByteVector.empty(), (acc, bv) => acc.concat(bv));

  static Option<ByteVector> fromBin(String s) =>
      fromBinDescriptive(s).toOption();

  static ByteVector fromValidBin(
    String s, [
    BinaryAlphabet alphabet = Alphabets.binary,
  ]) =>
      fromBinDescriptive(s, alphabet)
          .fold((err) => throw ArgumentError(err), id);

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
          .fold((err) => throw ArgumentError(err), id);

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
          .fold((err) => throw ArgumentError(err), id);

  static Either<String, ByteVector> fromBase32Descriptive(
    String str, [
    Base32Alphabet alphabet = Alphabets.base32,
  ]) =>
      fromBase32Internal(str, alphabet).map((a) => a.$1);

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
          .fold((err) => throw ArgumentError(err), id);

  static Either<String, ByteVector> fromBase64Descriptive(
    String str, [
    Base64Alphabet alphabet = Alphabets.base64,
  ]) =>
      fromBase64Internal(str, alphabet).map((a) => a.$1);

  factory ByteVector.fromInt(
    int i, [
    int size = 4,
    Endian ordering = Endian.big,
  ]) =>
      BitVector.fromInt(i, size * 8, ordering).bytes();

  factory ByteVector.fromList(List<Byte> ints) =>
      ByteVector(Uint8List.fromList(ints));

  ByteVector operator &(ByteVector other) => and(other);

  ByteVector operator ~() => not;

  ByteVector operator |(ByteVector other) => or(other);

  ByteVector operator ^(ByteVector other) => xor(other);

  Either<String, ByteVector> acquire(int bytes) => Either.cond(
        () => size >= bytes,
        () => take(bytes),
        () => 'Cannot acquire $bytes bytes from ByteVector of size $size',
      );

  ByteVector and(ByteVector other) => zipWith(other, (a, b) => a & b);

  ByteVector append(Byte byte) => concat(ByteVector.fromList([byte]));

  BitVector get bits => BitVector.fromByteVector(this);

  Byte call(int n) => get(n);

  ByteVector concat(ByteVector other) => ByteVector.fromList(
      _underlying.toList()..addAll(other._underlying.toList()));

  bool containsSlice(ByteVector slice) => indexOfSlice(slice).isDefined;

  ByteVector drop(int n) => ByteVector(
      Uint8List.sublistView(_underlying, min(n, _underlying.length)));

  ByteVector dropRight(int n) => take(size - max(0, n));

  ByteVector dropWhile(Function1<Byte, bool> f) {
    int toDrop(ByteVector b, int ix) =>
        b.nonEmpty && f(b.head) ? toDrop(b.tail(), ix + 1) : ix;

    return drop(toDrop(this, 0));
  }

  bool endsWith(ByteVector b) => takeRight(b.size) == b;

  Byte get(int n) => _underlying[n];

  IList<ByteVector> grouped(int chunkSize) {
    if (isEmpty) {
      return nil();
    } else if (size <= chunkSize) {
      return IList.of([this]);
    } else {
      return IList.of([take(chunkSize)])
          .concat(drop(chunkSize).grouped(chunkSize));
    }
  }

  A foldLeft<A>(A init, Function2<A, Byte, A> f) {
    var acc = init;

    for (final b in _underlying) {
      acc = f(acc, b);
    }

    return acc;
  }

  A foldRight<A>(A init, Function2<Byte, A, A> f) =>
      reverse().foldLeft(init, (a, b) => f(b, a));

  void forEach(Function1<int, void> f) => _underlying.forEach(f);

  Byte get head => _underlying[0];

  Option<Byte> get headOption => size > 0 ? Some(head) : none();

  Option<int> indexOfSlice(ByteVector slice, [int from = 0]) {
    Option<int> go(ByteVector b, int ix) {
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

  ByteVector init() => dropRight(1);

  ByteVector insert(int ix, Byte byte) =>
      take(ix).append(byte).concat(drop(ix));

  bool get isEmpty => _underlying.isEmpty;

  bool get isNotEmpty => !isEmpty;

  Byte get last => _underlying.last;

  Option<Byte> get lastOption => nonEmpty ? Some(last) : none();

  Option<Byte> lift(int ix) => 0 <= ix && ix < size ? Some(get(ix)) : none();

  ByteVector map(Function1<Byte, Byte> f) =>
      ByteVector.fromList(_underlying.map(f).toList());

  bool get nonEmpty => !isEmpty;

  ByteVector get not => map((b) => ~b);

  ByteVector or(ByteVector other) => zipWith(other, (a, b) => a | b);

  ByteVector padLeft(int n) =>
      size >= n ? this : ByteVector.low(n - size).concat(this);

  ByteVector padRight(int n) =>
      size >= n ? this : concat(ByteVector.low(n - size));

  ByteVector padTo(int n) => padRight(n);

  ByteVector patch(int ix, ByteVector b) =>
      take(ix).concat(b).concat(drop(ix + b.size));

  ByteVector prepend(Byte byte) => ByteVector.fromList([byte]).concat(this);

  ByteVector reverse() => ByteVector.fromList(_underlying.reversed.toList());

  ByteVector rotateLeft(int n) => bits.rotateLeft(n).bytes();

  ByteVector rotateRight(int n) => bits.rotateRight(n).bytes();

  ByteVector shiftLeft(int n) => bits.shiftLeft(n).bytes();

  ByteVector shiftRight(int n, bool signExtension) =>
      bits.shiftRight(n, signExtension).bytes();

  int get size => _underlying.length;

  ByteVector slice(int from, int until) =>
      drop(from).take(until - max(0, from));

  ByteVector splice(int ix, ByteVector b) =>
      take(ix).concat(b).concat(drop(ix));

  (ByteVector, ByteVector) splitAt(int ix) => (take(ix), drop(ix));

  bool startsWith(ByteVector b) => take(b.size) == b;

  ByteVector tail() => drop(1);

  ByteVector take(int n) => ByteVector(Uint8List.sublistView(
      _underlying, 0, max(0, min(n, _underlying.length))));

  ByteVector takeRight(int n) => drop(size - n);

  ByteVector takeWhile(Function1<Byte, bool> f) {
    int toTake(ByteVector b, int ix) =>
        b.isEmpty || !f(b.head) ? ix : toTake(b.tail(), ix + 1);

    return take(toTake(this, 0));
  }

  BitVector toBitVector() => BitVector.fromByteVector(this);

  Uint8List toByteArray() => _underlying;

  ByteVector update(int n, Byte byte) =>
      take(n).append(byte).concat(drop(n + 1));

  String toBin([BinaryAlphabet alphabet = Alphabets.binary]) {
    final bldr = StringBuffer();

    forEach((b) {
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

    forEach((b) {
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

  int toInt([Endian ordering = Endian.big]) => bits.toInt(true, ordering);

  int toUnsignedInt([Endian ordering = Endian.big]) =>
      bits.toInt(false, ordering);

  ByteVector xor(ByteVector other) => zipWith(other, (a, b) => a ^ b);

  ByteVector zipWith(ByteVector other, Function2<Byte, Byte, Byte> f) {
    final aIt = toByteArray().iterator;
    final bIt = other.toByteArray().iterator;

    final result = List<Byte>.empty(growable: true);

    while (aIt.moveNext() && bIt.moveNext()) {
      result.add(f(aIt.current, bIt.current));
    }

    return ByteVector.fromList(result);
  }

  @override
  String toString() =>
      toHex(); // TODO: Only show first n bytes if vector is very long

  @override
  bool operator ==(Object other) {
    if (other is ByteVector) {
      if (identical(_underlying, other._underlying)) {
        return true;
      }

      if (_underlying.length != other._underlying.length) {
        return false;
      }

      for (var i = 0; i < _underlying.length; i++) {
        if (_underlying[i] != other._underlying[i]) {
          return false;
        }
      }

      return true;
    }

    return false;
  }

  @override
  int get hashCode => Object.hashAll([size, Object.hashAll(_underlying)]);

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
        full = half |
            ((bytes[i + 1] & ((mask << (8 - off)) & 0xff)) >>> (8 - off));
      }

      return full >>> (8 - length);
    }
  }
}
