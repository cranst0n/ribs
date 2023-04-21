import 'dart:math';
import 'dart:typed_data';

import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';

typedef Byte = int;

final class ByteVector {
  final Uint8List _underlying;

  const ByteVector(this._underlying);

  factory ByteVector.empty() => ByteVector(Uint8List(0));

  factory ByteVector.low(int size) => ByteVector(Uint8List(size));

  factory ByteVector.high(int size) =>
      ByteVector(Uint8List.fromList(List.filled(size, 0xff)));

  static ByteVector fromValidBin(String s) =>
      fromBin(s).getOrElse(() => throw Exception('Illegal binary string: $s'));

  static Either<String, ByteVector> fromBin(String s) {
    Either<String, List<Byte>> takeParse(String s, List<Byte> acc) {
      if (s.isNotEmpty) {
        final next = s.substring(0, 8);
        final rest = s.substring(8);

        final b = Option.of(int.tryParse(next, radix: 2))
            .toRight(() => 'Failed to parse byte: $next');

        return b.flatMap((byte) => takeParse(rest, acc..add(byte)));
      } else {
        return Either.right(acc);
      }
    }

    final binOnly = s.startsWith('0b') ? s.substring(2) : s;
    final toPad = binOnly.length % 8 == 0 ? 0 : 8 - (binOnly.length % 8);

    return takeParse(
      binOnly.padLeft(binOnly.length + toPad, '0'),
      List.empty(growable: true),
    ).map(ByteVector.fromList);
  }

  static ByteVector fromValidHex(String s) =>
      fromHex(s).getOrElse(() => throw Exception('Illegal hex string: $s'));

  static Either<String, ByteVector> fromHex(String s) {
    Either<String, List<Byte>> takeParse(String s, List<Byte> acc) {
      if (s.length >= 2) {
        final next = s.substring(0, 2);
        final rest = s.substring(2);

        final b = Option.of(int.tryParse(next, radix: 16))
            .toRight(() => 'Failed to parse byte: $next');

        return b.flatMap((byte) => takeParse(rest, acc..add(byte)));
      } else if (s.isNotEmpty) {
        return Either.left('Failed to parse byte: $s');
      } else {
        return Either.right(acc);
      }
    }

    return takeParse(
      s.startsWith('0x') ? s.substring(2) : s,
      List.empty(growable: true),
    ).map(ByteVector.fromList);
  }

  factory ByteVector.fromList(List<Byte> ints) =>
      ByteVector(Uint8List.fromList(ints));

  ByteVector operator &(ByteVector other) => and(other);

  ByteVector operator ~() => not;

  ByteVector operator |(ByteVector other) => or(other);

  ByteVector operator ^(ByteVector other) => xor(other);

  Either<String, ByteVector> aquire(int bytes) => Either.cond(
        () => size >= bytes,
        () => take(bytes),
        () => 'Cannot acquire $bytes bytes from ByteVector of size $size',
      );

  ByteVector and(ByteVector other) => zipWith(other, (a, b) => a & b);

  ByteVector append(Byte byte) => concat(ByteVector.fromList([byte]));

  BitVector get bits => BitVector.fromByteVector(this);

  ByteVector concat(ByteVector other) => ByteVector.fromList(
      _underlying.toList()..addAll(other._underlying.toList()));

  bool containsSlice(ByteVector slice) => indexOfSlice(slice).isDefined;

  ByteVector drop(int n) => ByteVector(
      Uint8List.sublistView(_underlying, min(n, _underlying.length)));

  ByteVector dropRight(int n) => take(size - max(0, n));

  ByteVector dropWhile(Function1<Byte, bool> f) {
    int toDrop(ByteVector b, int ix) =>
        b.nonEmpty || f(b.head) ? toDrop(b.tail, ix + 1) : ix;

    return drop(toDrop(this, 0));
  }

  bool endsWith(ByteVector b) => takeRight(b.size) == this;

  Byte get(int n) => _underlying[n];

  A foldLeft<A>(A init, Function2<A, Byte, A> f) {
    A go(ByteVector b, A acc) => b.isEmpty ? acc : f(go(b.tail, acc), head);
    return go(this, init);
  }

