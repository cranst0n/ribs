import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_check/ribs_check.dart';

final binString =
    Gen.listOf(Gen.chooseInt(0, 25).map((a) => a * 8), Gen.binChar)
        .map((a) => a.join());

final hexString =
    Gen.listOf(Gen.chooseInt(0, 25).map((a) => a * 2), Gen.hexChar)
        .map((a) => a.join());

final base32String = Gen.listOf(Gen.chooseInt(0, 25),
        Gen.charSample('ABCDEFGHIJKLMNOPQRSTUVWXYZ234567'))
    .map((a) => a.join());

final base64String = Gen.listOf(
        Gen.chooseInt(0, 25).map((a) => a * 4),
        Gen.charSample(
            'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz0123456789+/'))
    .map((a) => a.join());

final base64UrlString = Gen.listOf(
        Gen.chooseInt(0, 25).map((a) => a * 4),
        Gen.charSample(
            'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz0123456789-_'))
    .map((a) => a.join());

final bitVector = binString.map(BitVector.fromValidBin);

final byteVector = binString.map(ByteVector.fromValidBin);

final byte = Gen.chooseInt(0, 255);

final bytesWithIndex = byteVector
    .flatMap((bv) => Gen.chooseInt(0, bv.size + 1).map((i) => (bv, i)));
