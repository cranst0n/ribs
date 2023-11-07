import 'package:ribs_binary/ribs_binary.dart';
import 'package:ribs_check/ribs_check.dart';

final binString =
    Gen.listOf(Gen.chooseInt(0, 25).map((a) => a * 8), Gen.charSample('01'))
        .map((a) => a.join());

final hexString =
    Gen.listOf(Gen.chooseInt(0, 25).map((a) => a * 2), Gen.hexChar)
        .map((a) => a.join());

final bitVector = binString.map(BitVector.fromValidBinString);

final byteVector = binString.map(ByteVector.fromValidBinString);

final byte = Gen.chooseInt(0, 255);

final bytesWithIndex = byteVector
    .flatMap((bv) => Gen.chooseInt(0, bv.size + 1).map((i) => (bv, i)));