  A foldRight<A>(A init, Function2<Byte, A, A> f) =>
      reverse().foldLeft(init, (a, b) => f(b, a));

  Byte get head => _underlying[0];

  Option<Byte> get headOption => size > 0 ? Some(head) : none();

  Option<int> indexOfSlice(ByteVector slice, [int from = 0]) {
    Option<int> go(ByteVector b, int ix) {
      if (b.isEmpty) {
        return none();
      } else if (b.startsWith(slice)) {
        return Some(ix);
      } else {
        return go(b.tail, ix + 1);
      }
    }

    return go(drop(from), 0);
  }

  ByteVector get init => dropRight(1);

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

  ByteVector rotateLeft(int n) => bits.rotateLeft(n).toByteVector();

  ByteVector rotateRight(int n) => bits.rotateRight(n).toByteVector();

  int get size => _underlying.length;

  ByteVector slice(int from, int until) =>
      drop(from).take(until - max(0, from));

  ByteVector splice(int ix, ByteVector b) =>
      take(ix).concat(b).concat(drop(ix));

  (ByteVector, ByteVector) splitAt(int ix) => (take(ix), drop(ix));

  bool startsWith(ByteVector b) => take(b.size) == b;

  ByteVector get tail => drop(1);

  ByteVector take(int n) => ByteVector(
      Uint8List.sublistView(_underlying, 0, min(n, _underlying.length)));

  ByteVector takeRight(int n) => drop(size - n);

  ByteVector takeWhile(Function1<Byte, bool> f) {
    int toTake(ByteVector b, int ix) =>
        b.isEmpty || !f(b.head) ? ix : toTake(b.tail, ix + 1);

    return take(toTake(this, 0));
  }

  Uint8List toByteArray() => _underlying;

  ByteVector update(int n, Byte byte) =>
      take(n).append(byte).concat(drop(n + 1));

  String toHexString() => isEmpty
      ? 'ByteVector.empty'
      : _underlying
          .toIList()
          .map((b) => b.toRadixString(16).padLeft(2, '0'))
          .mkString(sep: '');

  String toBinString() => isEmpty
      ? 'ByteVector.empty'
      : _underlying
          .toIList()
          .map((b) => b.toRadixString(2).padLeft(8, '0'))
          .mkString(sep: '');

  int toSignedInt([Endian ordering = Endian.big]) => bits.toInt(true, ordering);

  int toUnsignedInt([Endian ordering = Endian.big]) =>
      bits.toInt(false, ordering);

  ByteVector xor(ByteVector other) => zipWith(other, (a, b) => a ^ b);

  ByteVector zipWith(ByteVector other, Function2<Byte, Byte, Byte> f) {
    final aIt = toByteArray().iterator;
    final bIt = toByteArray().iterator;

    final result = List<Byte>.empty(growable: true);

    while (aIt.moveNext() && bIt.moveNext()) {
      result.add(f(aIt.current, bIt.current));
    }

    return ByteVector.fromList(result);
  }

  @override
  String toString() =>
      toHexString(); // TODO: Only show first n bytes if vector is very long

  @override
  bool operator ==(Object other) {
    if (other is ByteVector) {
      if (identical(_underlying, other._underlying)) {
        return true;
      }

      if (_underlying.length != other._underlying.length) {
        return false;
      }

      // Treat the original byte lists as lists of 8-byte words.
      final numWords = _underlying.lengthInBytes ~/ 8;
      final words1 = _underlying.buffer.asUint64List(0, numWords);
      final words2 = other._underlying.buffer.asUint64List(0, numWords);

      for (var i = 0; i < words1.length; i += 1) {
        if (words1[i] != words2[i]) {
          return false;
        }
      }

      // Compare any remaining bytes.
      for (var i = words1.lengthInBytes;
          i < _underlying.lengthInBytes;
          i += 1) {
        if (_underlying[i] != other._underlying[i]) {
          return false;
        }
      }

      return true;
    }

    return false;
  }

  @override
  int get hashCode => _underlying.hashCode;
}
