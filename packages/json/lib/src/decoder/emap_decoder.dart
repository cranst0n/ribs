import 'package:ribs_core/ribs_core.dart';
import 'package:ribs_json/ribs_json.dart';

final class EmapDecoder<A, B> extends Decoder<B> {
  final Decoder<A> aDecoder;
  final Function1<A, Either<String, B>> f;

  EmapDecoder(this.aDecoder, this.f);

  @override
  DecodeResult<B> decodeC(HCursor cursor) => tryDecodeC(cursor);

  @override
  DecodeResult<B> tryDecodeC(ACursor cursor) {
    return aDecoder.tryDecodeC(cursor).fold(
          (failure) => failure.asLeft(),
          (a) => f(a).leftMap((str) => DecodingFailure.fromString(str, cursor)),
        );
  }
}
