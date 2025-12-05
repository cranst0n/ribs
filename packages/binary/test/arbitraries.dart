import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_check/ribs_check.dart';

final binString =
    Gen.listOf(Gen.chooseInt(0, 128), Gen.binChar).map((a) => a.join());

final hexString =
    Gen.listOf(Gen.chooseInt(0, 16), Gen.hexChar).map((a) => a.join());

final base32String = Gen.listOf(Gen.chooseInt(0, 16),
        Gen.charSample('ABCDEFGHIJKLMNOPQRSTUVWXYZ234567'))
    .map((a) => a.join());

final base64String = Gen.listOf(
        Gen.chooseInt(0, 16).map((a) => a * 4),
        Gen.charSample(
            'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz0123456789+/'))
    .map((a) => a.join());

final base64UrlString = Gen.listOf(
        Gen.chooseInt(0, 16).map((a) => a * 4),
        Gen.charSample(
            'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz0123456789-_'))
    .map((a) => a.join());

final bitVector = Gen.oneOfGen([
  _flatBytes,
  _balancedTrees,
  _splitVectors,
  _concatSplitVectors,
]);

final _flatBytes = _genBitVector(maxBytes: 100);
final _balancedTrees = _genConcatBits(_genBitVector(maxBytes: 500));
final _splitVectors = _genSplitBits(1000);
final _concatSplitVectors = _genConcatBits(_genSplitBits(1000));

Gen<BitVector> _genBitVector({
  int maxBytes = 1024,
  int maxAdditionalBits = 7,
}) =>
    Gen.chooseInt(0, maxBytes).flatMap((byteSize) {
      return Gen.chooseInt(0, maxAdditionalBits).flatMap((additionalBits) {
        final size = byteSize * 8 + additionalBits;
        return Gen.listOfN((size + 7) ~/ 8, Gen.byte).map((bytes) {
          return BitVector.fromByteVector(ByteVector(bytes).take(size));
        });
      });
    });

Gen<BitVector> _genSplitBits(int maxSize) =>
    Gen.chooseInt(0, maxSize).flatMap((n) {
      return _genBitVector(maxBytes: 15).map((b) {
        final m = b.nonEmpty ? (n % b.size).abs() : 0;
        return b.take(m).concat(b.drop(m));
      });
    });

Gen<BitVector> _genConcatBits(Gen<BitVector> g) => g.map((b) => b
    .toIList()
    .foldLeft(BitVector.empty, (acc, high) => acc.concat(BitVector.bit(high))));

final byteVector = Gen.oneOfGen([
  _standardByteVectors(100),
  _genConcatBytes(_standardByteVectors(100)),
  _sliceByteVectors,
  _genSplitBytes(_sliceByteVectors),
  _genSplitBytes(_genConcatBytes(_standardByteVectors(500))),
]);

final bytesWithIndex = byteVector
    .flatMap((bv) => Gen.chooseInt(0, bv.size + 1).map((i) => (bv, i)));

Gen<ByteVector> _standardByteVectors(int maxSize) =>
    Gen.listOf(Gen.chooseInt(0, maxSize), Gen.byte)
        .map((bytes) => ByteVector(bytes));

Gen<ByteVector> _genConcatBytes(Gen<ByteVector> g) =>
    g.map((b) => b.foldLeft(ByteVector.empty, (acc, b) => acc.append(b)));

final _sliceByteVectors = Gen.chooseInt(0, 100).flatMap((n) {
  return Gen.listOfN(n, Gen.byte).flatMap((bytes) {
    return Gen.chooseInt(0, bytes.length).map((toDrop) {
      return ByteVector([0x01, 0x02]).drop(toDrop);
    });
  });
});

Gen<ByteVector> _genSplitBytes(Gen<ByteVector> g) => g.flatMap((b) =>
    Gen.chooseInt(0, b.size + 1).map((n) => b.take(n).concat(b.drop(n))));
