import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

final class OrDecoder<A> extends Decoder<A> {
  final Decoder<A> decodeA;
  final Decoder<A> decodeB;

  OrDecoder(this.decodeA, this.decodeB);

  @override
  DecodeResult<A> decodeC(HCursor cursor) => tryDecodeC(cursor);

  @override
  DecodeResult<A> tryDecodeC(ACursor cursor) {
    return decodeA
        .tryDecodeC(cursor)
        .fold(
          (err) => decodeB.tryDecodeC(cursor),
          (a) => a.asRight(),
        );
  }
}
