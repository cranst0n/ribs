import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_core/ribs_core.dart';

/// Factory methods for creating CRC (Cyclic Redundancy Check) computation
/// functions.
///
/// CRC is an error-detecting code commonly used to verify data integrity in
/// digital networks and storage devices.
///
/// This class provides two levels of API:
///
/// - **One-shot**: Use [crc8], [crc16], [crc24], [crc32], or [from] to
///   obtain a function that computes a CRC over a complete [BitVector] in
///   a single call.
/// - **Incremental**: Use [builder] to create a [CrcBuilder] that can
///   accumulate data in chunks before producing a final result.
///
/// ```dart
/// final checksum = Crc.crc32(myData);
/// ```
///
/// See also:
/// - [CrcParams], which defines the parameters for specific CRC algorithms.
/// - [CrcBuilder], for incremental CRC computation.
final class Crc {
  Crc._();

  /// Returns a CRC-8/SMBUS computation function.
  ///
  /// Each call creates a fresh function from [CrcParams.crc8].
  static Function1<BitVector, BitVector> get crc8 => from(CrcParams.crc8());

  /// Returns a CRC-16/ARC computation function.
  ///
  /// Each call creates a fresh function from [CrcParams.crc16].
  static Function1<BitVector, BitVector> get crc16 => from(CrcParams.crc16());

  /// Returns a CRC-24/OpenPGP computation function.
  ///
  /// Each call creates a fresh function from [CrcParams.crc24].
  static Function1<BitVector, BitVector> get crc24 => from(CrcParams.crc24());

  /// Returns a CRC-32/ISO-HDLC computation function.
  ///
  /// Each call creates a fresh function from [CrcParams.crc32].
  static Function1<BitVector, BitVector> get crc32 => from(CrcParams.crc32());

  /// Creates a one-shot CRC function from the given [params].
  ///
  /// The returned function accepts a [BitVector] and returns the computed
  /// CRC checksum as a [BitVector] whose size matches [CrcParams.width].
  static Function1<BitVector, BitVector> from(CrcParams params) => Crc.of(
    params.poly,
    params.initial,
    params.reflectInput,
    params.reflectOutput,
    params.finalXor,
  );

  /// Creates a one-shot CRC function from individual CRC components.
  ///
  /// All [BitVector] arguments must have the same [BitVector.size].
  ///
  /// Internally, this pre-computes a 256-entry lookup table for
  /// table-driven CRC computation and returns a closure that processes
  /// input data against that table.
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

  /// Creates a [CrcBuilder] for incremental CRC computation.
  ///
  /// Use this when data arrives in chunks or when you need to inspect
  /// intermediate CRC state. A 256-entry lookup table is pre-computed
  /// from the given [poly]nomial for efficient byte-at-a-time processing.
  ///
  /// For polynomials narrower than 8 bits, the builder falls back to
  /// bitwise processing.
  ///
  /// ```dart
  /// final bldr = Crc.builder(
  ///   poly, initial, reflectInput, reflectOutput, finalXor,
  /// );
  /// final result = bldr.updated(chunk1).updated(chunk2).result();
  /// ```
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

/// An immutable builder for incrementally computing a CRC checksum over
/// chunks of [BitVector] data.
///
/// Each call to [updated] returns a **new** builder with the additional
/// data incorporated — the original builder is unchanged. Call [result]
/// on the final builder to obtain the computed checksum.
///
/// The result type [R] is [BitVector] by default, but can be transformed
/// to another type via [mapResult].
///
/// ```dart
/// final builder = Crc.builder(poly, initial, refIn, refOut, xorOut);
/// final checksum = builder
///     .updated(chunk1)
///     .updated(chunk2)
///     .result();
/// ```
///
/// See also:
/// - [Crc.builder], which creates a new [CrcBuilder].
sealed class CrcBuilder<R> {
  /// Returns a new [CrcBuilder] that incorporates [data] into the running
  /// CRC computation.
  ///
  /// The original builder is not modified.
  CrcBuilder<R> updated(BitVector data);

  /// Computes and returns the CRC checksum from all data provided via
  /// [updated].
  R result();

  /// Returns a new [CrcBuilder] whose [result] is transformed by applying
  /// [f] to the underlying result.
  ///
  /// This is useful for converting the raw [BitVector] checksum into
  /// another representation (e.g. an integer or hex string).
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
      final data = byteAligned ? input.bytes : input.bytes.init;

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

    rem = rem.tail;
  }

  return reg;
}
