import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';

final class Crc {
  Crc._();

  static Function1<BitVector, BitVector> get crc8 => from(CrcParams.crc8());

  static Function1<BitVector, BitVector> get crc16 => from(CrcParams.crc16());

  static Function1<BitVector, BitVector> get crc24 => from(CrcParams.crc24());

  static Function1<BitVector, BitVector> get crc32 => from(CrcParams.crc32());

  static Function1<BitVector, BitVector> from(CrcParams params) => Crc.of(
        params.poly,
        params.initial,
        params.reflectInput,
        params.reflectOutput,
        params.finalXor,
      );

  static Function1<BitVector, BitVector> of(
    BitVector poly,
    BitVector initial,
    bool reflectInput,
    bool reflectOutput,
    BitVector finalXor,
  ) {
    assert(poly.nonEmpty, 'empty polynomial');

    assert(
      initial.size == poly.size && poly.size == finalXor.size,
      'poly, initial and finalXor must be same length',
    );

    final bldr = builder(poly, initial, reflectInput, reflectOutput, finalXor);
    return (data) => bldr.updated(data).result();
  }

  static CrcBuilder<BitVector> builder(
    BitVector poly,
    BitVector initial,
    bool reflectInput,
    bool reflectOutput,
    BitVector finalXor,
  ) {
    final table = Array.ofDim<BitVector>(256);

    final zeroed = BitVector.fill(poly.size - 8, false);
    const m = 8;

    for (int idx = 0; idx < table.length; idx++) {
      BitVector shift(int k0, BitVector crcreg0) {
        int k = k0;
        BitVector crcreg = crcreg0;

        while (k < m) {
          final shifted = crcreg << 1;
          k += 1;
          crcreg = crcreg.head ? shifted.xor(poly) : shifted;
        }

        return crcreg;
      }

      table[idx] = shift(0, ByteVector([idx]).bits.concat(zeroed)).compact();
    }

    return _GenericCrcBuilder(
      table,
      poly,
      initial,
      reflectInput,
      reflectOutput,
      finalXor,
    );
  }
}

sealed class CrcBuilder<R> {
  CrcBuilder<R> updated(BitVector data);

  R result();

  CrcBuilder<S> mapResult<S>(Function1<R, S> f) {
    return _MappedCrcBuilder(this, f);
  }
}

final class _MappedCrcBuilder<R, S> extends CrcBuilder<S> {
  final CrcBuilder<R> inner;
  final Function1<R, S> f;

  _MappedCrcBuilder(this.inner, this.f);

  @override
  CrcBuilder<S> updated(BitVector data) => _MappedCrcBuilder(inner.updated(data), f);

  @override
  S result() => f(inner.result());
}

final class _GenericCrcBuilder extends CrcBuilder<BitVector> {
  final Array<BitVector> table;

  final BitVector poly;
  final BitVector initial;
  final bool reflectInput;
  final bool reflectOutput;
  final BitVector finalXor;

  _GenericCrcBuilder(
    this.table,
    this.poly,
    this.initial,
    this.reflectInput,
    this.reflectOutput,
    this.finalXor,
  );

  @override
  CrcBuilder<BitVector> updated(BitVector input) {
    if (poly.size < 8) {
      return _GenericCrcBuilder(
        table,
        poly,
        _goBitwise(
          poly,
          reflectInput ? input.reverseBitOrder() : input,
          initial,
        ),
        reflectInput,
        reflectOutput,
        finalXor,
      );
    } else {
      var crcreg = initial;

      final size = input.size;
      final byteAligned = size % 8 == 0;
      final data = byteAligned ? input.bytes : input.bytes.init();

      if (reflectInput) {
        data.foreach((inputByte) {
          final index = crcreg.take(8) ^ BitVector.byte(inputByte).reverse;
          final indexAsInt = index.bytes.head & 0x0ff;

          crcreg = (crcreg << 8) ^ table[indexAsInt]!;
        });
      } else {
        data.foreach((inputByte) {
          final index = crcreg.take(8) ^ BitVector.byte(inputByte);
          final indexAsInt = index.bytes.head & 0x0ff;
          crcreg = (crcreg << 8) ^ table[indexAsInt]!;
        });
      }

      if (byteAligned) {
        return _GenericCrcBuilder(table, poly, crcreg, reflectInput, reflectOutput, finalXor);
      } else {
        final trailer = input.takeRight(size % 8);
        return _GenericCrcBuilder(
          table,
          poly,
          _goBitwise(
            poly,
            reflectInput ? trailer.reverseBitOrder() : trailer,
            crcreg,
          ),
          reflectInput,
          reflectOutput,
          finalXor,
        );
      }
    }
  }

  @override
  BitVector result() => (reflectOutput ? initial.reverse : initial).xor(finalXor);
}

BitVector _goBitwise(BitVector poly, BitVector remaining, BitVector crcreg) {
  var rem = remaining;
  var reg = crcreg;

  while (rem.nonEmpty) {
    final shifted = reg << 1;

    if (reg.head == rem.head) {
      reg = shifted;
    } else {
      reg = shifted.xor(poly);
    }

    rem = rem.tail();
  }

  return reg;
}
