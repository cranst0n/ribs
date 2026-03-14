import 'dart:typed_data';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:ribs_binary/ribs_binary.dart';

// ─── Packet format (8 bytes, big-endian) ──────────────────────────────────────
//
//  Bits  0- 3 : version    (uint4)
//  Bits  4- 7 : headerLen  (uint4)
//  Bits  8-23 : totalLen   (uint16)
//  Bits 24-31 : ttl        (uint8)
//  Bits 32-63 : checksum   (uint32)
//
// Example bytes: [0x45, 0x00, 0x00, 0x28, 0xab, 0xcd, 0x12, 0x34]
//   version=4, headerLen=5, totalLen=40, ttl=0xab, checksum=0xcd1234??
//   (wait, 0x00, 0x28 is the uint16 at bits 8-23 = 40)
//

typedef Packet = ({int version, int headerLen, int totalLen, int ttl, int checksum});

const _packetBytes = [0x45, 0x00, 0x28, 0xab, 0xcd, 0x12, 0x34, 0x56];
//  byte 0       = 0x45  → version=4, headerLen=5
//  bytes 1-2    = 0x00, 0x28 = 40  → totalLen
//  byte 3       = 0xab = 171  → ttl
//  bytes 4-7    = 0xcd, 0x12, 0x34, 0x56 → checksum

/// Decodes a [Packet] using ribs_binary [Decoder.tuple5] and [Codec] primitives.
/// Exercises the full codec pipeline: BitVector slicing, int decoding, tuple
/// assembly, and xmap.
class CodecDecodeBenchmark extends BenchmarkBase {
  late final Decoder<Packet> _decoder;
  late BitVector _bits;

  CodecDecodeBenchmark() : super('codec-decode');

  @override
  void setup() {
    _bits = BitVector.view(Uint8List.fromList(_packetBytes));
    _decoder = Decoder.tuple5(
      Codec.uint4,
      Codec.uint4,
      Codec.uint16,
      Codec.uint8,
      Codec.uint32,
    ).map(
      (t) => (
        version: t.$1,
        headerLen: t.$2,
        totalLen: t.$3,
        ttl: t.$4,
        checksum: t.$5,
      ),
    );
  }

  @override
  void run() => _decoder.decode(_bits);
}

/// Decodes the same [Packet] by indexing directly into a [ByteData] view.
/// No allocations beyond the result record itself; uses native typed-data ops.
class RawDecodeBenchmark extends BenchmarkBase {
  late ByteData _view;

  RawDecodeBenchmark() : super('raw-decode');

  @override
  void setup() {
    _view = ByteData.sublistView(Uint8List.fromList(_packetBytes));
  }

  @override
  void run() {
    final b0 = _view.getUint8(0);
    final _ = (
      version: (b0 >> 4) & 0xF,
      headerLen: b0 & 0xF,
      totalLen: _view.getUint16(1),
      ttl: _view.getUint8(3),
      checksum: _view.getUint32(4),
    );
  }
}
