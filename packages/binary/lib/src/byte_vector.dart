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

  static ByteVector fromValidBinString(String s) => fromBinString(s).fold(
        (err) => throw Exception('Illegal binary string: $s ($err)'),
        id,
      );

  static Either<String, ByteVector> fromBinString(String s) =>
      fromBinInternal(s).map((a) => a.$1);

  static ByteVector fromValidHexString(String s) => fromHexString(s).fold(
        (err) => throw Exception('Illegal hex string: $s ($err)'),
        id,
      );

  static Either<String, ByteVector> fromHexString(String s) {
    Either<String, List<Byte>> takeParse(String s, List<Byte> acc) {
      if (s.length >= 2) {
        final next = s.substring(0, 2);
        final rest = s.substring(2);

        final b = Option(int.tryParse(next, radix: 16))
            .toRight(() => 'Failed to parse byte: $next');

        return b.flatMap((byte) => takeParse(rest, acc..add(byte)));
      } else if (s.isNotEmpty) {
        return Either.left('Failed to parse byte: $s');
      } else {
        return Either.right(acc);
      }
    }

    final removeLeading = s.startsWith('0x') ? s.substring(2) : s;
    final padded = removeLeading.padLeft(
        removeLeading.length + (removeLeading.length % 2), '0');

    return takeParse(
      padded,
      List.empty(growable: true),
    ).map(ByteVector.fromList);
  }

  factory ByteVector.fromInt(
    int i, [
    int size = 4,
    Endian ordering = Endian.big,
  ]) =>
      BitVector.fromInt(i, size * 8, ordering).toByteVector();

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

  A foldLeft<A>(A init, Function2<A, Byte, A> f) {
    var acc = init;

    for (final b in _underlying) {
      acc = f(acc, b);
    }

    return acc;
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

  ByteVector rotateLeft(int n) => bits.rotateLeft(n).toByteVector();

  ByteVector rotateRight(int n) => bits.rotateRight(n).toByteVector();

  ByteVector shiftLeft(int n) => bits.shiftLeft(n).toByteVector();

  ByteVector shiftRight(int n, bool signExtension) =>
      bits.shiftRight(n, signExtension).toByteVector();

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

  Uint8List toByteArray() => _underlying;

  ByteVector update(int n, Byte byte) =>
      take(n).append(byte).concat(drop(n + 1));

  String toHexString() => isEmpty
      ? ''
      : _underlying
          .toIList()
          .map((b) => b.toRadixString(16).padLeft(2, '0'))
          .mkString(sep: '');

  String toBinString() => isEmpty
      ? ''
      : _underlying
          .toIList()
          .map((b) => b.toRadixString(2).padLeft(8, '0'))
          .mkString(sep: '');

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
}
